function [HMMguess,logliks] = hmmtrain2(seqs,HMMguess,nSym,varargin)
%HMMTRAIN2 maximum likelihood estimator of model parameters (start 
%   probabilities, ST, transition probability matrix, TR, and emission
%   probability matrix, E) for an HMM.
%
% Code adapted from hmmtrain.m by MathWorks.
%
%   Examples:
%
%     st = [0.6 0.4];
%
% 		tr = [0.95,0.05;
%             0.10,0.90];
%
% 		e = [1/6,  1/6,  1/6,  1/6,  1/6,  1/6;
%            1/10, 1/10, 1/10, 1/10, 1/10, 1/2;];
%
%       seq1 = hmmgenerate2(100,st,tr,e);
%       seq2 = hmmgenerate2(200,st,tr,e);
%       seqs = {seq1,seq2};
%       estHMM = hmmtrain2(seqs,struct('ST',st,'TR',tr,'E',e),size(e,2));

  Symbols          	= 1:nSym;
  extraOpts        	= assignopts(who, varargin);
  
  [ST,TR,E,logliks]	= train(seqs, HMMguess.ST, HMMguess.TR, HMMguess.E,...
                            'Symbols',Symbols,...
                            extraOpts{:});
  HMMguess.ST       = ST;
  HMMguess.TR       = TR;
  HMMguess.E        = E;
end

function [guessST,guessTR,guessE,logliks] = train(seqs,guessST,guessTR,guessE,varargin)

tol                     = 1e-6;
trtol                   = tol;
etol                    = tol;
maxiter                 = 500;
pseudoEcounts           = false;
pseudoTRcounts          = false;
pseudoSTcounts          = false;
verbose                 = false;

[numStates, checkTr]    = size(guessTR);
if checkTr ~= numStates
    error(message('stats:train:BadTransitions'));
end

checkSt                 = numel(guessST);
if ~isrowvec(guessST) || (checkSt ~= numStates)
    error(message('stats:train:BadStarts'));
end % if ~isrowvec(guessST)


% number of rows of e must be same as number of states

[checkE, numEmissions]	= size(guessE);
if checkE ~= numStates
    error('stats:train:InputSizeMismatch',...
        'EMISSIONS matrix must have the same number of rows as TRANSITIONS.');
end
if (numStates ==0 || numEmissions == 0)
    guessST             = [];
    guessTR             = [];
    guessE              = [];
    return
end

baumwelch               = true;

