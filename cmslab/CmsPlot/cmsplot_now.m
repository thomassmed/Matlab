function cmsplot_now(varargin)

if nargin==0,
    hfig=gcf;
else
    hfig=varargin{1};
end
%set(hfig,'pointer','watch');

cmsplot_prop=get(hfig,'userdata');
handles=cmsplot_prop.handles; 
hpl=handles(10,1);
if gca~=hpl, axes(hpl);end
coordinates=cmsplot_prop.coordinates;   % Allows plant specific coordinates to be displayed (FUE.IAX, FUE.JAX)
plottyp=cmsplot_prop.plot_type;         % image is normally used , but you can try to specify something else with set_cmsplot_prop
if isfield(cmsplot_prop,'colormap'),
    clmap=cmsplot_prop.colormap;
else
    clmap='jett';
    cmsplot_prop.colormap=clmap;
end
if2x2 = cmsplot_prop.if2x2;
mminj=cmsplot_prop.mminj;
knum=cmsplot_prop.knum;
sym=cmsplot_prop.core.sym;
label_text=cmsplot_prop.label_text;
curpos_axes = get(hpl,'Position');
curpos_figure = get(hfig,'Position');
dname=cmsplot_prop.dist_name;
option=cmsplot_prop.operator;
cmin=cmsplot_prop.scale_min;
cmax=cmsplot_prop.scale_max;
epsi=1.0d-8*(cmax-cmin);
rescale=cmsplot_prop.rescale;
new_axes=cmsplot_prop.new_axes;
if isfield(cmsplot_prop,'konrod'),
    konrod=cmsplot_prop.konrod;
    konrod_max=cmsplot_prop.konrod_max;
else
    cmsplot_prop.crods='no';
    konrod=[];
    cmsplot_prop.konrod=konrod;
    cmsplot_prop.konrod_max=max(konrod);
end
superc=cmsplot_prop.superc;
crods=cmsplot_prop.crods;
axplot=cmsplot_prop.axplot;         % handle to axplot figure, if empty or figure's been deleted, we'll deal with it
nod=cmsplot_prop.node_plane;
Xpo=cmsplot_prop.xpo;
irmx=cmsplot_prop.irmx;
kan=cmsplot_prop.kan;



    iafull=length(mminj);

% HDF5=strcmp(cmsplot_prop.filetype,'.h5')||strcmp(cmsplot_prop.filetype,'.hdf5');

switch upper(cmsplot_prop.plotsym)
    case 'FULL'
        cmsplot_prop.axis=[1 iafull+1 1 iafull+1];
    case 'E'
        cmsplot_prop.axis=[floor(iafull/2+1) iafull+1 1 iafull+1];
    case 'W'
        cmsplot_prop.axis=[1 ceil(iafull/2+1) 1 iafull+1];
    case 'S'
        cmsplot_prop.axis=[1 iafull+1 floor(iafull/2+1) iafull+1];        
    case 'N'
        cmsplot_prop.axis=[1 iafull+1 1 ceil(iafull/2+1)]; 
    case 'SE'
        cmsplot_prop.axis=[floor(iafull/2+1) iafull+1 floor(iafull/2+1) iafull+1];
    case 'SW'
        cmsplot_prop.axis=[1 ceil(iafull/2+1) floor(iafull/2+1) iafull+1];        
    case 'NW'
        cmsplot_prop.axis=[1 ceil(iafull/2+1) 1 ceil(iafull/2+1)];
    case 'NE'
        cmsplot_prop.axis=[floor(iafull/2+1) iafull+1 1 ceil(iafull/2+1)];
end

alimm=cmsplot_prop.axis;
if ~strcmpi(cmsplot_prop.Envelope,'Env ') &&  strcmpi(cmsplot_prop.filetype,'.res') && cmsplot_prop.coreinfo.fileinfo.Sim == 5 && (strncmpi('MICRO ',cmsplot_prop.dist_name,6) || strncmpi('SUB ',cmsplot_prop.dist_name,4))
    dist=check_dist(cmsplot_prop.data,mminj,knum,sym,5);
    resS5 = 1;
