function H = entropy2(arg,varargin)
%ENTROPY2
%   

  inputType   = 'probdist';
  assignopts(who, varargin);

  switch(inputType)
    case 'variable'
      X       = arg;
      if ~isnumeric(X) || (ndims(X)~=2)
        error('variable input must be a 2-d matrix');
      end % if ~isnumeric(X) || (ndims(X)~=2)
      uX      = unique(X,'rows');
      nX      = size(uX,1);
      p       = nan(1,nX);
      for n=1:nX
        p(n)	= sum(all(bsxfun(@eq,X,uX(n,:)),2))/size(X,1);
      end % for n=1:nX
    case 'probdist'
      p       = arg;
    otherwise
      error('Invalid input type specification');
  end % switch(inputType)

  if find(p < 0,1)
    error('Probabilities must be nonnegative');
  end % if find(p < 0,1)

  if abs(ndarraysum(p) - 1) > (1e1*eps)
    error('Invalid probability distribution');
  end % if abs(ndarraysum(p) - 1) > (1e1*eps)

  p           = rmentries(p, @(x) (x <= 0));
  H           = -ndarraysum(p.*log2(p));
end