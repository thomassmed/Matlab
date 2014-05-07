function cmsProfile(varargin)
hfig = gcf;
pos = get(hfig, 'position');
cmsplot_prop = get(hfig, 'userdata');
% get a parameter if the distribution is S5 with different size nodes
if strcmpi(cmsplot_prop.filetype,'.res') && cmsplot_prop.coreinfo.fileinfo.Sim == 5 && (strncmpi('MICRO ',cmsplot_prop.dist_name,6) || strncmpi('SUB ',cmsplot_prop.dist_name,4))
    resS5 = 1;
else
    resS5 = 0;
end
if nargin==0,
    plottype=1;
else
    plottype=varargin{1};
end
if plottype==1 && ~resS5,
    if min(size(cmsplot_prop.data))==1,
        uiwait(msgbox('Profile plots not meaningful for 2D-distribution'));
        return;
    end
end


if cmsplot_prop.core.if2x2==2&&size(cmsplot_prop.data,2)==4*cmsplot_prop.core.kan,
    mminj=cmsplot_prop.core.mminj2x2;
    knum = cmsplot_prop.core.knum2x2;
else
    mminj = cmsplot_prop.core.mminj;
    knum = cmsplot_prop.core.knum;
end
sym = cmsplot_prop.core.sym;
kan = sum(length(mminj) - 2*(mminj-1));
node_plane=eval(cmsplot_prop.node_plane);
kmax = cmsplot_prop.core.kmax;

Xpo=cmsplot_prop.Xpo;
if plottype==1, %Profile
    legstr=cell(length(Xpo),1);
    for i=1:length(Xpo),
        legstr{i}=sprintf('%i :%6.2f',i,Xpo(i));
    end
end      

if ~resS5 && min(size(cmsplot_prop.data))==1,
    d3plot=0;
else
    d3plot=1;
end
        
ij = knum2cpos(1:kan,mminj);

mesg_string = [ 'Left click to select starting point '
    '                                    '
    'Arrows to navigate                  '
    '                                    '
    'Left click again for new start point'
    '                                    '
    'Right click or <CR> to quit         '];

figure(hfig);
hmsg = msgbox(mesg_string);
msgpos = [pos(1)+0.2*pos(3) pos(2)+0.15*pos(4) 141 115];
%    set(hmsg, 'position', msgpos);
uiwait(hmsg);
start = 1; i = round(kan/2); button=[];
contin = 1;

dists=ReadCore(cmsplot_prop.coreinfo,cmsplot_prop.dist_name,'all');

while contin
    figure(hfig);
    [xx, yy, button] = ginput(1);
    
    if isempty(button), break;end
    switch(button)
        case 1
            nx = fix(xx);
            ny = fix(yy);
            knums = cpos2knum(ny, nx, mminj);
        case 3
            contin = 0; return;
        case 28
            if knums>1, knums=knums-1; end
        case 29
            if knums<kan, knums=knums+1; end
        case 30
            if ny>1, ny=ny-1; end
            knums = cpos2knum(ny, nx, mminj);
        case 31
            if ny<length(mminj), ny=ny+1; end
            knums = cpos2knum(ny, nx, mminj);
        case []
            return;
        otherwise
            knums = knums + 1;
    end
    % get data for channel
    nynx=knum2cpos(knums,mminj);ny=nynx(1);nx=nynx(2);
    %dists=ReadCore(cmsplot_prop.coreinfo,cmsplot_prop.dist_name,'all',knums);
   % if (strcmpi(cmsplot_prop.filetype,'.res') && strcmpi(cmsplot_prop.dist_name,'Power')) %|| ~strcmpi(cmsplot_prop.filetype,'.res')
        for i = 1:length(dists)
            distemp{i} = dists{i}(:,knums);
        end
        %dists = distemp;
    %end
    CmsProfileProp.data=distemp;
   
    
    if resS5 
        nodplan = 1:length(CmsProfileProp.data{1});
    else
        nodplan = check_dist(CmsProfileProp.data,node_plane);
    end
    if plottype==2 
        for i=1:length(nodplan),
            legstr{i}=sprintf('Nod %i',nodplan(i));
        end
    end
    if start
        scrsz=get(0,'screensize');
        spaceleft=pos(1);
        spaceright=scrsz(3)-pos(1)-pos(3);
        newpos = pos;
        newpos(3) = pos(3) * 0.7;
        if spaceleft>spaceright,
            newpos(1) = pos(1) - newpos(3) * 1.02;
            left=1;
        else
            left=0;
            newpos(1) = pos(1)+pos(3)*1.02;
        end
        g1 = figure('position', newpos, 'menubar', 'none');
        uimenu('label','Export Data','callback','SavedataGUI(0);');
        CmsProfileProp.knum=knum;
        CmsProfileProp.resS5=resS5;
        CmsProfileProp.kmax = kmax;
        if d3plot, 
            winheight=newpos(4);
            winwidth= max(0.18*newpos(3),80);
            
            hvar=uicontrol (g1, 'style', 'listbox', 'Max',100,'string', legstr, 'position', [5, 10, winwidth-10, winheight-40]);
            set(hvar,'callback',{@PlotCmsProfile,gcbo});
            hax=axes('position',[0.28 0.1 0.62 0.85]);     %Axes handle
            set(hvar,'Value',1:length(legstr));

            CmsProfileProp.nodplan=nodplan;
            CmsProfileProp.plottype=plottype;
            CmsProfileProp.hvar=hvar;
            CmsProfileProp.legstr=legstr;
            CmsProfileProp.hax=hax;
            CmsProfileProp.Xpo=Xpo;
        else
            hax=axes('position',[0.13 0.11 0.775 0.815]);
        end
    end
    start = 0;
    CmsProfileProp.knums=knums;
    set(g1,'userdata',CmsProfileProp);
    figure(g1); hold off; g1 = gcf;
    if d3plot,
        isel=get(hvar,'Value');
    else
        isel=1;
    end
    
    if plottype==1,
        if resS5
            oldprop = get(g1,'userdata');
            if isfield(oldprop,'H1')
                delete(oldprop.H1);
                delete(oldprop.H2);
                delete(oldprop.AX);
            end
            yvar = cumsum(cmsplot_prop.subgeom{knums});
            xvar = [CmsProfileProp.data{:}];
            CmsProfileProp.yvar = yvar;
            if max(xvar(:)) < 1
                xlen = max(xvar(:)) + max(xvar(:))/10;
            else
                xlen = round(max(xvar(:))) + round(max(xvar(:)))/10;
            end
            CmsProfileProp.xlen = xlen;
            Xnod = [(zeros(1,kmax))' (ones(1,kmax)*xlen)'];
            Ynod = [(1:kmax)' (1:kmax)']*yvar(end)/kmax;
            [AX,H1,H2] = plotyy(xvar,yvar,Xnod',Ynod','plot');
            CmsProfileProp.H1 = H1;
            CmsProfileProp.H2 = H2;
            CmsProfileProp.AX = AX;
            axtick1 = get(AX(1),'Ytick');
            set(AX,'Ytick',[]);
            set(AX(1),'Box','Off');
            set(AX(1),'Ytick',axtick1);
            numm = round(kmax/5);
            set(AX(2),'YTick',yvar(end)/numm*(1:numm)-yvar(end)/50)
            for i = 1:numm
               tickcell{i} = num2str(5*i);
            end
            set(AX(2),'YTickLabel',tickcell)
            axis(AX,[0 xlen 0 axtick1(end)])
            ylabel(AX(1),'Core Heigth');
            ylabel(AX(2),'Node Planes');
            set(H2,'LineStyle',':','color','b')
            CmsProfileProp.savdat.plotdata = xvar;
            CmsProfileProp.savdat.plotxvar = {yvar};
