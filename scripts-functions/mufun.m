function varargout = mufun(f,varargin)
%MUFUN MERGE-UNMERGE FUNCTION
%

  for i=1:(nargin-1)
   if ~iscell(varargin{i})
    error('Input arrays must be cell arrays');
   end % if ~iscell(varargin{i})
  end % for i=1:(nargin-1)

  sInput	= size(varargin{1});
  if (min(sInput) > 1) || (numel(sInput) ~= 2)
   error('The input cell arrays must be vector arrays');
  end % if (min(sInput) > 1) || (numel(sInput) ~= 2)
  for i=2:(nargin-1)
   if ~isequal(size(varargin{i}), sInput)
    error('Input arrays must have the same size');
   end % if ~isequal(size(varargin{i}), sInput)
  end % for i=2:(nargin-1)

  % Merge
  A                     = cell(nargin-1,1);
  for i=1:(nargin-1)
   if (sInput(1) == 1)
    A{i}                = horzcat(varargin{i}{:});
   elseif (sInput(2) == 1)
    A{i}                = vertcat(varargin{i}{:});
   end
  end % for i=1:(nargin-1)

  % Apply function
  B                     = cell(1,nargout(f{1}));
  if isempty(B)
   error(['Does not support functions with a',...
          ' variable number of output arguments']);
  end % if isempty(B)
  [B{:}]                = f{1}(A{:});
  if ~isequal(size(A{1}),size(B{1}))
   error('Merged input size(s) must not be changed by function');
  end % if ~isequal(size(A{1}),size(C{1}))

  if (numel(f{2}) ~= numel(B))
   error('Mismatch in the expected number of output arguments');
  end % if (numel(f{2}) ~= numel(B))

  for i=1:numel(B)
   if f{2}(i)
    % Unmerge
    if (sInput(1) == 1)
     idxLim             = [1-size(varargin{1}{1},2) 0];
    elseif (sInput(2) == 1)
     idxLim             = [1-size(varargin{1}{1},1) 0];
    end
    for j=1:max(sInput)
     if (sInput(1) == 1)
      idxLim(1)         = idxLim(1) + size(varargin{1}{max(1,j-1)},2);
      idxLim(2)         = idxLim(2) + size(varargin{1}{j},2);
      varargout{1}{1,j}	= B{1}(:,idxLim(1):idxLim(2));
     elseif (sInput(2) == 1)
      idxLim(1)         = idxLim(1) + size(varargin{1}{max(1,j-1)},1);
      idxLim(2)         = idxLim(2) + size(varargin{1}{j},1);
      varargout{1}{j,1}	= B{1}(idxLim(1):idxLim(2),:);
     end
    end % for j=1:max(sInput)
   else % if ~f{2}(i)
    varargout{i}        = B{i};
   end
  end % for i=1:numel(B)
end