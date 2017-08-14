function ind = minind(v, varargin)
%MININD returns the indices of the minimum value(s) in a vector
% 
  minTol                            = 0;
  assignopts(who, varargin);

  if ~isvector(v)
    error('Input must be a vector');
  end % if ~isvector(v)
  val                               = min(v);
  val                               = val + minTol;
  ind = find(v <= val);
end

