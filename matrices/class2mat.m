function A = class2mat(A)
%CLASS2MAT converts a cell array to a numeric array  
%
% @ 2017 Akinyinka Omigbodun    aomigbod@ucsd.edu

  if ~isnumeric(A)
    A	= cell2mat(A);
  end % if ~isnumeric(A)


end

