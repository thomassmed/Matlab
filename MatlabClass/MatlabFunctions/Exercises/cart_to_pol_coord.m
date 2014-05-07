function [r, theta] = cart_to_pol_coord(x,y)
r=sqrt(x.*x+y.*y);
theta=atan2(y,x);
