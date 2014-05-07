function get_next_assembly_for_pindata
% get_next_assembly_for_pindata enables to get a new assembly from cmsplot
% and plot it in Pinplot


%% find assembly handel and "parent" handle of cmsplot
pinfig = gcf;
pinplot_prop=get(pinfig,'userdata');
coreinfo = pinplot_prop.coreinfo;
hfig = pinplot_prop.hcmsplot;

%% change position in pinplot
iafull = coreinfo.core.iafull;
figure(hfig);

contin = 1;
while contin == 1
    % get new assembly
    figure(hfig);
    [xx,yy,button]=ginput(1);
    switch button
        case 1 
            nx=fix(xx);
            ny=fix(yy);
                  
        case 28
            if nx>1, nx=nx-1; end
        case 29
            if nx<iafull, nx=nx+1; end
        case 31
            if ny<iafull, ny=ny+1; end
        case 30
            if ny>1, ny=ny-1; end
        otherwise 
            contin = 0;
    end

    %% put a cross in cmsplot
    cmsplot_prop=get(pinplot_prop.hcmsplot,'userdata');
    if max(strcmp(fieldnames(cmsplot_prop),'corecross')) && max(cmsplot_prop.corecross(1) == findall(0,'type','line'))
        delete(cmsplot_prop.corecross);
    end
    xl = [nx nx+1;nx+1 nx];
    yl = [ny ny;ny+1 ny+1];
    corecross = line(xl, yl, 'color', 'black', 'erasemode', 'none', 'linew', 2);
    cmsplot_prop.corecross = corecross;
    set(pinplot_prop.hcmsplot,'userdata',cmsplot_prop);
    
    
    %% get pin data from resfile
    figure(pinfig);
    pinplot_prop=get(pinfig,'userdata');
    if coreinfo.core.if2x2 == 2
        knumuse = cpos2knum(ny,nx,coreinfo.core.mminj2x2);
        
        %subnums = convert2x2('2subnum',coreinfo.core.knum,coreinfo.core.mminj,'full');
        subnums=crnum2knum(coreinfo.core.knum,coreinfo.core.mminj2x2);
        [~, pos] = find(subnums == knumuse);
        pinplot_prop.rotpos = pos;
    else
        knumuse = cpos2knum(ny,nx,coreinfo.core.mminj);
    end
    if isfield(pinplot_prop,'pininfo')
        pinstruct = ReadCore(pinplot_prop.pininfo,{'PINPOW3','fuel_data','pinexp3'},pinplot_prop.st_pt,pinplot_prop.coreinfo.serial(knumuse));
        % create pindata
        pinw = cellpin2stcell(pinstruct.pinpow3);
        pine = cellpin2stcell(pinstruct.pinexp3);
        pindata.pinpow = pinw{1};
        pindata.pinexp = pine{1};
        pindata.kdfuel = pinstruct.fuel_data.KDFUEL;
        pindata.ser = pinstruct.fuel_data.SERIAL{pinplot_prop.st_pt}(knumuse); % TODO: check with other state points..
%         pindata.lab = pinstruct.fuel_data.LABEL{1}(knumuse);
        pindata.knums = knumuse;
        pindata.npin = pinstruct.fuel_data.NPIN(knumuse,pinplot_prop.st_pt);
        pindata.ia = pinstruct.fuel_data.IIAS(knumuse);
        pindata.ja = pinstruct.fuel_data.JJAS(knumuse);
        pindata.nfran = pinstruct.fuel_data.IROT(pinplot_prop.st_pt); % TODO: check this!!
        pindata.Xpo = pinstruct.fuel_data.XPO(pinplot_prop.st_pt);
        pinplot_prop.knumuse = knumuse;
    else
        pindata = ReadCore(coreinfo,'pindata',pinplot_prop.st_pt,knumuse);
    end
%     if coreinfo.core.if2x2 == 2
%         logi = pindata.knums == knumuse;
%         newpindata.ia = pindata.ia(logi);
%         newpindata.ja = pindata.ja(logi);
%         newpindata.npin = pindata.npin(logi);
%         newpindata.nfran = pindata.nfran(logi);
%         newpindata.ser = pindata.ser{logi};
%         newpindata.lab = pindata.lab{logi};
%         newpindata.pinexp = pindata.pinexp{logi};
%         newpindata.Xpo = pindata.Xpo;
%         newpindata.geoms = pindata.geoms{logi};
%         newpindata.kdfuel = pindata.kdfuel(logi);
%         newpindata.knums = knumuse;
%         pindata = newpindata;
%     else
        pinplot_prop.pindata = pindata;
%     end
    pinplot_prop.pindata = pindata;
    pinplot_prop.knumuse = knumuse;
    pinplot_prop.nod_plane = [1 pindata.kdfuel];
    
    %% draw the box
    if coreinfo.core.if2x2 ~=2
        if max(strcmp(fieldnames(pinplot_prop),'rect'))
            delete(pinplot_prop.rect);
        end
        rect = rectangle('Position',[0,0,pindata.npin+1,pindata.npin+1], 'LineWidth',10,'FaceColor',[1 1 1]);
        set(gca,'XTick',1:pindata.npin)
        set(gca,'YTick',1:pindata.npin)

        pinplot_prop.rect = rect;   
    end
        
    set(pinfig,'userdata',pinplot_prop);
    %% draw control rod
    if coreinfo.core.if2x2 ~=2
        DrawCtrrod   
    end
    pinplot_prop=get(pinfig,'userdata');
    %% draw pins
    PlotPinData
    pinplot_prop=get(pinfig,'userdata');
    set(pinfig,'userdata',pinplot_prop);
    %% check if there is a segment plot to update.
    segcheck = findall(0,'type','figure');
    if max(strcmp(fieldnames(pinplot_prop),'hsegplot')) && max(pinplot_prop.hsegplot == segcheck)
        Seg_Plot
    end
        
        

end

end