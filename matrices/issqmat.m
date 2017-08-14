function b = issqmat(A)
%ISSQMAT 
%   
  b     = false;  
  if (ndims(A) == 2) && (numel(unique(size(A))) == 1)
    b   = true;
  end
end

