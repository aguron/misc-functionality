function programcontrol(varargin)
%PROGRAMCONTROL
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


