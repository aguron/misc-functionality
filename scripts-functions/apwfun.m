function B = apwfun(f,varargin)
%APWFUN ARRAY PAGE-WISE FUNCTION applies a function f to all the pages of
%   multidimensional arrays
%
% INPUTS:
%
% f           - handle of function f
% varargin    - the pages of the multidimensional input arguments in
%               in varargin are the input arguments to the function f
%
% OUTPUTS:
%
% B           - output multidimensional array
%
% @ 2017 Akinyinka Omigbodun    aomigbod@ucsd.edu
%   
  nDim      = ndims(varargin{1});
  for i=2:(nargin-1)
   if (ndims(varargin{i}) ~= nDim)
    error('Input arrays must have the same number of dimensions');
   end % if (ndims(varargin{i}) ~= nDim)
  end % for i=2:(nargin-1)
  
  nPages    =	size(varargin{1});
  for i=2:(nargin-1)
   nPages2	=	size(varargin{i});
   if ~isequal(nPages2(3:end),nPages(3:end))
    error('Inconsistency in the number of pages');
   end % if ~isequal(nPages2(3:end),nPages(3:end))
  end % for i=2:(nargin-1)

  for p=counter(nPages(3:end))'
   p            = num2cell(p{1});
   args         = modifycells(varargin, @(A) A(:,:,p{:}));
   B(:,:,p{:})	= f(args{:});
  end % for p=counter(nPages(3:end))'
  
end

