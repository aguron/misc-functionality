function H = rentropy(argP,argQ,varargin)
%RELATIVEENTROPY computes the relative entropy (in bits) from probability
%   distributions or from samples of two discrete random variables
%
% INPUTS:
%
% argP       	- first probability distribution or discrete random variable
%               samples (in rows of a 2-D numeric array)
% argQ       	- second probability distribution or discrete random variable
%               samples (in rows of a 2-D numeric array)
%
% OUTPUTS:
%
% H           - relative entropy (in bits)
%
% OPTIONAL ARGUMENTS:
%
% inputType   - ('probdist' or 'variable') specifies whether the input
%               arguments ARGP and ARGQ are probability distributions or
%               discrete random variable samples (default: 'probdist')
%
% @ 2017 Akinyinka Omigbodun    aomigbod@ucsd.edu

  inputType	= 'probdist';
  assignopts(who, varargin);

  switch(inputType)
    case 'variable'
      XP    = argP;
      XQ    = argQ;
      H     = -entropy2(XP,varargin{:}) + xentropy(XP,XQ,varargin{:});
    case 'probdist'
      p     = argP;
      q     = argQ;
      H     = -entropy2(p,varargin{:}) + xentropy(p,q,varargin{:});      
    otherwise
      error('Invalid input type specification');
  end % switch(inputType)
end