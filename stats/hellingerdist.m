function H = hellingerdist(dist1, dist2, varargin)
%HELLINGERDIST
%   
  distType          = 'n'; % default: 'n'
  assignopts(who, varargin);

  
  switch(distType)
    case 'n'
      mu1           = dist1.mu;
      S1            = dist1.S;
      
      mu2           = dist2.mu;
      S2            = dist2.S;

      term1         = (det(S1)*det(S2))^(1/4);
      term2         = det((S1 + S2)/2)^(1/2);
      term3         = exp(-(1/8)*(mu1-mu2)'/((S1 + S2)/2)*(mu1-mu2));

      H             = sqrt(1 - (term1/term2)*term3);
    otherwise
      
  end
  
end

