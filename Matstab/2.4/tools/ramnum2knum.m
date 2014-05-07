function knum=ramnum2knum(mminj,ramnum,isym)
% knum=ramnum2knum(mminj,ramnum,isym)
% Translates south half core symmetry
% channel numbers of ramona to full core
% channel numbers of polca
%
% Input:
% mminj - from core master refer to readdist
% ramnum - channel number in ramona
% isym - refer to RAMONA manual, default isym=2 halfcore symmetry
%
% Output:
% knum - POLCA full core channel number


if nargin<3, isym=2;end

%  initialise
iimax=length(mminj);
kan=sum(iimax-2*(mminj-1));


if isym==1,
  knum=ramnum(:);
elseif isym==2,
  if nargin<2, ramnum=1:kan/2;end
  %  Do the translation
  ramnum=ramnum+kan/2;
  ij=knum2cpos(ramnum,mminj);
  knum=cpos2knum([iimax+1-ij(:,2) ij(:,1)],mminj);
  knum(:,2)=kan+1-knum;
elseif isym==7,
  ramnum=ramnum+kan/4;
  knum=half2full(ramnum,mminj);
  IJ=knum2cpos(knum,mminj);
  i=iimax+1-IJ(:,2);
  j=IJ(:,1);
  knum(:,3)=cpos2knum(i,j,mminj);
  knum(:,4)=kan+1-knum(:,3);
end
