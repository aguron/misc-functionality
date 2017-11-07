function makelegend(plotObjSpecs, varargin)
%MAKELEGEND generates a legend for a line or bar plot
%
% INPUTS:
%
% plotObjSpecs	- structure whose i-th entry (corresponding to the i-th
%                 plot line or bar) has fields
%                   LineStyle     -- plot line or bar edge line style
%                   LineWidth     -- plot line or bar edge line width
%                   legendEntry  	-- plot line or bar legend entry
%            EITHER:
%                   Marker        -- plot line marker
%                   Color         -- plot line color
%                OR:
%                   FaceColor     -- bar face color
%                   EdgeColor     -- bar edge color
%                   barWidth      -- bar width
% OPTIONAL ARGUMENTS:
%
% FontSize    	- font size specification for axes handle
%
% @ 2017 Akinyinka Omigbodun    aomigbod@ucsd.edu

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

