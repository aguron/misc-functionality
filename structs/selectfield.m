function t = selectfield(s,field)
%SELECTFIELD
%   
  t   = rmfield(s, setdiff(fieldnames(s), field));
end

