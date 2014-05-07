function CmsCore(varargin)
%
if (nargin < 1)
    return;
elseif (nargin==1)
    filename=file('normalize',varargin{1});
    ext=file('extension',filename);
    switch ext
        case '.res'
            fileinfo=ReadRes(filename);
        case '.sum'
            fileinfo=ReadSum(filename);
        case '.mat'
            fileinfo=ReadMat(filename);
        case '.cms'
            fileinfo=ReadCms(filename);
    end
    
    
    
    cmsfile = strrep(filename, '.res', '.cms');
    
    if(exist(cmsfile,'file') == 2)
        cmsinfo=ReadCms(cmsfile);
    end
    
    fileinfo.flp=cmsinfo.flp;
    fileinfo.fla=cmsinfo.fla;
    fileinfo.apl=cmsinfo.apl;
    fileinfo.lhg=cmsinfo.lhg;
    fileinfo.voi=cmsinfo.voi;
    fileinfo.rpf=cmsinfo.rpf;
    fileinfo.konrod=cmsinfo.konrod;
    fileinfo.corekonrod=cmsinfo.corekonrod;
    fileinfo.EXP3D=cmsinfo.exp;
    
    fileinfo.rand=vec2cor(cmsinfo.NodeData{1},fileinfo.mminj);
    
    
    
    fileinfo.fue_new.xenon=zeros(fileinfo.fue_new.kmax,fileinfo.fue_new.kan);
    fileinfo.fue_new.iodine=zeros(fileinfo.fue_new.kmax,fileinfo.fue_new.kan);
    fileinfo.fue_new.promethium=zeros(fileinfo.fue_new.kmax,fileinfo.fue_new.kan);
    fileinfo.fue_new.samarium=zeros(fileinfo.fue_new.kmax,fileinfo.fue_new.kan);
    fileinfo.fue_new.vhist=zeros(fileinfo.fue_new.kmax,fileinfo.fue_new.kan);
    fileinfo.fue_new.crdhist=zeros(fileinfo.fue_new.kmax,fileinfo.fue_new.kan);
    fileinfo.fue_new.tfuhist=zeros(fileinfo.fue_new.kmax,fileinfo.fue_new.kan);
    fileinfo.fue_new.konrod=fileinfo.fue_new.crdsteps*ones(1,max(size(fileinfo.fue_new.konrod)));
    
    fileinfo.fue_new.burnup=30*ones(fileinfo.fue_new.kmax,fileinfo.fue_new.kan);
    [d1,d2,sigr,siga1,siga2,usig1,usig2,kap_ny,V2D,X2D,Y2D,V3D,X3D,Y3D,Z3D,X,Y,XS,XSEC_DX2]=xs_cms(fileinfo.fue_new,'kkm/hot-j20200-C4E.lib',.5*ones(fileinfo.fue_new.kmax,fileinfo.fue_new.kan),900*ones(fileinfo.fue_new.kmax,fileinfo.fue_new.kan));
    kinf30=(usig1+sigr./siga2.*usig2)./(siga1+sigr);
    
    fileinfo.fue_new.burnup=60*ones(fileinfo.fue_new.kmax,fileinfo.fue_new.kan);
    [d1,d2,sigr,siga1,siga2,usig1,usig2,kap_ny]=xs_cms(fileinfo.fue_new,.5*ones(25,240),900*ones(fileinfo.fue_new.kmax,fileinfo.fue_new.kan),V2D,X2D,Y2D,V3D,X3D,Y3D,Z3D,X,Y,XS,XSEC_DX2);
    kinf60=(usig1+sigr./siga2.*usig2)./(siga1+sigr);
    
    c=(kinf30.*2-kinf60);
    k=(kinf30-c)./30;
    
    for i=1:length(fileinfo.xpo)
        fileinfo.kinf(:,:,i) = (fileinfo.EXP3D(:,:,i)).*k+c;
    end
    
end

vec=randvec(fileinfo.mminj);
fileinfo.zones=vec2cor(vec,fileinfo.mminj);

crvec=crrandvec(fileinfo.crmminj);
% fileinfo.crzones=vec2cor(crvec,fileinfo.crmminj);
% 
% fileinfo.konrod(:,:,1)=crvec;


fileinfo.crdzon=cr2core(crvec,fileinfo.mminj,fileinfo.crmminj);



