function numOut = radp(numIn, nDigits)
%ROUNDAFTERDECIMALPOINT
    numOut = 10^-nDigits * round(10^nDigits * numIn);
end

