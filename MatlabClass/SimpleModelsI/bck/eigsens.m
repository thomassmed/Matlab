%% Mass string example and explanation of Matstab
%% Define the system d2xdt+0.2dxdt+1.01x=0
A=[0      1
  -1.01  -.2];
[V,D]=eig(A);
V1=inv(V);

%% Calculate
x0=[1 0]';
t=0:.1:10;
N=length(t);
X=nan(2,N);
for i=1:N,
    X(:,i)=V*expm(D*t(i))*(V\x0);
end
plot(t,X)
legend('Displacement','Speed');
%% Initiate for Inverse iteration with shift
lam=2i;
e=[1;1];
%% Inverse iteration with shift
for i=1:10,
    e=(lam*eye(2)-A)\e;
    e=e/norm(e);
    lamold=lam;
    lam=e'*A*e/(e'*e)
    if abs(lamold-lam)<1e-5, break;end
end
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




