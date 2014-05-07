%@(#)   cprmodlhrmod.m 1.5	 10/07/03     23:51:55
%
%
%function [CPRMOD,straff]=cprmodlhrmod(indatafil);
%
% Input: Indata file which contains specification of buntyp-
%        characteristics wrt mean and stand.dev. of box bowing and
%        an EOFP-distr.file with appropriate burnup levels.
%
% Output1: Vectors with CPRMOD and penalty: [CPRMOD,straff]
% Output2: Files with map of CPRMOD and POLCA-input deck.
%




% Reference: PF-Rapport 503/89
%
%
function [CPRMOD,straff]=cprmodlhrmod(indatafil);
if nargin<1, indatafil='indata.cprmod';end
% Read input data AND
% Find the mean and standarddeviations by using burnup
% and buntyp from given distr. file
[cprmin,medel,stand,forboj,distfile,buidnt,lhrstraff,cprstraff]=readcprmod(indatafil);
% Find channel numbers for supercells
[dist,mminj,konrod,bb,hy,mz]=readdist7(distfile);
fprintf(1,'\nBURNUP distribution taken from %s\n',distfile);
konrod=ones(size(konrod));ikan=filtcr(konrod,mminj,0,2);
CPRMOD=zeros(mz(14),1);
LHRMOD=ones(mz(14),1);
lk=length(konrod);
% To understand calculation below,
% confer PF-Rapport 503/89
korr=1.3*0.75/100;
Sigma=0.05;  % If Sigma~=0.05, the change in result is negligible!!
cpr=1+Sigma;
straff=CPRMOD';
for l=1:lk
  sigsig(l)=sum(stand(ikan(l,:)).*stand(ikan(l,:)));
  medmed(l)=sum(medel(ikan(l,:)));
  nxsigma(l)=korr*sqrt(sigsig(l));
  mcpr=1+korr*medmed(l)+sqrt(Sigma^2+nxsigma(l)^2);
  straff(ikan(l,:))=mcpr-cpr-4*korr*forboj(ikan(l,:));
  CPRMOD(ikan(l,:))=cprmin(ikan(l,:))./(cprmin(ikan(l,:))+straff(ikan(l,:))');
end
i=find(CPRMOD==0);CPRMOD(i)=ones(size(i));
i=find(CPRMOD>1);CPRMOD(i)=ones(size(i));
BUIDNT=readdist7(distfile,'asyid');
for i=1:length(cprstraff),
  k=strmatch(buidnt(i,:),BUIDNT);
  CPRMOD(k)=CPRMOD(k)-cprstraff(i)/100;
  LHRMOD(k)=LHRMOD(k)+lhrstraff(i)/100;
end
fid=fopen('cprmod.fuel','w');
modmap(CPRMOD,mminj,'cprmod.lis','%5.2f');
printcprmod(fid,vec2core(CPRMOD,mminj),mminj);
fclose(fid);
fid=fopen('lhrmod.fuel','w');
modmap(LHRMOD,mminj,'lhrmod.lis','%5.2f');
printshfmod(fid,vec2core(LHRMOD,mminj),mminj);
fclose(fid);
disp('');
%type cprmod.lis
%type cprmod.fuel
disp('Input to POLCA4 is printed on cprmod.fuel, shfmod.fuel');
disp('Input to POLCA7 is printed on cprmod.lis, lhrmod.lis');
