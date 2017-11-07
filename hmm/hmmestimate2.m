function HMM = hmmestimate2(seqs,states,nSym,nStates,varargin)
%
% HMM = hmmestimate2(seqs, states, nSym, nStates, ...)
%
% Estimates the parameters (start probabilities, ST, transition probability
% matrix, TR, and emission probability matrix, E) for an HMM, given state
% information.
%
% INPUTS:
%
% seqs              - discrete sequences
% states            - hidden states corresponding to the sequences
% nSym              - number of symbols in the sequences
% nStates           - number of hidden states
%
% OUTPUTS:
%
% HMM               - hidden Markov models with fields
%                       ST (1 x nStates)        -- start probabilities
%                       TR (nStates x nStates)  -- transition probability
%                                                  matrix
%                       E (nStates x nSym)      -- emission probability
%                                                  matrix
%               
% OPTIONAL ARGUMENTS:
%
% Symbols           - sequence symbols (default: 1:nSym)
% Statenames        - state names (default: 1:nStates)
% Pseudostarts      - pseudo counts for start probabilities
%                     (default: zeros(1,nStates))
% Pseudotransitions	- pseudo counts for transition probability matrix
%                     (default: zeros(nStates))
% Pseudoemissions   - pseudo counts for emission probability matrix
%                     (default: zeros(nStates,nSym))
%
% Code adapted from hmmestimate.m by MathWorks.
%
% @ 2017 Akinyinka Omigbodun    aomigbod@ucsd.edu

  Symbols                 = 1:nSym;
  Statenames              = 1:nStates;
  Pseudostarts            = zeros(1,nStates);
  Pseudotransitions       = zeros(nStates);
  Pseudoemissions         = zeros(nStates,nSym);

  assignopts(who, varargin);

  HMM.ST                  = Pseudostarts;
  HMM.TR                  = Pseudotransitions;
  HMM.E                   = Pseudoemissions;

  if isnumeric(seqs)
    nSeq                  = size(seqs, 1);
    for i=1:nSeq
      [TR,E]              = hmmestimate(seqs(i,:),states(i,:),...
                                        'Symbols',Symbols,...
                                        'Statenames',Statenames);
      HMM.ST(states(i,1)) = HMM.ST(states(i,1)) + 1;
      HMM.TR              =...
        HMM.TR + bsxfun(@times,TR,histc(states(i,1:end-1),Statenames)');
      HMM.E               =...
        HMM.E  + bsxfun(@times,E,histc(states(i,1:end),Statenames)');
    end % for i=1:nSeq
  elseif iscell(seqs)
    nSeq                  = numel(seqs);
    
    for i=1:nSeq
      [TR,E]              = hmmestimate(seqs{i},states{i},...
                                        'Symbols',Symbols,...
                                        'Statenames',Statenames);
      HMM.ST(states{i}(1))= HMM.ST(states{i}(1)) + 1;
      HMM.TR              =...
        HMM.TR + bsxfun(@times,TR,histc(states{i}(1:end-1),Statenames)');
      HMM.E               =...
        HMM.E  + bsxfun(@times,E,histc(states{i}(1:end),Statenames)');
    end % for i=1:nSeq
  else
    error(message('stats:multihmmtrain:BadSequence'));
  end

  HMM.ST                  = normalize(HMM.ST);
  for s=1:nStates
    HMM.TR(s,:)           = normalize(HMM.TR(s,:));
    HMM.E(s,:)            = normalize(HMM.E(s,:));
  end % for s=1:nStates
end