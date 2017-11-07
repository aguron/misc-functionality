function [seq,  states]= hmmgenerate2(L,st,tr,e,varargin)
%HMMGENERATE2 allows state start probabilities, ST, to be specified in
%   generating a sequence for a Hidden Markov Model.
%
% Code adapted from hmmgenerate.m by MathWorks.
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
%       [seq, states] = hmmgenerate2(100,st,tr,e)
%
%       [seq, states] = hmmgenerate(100,st,tr,e,'Symbols',...
%                 {'one','two','three','four','five','six'},...
%                  'Statenames',{'fair';'loaded'})

seq = zeros(1,L);
states = zeros(1,L);

% tr must be square

numStates = size(tr,1);
checkTr = size(tr,2);
if checkTr ~= numStates
    error(message('stats:hmmgenerate:BadTransitions'));
end

% number of rows of e must be same as number of states

checkE = size(e,1);
if checkE ~= numStates
    error('stats:hmmgenerate:InputSizeMismatch',...
         'EMISSIONS matrix must have the same number of rows as TRANSITIONS.');
end

numEmissions = size(e,2);

customSymbols = false;
customStatenames = false;

if nargin > 4
    if rem(nargin,2)== 1
        error(message('stats:hmmgenerate:WrongNumberArgs', mfilename));
    end
    okargs = {'symbols','statenames'};
    for j=1:2:nargin-4
        pname = varargin{j};
        pval = varargin{j+1};
        k = strmatch(lower(pname), okargs);
        if isempty(k)
            error('stats:hmmgenerate:BadParameter',...
                  'Unknown parameter name:  %s.',pname);
        elseif length(k)>1
            error('stats:hmmgenerate:BadParameter',...
                  'Ambiguous parameter name:  %s.',pname);
        else
            switch(k)
                case 1  % symbols
                    symbols = pval;  
                    numSymbolNames = numel(symbols);
                    if length(symbols) ~= numSymbolNames
                        error('stats:hmmgenerate:BadSymbols',...
                              'SYMBOLS must be a vector.');
                    end
                    if numSymbolNames ~= numEmissions
                        error('stats:hmmgenerate:BadSymbols',...
                          'Number of Symbols must match number of emissions.');
                    end     
                    customSymbols = true;
                case 2  % statenames
                    statenames = pval;
                    numStateNames = length(statenames);
                    if numStateNames ~= numStates
                        error('stats:hmmgenerate:InputSizeMismatch',...
                      'Number of Statenames must match the number of states.');
                    end
                    customStatenames = true;
            end
        end
    end
end

% create two random sequences, one for state changes, one for emission
statechange = rand(1,L);
randvals = rand(1,L);

% calculate cumulative probabilities
stc = cumsum(st,2);
trc = cumsum(tr,2);
ec = cumsum(e,2);

% normalize these just in case they don't sum to 1.
stc = stc/stc(end);
trc = trc./repmat(trc(:,end),1,numStates);
ec = ec./repmat(ec(:,end),1,numEmissions);

% Assume that we start in state 1.
currentstate = 1;

% main loop 
for count = 1:L
    % calculate state transition
    stateVal = statechange(count);
    state = 1;
    if (count == 1)
      [trc(1,:) stc]	= deal(stc, trc(1,:));
    end % if (count == 1)
    for innerState = numStates-1:-1:1
        if stateVal > trc(currentstate,innerState)
            state = innerState + 1;
            break;
        end
    end
    if (count == 1)
      [trc(1,:) stc]	= deal(stc, trc(1,:));
    end % if (count == 1)
    
    % calculate emission
    val = randvals(count);
    emit = 1;
    for inner = numEmissions-1:-1:1
        if val  > ec(state,inner)
            emit = inner + 1;
            break
        end
    end
    % add values and states to output
    seq(count) = emit;
    states(count) = state;
    currentstate = state;
end

% deal with names/symbols
if customSymbols
    seq = reshape(symbols(seq),1,L);
end
if customStatenames
    states = reshape(statenames(states),1,L);
end




end

