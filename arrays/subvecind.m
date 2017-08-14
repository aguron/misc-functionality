function ind = subvecind(subInd,subDim,superInd)
%SUBVECIND
% 
% EXAMPLES:
%   subvecind([1 2], 2, [1 3 6])
%   ans =
%        1     2     5     6    11    12
%   subvecind([1 2], [], [1 3 6])
%   ans =
%      	 1     2     5     6    11    12
%   subvecind([], 2, [1 3 6])
%   ans =
%        1     2     5     6    11    12
%   subvecind({[1 2],[1 4],[2 3]}, [2 3 4 3], [1 3 4])
%   ans =
%        1     2     6     9    11    12
%   subvecind([1 2], [2 3 4 3], [1 3 4])
%   ans =
%      	 1     2     6     7    10    11
%   subvecind([], [2 3 4 3], [1 3 4])
%   ans =
%        1     2     6     7     8     9    10    11    12

  if ~isnumeric(subDim) ||...
    (~isscalar(subDim) && ~isrowvec(subDim) && ~isempty(subDim))
    error('subDim must be a scalar or row vector of subvector lengths');
  end % if ~isnumeric(subDim) || (~isvector(subDim) && ~isempty(subDim))

  if ~isrowvec(superInd)
    error('superInd must be a row vector');
  end % if ~isrowvec(superInd)
  nSubvecLen     	= numel(subDim);
  nSelSubvec      = numel(superInd);
  if (nSubvecLen > 1)
    if isnumeric(subInd)
      if isempty(subInd)
       subInd     = cellfun(@(x)(1:x),num2cell(subDim(superInd)),...
                            'UniformOutput', false);
      else
       temp      	= subInd;
       subInd    	= cell(1,nSelSubvec);
       [subInd{:}]= deal(temp);
      end
    elseif iscell(subInd)
      if ~isvector(subInd) || (numel(subInd) ~= nSelSubvec)
        error(['subInd must have the same number of ',...
               'entries as superInd if specified as a cell'])
      end % if ~isvector(subInd) || (numel(subInd) ~= nSelSubvec)
    end

    subvecInd     = cumsum([1, subDim(1:end-1)]);	% keep track of where
                                                  % sequences start
    if any(cellfun(@(x,y)(max(x)>y),subInd, num2cell(subDim(superInd))))
      error('Invalid indices specified in subInd');
    end
    if any(~cellfun(@(x)isrowvec(x),subInd))
      error('subInd must be a row vector or contain only row vectors');
    end % if any(~cellfun(@(x)isrowvec(x),subInd))
    ind           = cell2mat(cellfun(@(x,y)(x+(y-1)),...
                                     subInd, num2cell(subvecInd(superInd)),...
                                     'UniformOutput', false));
  else % if (nSubvecLen == 0) || (nSubvecLen == 1)
    if isempty(subInd) && isempty(subDim)
      error('subDim and subInd cannot both be empty');
    end % if isempty(subInd) && isempty(subDim)
    if isempty(subInd)
      subInd      = 1:subDim;
    end % if isempty(subInd)
    if isempty(subDim)
      subDim      = max(subInd);
    end % if isempty(subDim)
    if ~isrowvec(subInd)
      error('subInd must be a row vector');
    end % if ~isrowvec(subInd)
    if (subDim < numel(subInd))
      error('Invalid subvector dimension');
    end % if (subDim < numel(subInd))
    ind           = repmat(subInd,[1 nSelSubvec]) +...
                    kron(superInd-1,subDim*ones(1,numel(subInd)));
  end
end

