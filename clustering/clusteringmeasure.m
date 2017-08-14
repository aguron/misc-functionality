function [S S1 S2] = clusteringmeasure(clustering,category)
%CLUSTERINGMEASURE
%   

N           = length(clustering);

if N ~= length(category)
  error('Number of cluster and category assignments must be the same');
end % if length(clustering) ~= length(category)


clusters    = unique(clustering);
G           = length(clusters);
categories  = unique(category);
C           = length(categories);

if (G <= 1)
  error('The number of clusters must be greater than 1');
end % if (G <= 1)

if (C <=1)
  error('The number of categories must be greater than 1');
end % if (C <=1)

S1          = 0;    % impurity of individual clusters
S2          = 0;    % scattering of individual categories


for g=1:G
  p         = histc(category(clustering == clusters(g)),categories);
  N_g       = sum(p);
  p         = p/N_g;
  S1        = S1 + N_g*entropy2(p);
end % for g=1:G
S1          = S1*(G/(C+G))/(N*log2(C));

for c=1:C
  p         = histc(clustering(category == categories(c)),clusters);
  N_c       = sum(p);
  p         = p/N_c;
  S2        = S2 + N_c*entropy2(p);
end % for c=1:C
S2          = S2*(C/(C+G))/(N*log2(G));

S           = 1 - S1 - S2;

end