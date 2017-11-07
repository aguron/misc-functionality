function programcontrol(varargin)
%PROGRAMCONTROL sets a breakpoint on the line after the call to
%   PROGRAMCONTROL within the caller function if a file named
%   controlswitch is present in the folder path passed as an input
%   argument to PROGRAMCONTROL. (Consequently, execution of the
%   caller function is stopped at the breakpoint.) Please see
%   USERCONTROL.
%
% OPTIONAL ARGUMENTS:
%
% varargin    - path of folder in which PROGRAMCONTROL checks for
%               file named controlswitch (default: '.')
%
% @ 2017 Akinyinka Omigbodun    aomigbod@ucsd.edu

  if isempty(varargin)
    controlDir	= '.';
  else % if ~isempty(varargin)
    controlDir	= varargin{1};
  end
  
  interruptCode	= exist([controlDir, '/controlswitch'], 'file');
  if (interruptCode == 2)
      st        = dbstack;
      eval(['dbstop in ', st(2).name, ' at ', num2str(st(2).line+1)])
      delete([controlDir, '/controlswitch']);
      fprintf(['Breakpoint added for ', st(2).name,...
               ' on line ', num2str(st(2).line+1), '\n']);
  end
end


