%@(#)   cplot.m 1.2	 94/01/25     12:42:14
%
%set(gcf,'pointer','watch');
DNAMEMAT=setprop(4);
if length(DNAMEMAT)<9,
   ccplot;
elseif strcmp(DNAMEMAT(1:7),'MATLAB:')
   matvarread;
else
   ccplot;
end
%set(gcf,'pointer','arrow');
