function makelegend(plotObjSpecs, varargin)
%MAKELEGEND
% 

  FontSize	= 24;
  assignopts(who, varargin);

  show;
  hold on

  if isfield(plotObjSpecs, 'Color')
   for i=1:numel(plotObjSpecs)
    plot(i,'LineStyle',plotObjSpecs(i).LineStyle,...
           'Marker', plotObjSpecs(i).Marker,...
           'Color', plotObjSpecs(i).Color,...
           'LineWidth', plotObjSpecs(i).LineWidth)
   end % for i=1:numel(plotObjSpecs)
  elseif isfield(plotObjSpecs, 'FaceColor')
   for i=1:numel(plotObjSpecs)
    b	= bar(nan,plotObjSpecs(i).barWidth);
    set(b,'FaceColor',plotObjSpecs(i).FaceColor,...
          'EdgeColor',plotObjSpecs(i).EdgeColor,...
          'LineStyle',plotObjSpecs(i).LineStyle,...
          'LineWidth', plotObjSpecs(i).LineWidth)
   end % for i=1:numel(plotObjSpecs)
  end

  legend({plotObjSpecs(:).legendEntry})
  set(gca,'FontSize',FontSize)
end

