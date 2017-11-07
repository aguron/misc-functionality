function b = issqmat(A)
%ISSQMAT returns true if A is a square matrix
%
% @ 2017 Akinyinka Omigbodun    aomigbod@ucsd.edu

  b     = false;  
  if (ndims(A) == 2) && (numel(unique(size(A))) == 1)
    b   = true;
  end
end