else
    %% this have to be changed for cms, sum etc.
    dist=check_dist(cmsplot_prop.data,mminj,knum,sym);
    resS5 = 0;
end
if isempty(nod),% If no Preference concerning nodplanes have been made, the node-planes will be for the entire distribution
    nod=['1:',num2str(cmsplot_prop.core.kmax)];
    cmsplot_prop.node_plane=nod;
end

d2flag=0;
nod_disp=nod;
if resS5,
    geoms = cmsplot_prop.subgeom;
    nodbel = SubNode2NodePos(geoms,cmsplot_prop.hz,cmsplot_prop.core.kmax);
    evop=['Nod=',nod,';'];
    eval(evop);
    for i = 1:kan
        wansunod = min(Nod) <= nodbel{i} & max(Nod) >= nodbel{i};
        evop=['dis2d(i)=',option,'(dist{i}(wansunod,:));'];
        eval(evop);
        
    end
    dis2d = double(dis2d);
    cmsplot_prop.savdat.plotxvar = geoms;
    
%     wanted_sub_nods =  submeshplot_prop.nod_plane(2) >= subnodbel{i} &  submeshplot_prop.nod_plane(1) <= subnodbel{i};
elseif size(dist,1)>1,
    evop=['Nod=',nod,';'];
    eval(evop);
    if max(Nod)~=size(dist,1),
        Nod=1:size(dist,1);
        nod_disp=['1:',num2str(max(Nod))];
        cmsplot_prop.node_plane=['1:',num2str(size(dist,1))];
    end
    dist=dist(Nod,:);
    if size(dist,1)>1,
        i= option==' ';
        option(i)='';
        evop=['dis2d=',option,'(dist);'];
        eval(evop);
    else
        dis2d=dist;
        d2flag=1;
    end
else
    dis2d=dist;
    nod_disp='2-D';
    d2flag=1;
end

% Make sure filters for deleted windows are reset!
fig_numbers=get(0,'children');
i_remove=[];
for i=1:length(cmsplot_prop.filter.filt_handles)
    i_filt=find(fig_numbers==cmsplot_prop.filter.filt_handles(i), 1);
    if isempty(i_filt)
        i_remove=[i_remove i];
        switch cmsplot_prop.filter.filter_type{i}
            case 'nhyd'
                cmsplot_prop.filter.filt_nhyd=ones(1,kan);
            case 'nfta'
                cmsplot_prop.filter.filt_nfta=ones(1,kan);    
            case 'bat'
                cmsplot_prop.filter.filt_bat=ones(1,kan);   
            case 'crods'
                cmsplot_prop.filter.filt_crods=ones(1,kan);   
        end
        cmsplot_prop.filter.filter_type{i}=[];
    end
end
cmsplot_prop.filter.filt_handles(i_remove)=[];
cmsplot_prop.filter.filter_type=cell_pack(cmsplot_prop.filter.filter_type);
filtvec=cmsplot_prop.filter.filt_nhyd.*cmsplot_prop.filter.filt_nfta.*cmsplot_prop.filter.filt_bat.*cmsplot_prop.filter.filt_matvar.*cmsplot_prop.filter.filt_crods;
dis2d=dis2d.*filtvec;
if strcmpi(rescale,'auto')||strcmpi(rescale,'all')
   iscal=find(filtvec==0);
   if size(dist,2)==length(konrod)
     iscal=[iscal,find(dis2d==0)];
   end
   if strcmpi(rescale,'all'),
       if isempty(cmsplot_prop.dists)
           cmsplot_prop.dists = ReadCore(cmsplot_prop.coreinfo,cmsplot_prop.dist_name,'all');
       end
       [dist_max,dist_min]=find_scale(cmsplot_prop.dists,option);
       dist_max(iscal)=[];
       dist_min(iscal)=[];
       cmax=max(dist_max);cmin=min(dist_min);
   else
       disscal=dis2d;disscal(iscal)=[];
       cmin=min(disscal);
       cmax=max(disscal);
       if isempty(cmin), cmin=0;cmax=1e-6;end
   end
   if cmax==cmin, cmax=1.01*cmax+0.01;end
   epsi=1.0d-4*(cmax-cmin);
   cmax=cmax+epsi;
   cmin=cmin-epsi;
