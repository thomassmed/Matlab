function lam=fftfit(cmsfile,plotta)
% fftfit - Makes the fft fit implemented in S3K and other fits and compares
%
% Input:
%   cmsfile - cmsfile (*.cms)
%
% Output:
%   No variables, just plots and prints

%% Explain how to the fit in S3K is done
%% Read power and time from S3K 
if nargin<2
    if nargout>0, 
        plotta=false;
    else
        plotta=true;
    end
end
%cmsfile='r1_cy14_09_glbl.cms';
%cmsfile='r1_cy14_09_rgnl.cms';
%cmsfile='reg-s3k-09.cms';
%cmsfile='s3k-02.cms';
cmsinfo=read_cms(cmsfile);
t=read_cms_scalar(cmsinfo,1);
pow=read_cms_scalar(cmsinfo,'Relative Power');
%pow=read_cms_scalar(cmsinfo,'octant-4');
pow=pow';t=t';
%% read S3K's report on dr and fd
if plotta,
    [dr,fd,tw]=read_drfd_s3kout(strrep(cmsfile,'.cms','.out'));
else
    dr=0.8;
    fd=0.5;
    tw=[5 min(max(t),20)];
end
%% take the fft of power
isel1=(t>=tw(1)&t<=tw(2));
iisel1=find(isel1);
L=length(find(isel1));
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
NFFT=NFFT/2;
dt=t(iisel1(1)+1)-t(iisel1(1));
Fs=1/dt;
l=NFFT/2+1;
f = Fs/2*linspace(0,1,l);f=f';
w=f*2*pi;
Pfft=fft(detrend(pow(isel1)),NFFT);
Pfft=Pfft(1:l);
% Fit d and w0
% F(s) = (as+c)/((s/w0)^2+2d(s/w0)+1)
isel=f>=.2&f<=2;
d=0.1;
[xx,ii]=max(abs(Pfft));
w0=f(ii)*2*pi;
jw=w*1j;
options=optimset;
%d=-log(dr)./sqrt(4*pi*pi+log(dr).^2);
%w0=2*pi*fd/sqrt(1-d^2);
pp=fminsearch(@fitfft,[d;w0],options,Pfft(isel),jw(isel));
dx=pp(1);
wx=pp(2);
drx1=exp(-2*pi*dx/sqrt(1-dx^2));
fdx1=wx/2/pi*sqrt(1-dx^2);
lam=drfd2p(drx1,fdx1);
if plotta,
[err,Pfftest]=fitfft(pp,Pfft(isel),jw(isel));
% Plot the results
figure('position',[570 540 520 400]);
plot(f(isel),abs(Pfft(isel)));
hold on
plot(f(isel),abs(Pfftest),'r')
%%
figure('position',[1110 540 520 400]);
[phasor,xest,xx,tt,drx,fdx,p,p0,err,err0]=get_phasor(t(isel1),pow(isel1),.5*(drx1+dr),.5*(fdx1+fd),0,1);
fprintf('Time window %4.2f %4.2f\n',tw);
fprintf('Method      dr      freq\n');
fprintf('S3K FFT     %6.4f  %6.4f\n',dr,fd);
fprintf('Matlab FFT  %6.4f  %6.4f\n',drx1,fdx1);
fprintf('get_phasor  %6.4f  %6.4f\n',drx,fdx);
perc='%';
fprintf('Difference vs S3K (%s) \n',perc);
ddrx1=100*(drx1-dr)/dr;
dfdx1=100*(fdx1-fd)/fd;
fprintf('Matlab FFT  %6.3f  %6.3f\n',ddrx1,dfdx1);
ddrx=100*(drx-dr)/dr;
dfdx=100*(fdx-fd)/fd;
fprintf('get_phasor  %6.3f  %6.3f\n',ddrx,dfdx);

surf_fft
end

