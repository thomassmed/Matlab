function [An,Ant,AnIm,AntIm,l,u]=newtfreq(lam,en0,At,Atj,Atq,Atf,Ajt, ...
      Aj,Ajq,Ajf,Ant,AntIm,An,AnIm,Anf,Aqt,Aqn,Aqf,Aft,Afj,Afq,Af,Bt,Bf,Bj,Btj,fue_new,Xsec,matr)

% [An,Ant,AnIm,AntIm,l,u]=newt(lam,en0,At,Atj,Atq,Atf,Ajt, ...
%      Aj,Ajf,Ant,AntIm,An,AnIm,Anf,Aqt,Aqn,Aqf,Aft,Afj,Afq,Af,Bt,Bf,Bj,fue_new,Xsec,matr)  
  

%%

global msopt stab geom termo

%% Preparations
Midpoint=get_bool(msopt.Midpoint);
tolnewt=msopt.GlobalFullTol;
tollam=msopt.GlobalLamTol;
msopt.UpdateAneuNewLam=0;

nAI=matr.nAI;
let=size(At,1);
lej=size(Aj,1);

AT=[At Atj
    Ajt Aj];
BT=[Bt Btj
    sparse(lej,let) Bj];

leT=size(AT,1);
eT=zeros(leT,1);
hL=zeros(leT,1);

debug_mode=0;
manual_mode=0;
%% Preliminary solution
if manual_mode,
    lam=-.3+3.2j;
    [An,Ant,Anf,Aqn,Aqt,Aqf]=A_neu(fue_new,Xsec,matr,lam);
    AnIm=imag(An);
    An=real(An);
    AntIm=imag(Ant);
    Ant=real(Ant);
    clear Dlam Lam Ddlam Tol Et_efix
end

[lf,uf]=lu(lam*Bf-Af);
[l1,u1] = lu(lam*BT-AT);

Bu=zeros(leT,1);
Bu(leT-4)=-Aj(nAI+1,nAI);
Bu(leT-3)=-Aj(nAI+2,nAI);
[l,u]=ilu(An);

eT=u1\(l1\Bu);
ej=eT(let+1:leT);
et=eT(1:let);
ef=zeros(size(Af,1),1);
en=zeros(size(An,1),1);

for i3=1:3,
  hl=Ant*et+AntIm*(et*1j)+AnIm*(en*1j)+Anf*ef;
  en = pcgsolve(An,-hl,en,1e-5,30,0,l,u);
end

for i3=1:2,
  eq=Aqn*en+Aqt*et+Aqf*ef;
  ef = uf\(lf\(Aft*et+Afq*eq+Afj*ej));
end

maxiter=30;
maxnum=6;
for num=1:maxnum,
    if num>4, 
        maxiter=15;
    end
    for i=1:maxiter,
        hL(1:let)=Atq*eq + Atf*ef;
        hL(let+1:leT)=Ajq*eq;
        hL=hL+Bu;
        eT=u1\(l1\hL);
        %eT=0.5*eTn+0.5*eT;
        et=eT(1:let);
        ej=eT(let+1:leT);
        [tol,rtrt,rjrj,rqrq,rfrf,rnrn]=res_eig(At,Atj,Atq,Atf,Bt,Btj,Ajt,Ajq,Aj,Bj,Ant,AntIm,An,AnIm,Anf,Aqt,Aqn,Aqf,Aft,Afq,Afj,Af,Bf,et,ej,en,eq,ef,lam,et,Bu(let+1:leT));
        fprintf(1,'%4i\t%g\t%g\t%g\t%g\t%g\t%g\n',i,tol,rtrt,rjrj,rqrq,rfrf,rnrn);
        if tol<1e-4, break; end
        if i<maxiter,
            for i2=1:4
                for i3=1:3,
                    hl=Ant*et+AntIm*(et*1j)+AnIm*(en*1j)+Anf*ef;
                    en = pcgsolve(An,-hl,en,1e-5,30,0,l,u);
                end
                for i3=1:2,
                    eq=Aqn*en+Aqt*et+Aqf*ef;
                    ef = uf\(lf\(Aft*et+Afq*eq+Afj*ej));
                end
            end
        end
    end
    ejj(:,num)=eT(leT-5:leT);
    LAM(num)=lam;
    if num<maxnum
        if num<4
            dlam=-.2*2j*pi;
        else
            dlam=-.1*2j*pi;
        %else
        %    dlam=-.05*2j*pi;
        end
        lam=lam+dlam;
        f=real(lam/2j/pi)
        AT(leT,leT-1)=AT(leT,leT-1)*exp(-0*dlam);
        Aj(lej,lej-1)=Aj(lej,lej-1)*exp(-0*dlam);
        [An,Ant,Anf,Aqn,Aqt,Aqf]=A_neu(fue_new,Xsec,matr,lam);
        AnIm=imag(An);
        An=real(An);
        AntIm=imag(Ant);
        Ant=real(Ant);
        [lf,uf]=lu(lam*Bf-Af);
        [l1,u1] = lu(lam*BT-AT);
    end
end


%

stab.lam=lam;
stab.et=et;
stab.ej=ej;
stab.en=en;
stab.eq=eq;
stab.ef=ef;

save('-append',msopt.MstabFile,'stab','matr','geom','Aj','Ajt','Bj','Atj','Ajq','Bu','Afj','Aft','Af','Afq','Bf','ejj','LAM');




    function getMidpoint
        etn=et;
        if Midpoint, %Midpoint
            ev=et(matr.ibas_t);
            ev=reshape(ev,geom.kmax,geom.ncc);
            ev=bound2mid(ev);
            etn(matr.ibas_t)=ev(:);
        end
    end
end
