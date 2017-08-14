function usercontrol(varargin)
%USERCONTROL

  if isempty(varargin)
    controlDir	= '.';
  else % if ~isempty(varargin)
    controlDir	= varargin{1};
  end

  fclose(fopen([controlDir, '/controlswitch'],'w'));
end