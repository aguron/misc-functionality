function B = transpose2(A, field)
%TRANSPOSE2
%   Computes the transpose of cell array or struct array elements

% INPUT - cell array or struct array

  if iscell(A)
    B               = cell(size(A));
    for m=1:numel(A)
      B{m}          = A{m}';
    end % for m=1:numel(A)
  elseif isstruct(A)
    B               = A;
    for m=1:numel(A)
      B(m).(field)  = A(m).(field)';
    end % for m=1:numel(A)
  else
    error(message('operation:transpose2:InvalidInput'));
  end
end

