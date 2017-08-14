function a = rmentries(a, condition, field)
%RMENTRIES
%   
  if isnumeric(a)
    a = a(~condition(a));
  elseif iscell(a)
    a = a(~cellfun(condition,a));
  elseif isstruct(a)
    a = a(~cellfun(condition,{a.(field)}));
  end
end

