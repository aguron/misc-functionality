function [pStates,pSeq, fs, bs, s] = hmmdecode2(seq,st,tr,e,varargin)
%HMMDECODE2 allows state start probabilities, ST, to be specified in
%   calculating the posterior state probabilities of a sequence.
%
% Code adapted from hmmdecode.m by MathWorks.
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
%       pStates = hmmdecode2(seq,st,tr,e);
%
%       [seq, states] = hmmgenerate2(100,st,tr,e,'Symbols',...
%                 {'one','two','three','four','five','six'});
%       pStates = hmmdecode2(seq,st,tr,e,'Symbols',...
%                 {'one','two','three','four','five','six'});

numStates = size(tr,1);
checkTr = size(tr,2);
if checkTr ~= numStates
    error(message('stats:hmmdecode:BadTransitions'));
end

% number of rows of e must be same as number of states

checkE  = size(e,1);
if checkE ~= numStates
    error(message('stats:hmmdecode:InputSizeMismatch'));
end

numSymbols = size(e,2);

% deal with options
if nargin > 4
    if rem(nargin,2)== 1
        error(message('stats:hmmdecode:WrongNumberArgs', mfilename));
    end
    okargs = {'symbols'};
    for j=1:2:nargin-4
        pname = varargin{j};
        pval = varargin{j+1};
        k = strmatch(lower(pname), okargs);
        if isempty(k)
            error('stats:hmmdecode:BadParameter',...
                  'Unknown parameter name:  %s.',pname);
        elseif length(k)>1
            error('stats:hmmdecode:BadParameter',...
                  'Ambiguous parameter name:  %s.',pname);
        else
            switch(k)
                case 1  % symbols
                    symbols = pval;  
                    numSymbolNames = numel(symbols);
                    if length(symbols) ~= numSymbolNames
                        error('stats:hmmdecode:BadSymbols',...
                              'SYMBOLS must be a vector.');
                    end
                    if numSymbolNames ~= numSymbols
                        error('stats:hmmdecode:BadSymbols',...
                          'Number of Symbols must match number of emissions.');
                    end     
                    [~, seq]  = ismember(seq,symbols);
                    if any(seq(:)==0)
                        error(message('stats:hmmdecode:MissingSymbol'));
                    end
             end
        end
    end
end

if ~isnumeric(seq)
    error('stats:hmmdecode:BadSequence',...
          'The sequence must be numeric, or you must specify the symbols used in the sequence.');
end
numEmissions = size(e,2);
if any(seq(:)<1) || any(seq(:)~=round(seq(:))) || any(seq(:)>numEmissions)
     error('stats:hmmdecode:BadSequence',...
         'SEQ must consist of integers between 1 and %d.',numEmissions);
end


% add extra symbols to start to make algorithm cleaner at f0 and b0
seq = [numSymbols+1, seq ];
L = length(seq);

% This is what we'd like to do but it is numerically unstable
% warnState = warning('off');
% logTR = log(tr);
% logE = log(e);
% warning(warnState);
% f = zeros(numStates,L);
% f(1,1) = 1;
% % for count = 2:L
%     for state = 1:numStates
%         f(state,count) = logE(state,seq(count)) + log(sum( exp(f(:,count-1) + logTR(:,state))));
%     end
% end
% f = exp(f);

% so we introduce a scaling factor
fs = zeros(numStates,L);
fs(1,1) = 1;  % assume that we start in state 1.
s = zeros(1,L);
s(1) = 1;
for count = 2:L
    if (count == 2)
      [tr(1,:) st] = deal(st, tr(1,:));
    end
    for state = 1:numStates
        fs(state,count) = e(state,seq(count)) .* (sum(fs(:,count-1) .*tr(:,state)));
    end
    if (count == 2)
      [tr(1,:) st] = deal(st, tr(1,:));
    end
    % scale factor normalizes sum(fs,count) to be 1. 
    s(count) =  sum(fs(:,count));
    if (s(count) > 0)
      fs(:,count) =  fs(:,count)./s(count);
    end % if (s(count) > 0)
end

%  The  actual forward and  probabilities can be recovered by using
%   f = fs.*repmat(cumprod(s),size(fs,1),1);


% This is what we'd like to do but it is numerically unstable
% b = zeros(numStates,L);
% for count = L-1:-1:1
%     for state = 1:numStates
%         b(state,count) = log(sum(exp(logTR(state,:)' + logE(:,seq(count+1)) + b(:,count+1)  )));
%     end
% end

% so once again use the scale factor
bs = ones(numStates,L);
for count = L-1:-1:1
    for state = 1:numStates
      bs(state,count) = (1/s(count+1)) * sum( tr(state,:)'.* bs(:,count+1) .* e(:,seq(count+1))); 
    end
end

%  The  actual backward and  probabilities can be recovered by using
%  scales = fliplr(cumprod(fliplr(s)));
%  b = bs.*repmat([scales(2:end), 1],size(bs,1),1);

pSeq = sum(log(s));
pStates = fs.*bs;

% get rid of the column that we stuck in to deal with the f0 and b0 
pStates(:,1) = [];
fs(:,1) = [];
bs(:,1) = [];
s(:,1) = [];

end

