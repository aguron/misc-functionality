function varargout = loadvars(filename, varargin)
%LOADVARS
%   
  temp      = load(filename, varargin{:});
  fieldlist = fieldnames(temp);
  for i=1:numel(fieldlist)
    varargout{i}	= temp.(fieldlist{i});
  end
end

