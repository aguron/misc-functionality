function varargout = loadvars(filename, varargin)
%LOADVARS Loads specified variables from a MAT-file 
%
% @ 2017 Akinyinka Omigbodun    aomigbod@ucsd.edu

  temp            = load(filename, varargin{:});
  fieldlist       = fieldnames(temp);
  for i=1:numel(fieldlist)
    varargout{i}	= temp.(fieldlist{i});
  end
end

