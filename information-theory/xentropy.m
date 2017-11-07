function H = xentropy(argP,argQ,varargin)
%XENTROPY computes the cross entropy (in bits) from probability
%   distributions or from samples of two discrete random variables
%
% INPUTS:
%
% argP       	- first probability distribution or discrete random variable
%               samples (in rows of a 2-D numeric array)
% argQ       	- second probability distribution or discrete random variable
%               samples (in rows of a 2-D numeric array)
%
% OUTPUTS:
%
% H           - cross entropy (in bits)
%
% OPTIONAL ARGUMENTS:
%
% inputType   - ('probdist' or 'variable') specifies whether the input
%               arguments ARGP and ARGQ are probability distributions or
%               discrete random variable samples (default: 'probdist')
%
% @ 2017 Akinyinka Omigbodun    aomigbod@ucsd.edu


  inputType   = 'probdist';
  assignopts(who, varargin);

  switch(inputType)
    case 'variable'
      XP      = argP;
      XQ      = argQ;
      if ~isnumeric(XP) || (ndims(XP)~=2) ||...
         ~isnumeric(XQ) || (ndims(XQ)~=2)
        error('variable inputs must be a 2-d matrices');
      end
      uXP     = unique(XP,'rows');
      nXP     = size(uXP,1);
      p       = nan(1,nXP);
      for n=1:nXP
        p(n)	= sum(all(bsxfun(@eq,XP,uXP(n,:)),2))/size(XP,1);
      end % for n=1:nXP
      uXQ     = unique(XQ,'rows');
      nXQ     = size(uXQ,1);
      q       = nan(1,nXQ);
      for n=1:nXQ
        q(n)	= sum(all(bsxfun(@eq,XQ,uXQ(n,:)),2))/size(XQ,1);
      end % for n=1:nXQ
    case 'probdist'
      p       = argP;
      q       = argQ;
    otherwise
      error('Invalid input type specification');
  end % switch(inputType)
  
  if (numel(p) ~= numel(q))
    error('probabilities, p and q must have the same length');
  end % if (length(p) ~= length(q))

  
  if find(p < 0,1)
    error('Probabilities, p, must be nonnegative');
  end % if find(p < 0,1)
  if find(q < 0,1)
    error('Probabilities, q, must be nonnegative');
  end % if find(q < 0,1)

  if abs(ndarraysum(p) - 1) > (1e1*eps)
    error('Invalid probability distribution, p');
  end % if abs(ndarraysum(p) - 1) > (1e1*eps)
  if abs(ndarraysum(q) - 1) > (1e1*eps)
    error('Invalid probability distribution, q');
  end % if abs(ndarraysum(q) - 1) > (1e1*eps)
  [p, q]      = deal(p(~(p==q) | (p~=0)),q(~(p==q) | (p~=0)));
  H           = -sum(p(:).*log2(q(:)));
end