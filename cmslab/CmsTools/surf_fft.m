%%
drr=drx1-.02:0.001:drx1+0.02;
d=-log(drr)./sqrt(4*pi*pi+log(drr).^2);
N=length(d);
err=zeros(1,N);
W=err;
err1=err;
%%
options=optimset;
for i=1:N
    W(i)=fminsearch(@fitw,wx,options,d(i),Pfft(isel),jw(isel));
    err(i)=fitfft([d(i);W(i)],Pfft(isel),jw(isel));
    err1(i)=fitfft([d(i);wx],Pfft(isel),jw(isel));
end
%%
figure('position',[570 50 520 400]);
plot(drr,err)
xlabel('dr (-)');
ylabel('Loss function (-)');
%% generate surface plot
[DR,F]=meshgrid(drx1-.02:.001:drx1+.02,fdx1-0.01:0.001:fdx1+0.01);
ERR=DR;
D=-log(DR)./sqrt(4*pi*pi+log(DR).^2);
WW=2*pi*F./(1-D.^2);
for i=1:length(WW(:)),
    ERR(i)=fitfft([D(i);WW(i)],Pfft(isel),jw(isel));
end
figure('position',[1110 50 520 400]);
surf(DR,F,ERR)
xlabel('Decay Ratio');
ylabel('Frequency');
zlabel('Loss Function');
xlim([drx1-.02 drx1+.02]);
ylim([fdx1-.015 fdx1+0.015]);
figure(gcf);
