function B = indrange(A)
%INDRANGE
%   
  nDims   = size(A,1);
  B       = cell(nDims,1);
  for d=1:nDims
    B{d}	= A(d,1):A(d,2);
  end % for d=1:nDims
end