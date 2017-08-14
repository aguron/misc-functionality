function A = class2mat(A)
%CLASS2MAT
%   
  if ~isnumeric(A)
    A	= cell2mat(A);
  end % if ~isnumeric(A)


end

