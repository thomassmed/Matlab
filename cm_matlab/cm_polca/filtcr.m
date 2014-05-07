%@(#)   filtcr.m 1.2	 94/08/12     12:10:17
%
%function ikan=filtcr(konrod,mminj,mink,maxk)
%find fuel channel numbers for fuel in supercells with 
%crontrol rods betwenn mink and maxk %
%each control rod that satisfies mink<crod<maxk gives a row in ikan,
%i.e. ikan will be four columns
function [ikan,ikancr]=filtcr(konrod,mminj,mink,maxk)
mink=10*mink;maxk=10*maxk;
[map,mpos]=cr2map(konrod,mminj);
i=find(konrod>=mink&konrod<=maxk);
ikancr=i;
if size(i)>0,
  cpos=2*mpos(i,:);
  [ic,jc]=size(cpos);
  ione=zeros(ic,jc);kone=ones(ic,1);ione(:,1)=kone;
  knum=cpos2knum(cpos(:,1),cpos(:,2),mminj);
  cpos1=cpos-ione;
  knum1=cpos2knum(cpos1(:,1),cpos1(:,2),mminj);
  ikan=[knum1-kone knum1 knum-kone knum];
else
  ikan=[];
end
