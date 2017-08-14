function A = msum(A,dims)
%MSUM
%   
  for dim=sort(dims,'descend')
    A	= sum(A,dim);
  end % for dim=sort(dims,'descend')
end

