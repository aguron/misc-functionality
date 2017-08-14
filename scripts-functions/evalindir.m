function varargout = evalindir(otherDir, varargin)
%EVALINDIR executes a script or function in another directory and 
%   switches the working directory back to the original directory
%   
  origDir               = pwd;
  cd(otherDir)
  try
   n                    =	nargout(varargin{1});
   if (numel(varargin) == 1)
    if (n)
      argout           	= cell(n,1);
      [argout{:}]      	= evalin('caller', varargin{1});
      varargout        	= argout(1:nargout);
    else
      eval(varargin{1});
    end
   else % if (numel(varargin) > 1)
    for i=2:nargin-2
      varargin{i}       = [varargin{i},','];
    end % for i=2:nargin-2
    if (n)
      argout           	= cell(n,1);
      [argout{:}]      	=...
       evalin('caller', [varargin{1},'(',varargin{2:end},');']);
      varargout        	= argout(1:nargout);
    else
     evalin('caller', [varargin{1},'(',varargin{2:end},');']);
    end
   end
  catch err
   if strcmp(err.identifier, 'MATLAB:nargin:isScript')
    evalin('base',varargin{1})
   else
    rethrow(err)
   end
  end
  cd(origDir)
end