for i=1:fileinfo.tot_kan
    s=bundle(i,fileinfo,1);
    temp.s(i)=s;
end

for i=1:max(size(fileinfo.konrod))
    sc=crd(i,fileinfo);
    temp.sc(i)=sc;
end

core=reactor(temp);


core.kmax=fileinfo.kmax;
core.xpo=fileinfo.xpo;
core.crdsteps=fileinfo.crdsteps;
core.iafull=fileinfo.iafull;
core.tot_kan=fileinfo.tot_kan;
core.irmx=fileinfo.irmx;
core.tot_crd=fileinfo.tot_crd;
core.crdsteps=fileinfo.crdsteps;
core.mminj=fileinfo.mminj;
CmsCoreProp.core=core;


poolinfo.mminj=ones(20,1);
poolinfo.ij=zeros(400,2);
for k=1:400
    poolinfo.ij(k,:)=knum2cpos(k,poolinfo.mminj);
end
poolinfo.xpo=fileinfo.xpo;
poolinfo.kmax=fileinfo.kmax;
temp=[];
for i=1:400
    s=bundle(i,poolinfo,0);
    temp.s(i)=s;
end


pool=storage(temp);
pool.mminj=poolinfo.mminj;
pool.tot_kan=400;
pool.xpo=fileinfo.xpo;
CmsCoreProp.pool=pool;


CmsCoreProp.button = 2;

global cn;
cn=1;
% CmsCoreProp.cn = 1;


core.calc_core_mean('power');
global knum;
knum=1;

%%
scrsz = get(0,'ScreenSize');
CmsCoreProp.scrsz=scrsz;
dM=scrsz(3)*0.3;
sidy=scrsz(4)/1.5;
sidx=1.3*sidy;
hfig = figure('Position',[scrsz(3)-1.4*dM-sidx sidy-dM sidx sidy]);
set(hfig,'Name','CMSCore');
set(hfig,'color',[0.99 0.99 0.99]);
set(hfig,'menubar', 'none');
set(hfig,'numbertitle', 'off');
CmsCoreProp.clmap = colormap(jett_core);
% CmsCoreProp.clmap_reverse = colormap(jett_reverse);
set(hfig,'userdata',CmsCoreProp);
%% Fix the main drawing
CmsCoreProp.handles.coremap=axes('position',[0.03 0.07 0.88/1.3 0.88]);
set(hfig,'userdata',CmsCoreProp);
% paint_core([],[],hfig);
%%   POW Pushbutton 1
CmsCoreProp.handles.pow_button=uicontrol (hfig, 'style', 'pushbutton', 'string', 'POW', 'FontWeight','bold', ...
    'units','Normalized','position', [0.80 0.95 .047 .03], 'callback',{@paint_core,hfig});
set(CmsCoreProp.handles.pow_button,'BackgroundColor', [0.97,0.97,0.97]);
set(CmsCoreProp.handles.pow_button, 'FontSize', 11);
set(CmsCoreProp.handles.pow_button, 'FontUnits', 'normalized');
set(hfig,'userdata',CmsCoreProp);
%%   BUR Pushbutton 2
CmsCoreProp.handles.pow_button=uicontrol (hfig, 'style', 'pushbutton', 'string', 'BUR', 'FontWeight','bold', ...
    'units','Normalized','position', [0.85 0.95 .047 .03], 'callback',{@paint_core,hfig});
set(CmsCoreProp.handles.pow_button,'BackgroundColor', [0.97,0.97,0.97]);
set(CmsCoreProp.handles.pow_button, 'FontSize', 11);
set(CmsCoreProp.handles.pow_button, 'FontUnits', 'normalized');
set(hfig,'userdata',CmsCoreProp);
%%   EVOI Pushbutton 3
CmsCoreProp.handles.pow_button=uicontrol (hfig, 'style', 'pushbutton', 'string', 'EVOI', 'FontWeight','bold', ...
    'units','Normalized','position', [0.90 0.95 .047 .03], 'callback',{@paint_core,hfig});
