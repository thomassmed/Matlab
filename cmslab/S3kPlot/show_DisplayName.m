%See name while clicking on line in figure
function show_DisplayName(varargin) 
hmainFig=gcf; 
current_line=gcl; %see choosed line
xdata=get(current_line,'XData');
ydata=get(current_line,'YData');
%hdt = datacursormode;
%set(hdt,'DisplayStyle','window');  
%set(hdt,'UpdateFcn',{@labeldtips,xdata,ydata}) 