function A = class2cell(A)
%CLASS2CELL converts an array to a cell array if it is not one already
%   
  if ~iscell(A)
    A	= {A};
  end % if ~iscell(A)

end

