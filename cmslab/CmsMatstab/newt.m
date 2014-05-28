function [An,Ant,AnIm,AntIm,l,u]=newt(lam,en0,At,Atj,Atq,Atf,Ajt, ...
      Aj,Ajq,Ajf,Ant,AntIm,An,AnIm,Anf,Aqt,Aqn,Aqf,Aft,Afj,Afq,Af,Bt,Bf,Bj,Btj,fue_new,Xsec,matr)

% [An,Ant,AnIm,AntIm,l,u]=newt(lam,en0,At,Atj,Atq,Atf,Ajt, ...
%      Aj,Ajf,Ant,AntIm,An,AnIm,Anf,Aqt,Aqn,Aqf,Aft,Afj,Afq,Af,Bt,Bf,Bj,fue_new,Xsec,matr)  
  

%%

global msopt stab geom termo

%% Preparations
Midpoint=get_bool(msopt.Midpoint);
tolnewt=msopt.GlobalFullTol;
tollam=msopt.GlobalLamTol;
maxiter=msopt.GlobalFullMaxiter;
msopt.UpdateAneuNewLam=1;
CoreOnly=get_bool(msopt.CoreOnly);
kmax=geom.kmax;
ntot=geom.ntot;
nt=matr.nt;
nAI=matr.nAI;

if ~exist('harmonic','var'), harmonic=0; end

[dum,nmax]=max(mean(abs(en0)));
nod=(nmax-1)*kmax+22;
ibas_t=1:nt:ntot*nt;
efix=ibas_t(nod);
ett=zeros(1,size(At,1));
ett(efix)=1;
let=size(At,1);
et=zeros(let,1);

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
[l1,u1] = lu(lam*Bt-At);
if ~CoreOnly
    Ajttj=Ajt*(u1\(l1\Atj));
else
    Ajttj=sparse(matr.nAI+5,matr.nAI+5);
end
%% %%%%%%%%%%%%%%%%%%%%% ------------------ ändrat just nu!!! ------------
setup.type='nofill';
setup.droptol=0;
setup.milu='off';
setup.udiag=0;
setup.thresh=1;
[l,u]=ilu(An,setup);
% [l,u]=lu(An);
%
en=en0(:);
eq=Aqn*en;
ef = uf\(lf\(Afq*eq+Aft*et));
et=u1\(l1\(Atf*ef+Atq*eq));

if CoreOnly,
    ej=zeros(matr.nAI,1);
    Ajt=0*Ajt;
else
    ej=(lam*Bj-Aj-Ajttj)\(Ajf*ef+Ajt*et+Ajq*eq);
end
et=u1\(l1\(Atf*ef+Atq*eq+Atj*ej));
enupd=0;
for ii0=1:3,
  for ii=1:2,
    rhs1=-Bt*et*lam+At*et+Atj*ej+Atf*ef+Atq*eq-lam*Btj*ej;
    if CoreOnly,
        ej=0*ej;
    else
        dej=(lam*Bj-Aj-Ajttj)\(-Bj*lam*ej+Ajq*eq+Ajf*ef+Aj*ej+Ajt*et+Ajt*(u1\(l1\rhs1)));
        ej=ej+dej;
    end
    et=u1\(l1\(Atf*ef+Atq*eq+Atj*ej-lam*Btj*ej));
  end
  if ii0==3, enupd=1;end  
  [en,eq,ef]=newt_neu(lam,et,ej,en,ef,An,Ant,AntIm,AnIm,Anf,l,u,lf,uf,Aqn,Aqt,Aqf,Aft,Afq,Afj,enupd);
end
%%


if ~strcmpi(msopt.Algorithm(1),'N'),
    fprintf(1,'\n AESOPS Algorithm: \n');
[xx,vfix]=max(abs(et(ibas_t)));
efix=ibas_t(vfix);

J=[-1.5  .1
   -.1 -1.1];
