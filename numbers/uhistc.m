function b = uhistc(a, varargin)
%UHISTC Prepares counts of unique values 
%   
  b	= histc(a, unique(a), varargin{:});

end

