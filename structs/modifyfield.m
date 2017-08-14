function s = modifyfield(s, field, rule)
%MODIFYFIELD
%
  if ischar(field)
    field             = {field};
    rule              = {rule};
  end % if ischar(field)

  if numel(field) ~= numel(rule)
    error('The numbers of specified fields and rules must be equal');
  end % if numel(field) ~= numel(rule)

  for i=1:numel(field)
    for j=1:numel(s)
      s(j).(field{i})	= rule{i}(s(j).(field{i}));
    end % for j=1:numel(s)
  end % for i=1:numel(field)
end