function b = isinmatfile(file,var)
%ISINMATFILE
%   
  b   = false;
  
  arg	= load(file,var);
  if ~isempty(fieldnames(arg))
    b = true;
  end
end

