function [category, stats] = multihmmclassify(HMMs, seqs, varargin)
%MULTIHMMCLASSIFY
%   
  
  
  prior                     = [];
  extraOpts                 = assignopts(who, varargin);
  
  nHMM                      = length(HMMs);
  if isempty(prior)
    prior                   = normalize(ones(1,nHMM));
  end % 

  if isnumeric(seqs)
    nSeq                    = size(seqs, 1);
  elseif iscell(seqs)
    nSeq                    = numel(seqs);
  else
    error(message('stats:multihmmtrain:BadSequence'));
  end
  
  category                  = nan(nSeq,1);
  
  stats                     = struct('pStates', cell(nSeq,nHMM),...
                                     'logpseq', cell(nSeq,nHMM),...
                                     'fs', cell(nSeq,nHMM),...
                                     'bs', cell(nSeq,nHMM),...
                                     's', cell(nSeq,nHMM));

  switch(nHMM)
    case 1
      error('There must be at least two categories');
    otherwise % (nHMM > 2)
      for n=1:nSeq  
        if isnumeric(seqs)
          seq               = seqs(n,:);
        elseif iscell(seqs)
          seq               = seqs{n};
        else
          error(message('stats:multihmmtrain:BadSequence'));
        end
        for i=1:nHMM
          [pStates, logpseq, fs, bs, s]...
                            = hmmdecode2(seq,...
                                         HMMs(i).ST,...
                                         HMMs(i).TR,...
                                         HMMs(i).E,...
                                         extraOpts{:});
          stats(n,i).pStates= pStates;
          stats(n,i).logpseq= logpseq;
          stats(n,i).fs    	= fs;
          stats(n,i).bs    	= bs;
          stats(n,i).s     	= s;
        end % for i=1:nHMM
        
        [~, category(n)] 	= max(log(prior) + [stats(n,:).logpseq]);
      end % for n=1:nSeq
  end % switch(nHMM)
end