%@(#)   sum2lng.m 1.3	 06/11/17     10:21:49
%
%function [logdata,status]=sum2lng(sumfil);
function [logdata,status]=sum2lng(sumfil);
fid=fopen(expand(sumfil,'dat'),'r','b');
ind=fread(fid,100,'int32');
if ind(100)~=921106
  polca=7;
else
  polca=4;
end
fclose(fid);
if polca==4
  s=sum2mlab(sumfil);
  status=zeros(29,size(s,2));
  logdata=zeros(32,size(s,2));
  logdata(1,:)=s(6,:);
  logdata(2,:)=s(5,:);
  logdata(3,:)=s(4,:);
  logdata(4,:)=s(3,:);
  logdata(5,:)=s(2,:);
  logdata(6,:)=s(1,:);
  logdata(8,:)=s(9,:)*100;
  logdata(9,:)=s(10,:);
  logdata(10,:)=s(8,:);
  logdata(11,:)=s(11,:);
end
if polca==7
  s=sum2mlab7(sumfil);
  status=zeros(29,size(s,2));
  logdata=zeros(32,size(s,2));
  logdata(1,:)=s(6,:);
  logdata(2,:)=s(5,:);
  logdata(3,:)=s(4,:);
  logdata(4,:)=s(3,:);
  logdata(5,:)=s(2,:);
  logdata(6,:)=s(1,:);
  logdata(8,:)=s(9,:)*100;
  logdata(9,:)=s(10,:);
  logdata(10,:)=s(51,:);
  logdata(11,:)=s(11,:);
end
