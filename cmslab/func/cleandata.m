function data=cleandata(data)
for i=1:size(data,2), 
    iii=find(abs(data(:,i))>1e20);data(iii,i)=0;data(iii,i)=mean(data(:,i));
end
