function chan=GetChannel(data,chno)
% GetChannel - pulls out channel values from data (from read_cms_dist)
% 
% chan=GetChannel(data,chno)
ntstep=size(data,2);
kmax=size(data{1},1);
chan=NaN(ntstep,kmax);
for i=1:length(data),
    chan(i,:)=data{i}(:,chno)';
end
