%% Read the LPRM:s and time
cmsfile='r1c14m.cms';
cmsinfo=read_cms(cmsfile);
[lprm,Names]=read_cms_scalar(cmsinfo,'LPRM');
t=read_cms_scalar(cmsinfo,1);
%% Transpose
lprm=lprm';
t=t';
%% Find
itid=find(t>8);
lprmc=lprm(itid,:);
fftlprm=fft(detrend(lprmc));
[maxfft,ifft]=max(abs(fftlprm));
%%
ifft=round(mean(ifft));
phaslprm=fftlprm(ifft,:);
phaslprm=reshape(phaslprm,4,length(phaslprm)/4);
phaslprm=phaslprm(4:-1:1,:);
phaslprm=phaslprm/phaslprm(4,7);
%% Alternative estimation method
%[dr,fd]=drident(lprmc(:,21),0.05);
dr=1.10;
fd=0.53;
%% Estimate by fitting the latter portion to f=m+real(A*exp(lam*t))
[phas,lprmest,x,tc,drx,fdx,p,p0,err]=get_phasor(t,lprm,dr,fd,8);
%% Compare with the parametric based estimation
for i=1:size(lprm,2),
    hold off;plot(t,lprm(:,i));hold on;plot(tc,lprmest(:,i),'rx');
    legend('S3K','Estimated','Location','NW');
    title(num2str(i));figure(gcf);pause(0.05);
end
%%
%[phasor,lprmest,x,tc,drx,fdx,p]=get_phasor(t,lprm,dr,fd,8);
%% Rearrange
phas=p(2,:)'+1j*p(3,:)';
phas=reshape(phas,4,length(phas)/4);
phas=phas(4:-1:1,:);
phas=phas/phas(4,7);
%% And compare with the fft based estimation
for i=1:size(phas,2),
    hold off
    compass(phas(:,i));
    hold on
    compass(phaslprm(:,i),'r');
    title(num2str(i));
    figure(gcf)
    pause
end
