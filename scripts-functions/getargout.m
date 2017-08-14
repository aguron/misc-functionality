function varargout = getargout(argoutidx, f, varargin)
%GETARGOUT
%   
  argout            = cell(max(argoutidx),1);
  [argout{:}]       = f(varargin{:});
  for i=1:max(1,nargout)
    if (nargout == 0) && (numel(argoutidx) > 1)
      % return multiple arguments in cell array
      varargout{1}	= argout(argoutidx)';
      return
    end % if (nargout == 0) && (numel(argoutidx) > 1)
    varargout{i}    = argout{argoutidx(i)};
  end % for i=1:max(1,nargout)
end

