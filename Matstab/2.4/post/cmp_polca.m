function [Pow,keff,fa1,fa2]=cmp_polca(f_polca,plotta)
% [Pow,keff,fa1,fa2]=cmp_polca(f_polca,plotta)
% if plotta==0, no plot is performed
% default: plotta = 1
% Matstab-file corresponding to f_polca must be loaded.

if nargin<2  plotta=1;end
if plotta~=0 plotta=1;end

global srcdata msopt termo neu geom polcadata;

[Ppower,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,distlist,...
staton,f_master]=readdist7(f_polca,'power');		
Pdens=readdist7(f_polca,'dens');

kmax = geom.kmax;
kan = geom.kan;
isym = msopt.CoreSym;
ntot = kan*kmax;			
mminj = polcadata.mminj;
neig = neu.neig;
dzz = geom.hz;
dx=geom.hx;
qtherm = termo.Qtot/get_sym;
keff = neu.keffpolca;
knum=ramnum2knum(mminj,1:kan,isym);
knum=knum(:,1);

srcdata=readsrcdata(fixsrcfile(msopt.SourceFile));
[a11,a21,a22,cp]=read_alb7;
[d1,d2,sigr,siga1,siga2,usig1,usig2,ny]=xsec2mstab7(f_polca,Pdens);

power=Ppower(:,knum(:,1));power=power(:);
d1=d1(:,knum(:,1));d1=d1(:);
d2=d2(:,knum(:,1));d2=d2(:);
ny=ny(:,knum(:,1));ny=ny(:);
siga1=siga1(:,knum(:,1));siga1=siga1(:);
siga2=siga2(:,knum(:,1));siga2=siga2(:);
usig1=usig1(:,knum(:,1));usig1=usig1(:);
usig2=usig2(:,knum(:,1));usig2=usig2(:);
sigr=sigr(:,knum(:,1));sigr=sigr(:);

if plotta==1,
  fprintf('POLCA keff: %8.5f\n',keff);
end

fa1=8.5e11*power./(usig1./ny+usig2./ny.*sigr./siga2);
fa2=fa1.*sigr./siga2;

[keff,fa1,fa2,Pow]=solv_fi(keff,fa1,fa2,qtherm,neig,usig1,usig2,siga1,sigr,...
siga2,ny,ny,d1,d2,dx,dzz,a11,a21,a22,cp);

Pow=Pow/mean(Pow);
Pow=mstab2dist(Pow,f_polca);
fa1=mstab2dist(fa1,f_polca);
fa2=mstab2dist(fa2,f_polca);

if plotta==1,
distplot(f_polca,'Ppower-Pow',upright,Ppower-Pow);
end




%----------------------------------------------------------------------------
%	Nedanstående funktion är orginalet. 
%	Ändrad till ovanstående 060801 för att bli kompatibel med Polca7
%	och Matstab2.2
%	Korrigeringen kan ha ändrat funktionens användningsområde.
%
%	eml, 060801
%----------------------------------------------------------------------------

%function [Pow,keff,fa1,fa2]=cmp_polca(f_polca,plotta)
%% [Pow,keff,fa1,fa2]=cmp_polca(f_polca,plotta)
%% if plotta==0, no plot is performed
%
%global ISYM KAN KMAX NTOT
%
%if nargin<2, plotta=1; end
%if plotta~=0 plotta=1;end
%
%if isempty(ISYM), ISYM=2;disp('ISYM=2 is assumed');end
%
%[Ppower,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,distlist,...
%staton,f_master]=readdist(f_polca,'power');
%Pvoid=readdist(f_polca,'void');
%
%KMAX=mz(4);
%KAN=mz(22)/get_sym;
%NTOT=KAN*KMAX;
%
%KNUM=ramnum2knum(mminj,1:KAN,ISYM);
%knum=KNUM(:,1);
%
%[a11,a21,a22,cp]=read_alb(f_master,mminj);
%
%
%[d1,d2,sigr,siga1,siga2,usig1,usig2,ny]=xsec2mstab(f_polca,Ppower,Pvoid,f_master,knum);
%power=Ppower(:,knum(:,1));power=power(:);
%
%[x,i]=sort(knum);
%clear temp
%temp(x)=i;
%
%corec=vec2core(temp,mminj);
%core=zeros(length(mminj)+2);
%
%
%if ISYM==1
%  core(2:length(mminj)+1,2:length(mminj)+1)=corec;
%  [i,j]=find(core~=0);
%  for k=1:length(i),
%    neig(core(i(k),j(k)),:)=[core(i(k)-1,j(k)) core(i(k),j(k)+1) core(i(k)+1,j(k)) core(i(k),j(k)-1)];
%  end
%elseif ISYM==2
%  core(2:length(mminj)+1,2:length(mminj)+1)=rot90(corec,3);
%  core(2:length(mminj)+1,2:length(mminj)+1)=core(2:length(mminj)+1,2:length(mminj)+1)+rot90(corec);
%  [i,j]=find(core~=0);
%  for k=1:length(i)
%    if i(k)> length(mminj)/2+1
%      neig(core(i(k),j(k)),:)=[core(i(k),j(k)+1) core(i(k)+1,j(k)) core(i(k),j(k)-1) core(i(k)-1,j(k))];
%    end
%  end
%elseif ISYM==7
%  corec=corec+rot90(corec);
%  corec=corec+rot90(rot90(corec));
%  core(2:length(mminj)+1,2:length(mminj)+1)=corec;
%  [i,j]=find(core~=0);
%  for k=1:length(i)
%    if i(k)> length(mminj)/2+1 & j(k)>length(mminj)/2+1
%      neig(core(i(k),j(k)),:)=[core(i(k)-1,j(k)) core(i(k),j(k)+1) core(i(k)+1,j(k)) core(i(k),j(k)-1)];
%    end
%  end
%else
%  error('this symmetry is not supported')
%end
%
%
%neig=(neig-1)*KMAX;
%i=find(neig<0);
%neig(i)=(NTOT+1)*ones(length(i),1);
%
%neig=neig';
%neig=neig(:);
%
%NEIG=NEIGHBOUR(neig,KMAX);
%
%dzz=bb(15);
%dx=bb(16);
%qtherm=bb(5)/get_sym;
%keff=bb(51);
%if plotta==1,
%  fprintf('POLCA keff: %8.5f\n',keff);
%end
%
%fa1=8.5e11*power./(usig1./ny+usig2./ny.*sigr./siga2);
%fa2=fa1.*sigr./siga2;
%
%
%[keff,fa1,fa2,Pow]=solv_fi(keff,fa1,fa2,qtherm,NEIG,usig1,usig2,siga1,sigr,...
%siga2,ny,ny,d1,d2,dx,dzz,a11,a21,a22,cp,5e-5,plotta);
%Pow=Pow/mean(Pow);
%Pow=mstab2dist(Pow,f_polca);
%fa1=mstab2dist(fa1,f_polca);
%fa2=mstab2dist(fa2,f_polca);
%
%if plotta==1,
%distplot(f_polca,'Ppower-Pow',upright,Ppower-Pow);
%end

