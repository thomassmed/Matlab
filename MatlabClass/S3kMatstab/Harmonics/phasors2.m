%%
load_data
%%
fprintf(' Case Power  flow   lprm    lprm \n');
fprintf('                    lev 2   lev 4 \n');
for c='a':'i',
    q=eval(['q',c]);
    fl=eval(['mean(fl',c,')']);
    lp2=eval(['lprm2',c]);
    lp2=mean(lp2(:));
    lp4=eval(['lprm4',c]);
    lp4=mean(lp4(:));    
    fprintf('Case %s %4.1f %5i   %4.1f    %4.1f \n',c,q,round(fl),lp2,lp4);
end
%%
tmeas=0:Ts:8249*Ts;
ah=plot(tmeas,aprmmg);
[NW,NE,SW,SE]=get_scrpos;
SW(2)=SW(2)+50;
SW(3)=.9*SW(3);SW(4)=0.9*SW(4);
set(gcf,'position',SW);
title('APRM Ringhals 1');
figure(gcf)
%% Read the LPRM:s and time
cmsfile='/cms/Ringhals/Lotfi/r1c14m.cms';
cmsinfo=read_cms(cmsfile);
[lprm,Names]=read_cms_scalar(cmsinfo,'LPRM');
t=read_cms_scalar(cmsinfo,1);
%% Transpose
lprm=lprm';
t=t';
%% get the phasors from S3K
[phas,lprmest,x,tc,drx,fdx,p,p0,err]=get_phasor(t,lprm,1.1,.53,8);
%% Rearrange
phas=p(2,:)'+1j*p(3,:)';
phas=reshape(phas,4,length(phas)/4);
phas=phas(4:-1:1,:);
phas=phas/phas(4,7);
%% Now create the cmsplot figure for S3K
load e_meas
load /cms/Ringhals/Lotfi/r1c14.mat stabh geom matr
En1=sym_full(reshape(stabh.en(:,1),geom.kmax,geom.kan),geom.knum,1);
cmsplot /cms/Ringhals/Lotfi/r1c14.mat abs(En1) NW
hfig=gcf;
set_cmsplot_prop detectors numbers
cmsplot_now
c=get(gca,'children');
for i=1:length(c),
    if isprop(c(i),'string');
        str=get(c(i),'string');
        if findstr('fd =',str);
            delete(c(i));
        end
        if findstr('dr =',str);
            delete(c(i));
        end
    end
end
tilt=exp(1j*pi/6); % 30 degr
es3k=phas;
es3k(1,:)=nan;
es3k(3,:)=nan;
add_phasors(tilt*e_meas,tilt*es3k,hfig,28)
ht1=title('Phasors for S3K (black) and measured (white),2nd and 4th level');
set(ht1,'fontweight','bold','fontsize',14)
%% and for matstab
cmsplot /cms/Ringhals/Lotfi/r1c14.mat abs(En1) NE
hfig=gcf;
set_cmsplot_prop detectors numbers
cmsplot_now
tilt=exp(1j*pi/6); % 30 degr
[e_mstab,efi2,e_mstabh]=get_lprm_eigvec('/cms/Ringhals/Lotfi/r1c14.mat');
e_mstabh{1}=e_mstabh{1}/e_mstabh{1}(4,7);
ems=e_mstabh{1};
ems(1,:)=nan;
ems(3,:)=nan;
add_phasors(tilt*e_meas,tilt*ems,hfig,28)
ht2=title('Phasors for Matstab (black) and measured (white),2nd and 4th level');
set(ht2,'fontweight','bold','fontsize',14)
c=get(gca,'children'); % Remove the printout of dr and fd
for i=1:length(c),
    if isprop(c(i),'string');
        str=get(c(i),'string');
        if findstr('fd =',str);
            delete(c(i));
        end
        if findstr('dr =',str);
            delete(c(i));
        end
    end
end
