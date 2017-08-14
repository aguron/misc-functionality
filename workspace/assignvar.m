function f = assignvar(overwrite,varargin)
%ASSIGNVAR makes an assignment to a variable not already in the workspace.
%   When the variable is already in the workspace, the variable
%   is left unchanged if overwrite is set to false, but modified
%   if overwrite is set to true.
  if (mod(nargin-1,2) ~= 0)
    error('input arguments must be in variable-value pairs')
  end % if (mod(length(varargin),2) ~= 0)

  for i=1:((nargin-1)/2)
    if ~evalin('base',['exist(','''',varargin{2*i-1},'''',',','''var''',')']);
      assignin('base', varargin{2*i-1}, varargin{2*i});
      f = true;
    else
      if (overwrite)
        assignin('base', varargin{2*i-1}, varargin{2*i});
      end % if (overwrite)
      f = false;
    end
  end % for i=1:(nargin/2)
end