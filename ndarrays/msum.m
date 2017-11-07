function A = msum(A,dims)
%MSUM sums along specified dimensions of an numeric array
%
% INPUTS:
%
% A       - numeric array
% dims    - specified dimensions
%
% OUTPUTS:
%
% A     	- modified numeric array
%
% @ 2017 Akinyinka Omigbodun    aomigbod@ucsd.edu

% EXAMPLES:
%   a(:,:,1) = [1 2; 3 4]; a(:,:,2) = [5 6; 7 8];
%   msum(a,[1 3])
%   ans =
%       16    20
%   msum(a,[1 2])
%   ans(:,:,1) =
%       10
%   ans(:,:,2) =
%       26

  for dim=sort(dims,'descend')
    A	= sum(A,dim);
  end % for dim=sort(dims,'descend')
end

