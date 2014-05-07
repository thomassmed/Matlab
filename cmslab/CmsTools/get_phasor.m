function [phasor,xest,x,t,drx,fdx,p,p0,err,err0]=get_phasor(t,x,dr,fd,tcut,PlotFlag)

%%
dt=diff(t);
if nargin<5,
    rdt=round(10./dt);
    urdt=unique(rdt);
    imin=find(rdt>urdt(1),1,'first');
    tcut=t(imin+2);
end
if nargin<6, PlotFlag=0;end

if length(tcut)>1,
    tupper=tcut(2);
    tcut=tcut(1);
else
    tupper=max(t);
end

ikeep=find(t>tcut&t<=tupper);
trp=0;
if length(t)==size(x,2),
    trp=1;
    x=x';
end

if size(t,2)>1,
    t=t';
end

t0=t;
x0=x;
t=t(ikeep);
x=x(ikeep,:);
if nargin<3,
    [dr,fd]=drident(x(:,1),min(diff(t)));
end



%%
w=2*pi*fd;
sig=w*log(dr)/2/pi;
p00=[0 0 0 sig w];
options=optimset('fminsearch');
xest=nan(size(x));xest0=xest;
err=nan(1,size(x,2));err0=err;
p=zeros(5,size(x,2));
p0=p;

for i=1:size(x,2),
    p0(:,i)=initp(t-tcut,x(:,i),p00);
    [err0(i),xest0(:,i)]=fitstab(p0(:,i),t-tcut,x(:,i));
    p(:,i)=fminsearch(@fitstab,p0(:,i),options,t-tcut,x(:,i));
    [err(i),xest(:,i)]=fitstab(p(:,i),t-tcut,x(:,i));
end
phasor=p(2,:)+1j*p(3,:);
if trp,
    xest=xest';
    x=x';
end


if get_bool(PlotFlag)
    for i=1:size(x,2),
    hold off
    plot(t0,x0(:,i));
    hold on
    plot(t,xest(:,i),'rx');
    drawnow
    figure(gcf)
    pause(0.05);
    end
end

if nargout>4,
    lam=p(4,:)+1j*p(5,:);
    [drx,fdx]=p2drfd(lam);
end





function p0=initp(t,x,p00)

A=[ones(size(x)) exp(p00(4)*t).*cos(p00(5)*t) -exp(p00(4)*t).*sin(p00(5)*t)];
p13=A\x;
p0=p00;
p0(1:3)=p13;