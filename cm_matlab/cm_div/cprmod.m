%@(#)   cprmod.m 1.4	 05/12/08     13:18:31
%
%
%function [CPRMOD,straff]=cprmod(indatafil);
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
function [CPRMOD,straff]=cprmod(indatafil);
if nargin<1, indatafil='indata.cprmod';end
% Read input data AND
% Find the mean and standarddeviations by using burnup
% and buntyp from given distr. file
[cprmin,medel,stand,forboj,distfile]=readcprmod(indatafil);
% Find channel numbers for supercells
[dist,mminj,konrod,bb,hy,mz]=readdist7(distfile);
konrod=ones(size(konrod));ikan=filtcr(konrod,mminj,0,2);
CPRMOD=zeros(mz(14),1);
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
fid=fopen('cprmod.fuel','w');
cor2fil(CPRMOD,mminj,'cprmod.lis','%5.2f');
printcprmod(fid,vec2core(CPRMOD,mminj),mminj);
fclose(fid);
disp('');
type cprmod.lis
type cprmod.fuel
disp('Result is printed on cprmod.lis');
disp('Input to POLCA is printed on cprmod.fuel');
end
