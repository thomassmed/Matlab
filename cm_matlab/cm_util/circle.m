%@(#)   circle.m 1.2	 94/02/08     12:31:11
%
function [xx,yy]=circle(r,x,y)
x0=0:.01:2*pi;
xx=x+r*cos(x0);yy=y+r*sin(x0);
end
