function B = modifycells(A, rule)
%MODIFYCELLS applies a function to each entry of a cell array and
%   returns a corresponding cell array with the function evaluations
%
% INPUTS:
%
% A             - cell array
% rule          - handle of function to be applied to cell array entries
%
% OUTPUTS:
%
% B             - cell array with function evaluations of entries in A
%
% @ 2017 Akinyinka Omigbodun    aomigbod@ucsd.edu
%
% B       = cell(size(A));
% for i=1:numel(A)
%   B{i}  = rule(A{i});
% end
  
  B       = cellfun(rule,A,'UniformOutput',false);
end

