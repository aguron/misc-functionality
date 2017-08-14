function s = addfield(s, field, value)
%ADDFIELD
%   

  if ~isequal(size(s),size(value))
    error('size mismatch between struct, s and value');
  end % if ~isequal(size(s),size(value))

  for j=1:numel(value)
    s(j).(field)	= value{j};
  end % for j=1:numel(value)

end

