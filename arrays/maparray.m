function B = maparray(A, old, new)
%MAPARRAY
% 
% INPUTS:
%
% A             - numeric array
% old           - values in numeric array
% new           - new values that the numeric array entries should be
%                 changed to
%
% OUTPUTS:
%
% B             - modified numeric array
%
% @ 2017 Akinyinka Omigbodun    aomigbod@ucsd.edu

  if ~isequal(numunique(old), numel(old), numel(new)) ||...
     ~all(ismember(vec(unique(A)), vec(unique(old))))
    error('Invalid mapping');
  end

  B                 = A;
  for i=1:numel(old)
    B(A	== old(i))	= new(i);
  end
  
end

