function seq = counter(idxMax)
%COUNTER either displays or returns a sequence (in a cell array) of vectors
%   representing counting up from a vector of 1s to the vector in the input
%   argument IDXMAX
%
% INPUTS:
%
% idxMax      - final vector in counting sequence
%
% OUTPUTS:
%
% seq         - cell array of vectors
%
% @ 2017 Akinyinka Omigbodun    aomigbod@ucsd.edu

% EXAMPLES:
%   counter([2 3]);
%        1     1
%        1     2
%        1     3
%        2     1
%        2     2
%        2     3
%   seq = counter([2 3]);
%   seq{:}
%   ans =
%        1     1
%   ans =
%        1     2
%   ans =
%        1     3
%   ans =
%        2     1
%   ans =
%        2     2
%   ans =
%        2     3

    idx = ones(size(idxMax));
    
    seqLen      = prod(idxMax);
    if (nargout > 0)
      seq       = cell(seqLen,1);
    end % if (nargout > 0)
    for i=1:seqLen
      if (nargout > 0)
        seq{i}    = idx;
      else
        disp(idx);
      end % if (nargout > 0)
      temp = find(idx < idxMax,1,'last');
      idx(temp) = idx(temp) + 1;
      for j=(temp+1):length(idx)
        idx(j)  = 1;
      end % for j=(temp+1):length(idx)
    end % for i=1:seqLen
end