end
core=vec2cor(dis2d,mminj,@NaN);
cmsplot_prop.plotdata=core;
eval(['colormap(',clmap,');']);
ncol=size(colormap,1)-2;
cmin=cmin-epsi;
cmax=cmax+epsi;
if cmin<=0,
  plmat=ncol*core/(cmax-cmin)-ncol*cmin/(cmax-cmin)+2;
  i=find(core==0);
  plmat(i)=-ones(size(i));
else
  plmat=ncol*core/(cmax-cmin)-ncol*cmin/(cmax-cmin)+2;
end
cmsplot_prop.savdat.plotdata = core;
if strcmp(plottyp,'contour')
  sm=length(mminj);
  sc=(sm+1)/sm;
  pllot=[plottyp,'(1:sc:sm+1,sm+1:-sc:1,plmat,5);'];
  eval(pllot);
  axis('ij')
else
  ymstr=sprintf('%f',length(mminj)+.5);
  xy=['([1.5 ',ymstr,'],[1.5 ',ymstr,'],'];
  pllot=['hima=',plottyp,xy,'plmat);'];
  eval(pllot);
  handles(10,2)=hima;
  axes_handle=get(hima,'parent');
end

%% Title text in figure
textarea_left = handles(10,5);
textarea_right = handles(10,6);

