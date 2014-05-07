%@(#)   get_beta.m 1.1	 05/12/08     13:21:31
%
function [beta,lam]=get_beta(f_polca)
%
%  [beta,lam]=get_beta(f_polca)
%  
% 
%
% f_polca       POLCA distributionfile 
%		distributions from MATSTAB (default filename: [f_polca '_tmp.dat'])


%i=find(num==491000);             
%  b0=[.2070e-3 .1163e-2 .1027e-2 .2222e-2 .6990e-3 .1420e-3]';    % fractions of delayed neutron

%i=find(num==492000);
%  al=[.127e-1 .317e-1 .115 .311 .14e1 .387e1]';    % decay constant of delayed neutrons

% coefficients for betacorrelation b(burn,void,vhist),
%  betacoeff=[2.835181e-03  -4.514440e-05  4.783549e-07  5.814993e-05  -6.998074e-05];


b0=[0.000249  0.00145  0.00131  0.00287  0.000989  0.00225]';
al=[.127e-1 .317e-1 .115 .311 .14e1 .387e1]'; 


betacoeff=[1.0   -0.01355   0.00004888  -0.00198   -0.0305,
           1.0   -0.008335  0.00003721  -0.00198   -0.0305,
           1.0   -0.008335  0.00003721  -0.00198   -0.0305,
           1.0   -0.008335  0.00003721  -0.00198   -0.0305,
           1.0   -0.008335  0.00003721  -0.00198   -0.0305,
           1.0   -0.008335  0.00003721  -0.00198   -0.0305 ];




% Delayed neutrons

  %use correlation
  burnup=readdist7(f_polca,'burnup');
  burnup=burnup(:);
%  void=readdist7(f_polca,'void');
%  void=void(:);
  void=0*burnup;
  dnshis=readdist7(f_polca,'dnshis');
  dnshis=dnshis(:);
  power=readdist7(f_polca,'power');
  power=power(:);
  raal=739.3094; % Density of water at 70.5 Bar
  raag=36.8209;  % Density of steam at 70.5 Bar
  vhist=(raal-dnshis)/(raal-raag);
  for i=1:6
    corr(i,:)=betacoeff(i,:)*[ones(size(burnup)) burnup burnup.^2 void vhist]';
    b(i,:)=corr(i,:)*b0(i);
  end
  al=al*ones(size(burnup))';

beta(1,:)=mean(mean(b(1,:)'.*power));
beta(2,:)=mean(mean(b(2,:)'.*power));
beta(3,:)=mean(mean(b(3,:)'.*power));
beta(4,:)=mean(mean(b(4,:)'.*power));
beta(5,:)=mean(mean(b(5,:)'.*power));
beta(6,:)=mean(mean(b(6,:)'.*power));
lam=mean(al')';
