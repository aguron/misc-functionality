function b = isnatnum(A,varargin)
%ISNATNUM
%   
  zero	= false;
  assignopts(who, varargin);
  
  b     = isint(A);
  
  if (zero)
    b(b)	= (A(b) >= 0);
  else
    b(b)	= (A(b) > 0);
  end
end