sigk=[1;0];
wk=[0;1];

%
fprintf(1,'\n');
dlam=0;
[et_efix,et,ej,en,ef,eq]=find_dlam(lam,dlam,Bt,Btj,At,Atj,Atf,l1,u1,Atq,Bj,Aj,Ajttj,Ajf,Ajq,Ajt,Ant,AntIm,An,AnIm,Anf,Aqt,Aqn,Aqf,Aft,Afq,Af,Afj,Bf,...
       l,u,lf,uf,et,ej,en,eq,ef,efix,CoreOnly,matr);
[dr,fd]=p2drfd(lam);tol=abs(et_efix-1);
if debug_mode,
    fprintf(1,'  It.#     dr      freq.         lam              Delta(efix) \n') 
    fprintf(1,'-------+--------+---------+------------------+-------------------+ \n');
    if imag(et_efix)<0,
        fprintf(1,'  %i    %8.4f  %8.4f  %8.4f+%6.4fi  %10.6f-%8.6fi \n',0,dr,fd,real(lam+dlam),imag(lam+dlam),real(et_efix-1),abs(imag(et_efix-1)));
    else
        fprintf(1,'  %i    %8.4f  %8.4f  %8.4f+%6.4fi  %10.6f+%8.6fi \n',0,dr,fd,real(lam+dlam),imag(lam+dlam),real(et_efix-1),abs(imag(et_efix-1)));
    end
else
    fprintf(1,'  It.#     dr      freq.    tol (dlam)   \n') 
    fprintf(1,'-------+--------+---------+--------------+ \n');
    fprintf(1,'   %i   %8.4f   %8.4f   %10.6f \n',0,dr,fd,tol);    
end
dsig_de=J\sigk;
dw_de=J\wk;

