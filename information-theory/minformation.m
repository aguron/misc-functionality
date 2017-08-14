function I = minformation(arg,mVar,varargin)
%MINFORMATION computes mutual information
%   
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

