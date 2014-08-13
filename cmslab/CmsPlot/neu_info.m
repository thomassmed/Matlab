%
function neu_info

hfig=gcf;
cmsplot_prop=get(hfig,'userdata');
handles=cmsplot_prop.handles;

uiwait(msgbox('Left click to select, right click to quit'));

cmax=cmsplot_prop.scale_max;
cmin=cmsplot_prop.scale_min;

epsi=1.0d-10*(cmax-cmin);
cmax=cmax+epsi;
cmin=cmin-epsi;

button=1;
plmat=get(handles(10,2),'cdata');

mminj=cmsplot_prop.mminj;
clmap=cmsplot_prop.colormap;
knum=cmsplot_prop.knum;
kan=cmsplot_prop.kan;


if strcmp(cmsplot_prop.filetype,'.hms'),
  filnam=cmsplot_prop.filename;
  kan=cmsplot_prop.core.kan;
  burnup=hms_readdist(filnam,'3EXP');
  vhist=hms_readdist(filnam,'3HVO');
ser=char(32*ones(kan,6));
lab=ser; %TODO Fix this properly
  %serial=pp2_readdist_char(sock,'ASYID');
  crdhist=zeros(size(vhist));
  %lab=pp2_readdist_char(sock,'ASYTYP');
  nfta=nan(1,kan);
else
    switch cmsplot_prop.filetype,
        case '.out'
            ser=ReadCore(cmsplot_prop.coreinfo,'FUE.SER');
            lab=ReadCore(cmsplot_prop.coreinfo,'FUE.LAB');
            nfta=ReadCore(cmsplot_prop.coreinfo,'FUE.TYP');
            burnup=ReadCore(cmsplot_prop.coreinfo,'PRI.STA 2EXP',cmsplot_prop.state_point);
            crdhist=NaN(1,kan);
            vhist=crdhist;

            
            
        case '.res'
            if cmsplot_prop.if2x2 == 2
                searchcell = {'burnup','DENHIST','BORONDENS','assembly labels','nfta'};
                mminj = cmsplot_prop.core.mminj2x2;
                knum = cmsplot_prop.core.knum2x2;
            else
                searchcell = {'burnup','vhist','crdhist','assembly labels','nfta'};
            end
            data = ReadCore(cmsplot_prop.coreinfo,searchcell,cmsplot_prop.state_point);
            burnup = data.burnup;
            
            nfta = data.nfta;
            if cmsplot_prop.core.if2x2 == 2
                nfta = fill2x2(nfta,cmsplot_prop.core.mminj,cmsplot_prop.core.knum,'full');
                vhist = data.denhist;
                crdhist = data.borondens;
            else
                vhist = data.vhist;
                crdhist = data.crdhist;
            end
            ser = data.assemblylabels.ser;
            lab = data.assemblylabels.lab;
        case '.cms'
            burnup=ReadCore(cmsplot_prop.coreinfo,'3EXP',cmsplot_prop.state_point);
            nfta = ReadCore(cmsplot_prop.coreinfo,'NFT',1);
            ser = cmsplot_prop.coreinfo.serial;
            lab = cmsplot_prop.coreinfo.core.serial;
            % TODO: check if .cms never has vhist or crdhist
            vhist=nan(size(burnup));
            crdhist=vhist;
        case '.sum'
            % if there is any dist called exp??
            ser = ReadCore(cmsplot_prop.coreinfo,'FUE.SER');
            lab = ReadCore(cmsplot_prop.coreinfo,'FUE.LAB');
            nfta = ReadCore(cmsplot_prop.coreinfo,'FUE.TYP');
            vhist=nan(size(ser));
            burnup=vhist;
            crdhist = vhist;
        case '.mat'
            matdata = ReadCore(cmsplot_prop.coreinfo,{'ser','lab','nfta','vhist','burnup','crdhist'});
            ser=matdata.ser;
            lab=matdata.lab;
            nfta=matdata.nfta;
            vhist=matdata.vhist;
            burnup=matdata.burnup;
            crdhist=matdata.crdhist;
    end
end

if ischar(ser), ser=cellstr(char(ser));ser=cellstr(ser);end
if ischar(lab), lab=cellstr(char(lab));lab=cellstr(lab);end

eval([clmap,';']);
ncol=size(colormap,1)-2;

if cmin<=0,
  i=find(plmat==-1);
end
plmat=(cmax-cmin)/ncol*(plmat-2)+cmin;
if cmin<=0,
  plmat(i)=zeros(size(i));
end
i=0;
if cmsplot_prop.if2x2 == 2
    prntstr = 'Nfta  Serial   Label   Burnup  Dhist Borhist   Pos.   Channel  Plotvalue 1x1Channel';
    mminj1x1=(mminj(2:2:end)+1)/2;
elseif strcmpi(cmsplot_prop.core.lwr,'PWR'),
    prntstr = 'Nfta  Serial   Label   Burnup  Dhist Borhist   Pos.   Channel  Plotvalue';
else
    prntstr = 'Nfta  Serial   Label   Burnup  Vhist Crdhist   Pos.   Channel  Plotvalue';
end
fprintf('%s',prntstr)
fprintf('\n')
while button==1
[xx,yy,button]=ginput(1);
  if button==1
    i=i+1;
    if i>20,
      fprintf('\n')
      fprintf('%s',prntstr)
      fprintf('\n')
      i=0;
    end
    nx=fix(xx);
    ny=fix(yy);
    co=plmat(ny,nx);
    if abs(co)<epsi/2, co=0;end
    knm0=cpos2knum(ny,nx,mminj);
    if knm0==0
      fprintf('%s%2i%s%2i%s','(',ny,',',nx,') is outside core')
      fprintf('\n')
    else
      [knm rw]=find(knum==knm0);
      knm=knm(1);
      bur=round(mean(burnup(:,knm)));
      vhi=mean(vhist(:,knm));
      crdhi=mean(crdhist(:,knm));
      serl=ser{knm,rw};
      labl=lab{knm,rw};
      if isempty(nfta), nftapri=0; else nftapri=nfta(knm);end
      fprintf('%3i %8s %8s %6i  %6.3f %7.3f %s%2i%s%2i%s%6i%10.4g',nftapri,serl,labl,bur,vhi,crdhi,'  (',ny,',',nx,')',knm0,co);
      if cmsplot_prop.if2x2==2,
          ny2=ceil(ny/2);nx2=ceil(nx/2);
          knm2=cpos2knum(ny2,nx2,mminj1x1);
          fprintf('  %3i',knm2);
      end
      fprintf('\n')
    end
  end
end
disp(sprintf('\n'));

