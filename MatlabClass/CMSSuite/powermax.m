tic
resinfo=ReadCore('sim-dep.cms');
toc
%%
tic
pow=ReadCore(resinfo,'3RPF','all');
toc
%%
powmax=zeros(length(pow),size(pow{1},2));
for i=1:length(pow),
    powmax(i,:)=max(pow{i});
end
%% maxmax
maxmax=@(x) max(max(x));
powmaxx=cellfun(maxmax,pow)
%% Find at what state point max occurs
[xx,ix]=max(powmaxx)
%% Find which bundle max occurs in
[xb,ib]=max(powmax(ix,:))
%% Find what node max occurs in
[xn,in]=max(pow{ix}(:,ib))
%% generate the power history for that node:
for i=1:length(pow),
    maxnod(i)=pow{i}(in,ib);
end

