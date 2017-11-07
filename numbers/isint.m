function b = isint(A)
%ISINT
%
% @ 2017 Akinyinka Omigbodun    aomigbod@ucsd.edu
  
  A(isinf(A) | isnan(A))  	= 0.5;
    
  b                       	= ~logical(mod(A, 1));
  
end

