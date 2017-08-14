function b = issubstring(str1, str2)
%ISSUBSTRING

if ischar(str1)
  b         = ~isempty(strfind(str2, str1));
elseif iscell(str1)
  b         = false(size(str1));
  for i=1:numel(str1)
    b(i)    = ~isempty(strfind(str2, str1{i}));
  end % for i=1:numel(str1)
end

end

