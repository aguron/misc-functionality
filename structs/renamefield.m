function s = renamefield(s, oldnames, newnames)
%RENAMEFIELD
  if ischar(oldnames)
    oldnames              = {oldnames};
  end % if ischar(oldnames)
  if ischar(newnames)
    newnames              = {newnames};
  end % if ischar(newnames)

  for i=1:max([numel(oldnames) numel(newnames)])
    for j=1:numel(s)
      s(j).(newnames{i})	= s(j).(oldnames{i});
    end % for j=1:numel(s)
  end % for i=1:max([numel(oldnames) numel(newnames)])
  if ~isequal(oldnames, newnames)
    s                    	= rmfield(s, oldnames);
  end % if ~isequal(oldnames, newnames)
end

