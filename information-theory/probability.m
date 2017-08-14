function p = probability(X)
%PROBABILITY computes probability of variable(s)
%   
  if ~isnumeric(X) || (ndims(X)~=2)
    error('variable input must be a 2-d matrix');
  end % if ~isnumeric(X) || (ndims(X)~=2)
  
  nDim                = size(X,2);
  for d=1:nDim
    for u=unique(X(:,d))'
      X(X(:,d)==u,d)	= find(u==unique(X(:,d)));
    end % for u=unique(X(:,d))'
  end % for d=1:nDim

  uX                  = unique(X,'rows');
  nX                  = size(uX,1);
  
  
  sDim                = nan(1,nDim);
  for d=1:nDim
    sDim(d)           = numunique(X(:,d));
  end % for d=1:nDim
  
  if (numel(sDim) == 1)
    p               	= zeros(sDim,1);
  else
   	p               	= zeros(sDim);
  end
  for n=1:nX
    sub               = num2cell(uX(n,:));
    p(sub{:})         = sum(all(bsxfun(@eq,X,uX(n,:)),2))/size(X,1);
  end % for n=1:nX
end