set(CmsCoreProp.handles.pow_button,'BackgroundColor', [0.97,0.97,0.97]);
set(CmsCoreProp.handles.pow_button, 'FontSize', 11);
set(CmsCoreProp.handles.pow_button, 'FontUnits', 'normalized');
set(hfig,'userdata',CmsCoreProp);
%%   VOID Pushbutton 4
CmsCoreProp.handles.pow_button=uicontrol (hfig, 'style', 'pushbutton', 'string', 'VOID', 'FontWeight','bold', ...
    'units','Normalized','position', [0.95 0.95 .047 .03], 'callback',{@paint_core,hfig});
set(CmsCoreProp.handles.pow_button,'BackgroundColor', [0.97,0.97,0.97]);
set(CmsCoreProp.handles.pow_button, 'FontSize', 11);
set(CmsCoreProp.handles.pow_button, 'FontUnits', 'normalized');
set(hfig,'userdata',CmsCoreProp);
%%   KINF Pushbutton 5
CmsCoreProp.handles.pow_button=uicontrol (hfig, 'style', 'pushbutton', 'string', 'KINF', 'FontWeight','bold', ...
    'units','Normalized','position', [0.80 0.91 .047 .03], 'callback',{@paint_core,hfig});
set(CmsCoreProp.handles.pow_button,'BackgroundColor', [0.97,0.97,0.97]);
set(CmsCoreProp.handles.pow_button, 'FontSize', 11);
set(CmsCoreProp.handles.pow_button, 'FontUnits', 'normalized');
set(hfig,'userdata',CmsCoreProp);
%%   LHG Pushbutton 6
CmsCoreProp.handles.pow_button=uicontrol (hfig, 'style', 'pushbutton', 'string', 'LHG', 'FontWeight','bold', ...
    'units','Normalized','position', [0.85 0.91 .047 .03], 'callback',{@paint_core,hfig});
set(CmsCoreProp.handles.pow_button,'BackgroundColor', [0.97,0.97,0.97]);
set(CmsCoreProp.handles.pow_button, 'FontSize', 11);
set(CmsCoreProp.handles.pow_button, 'FontUnits', 'normalized');
set(hfig,'userdata',CmsCoreProp);
%%   FLP Pushbutton 7
CmsCoreProp.handles.pow_button=uicontrol (hfig, 'style', 'pushbutton', 'string', 'FLP', 'FontWeight','bold', ...
    'units','Normalized','position', [0.90 0.91 .047 .03], 'callback',{@paint_core,hfig});
set(CmsCoreProp.handles.pow_button,'BackgroundColor', [0.97,0.97,0.97]);
set(CmsCoreProp.handles.pow_button, 'FontSize', 11);
set(CmsCoreProp.handles.pow_button, 'FontUnits', 'normalized');
set(hfig,'userdata',CmsCoreProp);
%%   APL Pushbutton 8
CmsCoreProp.handles.pow_button=uicontrol (hfig, 'style', 'pushbutton', 'string', 'APL', 'FontWeight','bold', ...
    'units','Normalized','position', [0.95 0.91 .047 .03], 'callback',{@paint_core,hfig});
set(CmsCoreProp.handles.pow_button,'BackgroundColor', [0.97,0.97,0.97]);
set(CmsCoreProp.handles.pow_button, 'FontSize', 11);
set(CmsCoreProp.handles.pow_button, 'FontUnits', 'normalized');
set(hfig,'userdata',CmsCoreProp);
%%   FLA Pushbutton 9
CmsCoreProp.handles.pow_button=uicontrol (hfig, 'style', 'pushbutton', 'string', 'FLA', 'FontWeight','bold', ...
    'units','Normalized','position', [0.80 0.87 .047 .03], 'callback',{@paint_core,hfig});
set(CmsCoreProp.handles.pow_button,'BackgroundColor', [0.97,0.97,0.97]);
set(CmsCoreProp.handles.pow_button, 'FontSize', 11);
set(CmsCoreProp.handles.pow_button, 'FontUnits', 'normalized');
set(hfig,'userdata',CmsCoreProp);
%%   SER Pushbutton 10
CmsCoreProp.handles.pow_button=uicontrol (hfig, 'style', 'pushbutton', 'string', 'SER', 'FontWeight','bold', ...
    'units','Normalized','position', [0.85 0.87 .047 .03], 'callback',{@paint_core,hfig});
