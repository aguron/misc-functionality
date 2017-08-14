function B = modifycells(A, rule)
%MODIFYCELLS
%   

% B       = cell(size(A));
% for i=1:numel(A)
%   B{i}  = rule(A{i});
% end
  
  B       = cellfun(rule,A,'UniformOutput',false);
end

