function B = maparray(A, old, new)
%MAPARRAY
%   
  if (numunique(A) > numel(old)) ||...
    ~isequal(numunique(old), numel(old), numel(new)) ||...
     ~all(ismember(vec(unique(A)), vec(unique(old))))
    error('Invalid mapping');
  end

  B                 = A;
  for i=1:numel(old)
    B(A	== old(i))	= new(i);
  end % for i=1:numel(old)
  
end