set(CmsCoreProp.handles.pow_button,'BackgroundColor', [0.97,0.97,0.97]);
set(CmsCoreProp.handles.pow_button, 'FontSize', 11);
set(CmsCoreProp.handles.pow_button, 'FontUnits', 'normalized');
set(hfig,'userdata',CmsCoreProp);
%%   CPR Pushbutton 11
CmsCoreProp.handles.pow_button=uicontrol (hfig, 'style', 'pushbutton', 'string', 'CPR', 'FontWeight','bold', ...
    'units','Normalized','position', [0.90 0.87 .047 .03], 'callback',{@paint_core,hfig});
set(CmsCoreProp.handles.pow_button,'BackgroundColor', [0.97,0.97,0.97]);
set(CmsCoreProp.handles.pow_button, 'FontSize', 11);
set(CmsCoreProp.handles.pow_button, 'FontUnits', 'normalized');
set(hfig,'userdata',CmsCoreProp);
%%   ZON Pushbutton 12
CmsCoreProp.handles.pow_button=uicontrol (hfig, 'style', 'pushbutton', 'string', 'ZON', 'FontWeight','bold', ...
    'units','Normalized','position', [0.95 0.87 .047 .03], 'callback',{@paint_core,hfig});
set(CmsCoreProp.handles.pow_button,'BackgroundColor', [0.97,0.97,0.97]);
set(CmsCoreProp.handles.pow_button, 'FontSize', 11);
set(CmsCoreProp.handles.pow_button, 'FontUnits', 'normalized');
set(hfig,'userdata',CmsCoreProp);
%% Radial option
CmsCoreProp.handles.bgh = uibuttongroup('Parent',hfig, 'units','Normalized','position',[0.715 0.01 0.14 0.08],...
    'BackgroundColor',[1, 1 ,1],'BorderType','none','SelectionChangeFcn',{@radial_option,hfig});
CmsCoreProp.handles.max = uicontrol('Style','Radio','String',' Max',...
    'units','Normalized',  'position',[0.00 0.00 0.50 0.50],'parent',CmsCoreProp.handles.bgh,'HandleVisibility','off',...
    'BackgroundColor',[1, 1 ,1],'FontWeight', 'bold', 'FontSize', 11);
CmsCoreProp.handles.min = uicontrol('Style','Radio','String',' Min',...
    'units','Normalized',  'position',[0.00 0.50 0.50 0.50],'parent',CmsCoreProp.handles.bgh,'HandleVisibility','off',...
    'BackgroundColor',[1, 1 ,1],'FontWeight', 'bold', 'FontSize', 11);
CmsCoreProp.handles.mean = uicontrol('Style','Radio','String',' Mean',...
    'units','Normalized',  'position',[0.50 0.00 0.50 0.50],'parent',CmsCoreProp.handles.bgh,'HandleVisibility','off',...
    'BackgroundColor',[1, 1 ,1],'FontWeight', 'bold', 'FontSize', 11);
CmsCoreProp.handles.axial = uicontrol('Style','Radio','String',' Axial',...
    'units','Normalized',  'position',[0.50 0.50 0.50 0.50],'parent',CmsCoreProp.handles.bgh,'HandleVisibility','off',...
    'BackgroundColor',[1, 1 ,1],'FontWeight', 'bold', 'FontSize', 11);

set(CmsCoreProp.handles.mean,'value',1);
set(hfig,'userdata',CmsCoreProp);
%%  Axial node textbox
cc=sprintf('Ax node %d',1);
CmsCoreProp.handles.axial_node_textbox = annotation(hfig,'textbox',[.71 .095 .09 .03], ...
    'string',cc,'fontweight','bold','LineStyle','none', 'FontSize', 11);
set(CmsCoreProp.handles.axial_node_textbox,'BackgroundColor', [0.97,0.97,0.97]);
set(hfig,'userdata',CmsCoreProp);
%%  Axial node Slider
CmsCoreProp.handles_axial_node_slider = uicontrol(hfig,'Style','slider','Max',CmsCoreProp.core.kmax,'Min',1,'Value',1, ...
    'units','Normalized', 'Position',[.805 .10 .05 .02], 'SliderStep', [1/CmsCoreProp.core.kmax 1/CmsCoreProp.core.kmax], ...
    'Callback', {@axial_node_slider,hfig});
