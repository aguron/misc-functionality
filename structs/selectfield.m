function t = selectfield(s,field)
%SELECTFIELD keeps specified fields in structure and removes others
%
% INPUTS:
%
% s         - structure or structure array
% field     - fields to keep
%
% OUTPUTS:
%
% t         - modified structure or structure array
%
% @ 2017 Akinyinka Omigbodun    aomigbod@ucsd.edu

  t   = rmfield(s, setdiff(fieldnames(s), field));
end

