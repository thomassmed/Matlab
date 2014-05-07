tic
resinfo=ReadCore('dist-tip.res');
toc
%%
tic
pinpow=ReadCore(resinfo,'pinpow','all');
toc
%%
tic
for i=1:length(pinpow),
    Pinpow{i}=cor2veccell(pinpow{i},resinfo.core.mminj);
end
toc
%%
tic
mmmax=@(x) max(max(max(x)))
for i=1:length(Pinpow),
    maxpin(i,:)=cellfun(mmmax,Pinpow{i})';
end
toc
%% Find at what state point max occurs
[xm,sp]=max(max(maxpin'))
%%
[x,indx]=max(maxpin(sp,:))
%%
tic
pin87=ReadCore(resinfo,'pinpow','all',87);
toc
%%
[xx,indxx]=max(pin87{5},[],3)
%%
tic
for i=1:length(Pinpow), maxp(i)=Pinpow{i}{87}(10,8,4);end
toc
figure
plot(maxp)
%%
for i=1:length(Pinpow)-1,
    for j=1:length(Pinpow{i})
        dif{i}{j}=Pinpow{i+1}{j}-Pinpow{i}{j};
    end
end
%%
for i=1:length(dif),
    maxpindif(i,:)=cellfun(mmmax,dif{i})';
end
%%
pin156=ReadCore(resinfo,'pinpow','all',156);
%% Verify the interpretation of pinpow:
p1=Pinpow{1};
sumsum=@(x) squeeze(sum(sum(x)));
xx=sumsum(p1{1})
%%
pow1=ReadCore(resinfo,'POWER',1);
xx./pow1(:,1)
%%
temp=cellfun(sumsum,p1,'UniformOutput',false);
P1=cell2mat(temp');
P1=P1/mean(P1(:));
%%
dif=P1-pow1;
cmsplot dist-tip.res dif
compare2(P1,pow1)

    
    