distname_string = strrep(dname,'\','/');
distname_string = strrep(distname_string,'_','\_');

distopt_string = '';
if d2flag==0,
    distopt_string = [' - ' option];
end

symmetry_string = cmsplot_prop.core.sym;

nodes_string = ['Node(s) ' nod_disp ', ' symmetry_string];

exposure_string = '';
if ~isempty(Xpo),
    exposure_string = ['Statepoint ' num2str(cmsplot_prop.state_point)...
                       ', XPO: ' sprintf('%5.3f', cmsplot_prop.xpo)];
end

set(textarea_left, 'String', [cmsplot_prop.Envelope distname_string distopt_string]);
set(textarea_right, 'String', {nodes_string; exposure_string});

if isfield(cmsplot_prop,'stab'),
if isfield(cmsplot_prop.stab,'lam'),
    [dr,fd]=p2drfd(cmsplot_prop.stab.lam);
    drstr=sprintf('dr = %6.2f',dr);
    drt=text(cmsplot_prop.axis(1)+.1,cmsplot_prop.axis(3)+.8,drstr);
    set(drt,'FontWeight','bold');
    set(drt,'FontSize',12);
    fdstr=sprintf('fd = %6.2f',fd);
    fdt=text(cmsplot_prop.axis(1)+.1,cmsplot_prop.axis(3)+2.1,fdstr);
    set(fdt,'FontWeight','bold');
    set(fdt,'FontSize',12);
end
end

%% Make changes to colormap
eval(['colormap(',clmap,');']);

%% Draw cell and core boundaries
[psc,pcn]=plotcont(hpl,mminj,irmx,irmx);

pscxp=psc(1:2,:); pscyp=psc(3:4,:);
pcntx=pcn(1:2,:); pcnty=pcn(3:4,:);
hsc=line(pscxp,pscyp,'color','black','erasemode','none','visible',superc);
hcont=line(pcntx,pcnty,'color','black','erasemode','none');

%% Plot detectors
if  isempty(strcmp(cmsplot_prop.detectors,'off')),
    coldet=cmsplot_prop.detectors;   
    if strmatch(cmsplot_prop.detectors','numbers'),
        coldet='black';
        hold on
        nlp=length(cmsplot_prop.idet);
        [ydum,ids]=sort(1000*cmsplot_prop.jdet+cmsplot_prop.idet);
        for i=1:nlp,
            det_nr=cmsplot_prop.ndet(i);
            ttt=text(cmsplot_prop.idet(ids(i)),cmsplot_prop.jdet(ids(i)),sprintf('%2i',det_nr));
            %set(ttt,'color','k');
        end
    end
    hold on;plot(cmsplot_prop.idet,cmsplot_prop.jdet,'o','erasemode','none','color',coldet,'markersize',5);hold off
end

%% Redraw axes

if strcmpi(coordinates,'pltspc')
    ytlab = cellfun(@strtrim,cmsplot_prop.axlabels.assemlabs.lab1,'uniformoutput',0);
    xtlab = cellfun(@strtrim,cmsplot_prop.axlabels.assemlabs.lab2,'uniformoutput',0);
    if if2x2 == 2
        axtick = alimm(1)+1:2:alimm(2)-1;
    else
        axtick = alimm(1)+0.5:1:alimm(2)-0.5;
    end
    set(gca,'xtick',axtick)
    set(gca,'ytick',axtick)
    set(gca,'xticklabel',xtlab);
    set(gca,'yticklabel',ytlab);
    cmsplot_prop.savdat.plotxlab = xtlab;
    cmsplot_prop.savdat.plotylab = ytlab;
elseif strcmpi(coordinates,'pltsc')
    axis(alimm);
    ytlab = cmsplot_prop.axlabels.sclabs.lab1;
    xtlab = cmsplot_prop.axlabels.sclabs.lab2;
    axtick = alimm(1)+1:2:alimm(2)-1;
    set(gca,'xtick',axtick)
    set(gca,'ytick',axtick)
    set(gca,'xticklabel',xtlab);
    set(gca,'yticklabel',ytlab);
    cmsplot_prop.savdat.plotxlab = cmsplot_prop.axlabels.assemlabs.lab2;
    cmsplot_prop.savdat.plotylab = cmsplot_prop.axlabels.assemlabs.lab1;
else
    axis(alimm);
    if cmsplot_prop.if2x2==2&&strcmp(cmsplot_prop.filetype,'.res'),
      ytl=num2str(round((alimm(3)+1)/2):1:round((alimm(4)-1)/2),'%2i');
      xtl=num2str(round((alimm(1)+1)/2):1:round((alimm(2)-1)/2),'%2i');
    else
      ytl=num2str(alimm(3)+1:2:alimm(4)-1,'%2i');
      xtl=num2str(alimm(1)+1:2:alimm(2)-1,'%2i');
    end
    if alimm(1)<10,xtl=[' ' xtl];end
    xtlab=[xtl(1:2:length(xtl)-1)' xtl(2:2:length(xtl))'];
    set(gca,'xticklabel',xtlab);
    set(gca,'xtick',[alimm(1)+1.5:2:alimm(2)-0.5]);
    if alimm(3)<10,ytl=[' ' ytl];end
    ytlab=[ytl(1:2:length(ytl)-1)' ytl(2:2:length(ytl))'];
    set(gca,'yticklabel',ytlab);
    set(gca,'ytick',[alimm(3)+1.5:2:alimm(4)-0.5]);
    cmsplot_prop.savdat.plotxlab = xtlab;
    cmsplot_prop.savdat.plotylab = ytlab;
end
cmsplot_prop.savdat.cordtyp = coordinates;
cmsplot_prop.savdat.rawxlab = knum;
cmsplot_prop.savdat.sym = cmsplot_prop.core.sym;

%% Draw scale
if strcmp(rescale,'yes')||strcmp(rescale,'auto')||strcmpi(rescale,'all')||strcmpi(rescale,'ScaleThenHold')
    dd=(cmax-cmin)/10;
    palv=(cmin-dd:dd:cmax)';
    if strcmpi(class(palv),'single')
        palv = double(palv);
    end
    palv1=palv;
    mp=length(palv);
    palv1(mp-1)=palv(mp-1)-2*epsi;
    hscale=handles(10,3);
    ch=get(hscale,'children');
    delete(ch);
    axes(hscale);
    x=[0 1]';
    hsurc=handles(10,4);
    if ishandle(hsurc)&&hsurc>0,
        delete(hsurc);
    end
    hold off
    hsurc=surface(x,palv1,[palv';palv']',[palv1';palv1']');
    set(gca,'ycolor','black','xtick',[]);
    ytick=(cmin:dd:cmax)';
    md=max(abs(cmin),abs(cmax));
    isca=floor(log10(md));
    set(gca,'ytick',ytick);
    yticklabel=zeros(length(ytick),5);
    ytick=ytick/10^isca;
    for i=1:length(ytick),
        yticklabel(i,:)=sprintf('%5.2f',ytick(i));
    end
    yticklabel=char(yticklabel);
    set(gca,'yticklabel',yticklabel);
    title(sprintf('1e%i',isca),'color','bla');
    handles(10,4)=hsurc;
    cmsplot_prop.handles=handles;
    axis([0 1 cmin cmax])
    cmsplot_prop.scale_max=cmax;
    cmsplot_prop.scale_min=cmin;
    if strcmpi(rescale,'all')||strcmpi(rescale,'ScaleThenHold')
        cmsplot_prop.rescale = 'hold all';
    else
        cmsplot_prop.rescale='no';
    end
    axes(hpl);
end;

%% Draw control rods
hcrtext=[];
if size(cmsplot_prop.data,2)==length(cmsplot_prop.konrod), 
    cmsplot_prop.konrod='no';
    crods='no';
end
if ~strcmp(crods,'no')
  ik=find(konrod<konrod_max);
  crpos=crnum2crpos(ik,mminj,irmx);
  ll=length(ik);
  if ll>0
    i_space=floor(log10(max(konrod(ik))))+1;
    if isinf(i_space), i_space=2;end
    FORMAT=['%',num2str(i_space),'i'];
    ktext=zeros(ll,i_space);
    my=2*crpos(:,1);
    mx=2*crpos(:,2);
    %mx = mx-0.25-0.25*(i_space-2);%mx=2*crpos(:,2)-0.25*(i_space-2);
    my=my+length(mminj)/2-irmx;
    mx=mx+length(mminj)/2-irmx;
    for i=1:ll,
      ktext(i,:)=sprintf(FORMAT,round(konrod(ik(i))));
    end
    ktext=char(ktext);
    switch cmsplot_prop.plotsym
        case 'E'
            mx=mx+(mx>iafull/2&mx<iafull/2+1)*.5;
        case 'SE'
            mx=mx+(mx>iafull/2&mx<iafull/2+1)*.5;
            %my=my+0.5*(my==(iafull/2+1));
    end
    hcrtext = text(mx, my, ktext,...
                'Color', crods,...
                'FontSize', 12,...
                'FontWeight', 'bold',...
                'HorizontalAlignment', 'center');
  end
end

%% Add data labels
if ~strcmpi('no',cmsplot_prop.datalabels)
    bundle_width_px = (curpos_figure(3)*curpos_axes(3)) / (alimm(2) - alimm(1)); 
    if ~max(strcmpi(cmsplot_prop.datalabels,{'VALUE','KNUM2X2'})) && if2x2 == 2
        height = size(core, 1)/2;
        width = size(core, 2)/2;
        spn = 2;
        hmax = size(core, 1);
        wmax = size(core, 2);
        xshift = 1;
        yshift = 1;
        fntsz = bundle_width_px/2;
    else
        height = size(core, 1);
        width = size(core, 2);
        spn=1;
        hmax = size(core, 1);
        wmax = size(core, 2);
        xshift = 0.5;
        yshift = 0.5;
        fntsz = bundle_width_px/4;
    end

    xlocs = ones(height, width);
    ylocs = ones(height, width);
    
    xspan = (1:spn:wmax);
    yspan = (1:spn:hmax);
    yspan2 = yspan';

    for i=1:width
        xlocs(i,:) = xlocs(i,:).*xspan;
    end
    for j=1:height
        ylocs(:,j) = ylocs(:,j).*yspan2;
    end

    xlocs = xlocs+xshift;
    ylocs = ylocs+yshift;

    % trim for current axis
    %             visible_xlocs = [alimm(3) alimm(4)-1];
    %             visible_ylocs = [alimm(1) alimm(2)-1];

       
    switch (cmsplot_prop.datalabels)
        case 'value'
%             bundle_height_px = (curpos_figure(4)*curpos_axes(4)) / (alimm(4) - alimm(3));
            if floor(log10(min(core(:)))) +1 < -3
                coredat = 10^(-(floor(log10(min(core(:))~=0))+1))*core;
            else
                coredat = core;
            end
            format = set_format(dis2d);
            
    %         for j = visible_ylocs(1):visible_ylocs(2)
    %             for i = visible_xlocs(1):visible_xlocs(2)
    %                 if (label_text(j,i) ~= 0)
    %                     set(label_text(j,i), 'Visible', 'on');
    %                 end
    %             end
    %         end
        case 'nft'
            lab=GetDistName(cmsplot_prop.coreinfo,'NFT');
            nfta = ReadCore(cmsplot_prop.coreinfo,lab,1);
            if if2x2 == 2
                coredat = vec2cor(nfta,cmsplot_prop.core.mminj2x2);
            else
                coredat = vec2cor(nfta,mminj);
            end
            format = '%u';
            
        case 'label'
            if strcmp('res',cmsplot_prop.coreinfo.fileinfo.type)
                asmnam = ReadCore(cmsplot_prop.coreinfo,'ASMNAM');
                nfta = ReadCore(cmsplot_prop.coreinfo,'nfta');
                corevec = asmnam(nfta,:);
            else
                lab = 'NFT'; % TODO: check what this is called in other files
            end
            knumvec = 1:cmsplot_prop.core.kan;
            if if2x2 == 2
                coredat = vec2cor(knumvec,cmsplot_prop.core.mminj);
            else
                coredat = vec2cor(knumvec,mminj);
            end
            format = '%s';
            for j = 1:size(coredat,1)
                for i = 1:size(coredat,2)
                    if ~isnan(coredat(j,i))
                        label_text(j,i) = text(xlocs(j,i), ylocs(j,i), sprintf(format, strtrim(corevec(knumvec == coredat(j,i),:))),...
                            'Visible', 'on',...
                            'HorizontalAlignment', 'center',...
                            'FontUnits', 'pixels',...
                            'FontSize', bundle_width_px/4);
                    end
                end
            end
            
        case 'ibat'
            if strcmp('res',cmsplot_prop.coreinfo.fileinfo.type)
                lab = 'IBAT';
            else
                lab = 'BAT';
            end
            ibat = ReadCore(cmsplot_prop.coreinfo,lab,cmsplot_prop.state_point);
            if ~strcmpi('FULL',cmsplot_prop.core.sym)
               ibat = sym_full(ibat',knum);
            end
            if if2x2 == 2
                coredat = vec2cor(ibat,cmsplot_prop.core.mminj);
            else
                coredat = vec2cor(ibat,mminj);
            end
            format = '%u';
            
        case 'knum'
            channum = 1:cmsplot_prop.core.kan;
            if if2x2 == 2
                coredat = vec2cor(channum,cmsplot_prop.core.mminj);
            else
                coredat = vec2cor(channum,mminj);
            end
            format = '%u';
        case 'knum2x2'
            channum = 1:cmsplot_prop.core.kan*4;
            coredat = vec2cor(channum,mminj);
            format = '%u';
 
            
        case 'nhyd'
        	if strcmp('res',cmsplot_prop.coreinfo.fileinfo.type)
                lab = 'NHYD';
            else
                lab = 'NHYD'; % TODO: check what this is called in other files
            end
            nhyd = ReadCore(cmsplot_prop.coreinfo,lab,cmsplot_prop.state_point);
            if if2x2 == 2
                coredat = vec2cor(nhyd,cmsplot_prop.core.mminj);
            else
                coredat = vec2cor(nhyd,mminj);
            end
            format = '%u';

        otherwise
    end
    if ~strcmpi(cmsplot_prop.datalabels,'label')
        for j = 1:size(coredat,1)
            for i = 1:size(coredat,2)
                if ~isnan(coredat(j,i))
                    label_text(j,i) = text(xlocs(j,i), ylocs(j,i), sprintf(format, coredat(j,i)),...
                        'Visible', 'on',...
                        'HorizontalAlignment', 'center',...
                        'FontUnits', 'pixels',...
                        'FontSize', fntsz);
                end
            end
        end
    end
end
cmsplot_prop.label_text = label_text;

%% Title
switch cmsplot_prop.filetype
    case '.res'
        titel=cmsplot_prop.titcas;
    case '.mat'
        titel=cmsplot_prop.titmat; %
    case '.out'
        titel=cmsplot_prop.filename;
    case '.hms'
        titel=cmsplot_prop.filename;
    case {'.h5','.hdf5'}
        titel=cmsplot_prop.dist_path;   
    otherwise
        titel=cmsplot_prop.filename;
end

titel=strrep(titel,'\','/');
%ht=title(titel);

%% Axial plotting
%Do we need to create a new axplot or update a current?
if ~isempty(axplot),                % Then we need to do something
     children=get(0,'children');    % Check if figure already exists
     explot_prop.coreinfo = cmsplot_prop.coreinfo;
     if strcmp(axplot,'new'),
        newpos=curpos_figure;newpos(3)=newpos(3)*.7;
        newpos(1)=max(curpos_figure(1)-newpos(3)+20,0);
        cmsplot_prop.axplot=figure('pos',newpos, 'CloseRequestFcn', {@closeAxialPlotWindow, hfig});
        set(cmsplot_prop.axplot,'menubar','none');
        uimenu('label','Export Data','callback','SavedataGUI(0);');
        nodes=eval(nod);            % nod is a string, but nodes is a vector of active nodes
        i_filt= cmsplot_prop.filter.filt_nhyd.*cmsplot_prop.filter.filt_nfta.*cmsplot_prop.filter.filt_bat.*cmsplot_prop.filter.filt_matvar;
        if resS5
            nfta = ReadRes(cmsplot_prop.coreinfo,'nfta',cmsplot_prop.state_point);
            if cmsplot_prop.if2x2 == 2
                nfta = fill2x2(nfta,cmsplot_prop.core.mminj,cmsplot_prop.core.knum,'full','vec');
            end
            kmax = cmsplot_prop.core.kmax;
            hz = cmsplot_prop.hz;
            axmean = zeros(kmax,kan);
            if strcmpi(sym,'FULL')
                uninfta = unique(nfta);
                for i = 1:length(uninfta)
                    nftal = uninfta(i) == nfta;
                    geomtemp = cell2mat(geoms(nftal));
                    nodbeltemp = nodbel(nftal);
                    disttemp = cell2mat(dist(nftal));
                    for j = 1:kmax
                        nodbell = nodbeltemp{1} == j;
                        if nnz(nodbell) > 1
                            axmean(j,nftal) = sum(disttemp(nodbell,:).*geomtemp(nodbell,:))/hz;
                        else
                            axmean(j,nftal) = disttemp(nodbell,:);
                        end
                    end
                end
            else
                for i = 1:kan
                    geomtemp = geoms{i};
                    disttemp = dist{i};
                    for j = 1:kmax
                        nodbell = nodbel{i} == j;
                        if nnz(nodbell) > 1
                            axmean(j,i) = sum(disttemp(nodbell,:).*geomtemp(nodbell,:))/hz;
                        else
                            axmean(j,i) = disttemp(nodbell,:);
                        end
                    end
                end
            end
            plot(mean(axmean(:,find(i_filt)),2),nodes);
            explot_prop.savdat.plotdata =  mean(axmean(:,find(i_filt)),2);
        else
            plot(mean(dist(:,find(i_filt)),2),nodes);
            explot_prop.savdat.plotdata =mean(dist(:,find(i_filt)),2);
        end
        
        grid;
        title(['Axial average for ',distname_string]);
     else
        if min(size(dist))==1 && ~resS5
            clf(axplot);
            uiwait(msgbox('No update of axplot. Not meaningful for 2D-distribution'));
        else
            figure(axplot);             % Make sure the plot goes to the right window
            nodes=eval(nod);            % nod is a string, but nodes is a vector of active nodes
            i_filt= cmsplot_prop.filter.filt_nhyd.*cmsplot_prop.filter.filt_nfta.*cmsplot_prop.filter.filt_bat.*cmsplot_prop.filter.filt_matvar;
            if resS5
                nfta = ReadRes(cmsplot_prop.coreinfo,'nfta',cmsplot_prop.state_point);
                if cmsplot_prop.if2x2 == 2
                    nfta = fill2x2(nfta,cmsplot_prop.core.mminj,cmsplot_prop.core.knum,'full','vec');
                end
                uninfta = unique(nfta);
                kmax = cmsplot_prop.core.kmax;
                hz = cmsplot_prop.hz;
                for i = 1:length(uninfta)
                    nftal = uninfta(i) == nfta;
                    geomtemp = cell2mat(geoms(nftal));
                    nodbeltemp = nodbel(nftal);
                    disttemp = cell2mat(dist(nftal));
                    for j = 1:kmax
                        nodbell = nodbeltemp{1} == j;
                        if nnz(nodbell) > 1
                            axmean(j,nftal) = sum(disttemp(nodbell,:).*geomtemp(nodbell,:))/hz;
                        else
                            axmean(j,nftal) = disttemp(nodbell,:);
                        end
                    end
                end
                   plot(mean(axmean(:,find(i_filt)),2),nodes);
                   explot_prop.savdat.plotdata =  mean(axmean(:,find(i_filt)),2);
            else
                plot(mean(dist(:,find(i_filt)),2),nodes);
                explot_prop.savdat.plotdata =  mean(dist(:,find(i_filt)),2);
                
            end
            grid;
            title(['Axial average for ',distname_string]);
        end
     end
     set(cmsplot_prop.axplot,'userdata',explot_prop);
     figure(hfig);
end

%% Set data before exiting
cmsplot_prop.hcrtext=hcrtext;
cmsplot_prop.handles=handles;
%cmsplot_prop.htitle=ht;
cmsplot_prop.hsc=hsc;
cmsplot_prop.hcont=hcont;
set(hfig,'Userdata',cmsplot_prop);
set(hfig,'pointer','arrow');

%figure(hfig); 
%set(axes_handle,'HandleVisibility','callback');
end

function closeAxialPlotWindow(src, EventData, hfig)
    if ishandle(hfig) % if cmsplot window has somehow been closed, this is needed to close axplot windows
        cmsplot_prop=get(hfig,'userdata');
        cmsplot_prop.axplot=[];
        set(hfig,'userdata',cmsplot_prop);
    end
    delete(src);
end