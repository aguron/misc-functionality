function b = isint(A)
%ISINT
% 
  
  A(isinf(A) | isnan(A))  	= 0.5;
    
  b                       	= ~logical(mod(A, 1));
  
end

