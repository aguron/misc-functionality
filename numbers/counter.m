function seq = counter(idxMax)
%COUNTER
    idx = ones(size(idxMax));
    
    seqLen      = prod(idxMax);
    if (nargout > 0)
      seq       = cell(seqLen,1);
    end % if (nargout > 0)
    for i=1:seqLen
      if (nargout > 0)
        seq{i}    = idx;
      else
        disp(idx);
      end % if (nargout > 0)
      temp = find(idx < idxMax,1,'last');
      idx(temp) = idx(temp) + 1;
      for j=(temp+1):length(idx)
        idx(j)  = 1;
      end % for j=(temp+1):length(idx)
    end % for i=1:seqLen
end