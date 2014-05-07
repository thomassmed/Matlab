function [sumth,sumth_col,knum]=read_sumth(outfile,mminj,kmax)
% Read detailed edit from s3k-case
%
% [sumth,sumth_col,knum]=read_sumth(outfile,mminj,kmax)
%
% Input
%   outfile - name on s3k output file
%   mminj   - core contour
%   kmax    - Number of axial nodes
%  
% Output
%   sumth - structured variable with power, void etc (row by row)
%   sumth_col - structured variable with power, void etc (col by col)
%   knum  - transalation from sumth_col to sumth (sumth.power(:,knum)=sumth_col.power)
%
% Example
%   fue_new=read_restart_bin('/cms/t2-jef/c20/s3k/s3k-case-1.res');
%   kmax=fue_new.kmax;mminj=fue_new.mminj;
%   sumth=read_sumth('/cms/t2-jef/c20/s3k/s3k-1.out',mminj,kmax);

%% open and read file
fid=fopen(outfile,'r');
file=char(fread(fid)');
fclose(fid);
%%
if ispc,
   lf=find(file==13);
   file(lf)=[];
end
%%
cr=find(file==10);
chan=strfind(file,[10,'CHANNEL ']);
%% Read data from all channels
iamax=length(mminj);
kan=sum(iamax-2*(mminj-1));
data=cell(1,length(chan));
for i=1:length(chan),    
    data{i}=NaN(kmax+2,10);
    icr=find(cr>chan(i),1);
    chnum(i)=sscanf(file(chan(i)+8:chan(i)+11),'%i');
    rad=file(cr(icr+7)+1:cr(icr+8)-1);
    data{i}(kmax+3,:)=sscanf(rad,'%g');  % read top
    for j=1:kmax,    % read active fuel
        rad=file(cr(icr+8+j)+1:cr(icr+9+j)-1);
        data{i}(kmax+3-j,:)=sscanf(rad,'%g');
    end
    rad=file(cr(icr+10+kmax)+1:cr(icr+11+kmax)-1);
    data{i}(2,:)=sscanf(rad,'%g');  % read bottom
    rad=file(cr(icr+11+kmax)+1:cr(icr+12+kmax)-1);
    data{i}(1,:)=sscanf(rad,'%g');  % read bottom        
end
%% Pull out the various variables
jcoor=floor(chnum/(iamax+2))';
icoor=mod(chnum,iamax+2)'-1;
knum=cpos2knum(icoor,jcoor,mminj);
% Preallocate
sumth.power=NaN(kmax+3,length(chan));
sumth_col.power=NaN(kmax+3,length(chan));
sumth.press=NaN(kmax+3,length(chan));
sumth_col.press=NaN(kmax+3,length(chan));
sumth.void=NaN(kmax+3,length(chan));
sumth_col.void=NaN(kmax+3,length(chan));
sumth.xe=NaN(kmax+3,length(chan));
sumth_col.xe=NaN(kmax+3,length(chan));
sumth.xq=NaN(kmax+3,length(chan));
sumth_col.xq=NaN(kmax+3,length(chan));
sumth.tfu=NaN(kmax+3,length(chan));
sumth_col.tfu=NaN(kmax+3,length(chan));
sumth.tmo=NaN(kmax+3,length(chan));
sumth_col.tmo=NaN(kmax+3,length(chan));
sumth.shf=NaN(kmax+3,length(chan));
sumth_col.shf=NaN(kmax+3,length(chan));
sumth.elev=NaN(kmax+3,length(chan));
sumth_col.elev=NaN(kmax+3,length(chan));
sumth.node=NaN(kmax+3,length(chan));
sumth_col.node=NaN(kmax+3,length(chan));
for i=1:length(chan),
    % First withe row-wise convention to get ready for cmsplot etc
    sumth.node(:,knum(i))=data{i}(:,1);
    sumth.elev(:,knum(i))=data{i}(:,2);
    sumth.xe(:,knum(i))=data{i}(:,3);
    sumth.xq(:,knum(i))=data{i}(:,4);
    sumth.void(:,knum(i))=data{i}(:,5);
    sumth.press(:,knum(i))=data{i}(:,6);
    sumth.tmo(:,knum(i))=data{i}(:,7);
    sumth.tfu(:,knum(i))=data{i}(:,8);
    sumth.shf(:,knum(i))=data{i}(:,9);
    sumth.power(:,knum(i))=data{i}(:,10);
    % Then with the column-wise to be in harmony with S3K
    sumth_col.node(:,i)=data{i}(:,1);
    sumth_col.elev(:,i)=data{i}(:,2);
    sumth_col.xe(:,i)=data{i}(:,3);
    sumth_col.xq(:,i)=data{i}(:,4);
    sumth_col.void(:,i)=data{i}(:,5);
    sumth_col.press(:,i)=data{i}(:,6);
    sumth_col.tmo(:,i)=data{i}(:,7);
    sumth_col.tfu(:,i)=data{i}(:,8);
    sumth_col.shf(:,i)=data{i}(:,9);
    sumth_col.power(:,i)=data{i}(:,10);
end