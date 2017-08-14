function b = issuperstring(str1, str2)
%ISSUPERSTRING

if ischar(str1)
  b         = ~isempty(strfind(str1, str2));
elseif iscell(str1)
  b         = false(size(str1));
  for i=1:numel(str1)
    b(i)    = ~isempty(strfind(str1{i}, str2));
  end % for i=1:numel(str1)
end

end

