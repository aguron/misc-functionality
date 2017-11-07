function A_symm = symm(A)
%SYMM Symmetrize a square matrix
%
% @ 2016 Akinyinka Omigbodun    aomigbod@ucsd.edu

  if size(A,1) ~= size(A,2)
    error('Input A must be a square matrix');
  end
  A_symm = (A + A')/2;
end

