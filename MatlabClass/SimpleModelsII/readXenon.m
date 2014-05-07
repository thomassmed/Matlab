fid =fopen('pred-sum-xenon.txt');
for i=1:9,
    rad=fgetl(fid);
end
for i=1:100,
    rad=fgetl(fid);
    if length(rad)<18, break;end
    x(i,:)=sscanf(rad(19:end),'%g')';
end
fclose(fid);