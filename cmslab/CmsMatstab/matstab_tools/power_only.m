function varargout=power_only(fue_new,Oper,dens,tfu,neumodel,sym)
%
%
% [pow,keff,fa1,fa2,An,J1nm,J2nm]=power_only(fue_new,Oper,dens,tfu,'NEU1',sym)
% [pow,keff,fa1,fa2,An,J1nm,J2nm]=power_only(fue_new,Oper,dens,tfu);
% 




%%
global msopt geom
%% Reading defaults and input

if nargin<5,
    neumodel='NEU1';
end

%%

fue_new=expand_fuenew(fue_new);
fue_new.afuel=fue_new.afuel/1e4;        % Convert to m^2
fue_new.dhfuel=fue_new.dhfuel/1e2;      % Convert to m
fue_new.phfuel=fue_new.phfuel/1e2;      % Convert to m
for i=1:length(fue_new.A_wr),
    fue_new.A_wr{i}=fue_new.A_wr{i}/1e4;
    fue_new.Ph_wr{i}=fue_new.Ph_wr{i}/1e2;
    fue_new.Dhy_wr{i}=fue_new.Dhy_wr{i}/1e2;
end
msopt.LibFile=fue_new.cd_file;

%%
if nargin<6,
    if ~isfield(msopt,'CoreSym'), % default is full core
        sym=1;
    else
        sym=msopt.CoreSym;
    end
else
    if ischar(sym)
        switch lower(sym)
            case 'full',
                sym=1;
            case {'half''e'},
                sym=2;
            case {'quart','quarter','se'}
                sym=7;
        end
    end
end
%% 

msopt.CoreSym=sym;

if ~isfield(msopt,'PowerVoidNeuDisp'),
    msopt.PowerVoidNeuDisp='on';
end
if ~isfield(msopt,'PowerVoidNeuGamma'),
    msopt.PowerVoidNeuGamma=0.98;
end
if ~isfield(msopt,'PowerVoidNeuMaxiter'),
    msopt.PowerVoidNeuMaxiter=10;
end

mminj=fue_new.mminj;
kmax=fue_new.kmax;
kan=fue_new.kan;
knum=ramnum2knum(mminj,1:kan,msopt.CoreSym);
msopt.CoreSym=sym;
geom.knum=knum;
geom.kan=kan;
geom.kmax=kmax;
geom.mminj=fue_new.mminj;
geom.ntot=fue_new.kmax*fue_new.kan/get_sym(msopt);
qtherm=Oper.Qtot/get_sym(msopt);
hz=fue_new.hz;
hx=fue_new.hx;
[a11,a21,a22,cp]=read_alb7(fue_new); 
NEIG=NeigFromScratch(mminj,kmax,knum);
%%
keff=Oper.keff;
[d1,d2,sigr,siga1,siga2,usig1,usig2,kap_ny]=...
   xs_cms(fue_new,fue_new.cd_file,dens(:),tfu(:));
ny=3.2041e-11./kap_ny;
%%
power=Oper.Power;
fa1=8.5e11*power(:)./(usig1./ny+usig2./ny.*sigr./siga2);
fa2=fa1.*sigr./siga2;
fa1=fa1(:);fa2=fa2(:);
pow=eq_fisspow(fa1,fa2,usig1./ny/keff,usig2./ny/keff,hx,hz);
fa1=fa1*qtherm/sum(pow);
fa2=fa2*qtherm/sum(pow);
%%
switch upper(neumodel)
    case 'NEU1'
        [keff,fa1,fa2,pow,An,J1nm,J2nm]=solv_fi(keff,fa1(:),fa2(:),qtherm,NEIG,usig1(:),usig2(:),siga1(:),sigr(:),...
            siga2(:),ny(:),ny(:),d1(:),d2(:),hx,hz,a11,a21,a22,cp,1e-5);
        varargout{5}=An;
        varargout{6}=J1nm;
        varargout{7}=J2nm;
    case 'NEU1OLD'
[keff,fa1,fa2,pow,theta,r,kinf_,Alfa_n,Cn,Prod,Leak,Absorp,la,kef,keffp,Anm]=solv_neu1(keff,fa1,fa2,qtherm,NEIG,usig1,...
usig2,siga1,sigr,siga2,ny,d1,d2,hx,hz,a11,a21,a22,cp,10);
    case 'NEU3'
 [F1W,F1S,F2W,F2S,V2Ddf,X2Ddf,Y2Ddf,V3Ddf,X3Ddf,Y3Ddf,Z3Ddf,Xdf,Ydf,XSdf,XSEC_DX2df]=df_cms(fue_new,msopt.LibFile,dens,tfu);
 DF1=cas2sim(F1W,F1S,fue_new.nfra);
 DF2=cas2sim(F2W,F2S,fue_new.nfra);
[keff,fa1,fa2,pow,r,raa,Sn,C1nm,C2nm,Fiss,Leak,Absorp,la,kef,keffp,J1nm,J2nm,Anm,SC1,SC2]=...
    solv_neu3(keff,fa1,fa2,qtherm,NEIG,usig1,usig2,siga1,sigr,siga2,ny,ny,d1,d2,hx,hz,a11,a21,a22,DF1,DF2,5);
end
pow=reshape(pow,kmax,kan);
pow=pow/mean(pow(:));
fa1=reshape(fa1,kmax,kan);
fa2=reshape(fa2,kmax,kan);
varargout{1}=pow;
varargout{2}=keff;
varargout{3}=fa1;
varargout{4}=fa2;