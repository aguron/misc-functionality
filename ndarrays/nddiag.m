function B = nddiag(A,k)
%NDDIAG applies the MATLAB function DIAG to all the pages of
%   a multidimensional array
%
% @ 2017 Akinyinka Omigbodun    aomigbod@ucsd.edu

  if (ndims(A) == 2)
    switch(nargin)
     case 1
      B             = diag(A);
     case 2
      B             = diag(A,k);
     otherwise
      error('Invalid number of input arguments');
    end % switch(nargin)
    return
  end % if (ndims(A) == 2)

  sA              = size(A);
  for s=counter(sA(3:end))'
    s             = num2cell(s{1});
    if min(sA(1:2)) > 1
      switch(nargin)
       case 1
        B(:,1,s{:})	= diag(A(:,:,s{:}));
       case 2
        B(:,1,s{:})	= diag(A(:,:,s{:}),k);
       otherwise
        error('Invalid number of input arguments');
      end % switch(nargin)
    else
      switch(nargin)
       case 1
        B(:,:,s{:})	= diag(A(:,:,s{:}));
       case 2
        B(:,:,s{:})	= diag(A(:,:,s{:}),k);
       otherwise
        error('Invalid number of input arguments');
      end % switch(nargin)
    end
  end % for s=counter(sA(3:end))'
end

