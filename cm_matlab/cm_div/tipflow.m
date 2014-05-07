%@(#)   tipflow.m 1.11	 05/12/08     13:21:50
%
%function [normchdiff,normchdiffc,date,tipfiles]=tipflow(chmeas,chflow,efph,plotflokan,tipfiler)
%compares measured channel flow with computed
%Input:
%      chmeas     - measured chflow (output from evalpolca)
%      chflow     - computed chflow (output from evalpolca)
%      efph       - efph at TIP (output from evalpolca)
%      tipfiler   - name of file which contain list of tipfiles to be considered, 
%      plotflokan - vector of the flowchannels which are to be plotted, default=[];
%
% example:
%              tipflow(chmeas,chflow,efph) - presents no plot, only printout
%              tipflow(chmeas,chflow,efph,3) - plots the third (in alphabetical order) "K-punkt"
%              tipflow(chmeas,chflow,efph,(1:8)) - plots all "K-punkter"
%              tipflow  -  First evalpolca is executed, then tipflow is executed
%
function [normchdiff,normchdiffc,date,tipfiles]=tipflow(chmeas,chflow,efph,plotflokan,tipfiler)
reakdir=findreakdir;
i=find(reakdir=='/');unit=reakdir(i(2)+1:i(3)-1);
if nargin<4,
  plotflokan=[];
end
if nargin<1,
  [cycles,efph,efphc,keff,keffc,nod,nodc,rad,radc,ax,axc,chdev,chdevc,keffcc,chflow,chmeas]=evalpolca;
   plotflokan=(1:8);
end
if nargin<5,
  tipfiler=[reakdir,'div/multicycle/tipfiler'];
end
[tipfiles,nc,cycles,efphc]=readtipfiles(tipfiler);
date=tip2date(tipfiles);
batchdata=[reakdir,'div/bunhist/batch-data.txt'];
fid1=fopen(batchdata);
if fid1>0,
  [eladd,garburn,antal,levyear,enr,buntot,weight,eta,typ,stav]=readbatch(batchdata);
end
[chnum,knam]=flopos(unit);
[knam,isort]=ascsort(knam);
chnum=chnum(isort);
ic=length(efphc);
chdiff=chflow-chmeas;
ich=find(max(abs(chmeas'))>0&max(abs(chflow'))>0);
normflow=0*chflow;
normchflow=0*chflow;
for i=1:length(ich),
  normchflow(ich(i),:)=chflow(ich(i),:)*sum(chmeas(ich(i),:))/sum(chflow(ich(i),:));
end
normchdiff=normchflow-chmeas;
for i=1:ic,
  i0=nc(i);i1=nc(i+1)-1;
  ichcy=find(max(abs(chmeas(i0:i1,:)'))>0&max(abs(chflow(i0:i1,:)'))>0);
  if length(ichcy)==0,
    normchdiffc(i,:)=NaN*ones(1,size(normchdiff,2));
  elseif length(ichcy)==1,
    normchdiffc(i,:)=normchdiff(nc(i)-1+ichcy,:);
    normchstdc(i,:)=0*ones(1,size(normchdiff,2));
  else
    normchdiffc(i,:)=mean(normchdiff(nc(i)-1+ichcy,:));
    normchstdc(i,:)=std(normchdiff(nc(i)-1+ichcy,:));
  end
end
fid=1;
for i=1:length(plotflokan)
  ylab='POLCA-MEASURED (kg/s)';
  ploteval(unit,cycles,normchdiffc(:,plotflokan(i)),efphc,normchdiff(ich,plotflokan(i)),efph(ich),ylab);
  title(['Flödesavvikelse for ',knam(plotflokan(i),:)]);
end  
fid=fopen('flowresults.lis','w');
disp(['Results are printed on flowresults.lis']);
fprintf(fid,'\n\t%s%s\n\n','Flow results POLCA-MEASUREMENTS for ',unit);
for i=1:length(nc)-1,
  fprintf(fid,'\n\n\t%s\n',cycles(i,:));
  i0=nc(i);i1=nc(i+1)-1;
  ichcy=find(max(abs(chmeas(i0:i1,:)'))>0&max(abs(chflow(i0:i1,:)'))>0);
  if length(ichcy)>0,
    buntyp=readdist7(tipfiles(nc(i),:),'asytyp');
    bunflow=buntyp(chnum,:);
    irad=findeladd(bunflow,buntot,levyear);
    TYP=typ(irad,:);
    fprintf(fid,'\n\t%s',' ');
    for j=1:size(knam,1),
      fprintf(fid,'\t%s',knam(j,:));
    end     
    fprintf(fid,'\n\t%s','datum');
    for j=1:size(knam,1),
      fprintf(fid,'\t%s',TYP(j,1:7));
    end     
    for k=1:length(ichcy),
      fprintf(fid,'\n\t%s',date(i0-1+ichcy(k),:));
      for j=1:size(knam,1),
        fprintf(fid,'\t%5.2f',normchdiff(i0-1+ichcy(k),j));
      end
    end
    fprintf(fid,'\n\t%s','Aver');
    for j=1:size(knam,1),
      fprintf(fid,'\t%5.2f',normchdiffc(i,j));
    end
    fprintf(fid,'\n\t%s','std');
    for j=1:size(knam,1),
      fprintf(fid,'\t%5.2f',normchstdc(i,j));
    end
  end
end
fprintf(fid,'\n');
fclose(fid),
