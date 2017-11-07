function numOut = dadp(numIn, nDigits)
%DADP converts a number to a string, preserving a specified number of
%   digits after the decimal point
%
% INPUTS:
%
% numIn       - number
%
% OUTPUTS:
%
% numOut     	- string of number
%
% OPTIONAL ARGUMENTS:
%
% nDigits   	- number of digits after the decimal point (default: 0)
%
% @ 2015 Akinyinka Omigbodun    aomigbod@ucsd.edu

  if (nargin == 1)
   nDigits	= 0;
  else
   if (nDigits < 0) || ~isint(nDigits)
    error('nDigits must be a non-negative integer');
   end
  end
  numOut    = sprintf(['%0.',num2str(nDigits), 'f '], numIn);
end

