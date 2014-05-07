%% Mass string example and explanation of Matstab
%% Define the system d2xdt+0.2dxdt+1.01x=0
A=[0      1
  -1.01  -.2];
[V,D]=eig(A);
V1=inv(V);
%% Calculate dr and frequency
lam=D(1,1);
sig=real(lam);
w=abs(imag(lam));
fd=1/2/pi;
dr=exp(sig/fd);
%% Calculate
x0=[1 -.1]';
t=0:.01:10;
N=length(t);
X=nan(2,N);
for i=1:N,
    X(:,i)=V*expm(D*t(i))*(V\x0);
end
phasor=get_phasor(t,real(X'),dr,fd,0);
%%  Display the phasors
hold off
h=compass(phasor);
hold on
compass(V(:,1),'g')
compass(V(:,1)*phasor(2)/V(2),'r')
set(h,'linewidth',1.5);
figure(gcf)
%% Initiate for Inverse iteration with shift
lam=2i;
e=[1;1];
niter=0;
%% Inverse iteration with shift
%for i=1:1000,
    e=(lam*eye(2)-A)\e;
    e=e/norm(e);
    lamold=lam;
    lam=e'*A*e/(e'*e)
    abs(-0.1+1i-lam)
    niter=niter+1
    %if abs(lamold-lam)<1e-5, break;end
%end
%% Calculate the left hand eigenvector
f=((lam+1000*eps)*eye(2)-A')\e;
f=f/norm(f);
f=f/f(2)*V1(1,2)
%% Sensitivity 
DpDlam=f*e.'/(f.'*e)
%% We can guess the impact of changing eg A(2,2) by 0.02:
lamnew_estimated=lam+.02*DpDlam(2,2)
%% Check that it is true:
Apert=A;
Apert(2,2)=Apert(2,2)+0.02;
eig(Apert)




