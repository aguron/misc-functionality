function H = centropy(arg,cVar,varargin)
%CENTROPY computes conditional entropy H(X|Y) (in bits) from a probability
%   distribution or from samples of 2 discrete random variables
%
% INPUTS:
%
% arg         - probability distribution or samples of discrete random
%               variables (in rows of a 2-D numeric array)
% cVar        - vector with true boolean values indicating which dimensions
%               or columns of the input argument ARG correspond to discrete
%               random variable, Y
%
% OUTPUTS:
%
% H           - conditional entropy H(X|Y) (in bits)
%
% OPTIONAL ARGUMENTS:
%
% inputType   - ('probdist' or 'variable') specifies whether the input
%               argument ARG is a probability distribution or samples of
%               discrete random variables (default: 'probdist')
%
% @ 2017 Akinyinka Omigbodun    aomigbod@ucsd.edu

  inputType   = 'probdist';
  assignopts(who, varargin);
  
  if (size(cVar,1) > 1)
    error('cVar must be a row vector');
  end % if (size(cVar,1) > 1)
  
  switch(inputType)
    case 'variable'
      X       = arg;
      if (size(X,2) ~= length(cVar))
        error('Inconsistent specification of X and cvar');
      end % if (size(X,2) ~= length(cVar))
      
      H       = entropy2(X,varargin{:}) - entropy2(X(:,cVar),varargin{:});
    case 'probdist'
      p       = arg;
      if (ndims(p) ~= length(cVar))
        error('Inconsistent specification of p and cvar');
      end % if (ndims(p) ~= length(cVar))

      if find(p < 0,1)
        error('Probabilities must be nonnegative');
      end % if find(p < 0,1)

      if abs(ndarraysum(p) - 1) > (1e1*eps)
        error('Invalid probability distribution');
      end % if abs(ndarraysum(p) - 1) > (1e1*eps)

      p1      = msum(p, find(~cVar));
      H       = entropy2(p,varargin{:}) - entropy2(p1,varargin{:});
      
    otherwise
      error('Invalid input type specification');
  end % switch(inputType)
end