function [powfft,data,pow1pfft]=fft_phasor(cmsinfo,dist,tcut,lam)
if nargin<3, tcut=5;end
t=read_cms_scalar(cmsinfo,1);
data_cell=read_cms_dist(cmsinfo,dist);
[kmax,kan]=size(data_cell{1});
data=zeros(length(data_cell),kmax*kan);
for i=1:length(data_cell),
    data(i,:)=data_cell{i}(:)';
end
isel= t>tcut;
ddata=detrend(data(isel,:));
Powfft=fft(ddata);
[x,i]=max(abs(Powfft));
ifft=round(mean(i));
powfft=Powfft(ifft,:);
powfft=powfft.';
powfft=reshape(powfft,kmax,numel(powfft)/kmax);
if nargout>2&&nargin>3,
    vmult=exp(t(isel)*lam');
    pow1pfft=vmult*ddata;
    pow1pfft=reshape(pow1pfft,kmax,numel(powfft)/kmax);
end