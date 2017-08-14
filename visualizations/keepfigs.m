function keepfigs(figs2keep)
%KEEPFIGS
%   
  close(setdiff(findall(0,'type','figure'),figs2keep));
end

