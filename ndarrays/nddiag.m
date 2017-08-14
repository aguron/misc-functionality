function B = nddiag(A)
%NDDIAG
%   

  if (ndims(A) == 2)
    B             = diag(A);
    return
  end

  sA              = size(A);
  for s=counter(sA(3:end))'
    s             = num2cell(s{1});
    if min(sA(1:2)) > 1
      B(:,1,s{:})	= diag(A(:,:,s{:}));
    else
      B(:,:,s{:})	= diag(A(:,:,s{:}));
    end
  end % for s=counter(sA(3:end))'
end

