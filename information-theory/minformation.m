function I = minformation(arg,mVar,varargin)
%MINFORMATION computes mutual information (in bits) from a probability
%   distribution or from samples of 2 discrete random variables
%
% INPUTS:
%
% arg         - probability distribution or samples of discrete random
%               variables (in rows of a 2-D numeric array)
% mVar        - vector with true boolean values indicating which dimensions
%               or columns of the input argument ARG correspond to one of
%               the discrete random variables
%
% OUTPUTS:
%
% I           - mutual information (in bits)
%
% OPTIONAL ARGUMENTS:
%
% inputType   - ('probdist' or 'variable') specifies whether the input
%               argument ARG is a probability distribution or samples of
%               discrete random variables (default: 'probdist')
%
% @ 2017 Akinyinka Omigbodun    aomigbod@ucsd.edu

  inputType           = 'probdist';
  assignopts(who, varargin);

  switch(inputType)
    case 'variable'
      XY              = arg;
      I               =...
      	entropy2(XY(:,~mVar),varargin{:}) - centropy(XY,mVar,varargin{:});
    case 'probdist'
      pXY             = arg;
      pX              = msum(pXY,find(mVar));
      pY              = msum(pXY,find(~mVar));
      pXpY            = nan(size(pXY));
      for iXY=counter(size(pXY))'
        iX            = num2cell(iXY{1}(~mVar));
        iY            = num2cell(iXY{1}(mVar));
        iXY           = num2cell(iXY{1});
        pXpY(iXY{:})	= pX(iX{:})*pY(iY{:});
      end % for sub=counter(size(pXY))'
      I               = rentropy(pXY,pXpY,varargin{:});
    otherwise
      error('Invalid input type specification');
  end % switch(inputType)

end

