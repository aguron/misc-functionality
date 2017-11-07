function [HMMs LLs] = multihmmtrain(seqs,HMMguess,label,varargin)
%MULTIHMMTRAIN
%   

  labels                = unique(label);
  nHMM                  = numel(labels);
  HMMs                  = struct('ST', cell(1,nHMM),...
                                 'TR', cell(1,nHMM),...
                                 'E', cell(1,nHMM));
  LLs                   = cell(nHMM,1);

  if isnumeric(seqs)
    nSeq                = size(seqs, 1);
    if (nSeq ~= numel(label))
      error('Number of sequences and number of labels must be equal');
    end % if (nSeq ~= numel(label))
    cellflag            = false;
  elseif iscell(seqs)
    nSeq                = numel(seqs);
    if (nSeq ~= numel(label))
      error('Number of sequences and number of labels must be equal');
    end % if (nSeq ~= numel(label))
    cellflag            = true;
  else
    error(message('stats:multihmmtrain:BadSequence'));
  end

  switch(nHMM)
    case 1
      error('There must be at least two categories');      
    otherwise % (nHMM > 2)
      for i=1:nHMM
        if ~(cellflag)
          [HMM, LLs{i}]	= hmmtrain2(seqs(label==i,:), HMMguess(i),...
                                    varargin{:});
        else
          [HMM, LLs{i}]	= hmmtrain2(seqs(label==i), HMMguess(i),...
                                    varargin{:});
        end
        
        HMMs(i).ST      = HMM.ST;
        HMMs(i).TR      = HMM.TR;
        HMMs(i).E       = HMM.E;
      end % for i=1:nHMM
  end % switch(nHMM)
end

