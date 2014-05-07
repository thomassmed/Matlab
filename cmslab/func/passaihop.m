function [err,yi,ti]=passaihop(delta,y,t,y1,t1)
%UNTITLED Summary of this function goes here
if delta<0
    imin=find(t+delta>0,1,'first');
    t(1:imin-1)=[];
    y(1:imin-1)=[];
end
if (t(end)+delta)>t1(end)
    imax=find(t+delta>t1(end),1,'first');
    t(imax:end)=[];
    y(imax:end)=[];
end
yi=interp1(t1,y1,t+delta);
ti=t;
err=var(yi-y);
err=err^4;
end

