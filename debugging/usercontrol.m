function usercontrol(varargin)
%USERCONTROL writes a file named controlswitch to a folder whose
%   path is passed as an input argument to USERCONTROL. Please see
%   PROGRAMCONTROL.
%
% OPTIONAL ARGUMENTS:
%
% varargin    - path of folder in which USERCONTROL writes
%               file named controlswitch (default: '.')
%
% @ 2017 Akinyinka Omigbodun    aomigbod@ucsd.edu

  if isempty(varargin)
    controlDir	= '.';
  else % if ~isempty(varargin)
    controlDir	= varargin{1};
  end

  fclose(fopen([controlDir, '/controlswitch'],'w'));
end