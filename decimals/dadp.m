function numOut = dadp(numIn, nDigits)
%DIGITSAFTERDECIMALPOINT

  if (nargin == 1)
   nDigits	= 0;
  end % if (nargin == 1)
  numOut    = sprintf(['%0.',num2str(nDigits), 'f '], numIn);
end

