function yp=pointkin(t,y,fcnraa,al,b)
%function pointkin 
%
%yp=pointkin(t,y[,fcnraa,al,b]);
%
% [t,y]=ode45(@pointkin,[0 50],[1;b./al]);
%
% 
% To call with defined function for raa:
% [t,y]=ode45(@(t,y) pointkin(t,y,@raafcn),[0 5],[1;b./al]);
% To call with non-default alfa and beta:
% [t,y]=ode45(@(t,y) pointkin(t,y,80,al,b,),tspan,[1;b./al]);
% and function raa=raafcn(t) has be supplied somewhere in matlabs path
%

if nargin<4,
al =[0.01269999984652
     0.03170000016689
     0.11500000208616
     0.31099998950958
     1.39999997615814
     3.86999988555908];
al=[.012779;.03165;.121749;.322893;1.404693;3.881428];
end

if nargin<5
b=[0.00022220000392
   0.00124899996445
   0.00110300001688
   0.00238600000739
   0.00075050001033
   0.00015249999706];
b = [2.03e-04;1.273e-03;1.1154e-03;2.487e-03;9.13e-04;2.21e-04];
end

%if t>1&t<5, raa=0.003; else raa=0; end
%raa=-0.0029316*sin(pi*t);%  Doppler:  -(y(1)-1)*0.001;

if nargin<3
    raa=.00080;
else
    if isnumeric(fcnraa)
        raa=fcnraa;
    else
        raa=fcnraa(t);
    end
end

LAM=1e-4;
LAM=1.6825e-5;
yp(1,1)=(raa-sum(b))/LAM*y(1)+al'*y(2:7)/LAM;
yp(2:7,1)=b*y(1)-al.*y(2:7);


%if nargout>1,
%  A(1,:)=[(raa-sum(b))/LAM al'/LAM];
%  A(2:7,1)=b;
%  A(2:7,2:7)=-diag(al);
%end