if nargin > 4
    if rem(nargin,2)~= 0
        error(message('stats:train:WrongNumberArgs', mfilename));
    end % if rem(nargin,2)~= 0
    okargs                          =...
     {'symbols','tolerance','pseudoemissions','pseudotransitions','pseudostarts','maxiterations','verbose','algorithm','trtol','etol'};
    for j=1:2:nargin-4
        pname                       = varargin{j};
        pval                        = varargin{j+1};
        k                           = strmatch(lower(pname), okargs);
        if isempty(k)
            error('stats:train:BadParameter',...
                'Unknown parameter name:  %s.',pname);
        elseif length(k)>1
            error('stats:train:BadParameter',...
                'Ambiguous parameter name:  %s.',pname);
        else
            switch(k)
                case 1  % symbols
                    symbols         = pval;
                    numSymbolNames	= numel(symbols);
                    if length(symbols) ~= numSymbolNames
                        error('stats:train:BadSymbols',...
                            'SYMBOLS must be a vector.');
                    end
                    if numSymbolNames ~= numEmissions
                        error('stats:train:BadSymbols',...
                            'Number of Symbols (%d) does not match number of emissions (%d).', ...
                            numSymbolNames, numEmissions);
                    end

                    % deal with a single sequence first
                    if ~iscell(seqs) || ischar(seqs{1})
                        [~, seqs]   = ismember(seqs,symbols);
                        if any(seqs(:)==0)
                            error(message('stats:train:MissingSymbol'));
                        end
                    else  % now deal with a cell array of sequences
                        numSeqs     = numel(seqs);
                        newSeqs     = cell(numSeqs,1);
                        for count = 1:numSeqs
                            [~, newSeqs{count}]...
                                    = ismember(seqs{count},symbols);
                            if any(newSeqs{count}(:)==0)
                                error(message('stats:train:MissingSymbol'));
                            end
                        end
                        seqs        = newSeqs;
                    end
                    %
                case 2  % tol
                    tol             = pval;
                    trtol           = tol;
                    etol            = tol;
                case 3  % Pseudocounts
                    pseudoE         = pval;
                    [rows, cols]    = size(pseudoE);
                    if  rows < numStates
                        error('stats:train:InputSizeMismatch',...
                            'There are more states in GUESSTR than in PSEUDOE.');
                    end
                    if  cols < numEmissions
                        error('stats:train:InputSizeMismatch',...
                            'There are more symbols in SEQ than in PSEUDOE.');
                    end
                    numStates       = rows;
                    numEmissions    = cols;
                    pseudoEcounts   = true;

                case 4  % Pseudocount transitions
                    pseudoTR        = pval;
                    [rows, cols]    = size(pseudoTR);
                    if rows ~= cols
                        error(message('stats:train:BadPseudoTransitions'));
                    end
                    if  rows < numStates
                        error('stats:train:InputSizeMismatch',...
                            'There are more states in GUESSTR than in PSEUDOTR.');
                    end
                    numStates       = rows;
                    pseudoTRcounts  = true;
                case 5  % Pseudocount starts
                    pseudoST        = pval;
                    len             = numel(pseudoST);
                    if (len < numStates)
                        error('stats:train:InputSizeMismatch',...
                            'There are more states in GUESSTR than in PSEUDOST.');
                    end
                    if ~isrowvec(pseudoST)
                        error('stats:train:InputSizeMismatch',...
                            'PSEUDOST is not a row vector.');
                    end
                    numStates       = len;
                    pseudoSTcounts  = true;
                case 6 % max iterations
                    maxiter         = pval;
                case 7 % verbose
                    if islogical(pval) || isnumeric(pval)
                        verbose     = pval;
                    else
                        if ischar(pval)
                            k       = strmatch(lower(pval), {'on','true','yes'});
                            verbose = true;
                        end
                    end
                case 8 % algorithm
                    k               = strmatch(lower(pval), {'baumwelch','viterbi'});
                    if isempty(k)
                        error(message('stats:train:BadAlgorithm', pval));
                    end
                    if k == 2
                        baumwelch   = false;
                    end
                case 9 %transition tolerance
                    trtol           = pval;
                case 10 % emission tolerance
                    etol            = pval;
            end % switch(k)
        end
    end % for j=1:2:nargin-4
end % if nargin > 4
if isnumeric(seqs)
    [numSeqs, seqLength]            = size(seqs);
    cellflag                        = false;
elseif iscell(seqs)
    numSeqs                         = numel(seqs);
    cellflag                        = true;
else
    error(message('stats:train:BadSequence'));
end

% initialize the counters
ST                                  = zeros(size(guessST));
if ~pseudoSTcounts
    pseudoST                        = ST;
end

TR                                  = zeros(size(guessTR));
if ~pseudoTRcounts
    pseudoTR                        = TR;
end

E                                   = zeros(numStates,numEmissions);
if ~pseudoEcounts
    pseudoE                         = E;
end

