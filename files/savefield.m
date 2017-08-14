function savefield(filename, s, varargin)
%SAVEFIELD saves the fields of a struct, s, in file, filename
%   

  field__names	= fieldnames(s);
  save__options = varargin;
  for i=1:numel(field__names)
    eval(sprintf('%s = s.(''%s'');', field__names{i}, field__names{i}));
  end % for i=1:numel(field__names)
  save(filename, field__names{:}, save__options{:});
end

