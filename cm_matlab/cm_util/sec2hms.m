function [h,m,s]=sec2hms(inp)

h=floor(inp/(60*60));

m=floor((inp-(60*60*h))/60);

s=inp-(60*60*h)-60*m;