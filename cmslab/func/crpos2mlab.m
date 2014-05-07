function [konrods,dm]=crpos2mlab(crposfil)
if nargin==0
    crposfil='31s-03-crpos.dat';
end
fid=fopen(crposfil);
%%
fseek(fid,0,-1);
ncr=fread(fid,1,'int32');
slask=fread(fid,1,'int32');
ndm=fread(fid,1,'int32');
dat=fread(fid,6,'int32')';
hasse=char(fread(fid,4)');
%% hitta DM
fseek(fid,4*ncr,-1);
dm=fread(fid,ndm,'int32');
%% hitta filens längd
fseek(fid,0,1);
eof=ftell(fid);
fseek(fid,-4*ncr*ndm,1);
konrods=zeros(ndm,ncr);
for i=1:ndm,
    konrods(i,:)=fread(fid,ncr,'int32')';
end
%%
fclose(fid);



