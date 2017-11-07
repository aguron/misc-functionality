function s = modifyfield(s, field, rule)
%MODIFYFIELD applies function(s) to value(s) of field(s) of structure
%   of structure array
%
% INPUTS:
%
% s   	- structure or structure array
% field	- field or cell array of fields with a value or values to be
%         modified
% rule	- handle or cell array of handle(s) of function(s) to be applied
%         to the fields
%
% OUTPUTS:
%
% s     - modified structure or structure array
%
% @ 2017 Akinyinka Omigbodun    aomigbod@ucsd.edu

  if ischar(field)
    field             = {field};
    rule              = {rule};
  end % if ischar(field)

  if numel(field) ~= numel(rule)
    error('The numbers of specified fields and rules must be equal');
  end % if numel(field) ~= numel(rule)

  for i=1:numel(field)
    for j=1:numel(s)
      s(j).(field{i})	= rule{i}(s(j).(field{i}));
    end % for j=1:numel(s)
  end % for i=1:numel(field)
end