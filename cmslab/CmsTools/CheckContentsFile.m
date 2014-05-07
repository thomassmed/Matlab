%%
fid=fopen('Contents.m','r');cnt=textscan(fid,'%s','delimiter','\n');cnt=cnt{1};
iaf=find(~cellfun(@isempty,regexp(cnt,'^%   ')));
fun=cnt(iaf);
clear fcn
icount=0;
for i=1:length(fun),
    rad=fun{i};rad(1)=[];rad=remleadblank(rad);ispac=find(rad==' ',1,'first');
    if ispac>2,
        icount=icount+1;
        fcn{icount}=rad(1:ispac-1);
    end
end
%%
for i=1:length(fcn),
which(fcn{i})
end
