function B = ndtranspose(A)
%NDTRANSPOSE
%   
  
  if (ndims(A) == 2)
    B           = transpose(A);
    return
  end

  sA            = size(A);
  for s=counter(sA(3:end))'
    s           = num2cell(s{1});
    B(:,:,s{:})	= transpose(A(:,:,s{:}));
  end % for s=counter(sA(3:end))'
end