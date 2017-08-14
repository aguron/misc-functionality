function H = rentropy(argP,argQ,varargin)
%RELATIVEENTROPY computes relative entropy
%   
  inputType	= 'probdist';
  assignopts(who, varargin);

  switch(inputType)
    case 'variable'
      XP    = argP;
      XQ    = argQ;
      H     = -entropy2(XP,varargin{:}) + xentropy(XP,XQ,varargin{:});
    case 'probdist'
      p     = argP;
      q     = argQ;
      H     = -entropy2(p,varargin{:}) + xentropy(p,q,varargin{:});      
    otherwise
      error('Invalid input type specification');
  end % switch(inputType)
end