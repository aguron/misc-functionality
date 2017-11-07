function varargout = getargout(argoutidx, f, varargin)
%   
% varargout = getargout(argoutidx, f, ...)
%
% Returns arguments specified by indices from a function
%
% INPUTS:
%
% argoutidx     - indices of arguments to be returned from function
% f             - function handle
% varargin      - input arguments to function
%
% OUTPUTS:
%
% varargout     - output arguments from function
%
% @ 2017 Akinyinka Omigbodun    aomigbod@ucsd.edu

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

