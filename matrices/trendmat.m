function B = trendmat(A,P,N)
%TRENDMAT
% 
% EXAMPLES:
%   trendmat([1 2],[2 2],[1 3])
%   ans =
%       1     2     4     5
%       2     3     5     6
%   trendmat([1 2],2,1)
%   ans =
%       1     2     2     3
%       2     3     3     4

  if (size(P,1) ~= 1) || (size(N,1) ~= 1) || (numel(P) ~= numel(N))
    error('P and N must be row vectors of the same size');
  end
  
  if any(~isint(P)) || any(P <= 0)
   error('P must contain positive integers');
  end
  
  if (numel(P) == 1)
    P       = [P P];
  end % if (numel(P) == 1)
  
  if (numel(N) == 1)
    N       = [N N];
  end % if (numel(N) == 1)

  B         = repmat(A,P);
  
  for idx=counter(P)'
    ind     = idx{1};
    r       = bsxfun(@times, [(ind-1); ind], size(A));
    r(1,:)	= r(1,:) + 1;
    r       = r';
    r       = indrange(r);
    B(r{:}) = B(r{:}) + sum((ind-1) .* N);
  end % for idx=counter(P)  
end

