function A = class2cell(A)
%CLASS2CELL
%   
  if ~iscell(A)
    A	= {A};
  end % if ~iscell(A)

end

