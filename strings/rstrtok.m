function [token, remain] = rstrtok(str, delimiter)
%RSTRTOK performs the same function as STRTOK from the end of a
%   string (instead of from the beginning)

  str               = fliplr(str);
  [token, remain]   = strtok(str, delimiter);
  [token, remain]   = deal(fliplr(remain),fliplr(token));
  token             = token(1:end-1);
  remain            = [delimiter, remain];
end

