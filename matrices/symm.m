function A_symm = symm(A)
%SYMM Symmetrize input
% 
  if size(A,1) ~= size(A,2)
    error('Input A must be a square matrix');
  end
  A_symm = (A + A')/2;
end

