function [powfft,data]=lam_phasor(cmsinfo,dist,lam,tcut)
if nargin<4, tcut=5;end
if nargin<3,
    s3kout=strrep(cmsinfo.fileinfo.fullname,'.cms','.out');
    [dr,fd]=read_drfd_s3kout(s3kout);
    lam=drfd2p(dr,fd);
end
t=read_cms_scalar(cmsinfo,1);
data_cell=read_cms_dist(cmsinfo,dist);
[kmax,kan]=size(data_cell{1});
data=zeros(length(data_cell),kmax*kan);
for i=1:length(data_cell),
    data(i,:)=data_cell{i}(:)';
end
i=find(t>tcut);
xmult=exp(lam'*t(i));
powfft=xmult*detrend(data(i,:));
powfft=reshape(powfft,kmax,numel(powfft)/kmax);
if size(powfft,2)==cmsinfo.core.kan/2,
    temp=powfft;
    kan=cmsinfo.core.kan;
    powfft=zeros(kmax,kan);
    powfft(:,kan/2+1:kan)=temp;
    powfft(:,kan/2:-1:1)=temp;
end