function B = arrayaccess(A,access)
%ARRAYACCESS
%
% INPUTS:
%
% A       - array
% access  - string indicating how to access A
%
% OUTPUTS:
%
% B       - retrieved entries
%
% @ 2017 Akinyinka Omigbodun    aomigbod@ucsd.edu

% EXAMPLES:
%   A = [1 2; 3 4];
%   arrayaccess(A,'(:,1)')
%   ans =
%        1
%        3

  B	= eval(['A',access,';']);
end