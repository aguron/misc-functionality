function a = rmentries(a, condition, field)
%RMENTRIES removes entries from a numeric, cell, or structure array that
%   satisfy a condition
%
% INPUTS:
%
% a           - numeric, cell, or structure array
%
% OUTPUTS:
%
% condition  	- handle of function expressing condition
%
% OPTIONAL ARGUMENTS:
%
% field       - field name if input argument A is a structure array
%
% @ 2017 Akinyinka Omigbodun    aomigbod@ucsd.edu

  if isnumeric(a)
    a = a(~condition(a));
  elseif iscell(a)
    a = a(~cellfun(condition,a));
  elseif isstruct(a)
    a = a(~cellfun(condition,{a.(field)}));
  end
end