converged                           = false;
% loglik is the log likelihood of all sequences given the ST, TR and E
loglik                              = 1;
logliks                             = zeros(1,maxiter);
for iteration = 1:maxiter
    oldLL                           = loglik;
    loglik                          = 0;
    oldGuessE                       = guessE;
    oldGuessTR                      = guessTR;
    % oldGuessST                   	= guessST;
    for count = 1:numSeqs
        if cellflag
            seq                     = seqs{count};
            seqLength               = length(seq);
        else
            seq                     = seqs(count,:);
        end

        if baumwelch   % Baum-Welch training
            % get the scaled forward and backward probabilities
            [p,logPseq,fs,bs,scale] = hmmdecode2(seq,guessST,guessTR,guessE);
            loglik                  = loglik + logPseq;
            logf                    = log(fs);
            logb                    = log(bs);
            logGE                   = log(guessE);
            logGTR                  = log(guessTR);
            % f and b no longer start at 0 so offset seq by one
            %	seq = [0 seq];

            for k = 1:numStates
                ST(k)               = ST(k) + sum(exp(logf(k,1)+logb(k,1)));
            end
            for k = 1:numStates
                for l = 1:numStates
                    for i = 1:(seqLength-1)
                        TR(k,l)    	=...
                         TR(k,l) + exp( logf(k,i) + logGTR(k,l) + logGE(l,seq(i+1)) + logb(l,i+1))./scale(i+1);
                    end
                end
            end
            for k = 1:numStates
                for i = 1:numEmissions
                    pos            	= find(seq == i);
                    E(k,i)         	= E(k,i) + sum(exp(logf(k,pos)+logb(k,pos)));
                end
            end
        else  % Viterbi training
            [estimatedStates,logPseq]...
                                    = hmmviterbi2(seq,guessST,guessTR,guessE);
            loglik                  = loglik + logPseq;
            % w = warning('off');
            iterHMM                 =...
             hmmestimate2(seq,estimatedStates,numEmissions,numStates,...
                          'Pseudoemissions',pseudoE,...
                          'Pseudotransitions',pseudoTR,...
                          'Pseudostarts',pseudoST);
            iterST                  = iterHMM.ST;
            iterTR                  = iterHMM.TR;
            iterE                   = iterHMM.E;
            %warning(w);
            % deal with any possible NaN values
            iterST(isnan(iterST))   = 0;
            iterTR(isnan(iterTR))   = 0;
            iterE(isnan(iterE))     = 0;

            ST                      = ST + iterST;
            TR                      = TR + iterTR;
            E                       = E + iterE;
        end
    end
    totalEmissions                  = sum(E,2);
    totalTransitions                = sum(TR,2);
    totalStarts                     = sum(ST);

    % avoid divide by zero warnings
    guessE                          = E./(repmat(totalEmissions,1,numEmissions));
    guessTR                         = TR./(repmat(totalTransitions,1,numStates));
    guessST                         = ST/totalStarts;
    % if any rows have zero transitions then assume that there are no
    % transitions out of the state.
    if any(totalTransitions == 0)
        noTransitionRows            = find(totalTransitions == 0);
        guessTR(noTransitionRows,:) = 0;
        guessTR(sub2ind(size(guessTR),noTransitionRows,noTransitionRows)) = 1;
    end
    % clean up any remaining Nans
    guessST(isnan(guessST))         = 0;
    guessTR(isnan(guessTR))         = 0;
    guessE(isnan(guessE))           = 0;

    if verbose
        if iteration == 1
            fprintf('Relative Changes in Log Likelihood, Transition Matrix and Emission Matrix');
        else
            fprintf('\nIteration %d relative changes:\nLog Likelihood: %f  Transition Matrix: %f  Emission Matrix: %f',...
                iteration, (abs(loglik-oldLL)./(1+abs(oldLL)))  ,norm(guessTR - oldGuessTR,inf)./numStates,norm(guessE - oldGuessE,inf)./numEmissions);
        end
    end
    % Durbin et al recommend loglik as the convergence criteria  -- we also
    % use change in TR and E. Use (undocumented) option trtol and
    % etol to set the convergence tolerance for these independently.
    %
    logliks(iteration)              = loglik;
    if (abs(loglik-oldLL)./(1+abs(oldLL))) < tol
        if norm(guessTR - oldGuessTR,inf)./numStates < trtol
            if norm(guessE - oldGuessE,inf)./numEmissions < etol
                if verbose
                    fprintf('\nAlgorithm converged after %d iterations.\n',iteration)
                end
                converged           = true;
                break
            end
        end
    end
    E                               =	pseudoE;
    TR                              = pseudoTR;
    ST                              = pseudoST;
end % for iteration = 1:maxiter
if ~converged
    warning('stats:train:NoConvergence',...
        'Algorithm did not converge with tolerance %f in %d iterations.',tol,maxiter);
end
logliks(logliks ==0)                =	[];
end