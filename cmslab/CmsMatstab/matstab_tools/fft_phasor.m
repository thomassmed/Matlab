function [powfft,data]=fft_phasor(cmsinfo,dist,tcut)
if nargin<3, tcut=5;end
t=read_cms_scalar(cmsinfo,1);
data_cell=read_cms_dist(cmsinfo,dist);
[kmax,kan]=size(data_cell{1});
data=zeros(length(data_cell),kmax*kan);
for i=1:length(data_cell),
    data(i,:)=data_cell{i}(:)';
end
i=find(t>tcut);
Powfft=fft(detrend(data(i,:)));
[x,i]=max(abs(Powfft));
ifft=round(mean(i));
powfft=Powfft(ifft,:);
powfft=powfft.';
powfft=reshape(powfft,kmax,numel(powfft)/kmax);