function [currentState, logP] = hmmviterbi2(seq,st,tr,e,varargin)
%HMMVITERBI2 allows state start probabilities, ST, to be specified in
%   calculating the most probable state path for a sequence.
%
% Code adapted from hmmviterbi.m by MathWorks.
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
%       [seq, states] = hmmgenerate2(100,st,tr,e);
%       estimatedStates = hmmviterbi2(seq,st,tr,e);
%
%       [seq, states] = hmmgenerate2(100,st,tr,e,'Statenames',{'fair';'loaded'});
%       estimatesStates = hmmviterbi2(seq,st,tr,e,'Statenames',{'fair';'loaded'});

numStates = size(tr,1);
checkTr = size(tr,2);
if checkTr ~= numStates
    error(message('stats:hmmviterbi:BadTransitions'));
end

% number of rows of e must be same as number of states

checkE = size(e,1);
if checkE ~= numStates
    error(message('stats:hmmviterbi:InputSizeMismatch'));
end

numEmissions = size(e,2);
customStatenames = false;

% deal with options
if nargin > 4
    if rem(nargin,2)== 1
        error(message('stats:hmmviterbi:WrongNumberArgs', mfilename));
    end
    okargs = {'symbols','statenames'};
    for j=1:2:nargin-4
        pname = varargin{j};
        pval = varargin{j+1};
        k = strmatch(lower(pname), okargs);
        if isempty(k)
            error('stats:hmmviterbi:BadParameter',...
                  'Unknown parameter name:  %s.',pname);
        elseif length(k)>1
            error('stats:hmmviterbi:BadParameter',...
                  'Ambiguous parameter name:  %s.',pname);
        else
            switch(k)
                case 1  % symbols
                    symbols = pval;  
                    numSymbolNames = numel(symbols);
                    if length(symbols) ~= numSymbolNames
                        error('stats:hmmviterbi:BadSymbols',...
                              'SYMBOLS must be a vector');
                    end
                    if numSymbolNames ~= numEmissions
                        error('stats:hmmviterbi:BadSymbols',...
                          'Number of Symbols must match number of emissions.');
                    end     
                    [~, seq]  = ismember(seq,symbols);
                    if any(seq(:)==0)
                        error(message('stats:hmmviterbi:MissingSymbol'));
                    end
                case 2  % statenames
                    statenames = pval;
                    numStateNames = length(statenames);
                    if numStateNames ~= numStates
                        error(message('stats:hmmviterbi:BadStateNames'));
                    end
                    customStatenames = true;
            end
        end
    end
end

% work in log space to avoid numerical issues
L = length(seq);
if any(seq(:)<1) || any(seq(:)~=round(seq(:))) || any(seq(:)>numEmissions)
     error(message('stats:hmmviterbi:BadSequence', numEmissions));
end
currentState = zeros(1,L);
if L == 0
    return
end
logST = log(st);
logTR = log(tr);
logE = log(e);

% allocate space
pTR = zeros(numStates,L);
% assumption is that model is in state 1 at step 0
v = -Inf(numStates,1);
v(1,1) = 0;
vOld = v;

% loop through the model
for count = 1:L
    if (count == 1)
      [logTR(1,:) logST]	= deal(logST, logTR(1,:));
    end % if (count == 1)
    for state = 1:numStates
        % for each state we calculate
        % v(state) = e(state,seq(count))* max_k(vOld(:)*tr(k,state));
        bestVal = -inf;
        bestPTR = 0;
        % use a loop to avoid lots of calls to max
        for inner = 1:numStates 
            val = vOld(inner) + logTR(inner,state);
            if val > bestVal
                bestVal = val;
                bestPTR = inner;
            end
        end
        % save the best transition information for later backtracking
        pTR(state,count) = bestPTR;
        % update v
        v(state) = logE(state,seq(count)) + bestVal;
    end
    if (count == 1)
      [logTR(1,:) logST]	= deal(logST, logTR(1,:));
    end % if (count == 1)
    vOld = v;
end

% decide which of the final states is post probable
[logP, finalState] = max(v);

% Now back trace through the model
currentState(L) = finalState;
for count = L-1:-1:1
    currentState(count) = pTR(currentState(count+1),count+1);
    if currentState(count) == 0
        error('stats:hmmviterbi:ZeroTransitionProbability',...
       ['A zero transition probability was encountered from state %d.\n',...
       'Please provide more data or PseudoTransition information.'],...
       currentState(count+1));
    end
end
if customStatenames
    currentState = reshape(statenames(currentState),1,L);
end


end