%             CmsProfileProp
            set(g1,'userdata',CmsProfileProp);
        else
            distmat = cell2mat(CmsProfileProp.data);
            plot(hax,distmat(:,isel),nodplan);
            CmsProfileProp.savdat.plotdata = distmat;
            grid on
            ylabel('Nod plane');
            xlabel(cmsplot_prop.dist_name);
        end
    elseif plottype==2,
        if resS5
            oldprop = get(g1,'userdata');
            yvar = (cell2mat(CmsProfileProp.data))';
            xvar = Xpo';
            H1 = plot(xvar,yvar);
        else
            distmat = cell2mat(CmsProfileProp.data);
            
            if d3plot,
                
                plot(hax,Xpo,distmat(isel,:));
                CmsProfileProp.savdat.plotdata = distmat;
            else
                hplot=plot(hax,Xpo,distmat);
                set(hplot, 'ButtonDownFcn',@show_DisplayName,'DisplayName',cmsplot_prop.dist_name);
                hdt = datacursormode;       %see which object who is choosen
                set(hdt,'Enable','on');     %Enable every time
                set(hdt,'DisplayStyle','window'); %Put infobox in window
            end
        end
        if exist('cmsplot_prop.coreinfo.ScalarNames{1}')
            xlabel(cmsplot_prop.coreinfo.ScalarNames{1}); % TODO: fix for resfile
        else
            xlabel('Xpo');
        end
        ylabel(cmsplot_prop.dist_name);
        grid on
    end
    %if left, loc='Westoutside';else loc='EastOutside';end
    loc='EastOutside';
    Legstr=cell(length(isel),1);
    for i1=1:length(isel),
        Legstr{i1}=legstr{isel(i1)};
    end
    if length(Legstr)>1||d3plot,
        legend(Legstr,'Location',loc);
    end
    if strcmp(cmsplot_prop.coordinates,'ij')
        title(sprintf('Channel: %i, i: %i j: %i',knums, ny,nx));
    else
        nxtex = cmsplot_prop.axlabels.assemlabs.lab2{nx};
        nytex = cmsplot_prop.axlabels.assemlabs.lab1{ny};
        title(sprintf(['Channel: %i, i: ' nxtex ' j: ' nytex],knums));
    end
    figure(hfig); 
    xl = [nx nx+1;nx+1 nx];
    yl = [ny ny;ny+1 ny+1];
    cmsplot_now;
    h = line(xl, yl, 'color', 'black', 'erasemode', 'none', 'linew', 2); drawnow; figure(g1);
    CmsProfileProp.coreinfo = cmsplot_prop.coreinfo;
    set(g1,'userdata',CmsProfileProp);
end
figure(hfig);


function nodplan=check_dist(dists,node_plane)
[id,jd]=size(dists{1});
nodplan=node_plane;
nodplan(nodplan>id)=[];
nodplan(nodplan<1)=[];
if length(nodplan)<length(node_plane),
    msg=['Not all nodes can be found in distritution, only nodes',num2str(nodplan),' will be plotted'];
    warning(msg);
end

