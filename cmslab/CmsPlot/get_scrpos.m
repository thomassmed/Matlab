function [NW,NE,SW,SE]=get_scrpos
% [NW,NE,SW,SE]=get_scrpos
% pos=get_scrpos (pos will be 4 by 4, [NW;NE;SW;SE]
%
% Example
% fg=cmsplot('s3.res');
% set(fg,'pos',NW)
scrsz=get(0,'screensize');
xsz=scrsz(3);
ysz=scrsz(4);
NW=[.01*xsz ysz*.5 .49*xsz .45*ysz];
NE=[.5*xsz ysz*.5 .49*xsz .45*ysz];
SW=[.01*xsz .01*ysz xsz*.49 ysz*.45];
SE=[.5*xsz .01*ysz xsz*.49 ysz*.45];
if nargout==1,
    NW=[NW;NE;SW;SE];
end