%%
dlam=0.7*(et_efix-1);
if abs(dlam)>0.2, dlam=0.2*dlam/abs(dlam);end
for i=1:maxiter,
    if i>1,
        %
        [An,Ant,Anf,Aqn,Aqt,Aqf]=A_neu(fue_new,Xsec,matr,lam);
        AnIm=imag(An);
        An=real(An);
        AntIm=imag(Ant);
        Ant=real(Ant);
        %}
        [lf,uf]=lu(lam*Bf-Af);
        [l1,u1] = lu(lam*Bt-At);
        dlam=0;
    end
    et_efix0=et_efix;
    for j=1:10,
        et_efix00=et_efix;
        Lam(j,i)=lam+dlam;
         Dlam(j,i)=dlam;
         [et_efix,et,ej,en,ef,eq]=find_dlam(lam,dlam,Bt,Btj,At,Atj,Atf,l1,u1,Atq,Bj,Aj,Ajttj,Ajf,Ajq,Ajt,Ant,AntIm,An,AnIm,Anf,Aqt,Aqn,Aqf,Aft,Afq,Af,Afj,Bf,...
            l,u,lf,uf,et,ej,en,eq,ef,efix,CoreOnly,matr);
        ddlam_real=dsig_de(1)*real(et_efix-1)+dsig_de(2)*imag(et_efix-1);
        ddlam_imag=dw_de(1)*real(et_efix-1)+dw_de(2)*imag(et_efix-1);
        ddlam=-ddlam_real-1j*ddlam_imag;
        if i==1&&j==1,
            J=[J;real(et_efix-et_efix0) imag(et_efix-et_efix0)];
            sigk=[sigk;real(Dlam(1,1))];
            wk=[wk;imag(Dlam(1,1))];
            dsig_de=J\sigk;
            dw_de=J\wk;
        end
        if j>1,
           % if j>4, J(1,:)=[];sigk(1)=[];wk(1)=[];end
            J=0.5*J;sigk=0.5*sigk;wk=0.5*wk;
            J=[J;real(et_efix-et_efix00) imag(et_efix-et_efix00)];
            %disp([et_efix-et_efix00 Ddlam(j-1,i)])
            sigk=[sigk;real(Ddlam(j-1,i))];
            wk=[wk;imag(Ddlam(j-1,i))];
            dsig_de=J\sigk;
            dw_de=J\wk;
        end
        if abs(ddlam)>0.2, ddlam=0.2*ddlam/abs(ddlam); end
        dlam=dlam+ddlam;
        Ddlam(j,i)=ddlam;
        Et_efix(j,i)=et_efix;
        if debug_mode,
            disp([dsig_de';dw_de']);
        end
        [dr,fd]=p2drfd(lam+dlam);tol=abs(et_efix-1);
        Tol(j,i)=tol;
        if debug_mode,
            if imag(et_efix)<0,
                fprintf(1,'  %i    %8.4f  %8.4f  %8.4f+%6.4fi  %10.6f-%8.6fi \n',i,dr,fd,real(lam+dlam),imag(lam+dlam),real(et_efix-1),abs(imag(et_efix-1)));
            else
                fprintf(1,'  %i    %8.4f  %8.4f  %8.4f+%6.4fi  %10.6f+%8.6fi \n',i,dr,fd,real(lam+dlam),imag(lam+dlam),real(et_efix-1),abs(imag(et_efix-1)));
            end
        else
            if j==1,
                fprintf(1,'   %i   %8.4f   %8.4f   %10.6f \n',i,dr,fd,tol);
            else
                fprintf(1,'       %8.4f   %8.4f   %10.6f \n',dr,fd,tol);
            end
            getMidpoint
            [toll,rtrt,rjrj,rqrq,rfrf,rnrn]=res_eig(At,Atj,Atq,Atf,Bt,Btj,...
                Ajt,Ajq,Aj,Bj,Ant,AntIm,An,AnIm,Anf,Aqt,Aqn,Aqf,Aft,Afq,Afj,Af,Bf,et,ej,en,eq,ef,lam,etn);
            %fprintf(1,' %g %g %g %g %g %g \n',toll,rtrt,rjrj,rqrq,rfrf,rnrn);
        end
        if tol<tollam, break;end
        if j==10,
            [xx,jj]=min(Tol(:,i));
            if jj<8,
                fprintf(1,'Risk for non-convergence, will reset search-Jacobian and continue from sub-iteration # %i \n',jj);
                dlam=Dlam(jj,i);
                J=[-1.5 0.1
                   -0.1 -1.1];
                sigk=[1;0];
                wk=[0;1];
                dsig_de=J\sigk;
                dw_de=J\wk;
            end
        end
    end
    lam=lam+dlam;
    if tol<0.0001&&i>1, break;end
    if strcmpi(msopt.Algorithm(1),'C'),
        if tol<0.0002,break;end
    end
end
else dlam=1;
end

if ~strcmpi(msopt.Algorithm(1),'A'),
    fprintf(1,'\n Newton Algorithm: \n');
[l2,u2] = lu([lam*Bt-At Bt*et;ett 0]);
j_ett=find(ett);
def=0*ef;

