function s = addfield(s, field, value)
%ADDFIELD adds a field to a structure or structure array
%
% INPUTS:
%
% s     - structure or structure array
% field	- field to be added
% value - value or cell array of values for the new field
%
% OUTPUTS:
%
% s     - modified structure or structure array
%
% @ 2017 Akinyinka Omigbodun    aomigbod@ucsd.edu

  if ~isequal(size(s),size(value))
    error('size mismatch between structure s and value');
  end % if ~isequal(size(s),size(value))

  if ~iscell(value)
   value            = {value};
  end % if ~iscell(value)
  
  for j=1:numel(value)
    s(j).(field)	= value{j};
  end % for j=1:numel(value)
end

