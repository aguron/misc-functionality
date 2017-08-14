function [IDX,C,sumd,D] = kmeanscluster(data, nClusters, varargin)
%KMEANSCLUSTER
% 
% OPTIONAL ARGUMENTS:
%
% nRuns         - number of times k-means is run
% runUpdtCrit	- run update criterion (default: 'maxLL')
%                   'minDist' 	- minimize sum of centroid distances  
%                   'maxMinSzCl'- maximize number of data points
%                                 in the smallest cluster
% MaxIter       - number of iterations in k-means run
% verbose       - logical that specifies whether to display status messages
%                 (default: false)
% resetPRNG     - reset pseudorandom number generator (default: true)
% centroid      - k-means cluster centroids to be used in clustering
%                 (default: [])

  centroid          = [];
  
  extraOpts       	= assignopts(who, varargin);
  

  if isempty(centroid)
    nRuns          	= 1;
    runUpdtCrit     = 'minDist';
    MaxIter        	= 500;
    verbose        	= false;
    resetPRNG      	= true;

    assignopts(who, extraOpts);

    if (resetPRNG)
      rng('default');
    end % if (resetPRNG)
    opts           	= statset('MaxIter', MaxIter);
  
    temp           	= cell(4, 1);
  
    for i=1:max(1,nRuns)
      if (verbose)
        fprintf('K-means run %3d of %d\n', i, nRuns);
      end % if (verbose)
      [temp{:}]    	= kmeans(data, nClusters, 'Options', opts);

      if strcmp(runUpdtCrit, 'maxMinSzCl')
        temp2     	= histc(temp{1}, 1:nClusters);
      end % if strcmp(runUpdtCrit, 'maxMinSzCl')

      if (i > 1)
       switch(runUpdtCrit)
        case 'minDist'
         crit       = sum(temp{3}) < sum(sumd);
        case 'maxMinSzCl'
         crit       = min(nPoints) < min(temp2);
       end % switch(runUpdtCrit)
      end % if (i > 1)

      if (i == 1) || crit
        IDX        	= temp{1};
        C          	= temp{2};
        sumd       	= temp{3};
        D          	= temp{4};
        if strcmp(runUpdtCrit, 'maxMinSzCl')
          nPoints   	= temp2;
        end % if strcmp(runUpdtCrit, 'maxMinSzCl')
      end
    end % for i=1:max(1,nRuns)
    disp('');
  else
    if (nClusters ~= size(centroid,1))
      error(['The number of specified clusters is ',...
             'inconsistent with the centroid matrix']);
    end % if (nClusters ~= size(centroid,1))
    C               = centroid;
    D               = pdist2(data, C);
    D               = D.^2;
    [~, IDX]        = min(D,[],2);
    sumd            = nan(nClusters,1);

    for c=1:nClusters
      sumd(c)       = sum(D(IDX==c,c));
    end % for c=1:nClusters
  end
end