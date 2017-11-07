function HMMs = multihmmestimate(seqs,states,label,varargin)
%MULTIHMMESTIMATE
%   

  labels                = unique(label);
  nHMM                  = numel(labels);
  HMMs                  = struct('ST', cell(1,nHMM),...
                                 'TR', cell(1,nHMM),...
                                 'E', cell(1,nHMM));

  if isnumeric(seqs) && isnumeric(states)
    nSeq                = size(seqs, 1);
    if (nSeq ~= numel(label))
      error('Number of sequences and number of labels must be equal');
    end % if (nSeq ~= numel(label))
    if (nSeq ~= size(states, 1))
      error('seqs and states must be the same size');
    end % if (nSeq ~= size(states, 1))
    nSym                = numel(unique(seqs));
    nStates             = numel(unique(states));
    cellflag            = false;
  elseif iscell(seqs) && iscell(states)
    nSeq                = numel(seqs);
    if (nSeq ~= numel(label))
      error('Number of sequences and number of labels must be equal');
    end % if (nSeq ~= numel(label))
    if (nSeq ~= numel(states))
      error('seqs and states must be the same size');
    end % if (nSeq ~= numel(states))
    nSym                = numel(unique(cell2mat(seqs)));
    nStates             = numel(unique(cell2mat(states)));
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
          HMM           = hmmestimate2(seqs(label==i,:),...
                                       states(label==i,:),...
                                       nSym,...
                                       nStates,...
                                       varargin{:});
        else
          HMM           = hmmestimate2(seqs(label==i),...
                                       states(label==i),...
                                       nSym,...
                                       nStates,...
                                       varargin{:});
        end
        
        HMMs(i).ST      = HMM.ST;
        HMMs(i).TR      = HMM.TR;
        HMMs(i).E       = HMM.E;
      end % for i=1:nHMM
  end % switch(nHMM)

end

