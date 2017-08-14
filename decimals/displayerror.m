function displayerror(err, varargin)
%DISPLAYERROR

  verbose	= false;
  assignopts(who, varargin);

  disp(err)
  if (verbose)
    for st=1:numel(err.stack)
      disp(err.stack(st))
      disp(' ');
    end % for st=1:numel(err.stack)
  end % if (verbose)
end