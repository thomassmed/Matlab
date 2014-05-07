function [e_mstab,efi2,e_mstabh]=get_lprm_eigvec(matfile,axnod)
% get_lprm_eigvec - Constructs the lprm eigenvectors from a matstab matfile
%
% [e_mstab,efi2,emstabh]=get_lprm_eigvec(matfile)
%
% Input:
%  matfile - matstab result file
%  
% Output:
%  e_mstab - 4 by no-of-detectorstrings matrix with the phasors from the stability calculation
%            Note numering is from top(1) to bottom (4)
%            This is because the plant numbering typically is done that way
%  e_fi2   - Eigenvector fro thermal flux (kmax by kan, full core symmetry)

load(matfile)
%%
efi2=sym_full(reshape(stab.en.*steady.fa2./steady.fa1,geom.kmax,geom.kan),geom.knum);
harm_flag=0;
if nargout==3,
  slask=zeros(geom.kmax,geom.tot_kan);
  for i=1:size(stabh.en,2),
      slask(:,geom.knum(:,1))=reshape(stabh.en(:,i).*steady.fa2./steady.fa1,geom.kmax,geom.kan);
      if msopt.CoreSym==2,
          slask(:,geom.knum(:,2))=-slask(:,geom.knum(:,1));
      end
      En{i}=slask;
      harm_flag=1;
  end
end  
%%
irmx=fue_new.irmx;
mminj=fue_new.mminj;
off_set=length(mminj)/2-irmx;
[jdet,idet]=find(fue_new.detloc);
idet=2*idet+1-off_set;
jdet=2*jdet+1-off_set;
detpos=sort(cpos2knum(jdet,idet,mminj));
xy=knum2cpos(detpos,mminj);
x=xy(:,2);
y=xy(:,1);detpos_nw=cpos2knum(xy-1,mminj);
Detpos=[detpos_nw detpos_nw+1 detpos-1 detpos];
hz=fue_new.hz;
if nargin<2,
    axloc=fue_new.det_axloc;
    if isempty(axloc),
        warning('Using default axial locations');
        disp('axnod= [3.5 9.25 15 21]');
        disp('To modify supply axnod as the 2:nd input argument');
        axnod=[3.5 9.25 15 21];
        axloc=axnod*hz;
    end
end
kmax=fue_new.kmax;
node_center=hz/2:hz:kmax*hz;
%%
for i=1:length(axloc),
    iup(i)=find(axloc(i)<node_center,1);
    wup(i)=(axloc(i)-node_center(iup(i)-1))/hz;
end
max_lp=length(axloc);
e_mstab=nan(max_lp,length(detpos));
for i=1:length(detpos),
    for k=1:max_lp,
        e_mstab(max_lp+1-k,i)=wup(k)*sum(efi2(iup(k),Detpos(i,:)))+(1-wup(k))*sum(efi2(iup(k)-1,Detpos(i,:)));
        if harm_flag,
            for j=1:size(stabh.en,2),
                e_mstabh{j}(max_lp+1-k,i)=wup(k)*sum(En{j}(iup(k),Detpos(i,:)))+(1-wup(k))*sum(En{j}(iup(k)-1,Detpos(i,:)));
            end
        end
    end
end
