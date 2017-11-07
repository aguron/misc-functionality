function [token, remain] = rstrtok(str, delimiter)
%RSTRTOK performs the same function as STRTOK relative to the end of a
%   string (instead of relative to the beginning)
%
% EXAMPLES:
%   [token, remain] = rstrtok('a_b_c','_')
%   token =
%   a_b
%   remain =
%   _c
%   [token, remain] = strtok('a_b_c','_')
%   token =
%   a
%   remain =
%   _b_c
%
% @ 2017 Akinyinka Omigbodun    aomigbod@ucsd.edu

  str               = fliplr(str);
  [token, remain]   = strtok(str, delimiter);
  [token, remain]   = deal(fliplr(remain),fliplr(token));
  token             = token(1:end-1);
  remain            = [delimiter, remain];
end

