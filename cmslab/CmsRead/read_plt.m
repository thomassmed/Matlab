function [burnup,ent,burlim,entlim,header]=read_plt(pltfile,mminj,kmax)
% read_plt - reads pin enthalpy from .plt file from S3K
%
% [burnup,ent,burlim,entlim,header]=read_plt(pltfile[,mminj,kmax])
%
% Input
%   pltfile - name on pltfile
%   mminj   - core contour
%   kmax    - number of axial nodes
%
% Output
%   burnup  - Nodewise exposure
%   ent     - Nodewise enthalpy
%   burlim  - Data for limiting curve, exposure (burnup)
%   entlim  - Data for limiting curve, enthalpy
%   header  - File Head info
%   
% Examples:
%   fue_new=read_restart_bin('s3.res');mminj=fue_new.mminj;kmax=fue_new.kmax;
%   [burnup,ent,burlim,entlim,header]=read_plt('20C-26.PLT',mminj,kmax);
%   figure;hl=plot(burlim,entlim,'r');set(hl,'LineWidth',2);
%     hold on;plot(burnup(:),ent(:),'x');ax=axis;ax(3)=0;axis(ax);grid on
%   elim=interp1(burlim,entlim,burnup);
%   cmsplot s3.res ent-elim
%   set_cmsplot_prop operator max
%   set_cmsplot_prop filt_matvar_string max(ent-elim)>0 
%   set_cmsplot_prop('filt_matvar',max(ent-elim)>0);
%   set_cmsplot_prop rescale auto
%   cmsplot_now
%   %Number of nodes above the limit:
%   length(find((ent(:)-elim(:))>0))
%   % Number of bundles above the limit:
%   length(find(max(ent-elim)>0))
%   %Obviously, the bundles above the limit are given by:
%   ibun=find(max(ent-elim)>0);
%   %Positions and names are given by:
%   knum2cpos(ibun,mminj),fue_new.ser(ibun,:)



%%
fid=fopen(pltfile);
start=fread(fid,2000,'char=>char')';
lf= abs(start)==13; %remove line feeds
start(lf)=[];
istart=strfind(start,'--Data Follows--------------------------------------');
istart=istart+52;
fseek(fid,istart,-1);
header=start(1:istart-1);
%%
a=fscanf(fid,'%g,');
%%
a1=a(end);a(end)=[];
fr=fread(fid,'char=>char')';
fclose(fid);
%% 
fr(fr==13)=[]; % Remove line feeds
[b,count]=sscanf(fr,',%g,',1);
%%
cr=find(fr==10,1,'first');
fr(1:cr)=[];
%%
[c,count]=sscanf(fr,'%g,  ,%g,');
%%
c=reshape(c,2,count/2);
c=c';
%%
sumnum=[a1 b;c];
burlim=sumnum(:,1);
entlim=sumnum(:,2);
%% Fix a
a=reshape(a,2,length(a)/2);
a=a';
if nargin>1,
    kan=sum(length(mminj)-2*(mminj-1));
    brn=reshape(a(:,1),kmax,kan);
    cm=vec2cor(1:kan,mminj);
    kanren=cor2vec(cm',mminj);
    burnup=brn(:,kanren);
    ent=reshape(a(:,2),kmax,kan);
    ent=ent(:,kanren);
else
    burnup=a(:,1);
    ent=a(:,1);
end