function keep(varargin)
%KEEP
% 
  for i=1:nargin-1
    varargin{i}	= ['''',varargin{i}, '''',','];
  end % for i=1:nargin-1
  varargin{end}	= ['''',varargin{end}, ''''];
  evalin('base','vars2clear	= [];')
  evalin('base',['vars2clear	= setdiff(who,{',[varargin{:}],'});'])
  evalin('base','clear(vars2clear{:})')
end