function [keff,power,fa1,fa2,tl,alfa,dens,Wg,Wl,flowb,Wbyp,tfm,tcm,tw,Iboil,ploss,dp_wr,dpin,dp_sup,Xsec,XS,X]= power_void (fue_new,Oper)
%%
global msopt geom termo neu fuel

re_calc=0;

% TODO: It seems to always be node 2 that does not converge, fix that!!
maxiter=msopt.PowerVoidThMaxiter;
distfile=msopt.DistFile;
NodalCode=msopt.NodalCode;
NeuModel=msopt.NeuModel;

hz=geom.hz;
hx=geom.hx;

ncc=geom.ncc;
kan=geom.kan;
kmax=geom.kmax;
knum=geom.knum;
p=termo.p;
neig=neu.neig;
qtherm=termo.Qtot/get_sym;
delta=neu.delta;
Midpoint=get_bool(msopt.Midpoint);

%%
if strcmpi(NodalCode,'POLCA7')||strcmpi(NodalCode,'SIM3'),
  rf=fuel.rf;
  rca=fuel.rca;
  drca=fuel.drca;
  nrods=fuel.nrods;
  rcca=fuel.rcca;
  e1=fuel.e1;
  e2=fuel.e2;
  gcamx=fuel.gcamx;
  gca0=fuel.gca0;
  gca1=fuel.gca1;
  gca2=fuel.gca2;
  rlca=fuel.rlca;
end


% tolerances and iteration parameters
tol_pv=msopt.PowerVoidTol;
nitr=msopt.PowerVoidMaxiter;

Ppower=Oper.Power;
power=Ppower(:,knum(:,1));
P=p*ones(size(power));

switch upper(NodalCode)
case 'POLCA4' 
  [a11,a21,a22,cp]=read_alb; %POLCA albedos
  chflow=readdist(distfile,'chflow');
  flowb1=readdist(distfile,'flowb1');
  flowb2=readdist(distfile,'flowb2');
  flowb=flowb1+flowb2;
case 'POLCA7'
  [a11,a21,a22,cp]=read_alb7; %POLCA albedos
  chflow=readdist7(distfile,'chflow');
  flowb=readdist7(distfile,'flwwc');  % flwwc corresponds approx. to flowb
  %chflow=chflow+flowb; % Use Polca4 definition of chflow. Not anymore
case 'SIM3'
  [a11,a21,a22,cp]=read_alb7; 
end
init_flag=0;init_xs=0;
if 0%exist(msopt.MstabFile,'file'),
    [init_flag,pow,alfa,tl,Wg,Wl,tw,flowb,fa1,fa2,Xsec,XS,X]=init_from_mat(msopt,'ss',knum);
    if init_flag,
        power=pow;
        Wbyp=termo.Wbyp;
    end
    if isempty(Xsec), 
        init_xs=0;
    else
        init_xs=Xsec.flag;
    end
    if init_xs,
        d1=Xsec.d1;d1d=Xsec.d1d;d1t=Xsec.d1t;d2=Xsec.d2;d2d=Xsec.d2d;d2t=Xsec.d2t;
        siga1=Xsec.siga1;siga1d=Xsec.siga1d;siga1t=Xsec.siga1t;siga2=Xsec.siga2;siga2d=Xsec.siga2d;siga2t=Xsec.siga2t;
        usig1=Xsec.usig1;usig1d=Xsec.usig1d;usig1t=Xsec.usig1t;usig2=Xsec.usig2;usig2d=Xsec.usig2d;usig2t=Xsec.usig2t;
        sigr=Xsec.sigr;sigrd=Xsec.sigrd;sigrt=Xsec.sigrt;ny=Xsec.ny;dens0=Xsec.dens0;tfmm0=Xsec.tfmm0;
    else
        msopt.XSinit='off';
    end
end
if ~init_flag,
%% init, flatstart
if  exist('chflow','var'),
     if length(chflow)>length(knum(:,1));
         chflow=chflow(knum(:,1));
     end
else
    chflow=termo.Wtot;
end
if  exist('flowb','var'),
    if length(flowb)>length(knum(:,1));
        flowb=flowb(knum(:,1));
    end