set(CmsCoreProp.handles_axial_node_slider,'BackgroundColor', [0.97,0.97,0.97]);
set(CmsCoreProp.handles_axial_node_slider,'value',1);
%%   Axial plot Pushbutton
CmsCoreProp.handles.axial_plot_button=uicontrol (hfig, 'style', 'pushbutton', 'string', 'Axial plot', 'FontWeight','bold', ...
    'units','Normalized','position', [0.72 0.13 .08 .03], 'callback',{@paint_axial_dist,hfig});
set(CmsCoreProp.handles.axial_plot_button,'BackgroundColor', [0.97,0.97,0.97]);
set(CmsCoreProp.handles.axial_plot_button, 'FontSize', 11);
set(CmsCoreProp.handles.axial_plot_button, 'FontUnits', 'normalized');
set(hfig,'userdata',CmsCoreProp);
%%   Exchange Pushbutton
CmsCoreProp.handles.exchange_button=uicontrol (hfig, 'style', 'pushbutton', 'string', 'Exchange', 'FontWeight','bold', ...
    'units','Normalized','position', [0.72 0.26 .08 .03], 'callback',{@exchange,hfig});
set(CmsCoreProp.handles.exchange_button,'BackgroundColor', [0.97,0.97,0.97]);
set(CmsCoreProp.handles.exchange_button, 'FontSize', 11);
set(CmsCoreProp.handles.exchange_button, 'FontUnits', 'normalized');
set(hfig,'userdata',CmsCoreProp);
%%   Move Pushbutton
CmsCoreProp.handles.move_button=uicontrol (hfig, 'style', 'pushbutton', 'string', 'Move', 'FontWeight','bold', ...
    'units','Normalized','position', [0.72 0.22 .08 .03], 'callback',{@move,hfig});
set(CmsCoreProp.handles.move_button,'BackgroundColor', [0.97,0.97,0.97]);
set(CmsCoreProp.handles.move_button, 'FontSize', 11);
set(CmsCoreProp.handles.move_button, 'FontUnits', 'normalized');
set(hfig,'userdata',CmsCoreProp);
%%   Unload Pushbutton
CmsCoreProp.handles.move_button=uicontrol (hfig, 'style', 'pushbutton', 'string', 'Unload', 'FontWeight','bold', ...
    'units','Normalized','position', [0.72 0.18 .08 .03], 'callback',{@unload,hfig});
set(CmsCoreProp.handles.move_button,'BackgroundColor', [0.97,0.97,0.97]);
set(CmsCoreProp.handles.move_button, 'FontSize', 11);
set(CmsCoreProp.handles.move_button, 'FontUnits', 'normalized');
set(hfig,'userdata',CmsCoreProp);
%%   Pool Pushbutton
CmsCoreProp.handles.pool_button=uicontrol (hfig, 'style', 'pushbutton', 'string', 'Pool', 'FontWeight','bold', ...
    'units','Normalized','position', [0.72 0.30 .08 .03], 'callback',{@paint_pool,hfig});
set(CmsCoreProp.handles.pool_button,'BackgroundColor', [0.97,0.97,0.97]);
set(CmsCoreProp.handles.pool_button, 'FontSize', 11);
set(CmsCoreProp.handles.pool_button, 'FontUnits', 'normalized');
set(hfig,'userdata',CmsCoreProp);
%%   Bur listbox
CmsCoreProp.burVal=NaN(CmsCoreProp.core.tot_kan,1);
% NamesSel=cell(CmsCoreProp.tot_kan,1);
for k=1:CmsCoreProp.core.tot_kan
    CmsCoreProp.burVal(k)=mean(CmsCoreProp.core.s(k).burnup(:,:,1));
    CmsCoreProp.burSel{k}=round(1000*CmsCoreProp.burVal(k))/1000;
end
% [~,isort]=sort(SelVal,'descend');
[~,isort]=sort(CmsCoreProp.burVal,'ascend');
NamesSel=CmsCoreProp.burSel(isort);
CmsCoreProp.isort=isort;

CmsCoreProp.handles.bur_listbox=uicontrol (hfig, 'style', 'listbox', 'Min',0,'Max',CmsCoreProp.core.tot_kan,'string',NamesSel, ...
    'units','Normalized','position', [0.93 0.07 .07 .70], 'FontSize', 10, 'callback', {@bur_listbox_callback,hfig});
