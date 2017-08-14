function [idx,obj] = gmcluster(data, nMixtures, varargin)
%GMCLUSTER
% 

% OPTIONAL ARGUMENTS:
%
% nRuns         - number of times gmdistribution.fit is run
% runUpdtCrit   - run update criterion (default: 'maxLL')
%                   'maxLL'     - maximize data loglikelihood
%                   'maxMinSzCl'- maximize number of data points
%                                 in the smallest cluster
% MaxIter       - number of iterations in gmdistribution.fit run
% verbose       - logical that specifies whether to display status messages
%                 (default: false)
% resetPRNG     - reset pseudorandom number generator (default: true)

  nRuns             = 1;
  runUpdtCrit       = 'maxLL';
  MaxIter           = 500;
  verbose           = false;
  resetPRNG         = true;

  assignopts(who, varargin);

  if (resetPRNG)
    rng('default');
  end % if (resetPRNG)
  opts              = statset('MaxIter', MaxIter);
  
  for i=1:max(1,nRuns)
    if (verbose)
      fprintf('GMM run %3d of %d\n', i, nRuns);
    end
    try
      temp          = gmdistribution.fit(data, nMixtures, 'Options', opts);
      temp2         = cluster(temp,data);
      temp3         = histc(temp2, 1:nMixtures);
      
      if exist('obj', 'var')
       switch(runUpdtCrit)
        case 'maxLL'
         [~, nlogl] = posterior(obj,data);
         [~, temp4] = posterior(temp,data);
         crit       = temp4 < nlogl;
        case 'maxMinSzCl'
         crit       = min(nPoints) < min(temp2);
       end % switch(runUpdtCrit)
      end % if exist('obj', 'var')

      if ~exist('obj', 'var') || crit
        obj         = temp;
        idx         = temp2;
        nPoints     = temp3;
      end
    catch err
      displayerror(err, 'verbose', verbose);
    end % try
  end % for i=1:max(1,nRuns)
  disp('');
end