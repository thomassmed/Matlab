function racs2f1f1new(racsfil)
[beskrivning,b,data]=ldracs(racsfil);
B=b;B(101:200)=[];B(find(abs(B)==10))=[];
l=length(B)/99;
B=reshape(B,99,l);B=B';
signaler=B;
i=find(racsfil=='.');
isafe=findstr(racsfil,'.mat');
if isempty(isafe),
  matfile=[racsfil(1:i-1),'.mat'];
  save(matfile,'beskrivning','signaler','data');
end
%@(#)   racs2f1f2new.m 1.2   03/08/26     08:05:13