set(CmsCoreProp.handles.bur_listbox,'FontWeight', 'bold');
set(CmsCoreProp.handles.bur_listbox,'BackgroundColor', [1,1,0.8]);
set(hfig,'userdata',CmsCoreProp);
%%   Data listbox
% SelVal=NaN(CmsCoreProp.tot_kan,1);
for k=1:CmsCoreProp.core.tot_kan
    CmsCoreProp.SelVal(k)=mean(CmsCoreProp.core.s(k).power(:,:,1));
    CmsCoreProp.NamesSel{k}=round(1000*CmsCoreProp.SelVal(k))/1000;
end
NamesSel=CmsCoreProp.NamesSel(CmsCoreProp.isort);
CmsCoreProp.handles.data_listbox=uicontrol (hfig, 'style', 'listbox', 'Min',0,'Max',CmsCoreProp.core.tot_kan,'string',NamesSel, ...
    'units','Normalized','position', [0.86 0.07 .07 .70], 'FontSize', 10, 'callback', {@data_listbox_callback,hfig});
set(CmsCoreProp.handles.data_listbox,'FontWeight', 'bold');
set(CmsCoreProp.handles.data_listbox,'BackgroundColor', [1,1,0.8]);
set(hfig,'userdata',CmsCoreProp);
%%  BUR textbox
% ce=sprintf('BUR');
CmsCoreProp.handles.bur = annotation(hfig,'textbox',[.93 .77 .15 .04], ...
    'string','BUR','fontweight','bold','LineStyle','none');
set(CmsCoreProp.handles.bur, 'FontSize', 10);
set(CmsCoreProp.handles.bur, 'FontUnits', 'normalized');
set(hfig,'userdata',CmsCoreProp);
%%  Select textbox
CmsCoreProp.handles.sel = annotation(hfig,'textbox',[.86 .77 .15 .04], ...
    'string','POW','fontweight','bold','LineStyle','none');
set(CmsCoreProp.handles.sel, 'FontSize', 10);
set(CmsCoreProp.handles.sel, 'FontUnits', 'normalized');
set(hfig,'userdata',CmsCoreProp);
%%  Case number textbox
cc=sprintf('Case Number %d',1);
CmsCoreProp.handles.cn_textbox = annotation(hfig,'textbox',[.86 .04 .12 .025], ...
    'string',cc,'fontweight','bold','LineStyle','none');
set(CmsCoreProp.handles.cn_textbox,'BackgroundColor', [0.97,0.97,0.97]);
set(hfig,'userdata',CmsCoreProp);
%%  Case number Slider
cnmax=length(CmsCoreProp.core.xpo);
CmsCoreProp.handles_cn_slider = uicontrol(hfig,'Style','slider','Max',100,'Min',1,'Value',1, ...
    'units','Normalized', 'Position',[.86 .01 .10 .02], 'SliderStep', [0.01 0.01], ...
    'Callback', {@cn_slider,hfig});
set(CmsCoreProp.handles_cn_slider,'BackgroundColor', [0.97,0.97,0.97]);
set(CmsCoreProp.handles_cn_slider,'value',1);
%%
CmsCoreProp.i(1)=core.s(1).pos(1);
CmsCoreProp.j(1)=core.s(1).pos(2);
CmsCoreProp.x=core.s(1).pos(1);
CmsCoreProp.y=core.s(1).pos(2);
CmsCoreProp.nr_points=1;
% CmsCoreProp.move=2;
CmsCoreProp.pool_j=1;
CmsCoreProp.pool_i=1;

k=1;
while k < CmsCoreProp.core.tot_kan && (CmsCoreProp.isort(k) ~= knum)
    k=k+1;
end
set(CmsCoreProp.handles.data_listbox, 'value', k, 'ListboxTop',k);
set(CmsCoreProp.handles.bur_listbox, 'value', k, 'ListboxTop',k);
%%
set(hfig,'userdata',CmsCoreProp);

paint_core([],[],hfig);

end


function radial_option(~,~,hfig)

paint_core([],[],hfig);

end


function axial_node_slider(src,~,hfig)

CmsCoreProp=get(hfig,'userdata');

slider_value = round(get(src,'Value'));
cc=sprintf('Ax node %d',slider_value);
set(CmsCoreProp.handles.axial_node_textbox,'string',cc);
set(hfig,'userdata',CmsCoreProp);
% paint_core([],[],hfig);

end