else
    flowb=[];
end
[alfa,tl,Wg,Wl,chflow,flowb,Wbyp]=syst_f_ini(power,chflow,flowb);
%%
[conv,alfa,tl,Wg,Wl,tw]=syst_f4(power,flowb,alfa,tl,Wg,Wl,1000);
[conv,alfa,tl,Wg,Wl,tw]=syst_f4(power,flowb,alfa,tl,Wg,Wl,0.00001);
%%
end
%%
if ~init_xs,
    if Midpoint
        alfa0=bound2mid(alfa);
    else
        alfa0=alfa;
    end
    dens=void2dens(alfa0,p,tl)/1000;dens0=dens;
    [tfm,tcm] =eq_tftc(tw(:),qtherm,power(:),hz,rf,e1,e2,gca0,gca1,gca2,gcamx,rlca,rca,drca,rcca,p,delta,nrods);
    tfmm=mean(tfm')';tfmm0=reshape(tfmm,kmax,ncc);
    switch lower(msopt.XSmodel)
        case {'xs_cms','xs_cms_df'}
            df_flag=0;if strcmp(msopt.XSmodel,'xs_cms_df'), df_flag=1;end
            [d1,d2,sigr,siga1,siga2,usig1,usig2,kap_ny,V2D,X2D,Y2D,V3D,X3D,Y3D,Z3D,X,Y,XS,XSEC_DX2]=...
                xs_cms(fue_new,msopt.LibFile,dens,tfmm+273.13,knum,df_flag);
            ny=3.2041e-11./kap_ny;
            Dt=10;
            [d1d,d2d,sigrd,siga1d,siga2d,usig1d,usig2d]=...
                xs_cms(fue_new,dens+0.001,tfmm+273.13,V2D,X2D,Y2D,V3D,X3D,Y3D,Z3D,X,Y,XS,XSEC_DX2,knum);
            [d1t,d2t,sigrt,siga1t,siga2t,usig1t,usig2t]=...
                xs_cms(fue_new,dens,tfmm+273.13+Dt,V2D,X2D,Y2D,V3D,X3D,Y3D,Z3D,X,Y,XS,XSEC_DX2,knum);
            XS_FD=1;
        case {'fastxs','fastxs_lin'}
            [xs,xsd,xst,XS,xsdd]=xs_pin_lib(msopt.LibFile,fue_new,dens(:),tfmm(:)+273.13,geom.knum(:,1));
            for i=1:7,
                xst(:,i)=xst(:,i)./sqrt(tfmm(:)+273.13)/2;
            end
            [d1,d2,sigr,siga1,siga2,usig1,usig2,ny,d1d,d2d,sigrd,siga1d,siga2d,usig1d,usig2d,...
                d1t,d2t,sigrt,siga1t,siga2t,usig1t,usig2t]=unpack(xs,xsd,xst,kmax,ncc);
            XS_FD=0;
        case 'ramcof'
            disfil=msopt.DistFile;
            Pdens=sym_full(dens);
            Tfm=sym_full(tfmm0);
            [d1,d2,sigr,siga1,siga2,usig1,usig2,ny,d1d,d2d,sigrd,siga1d,siga2d,usig1d,usig2d,nyd,...
                sigrt,siga1t,siga2t,usig2t]=...
                xsec2mstab7(disfil,1000*Pdens,Tfm,knum);
            d1d=d1d*1000;d2d=d2d*1000;sigrd=sigrd*1000;siga1d=siga1d*1000;
            siga2d=1000*siga2d;usig1d=usig1d*1000;usig2d=usig2d*1000;nyd=nyd*1000;
            d1t=0*d1;d2t=0*d2;usig1t=0*usig1;
            XS=[];X=[];
            XS_FD=0;
    end
    if XS_FD,
        delta_dens=.001; %
        d1d=(d1d-d1)/delta_dens;
        d2d=(d2d-d2)/delta_dens;
        sigrd=(sigrd-sigr)/delta_dens;
        siga1d=(siga1d-siga1)/delta_dens;
        siga2d=(siga2d-siga2)/delta_dens;
        usig1d=(usig1d-usig1)/delta_dens;
        usig2d=(usig2d-usig2)/delta_dens;
        d1t=(d1t-d1)/Dt;
        d2t=(d2t-d2)/Dt;
        sigrt=(sigrt-sigr)/Dt;
        siga1t=(siga1t-siga1)/Dt;
        siga2t=(siga2t-siga2)/Dt;
        usig1t=(usig1t-usig1)/Dt;
        usig2t=(usig2t-usig2)/Dt;
    end
    if ~init_flag,
        fa1=8.5e11*power./(usig1./ny+usig2./ny.*sigr./siga2);
        fa2=fa1.*sigr./siga2;
        fa1=fa1(:);fa2=fa2(:);
    end
end

keff=Oper.keff;
switch upper(NeuModel)
    case 'NEU1'
        [keff,fa1,fa2,pow]=solv_fi(keff,fa1(:),fa2(:),qtherm,neig,usig1(:),usig2(:),siga1(:),sigr(:),...
            siga2(:),ny(:),ny(:),d1(:),d2(:),hx,hz,a11,a21,a22,cp);
        Sn=[];C1nm=[];C2nm=[];DF1=[];DF2=[];
    case 'NEU3'
        [F1W,F1S,F2W,F2S,V2Ddf,X2Ddf,Y2Ddf,V3Ddf,X3Ddf,Y3Ddf,Z3Ddf,Xdf,Ydf,XSdf,XSEC_DX2df]=df_cms(fue_new,msopt.LibFile,dens,tfmm+273.13,knum);
        DF1=cas2sim(F1W,F1S,fue_new.nfra(knum(:,1)));
        DF2=cas2sim(F2W,F2S,fue_new.nfra(knum(:,1)));
        [keff,fa1,fa2,pow,r,raa,Sn,C1nm,C2nm]=...
            solv_neu3(keff,fa1,fa2,qtherm,neig,usig1(:),usig2(:),siga1(:),sigr(:),siga2(:),ny(:),ny(:),d1(:),d2(:),hx,hz,a11,a21,a22,DF1,DF2,5);
end
%power=reshape(pow,kmax,ncc);
%power=power/mean(power(:));


[pathstr,filestr,extstr]=fileparts(msopt.MstabFile);
fid=0;


if re_calc==0,
    disp('Power-Void Iteration:')
    disp('It #  Max(dPow)    max(DdP)    Keff ')
    disp('                    (kPa) ');
    disp('-----+----------+-----------+-----------+')
else
fid=fopen([pathstr,'/',filestr,'.lis'],'w');
    disp('Power-Void Iteration:')
    disp('It. nr    Norm(err)  norm(dP_err)     Keff         dpow      node')
    disp('                        (kPa) ');
    disp('-------+-----------+---------------+-----------+----------+---------+')
            fprintf(fid,'Power-Void Iteration:\n');
    fprintf(fid,'It. nr    Norm(err)  norm(dP_err)     Keff         dpow      node\n');
    fprintf(fid,'                        (kPa) \n');
    fprintf(fid,'-------+-----------+---------------+-----------+----------+---------+\n');
end

%%
tol=[0.001 0.001 0.001*ones(1,100)]/10;
nitr=2;
if re_calc==0, nitr=1;end
ntol=0;
bryt=0;
for n=1:nitr,
    for nn=1:1,
        ntol=ntol+1;
    [err,power,alfa,tl,Wg,Wl,flowb,Wbyp,tw,tcm,tfm,tfmm,Iboil,keff,fa1,fa2,ploss,dp_wr,dpin,dp_sup,Sn]=syst_f57(power,flowb,alfa,dens0,tl,Wg,Wl,Wbyp,...
      tfmm0,tol(ntol),fa1,fa2,keff,d1,d2,sigr,siga1,siga2,usig1,usig2,ny,d1d,d2d,sigrd,siga1d,siga2d,usig1d,usig2d,d1t,d2t,...
       sigrt,siga1t,siga2t,usig1t,usig2t,neig,a11,a21,a22,cp,n,nn,DF1,DF2,Sn,C1nm,C2nm,fid,NeuModel);
         if err(7)<0.0005 && err(8)<0.1, if re_calc==0, bryt=1;end;break;end
    end
    if re_calc,
        if Midpoint
            alfa0=bound2mid(alfa);
        else
            alfa0=alfa;
        end
        dens=void2dens(alfa0,p,tl);
        [tfm,tcm] =eq_tftc(tw(:),qtherm,power(:),hz,rf,e1,e2,gca0,gca1,gca2,gcamx,rlca,rca,drca,rcca,p,delta,nrods);
        tfmm=mean(tfm')';tfmm0=reshape(tfmm,kmax,ncc);
        [d1,d2,sigr,siga1,siga2,usig1,usig2,kap_ny]=...
           xs_cms(fue_new,dens/1000,tfmm+273.13,V2D,X2D,Y2D,V3D,X3D,Y3D,Z3D,X,Y,XS,XSEC_DX2,knum);
        ny=3.2041e-11./kap_ny;
        power0=power;
        [keff,fa1,fa2,pow]=solv_fi(keff,fa1(:),fa2(:),qtherm,neig,usig1(:),usig2(:),siga1(:),sigr(:),...
        siga2(:),ny(:),ny(:),d1(:),d2(:),hx,hz,a11,a21,a22,cp);
        pow=pow/mean(pow);power=reshape(pow,kmax,kan);
        [err1,pone]=max(abs(power0(:)-power(:)));
        fprintf(1,'%i %16.5f %12.5f %12.5f %12.5f %6i\n',n,err(3),err(4),keff,power(pone)-power0(pone),pone);
        fprintf(fid,'%i %16.5f %12.5f %12.5f %12.5f %6i\n',n,err(3),err(4),keff,power(pone)-power0(pone),pone);
        %ppow{n+1}=power;TFU{n+1}=tfmm;den{n+1}=dens;TL{n+1}=tl;al{n+1}=alfa;
        if err1<0.001&&err(3)<0.001&&err(4)<0.001&&n>1,
            bryt=1;break
        end
         if n==maxiter,error('No convergence!'),end
    else
        err1=1e-5;
        %fprintf(1,'%i %16.5f %12.5f %12.5f\n',n,err(3),err(4),keff);
        %fprintf(fid,'%i %16.5f %12.5f %12.5f\n',n,err(3),err(4),keff);
    end
    if bryt,break;end
end
fprintf(1,'          keff        dPcore     dPin       TotBypass   ExtBypass  IntBypass\n');
if strcmpi(NodalCode,'SIM3')||strcmpi(NodalCode,'SIM5'),
    fprintf(1,'Simulate: %7.5f',Oper.keff);
    fprintf(1,'\n');
elseif strncmp(NodalCode,'POLCA',5),
    fprintf(1,'POLCA:   %7.5f',Oper.keff);
    WtPol=termo.Wtot;fracs=[termo.spltot termo.spltot-termo.spltwc termo.spltwc];
    polPF=[termo.dpcore termo.dpavin WtPol*fracs];
    fprintf(1,' %10i',round(polPF));
    fprintf(1,'\n');
end
iby=sum(flowb)*get_sym;
eby=Wbyp*get_sym;
fprintf(1,'MATSTAB: %7.5f',keff);
fprintf(1,' %10i',round([mean(sum(ploss)) mean(ploss(1,:)) eby+iby eby iby]));
fprintf(1,'\n');


fprintf(1,'%s\n','Power Comparison:');
fprintf(1,'   %s       %s         %s','MAX','PPF','FRAD');
fprintf(1,'\n');
fprintf(1,'%7s%s%10.3f%12.3f',msopt.NodalCode,':',max(Oper.Power(:)),max(mean(Oper.Power)));
fprintf(1,'\n');
fprintf(1,'%s%10.3f%12.3f','MATSTAB:',max(power(:)),max(mean(power)));
fprintf(1,'\n');
fprintf(1,'%s      %s   %s  %s  %s  ','Diff(%):',' NODrms','RADrms',' NODmax',' NODmin');
fprintf(1,'%s  %s','  AVEmax','AVEmin');
fprintf(1,'\n');
Ppow=sym_full(power);
dN=Ppow(:)-Oper.Power(:);
dM=mean(Ppow)-mean(Oper.Power);
difs=100*[std(dM,1) max(dN) min(dN)  max(dM)  min(dM)];
fprintf(1,'%s%6s','MATSTAB-',msopt.NodalCode);
fprintf(1,'%7.3f',std(dN,1)*100);
fprintf(1,'%9.3f',difs);
fprintf(1,'\n');

    

if re_calc==0,
    if Midpoint
        alfam=bound2mid(alfa);
    else
        alfam=alfa;
    end
    densm=void2dens(alfam,P,tl)/1000;
     d1=d1+d1d.*(densm-dens0)+d1t.*(tfmm-tfmm0);
     d2=d2+d2d.*(densm-dens0)+d2t.*(tfmm-tfmm0);
     sigr=sigr+sigrd.*(densm-dens0)+sigrt.*(tfmm-tfmm0);     
     siga1=siga1+siga1d.*(densm-dens0)+siga1t.*(tfmm-tfmm0);           
     siga2=siga2+siga2d.*(densm-dens0)+siga2t.*(tfmm-tfmm0);                 
     usig1=usig1+usig1d.*(densm-dens0)+usig1t.*(tfmm-tfmm0);                       
     usig2=usig2+usig2d.*(densm-dens0)+usig2t.*(tfmm-tfmm0);
     dens0=densm;
elseif re_calc>1,
    delta_alfa=0.0001;
    if Midpoint
        alfam=bound2mid(alfa);
    else
        alfam=alfa;
    end
    densd=void2dens(alfam+delta_alfa,p,tl);
    [d1d,d2d,sigrd,siga1d,siga2d,usig1d,usig2d,kap_nyd]=...
           xs_cms(fue_new,densd/1000,tfmm+273.13,V2D,X2D,Y2D,V3D,X3D,Y3D,Z3D,X,Y,XS,XSEC_DX2,knum);
    [d1t,d2t,sigrt,siga1t,siga2t,usig1t,usig2t,kap_nyt]=...
           xs_cms(fue_new,dens/1000,tfmm+273.13+1,V2D,X2D,Y2D,V3D,X3D,Y3D,Z3D,X,Y,XS,XSEC_DX2,knum);
    d1d=(d1d-d1)/delta_alfa;
    d2d=(d2d-d2)/delta_alfa;
    sigrd=(sigrd-sigr)/delta_alfa;
    siga1d=(siga1d-siga1)/delta_alfa;
    siga2d=(siga2d-siga2)/delta_alfa;
    usig1d=(usig1d-usig1)/delta_alfa;
    usig2d=(usig2d-usig2)/delta_alfa;
    d1t=(d1t-d1);
    d2t=(d2t-d2);
    sigrt=(sigrt-sigr);
    siga1t=(siga1t-siga1);
    siga2t=(siga2t-siga2);
    usig1t=(usig1t-usig1);
    usig2t=(usig2t-usig2);
end
Xsec.d1=d1(:);
Xsec.d2=d2(:);
Xsec.sigr=sigr(:);
Xsec.siga1=siga1(:);
Xsec.siga2=siga2(:);
Xsec.usig1=usig1(:);  
Xsec.usig2=usig2(:);  
Xsec.ny=ny(:);
Xsec.d1d=d1d(:);
Xsec.d2d=d2d(:);
Xsec.sigrd=sigrd(:);
Xsec.siga1d=siga1d(:);
Xsec.siga2d=siga2d(:);
Xsec.usig1d=usig1d(:);  
Xsec.usig2d=usig2d(:);  
Xsec.d1t=d1t(:);
Xsec.d2t=d2t(:);
Xsec.sigrt=sigrt(:);
Xsec.siga1t=siga1t(:);
Xsec.siga2t=siga2t(:);
Xsec.usig1t=usig1t(:);  
Xsec.usig2t=usig2t(:);  
Xsec.tfmm0=tfmm;
Xsec.dens0=dens0;
dens=void2dens(alfa,p,tl)/1000;

if strcmp(msopt.XSmodel,'fastxs'),
    Xsec.d1d=xsdd(:,1);
    Xsec.d2d=xsdd(:,2);
    Xsec.sigrd=xsdd(:,3);
    Xsec.siga1d=xsdd(:,4);
    Xsec.siga2d=xsdd(:,5);
    Xsec.usig1d=xsdd(:,6);
    Xsec.usig2d=xsdd(:,7);
end

if strcmpi(NeuModel,'NEU3'),
    Xsec.DF1=DF1;
    Xsec.DF2=DF2;
    Xsec.Sn=Sn;
    Xsec.C1nm=C1nm;
    Xsec.C2nm=C2nm;
end
%{
Xsec.d1d=(d1d(:)-d1(:))/delta_alfa;
Xsec.d2d=(d2d(:)-d2(:))/delta_alfa;
Xsec.sigrd=(sigrd(:)-sigr(:))/delta_alfa;
Xsec.siga1d=(siga1d(:)-siga1(:))/delta_alfa;
Xsec.siga2d=(siga2d(:)-siga2(:))/delta_alfa;
Xsec.usig1d=(usig1d(:)-usig1(:))/delta_alfa;
Xsec.usig2d=(usig2d(:)-usig2(:))/delta_alfa;
Xsec.d1t=(d1t(:)-d1(:));
Xsec.d2t=(d2t(:)-d2(:));
Xsec.sigrt=(sigrt(:)-sigr(:));
Xsec.siga1t=(siga1t(:)-siga1(:));
Xsec.siga2t=(siga2t(:)-siga2(:));
Xsec.usig1t=(usig1t(:)-usig1(:));
Xsec.usig2t=(usig2t(:)-usig2(:));
%save X_sec Xsec 
%}
%save X_sec Xsec geom X Y XS V2D X2D Y2D V3D X3D Y3D Z3D XSEC_DX2
if fid>0, fclose(fid);end
if ~exist('X','var'), X=[];end


function       [d1,d2,sigr,siga1,siga2,usig1,usig2,ny,d1d,d2d,sigrd,siga1d,siga2d,usig1d,usig2d,...
    d1t,d2t,sigrt,siga1t,siga2t,usig1t,usig2t]=unpack(xs,xsd,xst,kmax,ncc)
    d1=xs(:,1);
   d2=xs(:,2);
   sigr=xs(:,3);
   siga1=xs(:,4);   
   siga2=xs(:,5);
   usig1=xs(:,6);
   usig2=xs(:,7);
   ny=3.2041e-11./xs(:,8);
   d1d=xsd(:,1);
   d2d=xsd(:,2);
   sigrd=xsd(:,3);
   siga1d=xsd(:,4);   
   siga2d=xsd(:,5);
   usig1d=xsd(:,6);
   usig2d=xsd(:,7);   
   d1t=xst(:,1);
   d2t=xst(:,2);
   sigrt=xst(:,3);
   siga1t=xst(:,4);   
   siga2t=xst(:,5);
   usig1t=xst(:,6);
   usig2t=xst(:,7);   
    ny=reshape(ny,kmax,ncc);
    d1=reshape(d1,kmax,ncc);
    d1d=reshape(d1d,kmax,ncc);
    d1t=reshape(d1t,kmax,ncc);
    d2=reshape(d2,kmax,ncc);
    d2d=reshape(d2d,kmax,ncc);
    d2t=reshape(d2t,kmax,ncc);
    sigr=reshape(sigr,kmax,ncc);
    sigrd=reshape(sigrd,kmax,ncc);
    sigrt=reshape(sigrt,kmax,ncc);
    siga1=reshape(siga1,kmax,ncc);
    siga1d=reshape(siga1d,kmax,ncc);
    siga1t=reshape(siga1t,kmax,ncc);
    siga2=reshape(siga2,kmax,ncc);
    siga2d=reshape(siga2d,kmax,ncc);
    siga2t=reshape(siga2t,kmax,ncc);
    usig1=reshape(usig1,kmax,ncc);
    usig1d=reshape(usig1d,kmax,ncc);
    usig1t=reshape(usig1t,kmax,ncc);
    usig2=reshape(usig2,kmax,ncc);
    usig2d=reshape(usig2d,kmax,ncc);
    usig2t=reshape(usig2t,kmax,ncc);   