ibryt=0;
fprintf(1,'\n');
fprintf(1,'  It.#     dr      freq.       tol     tol(dlam) \n') 
fprintf(1,'-------+--------+---------+-----------+-------- \n');
[dk,fd]=p2drfd(lam);
getMidpoint
[tol,rtrt,rjrj,rqrq,rfrf,rnrn]=res_eig(At,Atj,Atq,Atf,Bt,Btj,Ajt,Ajq,Aj,Bj,Ant,AntIm,An,AnIm,Anf,Aqt,Aqn,Aqf,Aft,Afq,Afj,Af,Bf,et,ej,en,eq,ef,lam,etn);
fprintf(1,'  %2i    %8.4f  %8.4f  %10.6f  %10.6f \n',0,dk,fd,tol,abs(dlam));
%fprintf(1,' %g %g %g %g %g %g \n',tol,rtrt,rjrj,rqrq,rfrf,rnrn);
for n0=1:maxiter,
  lam0=lam;
  [dr0,fd0]=p2drfd(lam0);
  for n1=1:3,
    for n2=1:5,
      rhs1=-Bt*et*lam+At*et+Atj*ej+Atf*ef+Atq*eq;
      if CoreOnly,
          ej=0*ej;dej=0*ej;
      else
          dej=(lam*Bj-Aj-Ajttj)\(-Bj*lam*ej+Ajq*eq+Aj*ej+Ajf*(ef+def)+Ajt*et+Ajt*(u1\(l1\rhs1)));
      end
      ej=ej+dej;
      de=u2\(l2\([rhs1+Atj*dej;0]));dlam=de(let+1);de(let+1)=[];
      et=et+de;
      lam=lam+dlam;
    end
    getMidpoint
    for i3=1:3,
      hl=Ant*etn+AntIm*(etn*1j)+AnIm*(en*1j)+Anf*ef;
      en = pcgsolve(An,-hl,en,1e-5,30,0,l,u);
    end
    for i3=1:3,
      eq=Aqn*en+Aqt*et+Aqf*ef;
      ef = (lam*Bf-Af)\(Aft*et+Afq*eq+Afj*ej);
    end
    [dk,fd]=p2drfd(lam); %TODO Investigate the Leibstadt case
    [tol,rtrt,rjrj,rqrq,rfrf,rnrn]=res_eig(At,Atj,Atq,Atf,Bt,Btj,Ajt,Ajq,Aj,Bj,Ant,AntIm,An,AnIm,Anf,Aqt,Aqn,Aqf,Aft,Afq,Afj,Af,Bf,et,ej,en,eq,ef,lam,etn);
    if abs(tol)<tolnewt&&abs(dk-dr0)<0.005, ibryt=1;break;end
    if n1<3, fprintf(1,'        %8.4f  %8.4f  %10.6f  %10.6f \n',dk,fd,tol,abs(lam-lam0));end
   % fprintf(1,' %g %g %g %g %g %g \n',tol,rtrt,rjrj,rqrq,rfrf,rnrn);
  end
 
  [tol,rtrt,rjrj,rqrq,rfrf,rnrn]=res_eig(At,Atj,Atq,Atf,Bt,Btj,Ajt,Ajq,Aj,Bj,Ant,AntIm,An,AnIm,Anf,Aqt,Aqn,Aqf,Aft,Afq,Afj,Af,Bf,et,ej,en,eq,ef,lam,etn);
  fprintf(1,'  %2i    %8.4f  %8.4f  %10.6f  %10.6f \n',n0,dk,fd,tol,abs(lam-lam0));
  if ibryt==1||n0==maxiter, break;end

  [l1,u1] = lu(lam*Bt-At);

  [l2,u2] = lu([lam*Bt-At Bt*et;ett 0]);

  Ajttj=Ajt*(u1\(l1\Atj));

  if get_bool(msopt.UpdateAneuNewLam),
  
        [An,Ant,Anf,Aqn,Aqt,Aqf]=A_neu(fue_new,Xsec,matr,lam);
        AnIm=imag(An);
        An=real(An);
        AntIm=imag(Ant);
        Ant=real(Ant);
        [l1,u1] = lu(lam*Bt-At);
   end
end
end
   
%%
enorm=et(efix); 
et=et/enorm;ej=ej/enorm;en=en/enorm;eq=eq/enorm;ef=ef/enorm;

stab.lam=lam;
[dr,f]=p2drfd(lam);
stab.dr=dr;
stab.f=f;
stab.et=et;
stab.ej=ej;
stab.en=en;
stab.eq=eq;
stab.ef=ef;

save('-append',msopt.MstabFile,'stab','matr','geom','Aj','Ajt','Bj','Atj','Ajq','Af','Afq');

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