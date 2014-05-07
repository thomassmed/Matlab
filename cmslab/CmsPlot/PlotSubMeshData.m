function PlotSubMeshData
% PlotSubMeshData is the basic plot program for plot_sub_mesh
%
% See also plot_sub_mesh, get_submesh_data

% Mikael Andersson 2012-01-05

%% get data 
submeshfig = gcf;
submeshplot_prop=get(submeshfig,'userdata');
coreinfo = submeshplot_prop.coreinfo;
cdinfo = submeshplot_prop.cdinfo;
st_pt = submeshplot_prop.st_pt;
lib = submeshplot_prop.lib;
ias = submeshplot_prop.positions{1};
jas = submeshplot_prop.positions{2};
mminj = coreinfo.core.mminj;
kmax = coreinfo.core.kmax;
knums = submeshplot_prop.knums;
subnodedata = submeshplot_prop.subnodedata;
dispval = submeshplot_prop.dispval;
resolu = 150;
numofass = length(knums);
%% Read nessesary data from file
% subnodedata = ReadRes(coreinfo,['submesh data ' submeshplot_prop.dataplot],st_pt,knums');
control_rod_data = ReadRes(coreinfo,'control rod',st_pt);
nfra = ReadRes(coreinfo,'nfra',st_pt);
subgeom = submeshplot_prop.geoms(knums);
hz = submeshplot_prop.hz;
if coreinfo.core.if2x2 == 2
    nfra = reshape([nfra' nfra' nfra' nfra']',1,4*length(nfra));
    nfras = nfra(knums);
else
    nfras = nfra(knums);
end
subnodbel = SubNode2NodePos(subgeom,hz,kmax);
%% get dimensions from library file
% TODO: fixa så att den ger nått bra även om det inte finns någon lib fil..
if strcmpi(cdinfo,'nocdfile')
    for i = 1:numofass
        xmesh{i} = submeshplot_prop.xmesh;
        ymesh{i} = submeshplot_prop.ymesh;
        nsubs{i} = submeshplot_prop.nsubs;
    end
else
    segsforsize = lib.Core_Seg{1}(1,knums);
    submeshdims = ReadCdfile(cdinfo,'submesh dims',segsforsize);
    nsubs = submeshdims.nsubs;
    xmesh = submeshdims.xmesh;
    ymesh = submeshdims.ymesh;
end
% ns = 5;
% xme = [3.0550 3.0550 3.0550 3.0550 3.0550];
% for i = 1:length(subnodedata)
%     xmesh{i} = xme;
%     ymesh{i} = xme;
%     nsubs{i} = ns;
% end
% TODO: fixa så de funkar med bara en också...
%% do the calculations on the data..
minval = 100; % just a "big number" may be done in a better way.
maxval = 0;


for i = 1:numofass
    if numofass == 1 
        if ~iscell(subnodedata) 
            subnodedata = {subnodedata};
        end
        if ~iscell(nsubs)
            nsubs = {nsubs};
            xmesh = {xmesh};
            ymesh = {ymesh};
        end
        wanted_sub_nods =  submeshplot_prop.nod_plane(2) >= 1:length(subnodedata{1})&  submeshplot_prop.nod_plane(1) <= 1:length(subnodedata{1});
    else
        wanted_sub_nods =  submeshplot_prop.nod_plane(2) >= subnodbel{i} &  submeshplot_prop.nod_plane(1) <= subnodbel{i};
    end
    
    
    if submeshplot_prop.nod_plane(2) == submeshplot_prop.nod_plane(1) && nnz(subnodbel{i} == submeshplot_prop.nod_plane(1)) == 1
        evalstr = ['nonrotdata = reshape(((subnodedata{i}(:,wanted_sub_nods))' char(39) '),nsubs{i},nsubs{i});'];
    else
        evalstr = ['nonrotdata = reshape(' submeshplot_prop.datacalc '((subnodedata{i}(:,wanted_sub_nods))' char(39) '),nsubs{i},nsubs{i});'];
    end
	eval(evalstr);
    if coreinfo.core.if2x2 ~= 2
        rotdata{i} = rot90(nonrotdata,-nfras(i));
    else
        rotpos = submeshplot_prop.rotpos;
        rotvec = [2 1 3 0];
        rotdata{i} = rot90(nonrotdata,rotvec(rotpos(i)));
%         rotdata{i} = nonrotdata;
    end
    minval = min([min(nonrotdata(:)) minval]);
    maxval = max([max(nonrotdata(:)) maxval]);
end
    

% subpow = Submesh2Power(powers,subnodedata,geoms,hz,kmax); %% TODO: borde
% göras till exp kanske pow också...


%% prepare controlrod data
controlrod = cr2core(control_rod_data.konrod,coreinfo.core.mminj,control_rod_data.crmminj,nan);
controlvec = cor2vec(controlrod,mminj);
konrodmax = max(controlvec);
konrods = controlvec(knums);

%% prepare plot window

xled = length(ias);
yled = length(jas);
xledi = 1:xled;
yledi = 1:xled:length(knums);
xwid = sum([xmesh{xledi}]);
ywid = sum([ymesh{yledi}]);

if strcmpi(submeshplot_prop.dataplot,'EXPR')
    for i = 1:numofass
        if nnz(rotdata{i}) > 0
            rotdata{i}(rotdata{i} == 0) = minval*1.1;
        end
    end
end

%% create data matrix for plot
for i=1:numofass
    matp{i} = CreatePlotMat(rotdata{i},xmesh{i},ymesh{i},nsubs{i},resolu);
end
ctrdsiz = resolu/10;
ctrdgapmat = zeros(resolu,ctrdsiz); % vertical
ctrdmitt = zeros(ctrdsiz);
%% create data matrix and add controlrods (not att left and top border, those are handled later)
itcon = 1;
row = 1;
ctrdposit = 1;
kons = 0;
konst = 0;
konsv = 0;
for i = 1:numofass
    matdata(row,itcon) = matp(i);
    if coreinfo.core.if2x2 ~= 2
        kontrolbar = ctrdgapmat + minval;
        if konrods(i) == konrodmax
            ctrdcol = minval;
        else
            ctrdcol = maxval + maxval*0.5; % see if this is good.
        end
        kontrolbar(1:resolu*8/10,:) = ctrdcol + ctrdgapmat(1:resolu*8/10,:);
        kontrolmitt = ctrdcol + ctrdmitt;

        if nfras(i) == 2  
            matdata(row+1,itcon) = {(flipud(kontrolbar))'};
            if konrods(i) ~= konrodmax
                kons = 1;
                ctrdposx(ctrdposit) = size(cell2mat(matdata(:,min(~(cellfun(@isempty,matdata)),[],1))),2) + ctrdsiz/2;
                ctrdposy(ctrdposit) = size(cell2mat(matdata(:,min(~(cellfun(@isempty,matdata)),[],1))),1) - ctrdsiz/2;
                ctrdposit = ctrdposit + 1;
            end


        elseif nfras(i) == 3
            matdata(row+1,itcon) = {kontrolbar'};
        end
        if nfras(i) == 1
            itcon = itcon + 1;
            matdata(row,itcon) = {kontrolbar};
            itcon = itcon + 1;
        elseif nfras(i) == 2
            itcon = itcon + 1;
            matdata(row,itcon) = {flipud(kontrolbar)};
            matdata(row+1,itcon) = {kontrolmitt};
            itcon = itcon + 1;
        else
            itcon = itcon + 1;
        end
    else
        itcon = itcon + 1;
    end
    
    if ((i/xled)-round(i/xled)) == 0
        if nfras(i) == 2 || nfras(i) ==3
            row = row + 2;
            itcon = 1;
        else
            row = row + 1;
            itcon = 1;
        end
    end
end

itcon = 1;
for i = 1:xled
    for j = 1:yled
        plotdatatemp(i,j) = rotdata(itcon);
        itcon = itcon +1;
    end
end
submeshplot_prop.savdat.plotdata = cell2mat(plotdatatemp);

%% check left and top controlrods
ctrdit = 1;
if coreinfo.core.if2x2 ~= 2
    if nfras(1) == 1 || nfras(1) == 0 
        if kons, ctrdposy = ctrdposy + ctrdsiz; end
        % top row
        itcon = 1;    
        for i = 1:xled
            kontrolbar = ctrdgapmat + minval;
            if konrods(i) == konrodmax
                ctrdcol = minval;
            else
                ctrdcol = maxval + maxval*0.5; % see if this is good.
            end
            kontrolbar(1:resolu*8/10,:) = ctrdcol + ctrdgapmat(1:resolu*8/10,:);
            kontrolmitt = ctrdcol + ctrdmitt;
            if nfras(i) == 0
                extraline1(:,itcon) = {kontrolbar'};
                if konrods(i) ~=konrodmax
                    konst = 1;
                    if nfras(1) == 1
                        extsi = ctrdsiz;
                    else
                        extsi = 0;
                    end
                    extractrdposx(ctrdit) = size(cell2mat(extraline1),2) - resolu + ctrdsiz/2 - extsi;
                    extractrdposy(ctrdit) = ctrdsiz/2;
                    extratrdval(ctrdit) = konrods(i);
                    ctrdit = ctrdit + 1;
                end
                itcon = itcon + 1;
            else
                extraline1(:,itcon) = {(flipud(kontrolbar))'};
                itcon = itcon + 1;
                extraline1(:,itcon) = {kontrolmitt};
                itcon = itcon + 1;
            end
            if i == xled && nfras(i) == 1 && konrods(i) ~= konrodmax
                konst = 1;
                if nfras(1) == 1
                    extsi = ctrdsiz;
                else
                    extsi = 0;
                end
                extractrdposx(ctrdit) = size(cell2mat(extraline1),2) + ctrdsiz/2 - extsi;
                extractrdposy(ctrdit) = ctrdsiz/2;
                extratrdval(ctrdit) = konrods(i);
            end
        end
    end
    ctrdit = 1;
    if nfras(1) == 3 || nfras(1) == 0
        if kons, ctrdposx = ctrdposx + ctrdsiz; end
        % left row
        itcon = 1;    
        for i = 1:yled
            kontrolbar = ctrdgapmat + minval;
            if konrods(yledi(i)) == konrodmax
                ctrdcol = minval;
            else
                ctrdcol = maxval + maxval*0.5; % see if this is good.
            end
            kontrolbar(1:resolu*8/10,:) = ctrdcol + ctrdgapmat(1:resolu*8/10,:);
            kontrolmitt = ctrdcol + ctrdmitt;
            if nfras(yledi(i)) == 0
                extraline2(itcon,:) = {kontrolbar};
                itcon = itcon + 1;
            else
                extraline2(itcon,:) = {(flipud(kontrolbar))};
                itcon = itcon + 1;
                if konrods(yledi(i)) ~= konrodmax
                    konsv = 1;
                    if konst
                        extsi = ctrdsiz;
                    else
                        extsi = 0;
                    end
                    leftextractrdposx(ctrdit) = ctrdsiz/2;
                    leftextractrdposy(ctrdit) = size(cell2mat(extraline2),1) + ctrdsiz/2 + extsi;
                    leftextratrdval(ctrdit) = konrods(yledi(i));
                    ctrdit = ctrdit + 1;
                end
                extraline2(itcon,:) = {kontrolmitt};
                itcon = itcon + 1;
                if ctrdit>1 && nfras(1) == 0
                    leftextractrdposy = leftextractrdposy + ctrdsiz/2;
                end

            end
        end
    end
    % add extra lines to data matrix
    if nfras(1) == 0
        if konrods(1) == konrodmax
            ctrdcol = minval;
        else
            ctrdcol = maxval + maxval*0.5; % see if this is good.
        end
        extramitt1{1} = ctrdcol + ctrdmitt;
        matdata = [extramitt1 extraline1;
                   extraline2 matdata];
    elseif nfras(1) == 1
        matdata = [extraline1; matdata];
    elseif nfras(1) == 3
        matdata = [extraline2, matdata];
    end
end
%% set up positions for values
if dispval
%     if coreinfo.core.if2x2 == 2
%         ass = 1;
%         for i = 1:xled
%             for j = 1:yled
%                 
%             end
%         end
        
        
%     else
        ref = cell(size(matdata));
        ref(cellfun(@isempty,ref)) = {[resolu]};
        logimat = cell2mat(cellfun(@eq,cellfun(@size,matdata,'uniformoutput',0),ref,'uniformoutput',0));
        hei = 0;
        ass = 1;
        for rw = 1:size(matdata,1)
            rwsz = size(matdata{rw,1},1);
            if logimat(rw,1)
                wei = 0;
                for col = 1:size(matdata,2)
                    colsz = size(matdata{rw,col},2);
                    if logimat(rw,2*col-1) == 1 && logimat(rw,2*col) == 1
                        yleng = hei + colsz/2;
                        xleng = wei + rwsz/2;
                        dataplace{ass} = [yleng xleng];
                        % TODO: can there be a different kind of submesh?? 
                        if coreinfo.core.if2x2 == 2
                            xrelplace{ass} = [-((xmesh{ass}(2) + xmesh{ass}(3))/2) -xmesh{ass}(1)/2 0 xmesh{ass}(5)/2 ((xmesh{ass}(3) + xmesh{ass}(4))/2)];
                            xrelplace{ass} = xrelplace{1}/sum(abs(xrelplace{1}))*resolu*3.5/3;
                            yrelplace{ass} = [-((ymesh{ass}(2) + ymesh{ass}(3))/2) -ymesh{ass}(1)/2 0 ymesh{ass}(5)/2 ((ymesh{ass}(3) + ymesh{ass}(4))/2)];
                            yrelplace{ass} = yrelplace{1}/sum(abs(yrelplace{1}))*resolu*3.5/3;
                        else
                            xrelplace{ass} = [-((xmesh{ass}(2) + xmesh{ass}(3))/2) 0 ((xmesh{ass}(3) + xmesh{ass}(4))/2)];
                            xrelplace{ass} = xrelplace{1}/sum(abs(xrelplace{1}))*resolu*2/3;
                            yrelplace{ass} = [-((ymesh{ass}(2) + ymesh{ass}(3))/2) 0 ((ymesh{ass}(3) + ymesh{ass}(4))/2)];
                            yrelplace{ass} = yrelplace{1}/sum(abs(yrelplace{1}))*resolu*2/3;
                        end
                        ass = ass + 1;
                    end
                    wei = wei + size(matdata{rw,col},2);
                end
            end
            hei = hei + size(matdata{rw,1},1);
%         end
    end
end


%% plot new data
figure(submeshfig);

if strcmp(submeshplot_prop.axstyle,'ij') || strcmp(submeshplot_prop.axstyle,'plntspc')
    plothand = imagesc(cell2mat(matdata));
    % create assembly positions for axes
    if coreinfo.core.if2x2 == 2 && strcmp(submeshplot_prop.axstyle,'plntspc')
        xlabpos = unique(ceil(submeshplot_prop.positions{1}/2));
        ylabpos = unique(ceil(submeshplot_prop.positions{2}/2));
        pos2 = ceil(submeshplot_prop.positions{2}/2);
        if rotpos(1) == 3
            yledt = floor(yled/2)+1;
            xledt = ceil(xled/2);
        elseif rotpos(1) == 4
            yledt = floor(yled/2)+1;
            xledt = floor(yled/2)+1;
        elseif rotpos(1) == 1
            xledt = ceil(xled/2);
            yledt = ceil(yled/2);
        else
            xledt = floor(xled/2)+1;
            yledt = ceil(yled/2);
            
        end
    else
        xledt = xled;
        yledt = yled;
    end
    for i = 1:xledt
        if coreinfo.core.if2x2 == 2 && strcmp(submeshplot_prop.axstyle,'plntspc')
            xlabs{i} = num2str(xlabpos(i));
        else
            xlabs{i} = num2str(ias(i));
        end
        if i ~= 1
            if (nfras(i) == 3 || nfras(i) == 0) && coreinfo.core.if2x2 ~= 2
                xpos(i) = resolu + xpos(i-1) + ctrdsiz;
            elseif coreinfo.core.if2x2 == 2 && strcmp(submeshplot_prop.axstyle,'plntspc')
                xpos(i) = resolu*2 + xpos(i-1);
            else
                xpos(i) = resolu + xpos(i-1);
            end
        else
            if (nfras(i) == 3 || nfras(i) == 0 ) && coreinfo.core.if2x2 ~= 2
                xpos(i) = resolu/2 + ctrdsiz;
            elseif coreinfo.core.if2x2 == 2 && strcmp(submeshplot_prop.axstyle,'plntspc')
                if rotpos(1) == 3 || rotpos(1) == 4
                    xpos(i) = 0;
                else
                    xpos(i) = resolu;
                end
            else
                xpos(i) = resolu/2;
            end
        end
    end
    for i = 1:yledt
        if coreinfo.core.if2x2 == 2 && strcmp(submeshplot_prop.axstyle,'plntspc')
            ylabs{i} = num2str(ylabpos(i));
        else
            ylabs{i} = num2str(jas(i));
        end
        if i ~= 1
            if (nfras(1 + xledt*(i-1)) == 1 || nfras(1 + xledt*(i-1)) == 0)  && coreinfo.core.if2x2 ~= 2
                ypos(i) = resolu + ypos(i-1) + ctrdsiz;
            elseif coreinfo.core.if2x2 == 2 && strcmp(submeshplot_prop.axstyle,'plntspc')
                ypos(i) = resolu*2 + ypos(i-1);
            else
                ypos(i) = resolu + ypos(i-1);
            end
        else
            if (nfras(i) == 1 || nfras(i) == 0) && coreinfo.core.if2x2 ~= 2
                ypos(i) = resolu/2 + ctrdsiz;
            elseif coreinfo.core.if2x2 == 2 && strcmp(submeshplot_prop.axstyle,'plntspc')
                if rotpos(1) == 3 || rotpos(1) == 4
                    ypos(i) = 0;
                else
                    ypos(i) = resolu;
                end
            else
                ypos(i) = resolu/2;
            end
        end
    end
    set(gca,'YTick',ypos);
    set(gca,'XTick',xpos);
    if strcmp(submeshplot_prop.axstyle,'ij')
        set(gca,'XTickLabel',xlabs);
        set(gca,'YTickLabel',ylabs);
    else
        
        xlab = submeshplot_prop.axlabels.assemlabs.lab2(cell2mat(cellfun(@str2double,xlabs,'uniformoutput',0)));
        ylab = submeshplot_prop.axlabels.assemlabs.lab1(cell2mat(cellfun(@str2double,ylabs,'uniformoutput',0)));
        set(gca,'XTickLabel',xlab);
        set(gca,'YTickLabel',ylab);
    end
    xlabel('Positions in Core')
    ylabel('Positions in Core')
else
    plothand = imagesc(cell2mat(matdata));
    ypos = (0:10:ywid)*size(cell2mat(matdata),1)/ywid;
    xpos = (0:10:xwid)*size(cell2mat(matdata),2)/xwid;
    set(gca,'YTick',ypos);
    set(gca,'YTickLabel',mat2cell(0:10:ywid,1,ones(1,length(0:10:ywid))))
    set(gca,'XTick',xpos);
    set(gca,'XTickLabel',mat2cell(0:10:xwid,1,ones(1,length(0:10:xwid))));
    xlabel('Length (cm)')
    ylabel('Length (cm)')
end
%% if values are wanted
if dispval    
    for i = 1:numofass
        subnum = find(rotdata{i} ~= 0);
        it = 1;
        numofdec = 3 - min(ceil(log10(rotdata{i}(subnum))));
        for j = 1:length(xrelplace{i})
            for k = 1:length(yrelplace{i})
                if strcmpi(submeshplot_prop.dataplot,'EXP')
                    str = num2str(round(rotdata{i}(subnum(it))*10^numofdec)/10^numofdec);
                else
                    str = num2str(round(rotdata{i}(subnum(it))*10^numofdec)/10^numofdec *10^(-min(ceil(log10(rotdata{i}(subnum))))));
                end
                texthand(i,it) = text(dataplace{i}(2)+xrelplace{i}(j),dataplace{i}(1)+yrelplace{i}(k),str,'HorizontalAlignment','center');
                it = it +1;
            end
        end
    end
end

% create lines for 2x2 (pwr)
if coreinfo.core.if2x2 == 2
    rotmat = reshape(rotpos,xled,yled)';
    % horizontal lines
    for i = 1:yled-1
        if rotmat(i,1) == 1 || rotmat(i,1) == 2
            pwrline(1,i) = line([0 xled*resolu],[i*resolu i*resolu],'LineStyle',':','Color','black');
        else
            pwrline(1,i) = line([0 xled*resolu],[i*resolu i*resolu],'LineStyle','-','Color','black');
        end
    end
    % vertical lines
    for i = 1:xled-1
        if rotmat(1,i) == 1 || rotmat(1,i) == 3
            pwrline(2,i) = line([i*resolu i*resolu],[0 yled*resolu],'LineStyle',':','Color','black');
        else
            pwrline(2,i) = line([i*resolu i*resolu],[0 yled*resolu],'LineStyle','-','Color','black');
        end
    end
end




%% control rod text (BWR)
if coreinfo.core.if2x2 ~=2
    konrodtexts = konrods(nfras == 2 & konrods ~= konrodmax);
    if kons
        for i = 1:length(ctrdposx)
            text(ctrdposx(i),ctrdposy(i),num2str(konrodtexts(i)),'FontSize',20,'HorizontalAlignment','Center');
        end
    end

    if konst
        for i = 1:length(extractrdposy)
            text(extractrdposx(i),extractrdposy(i),num2str(extratrdval(i)),'FontSize',20,'HorizontalAlignment','Center');
        end
    end
    if konsv
        for i = 1:length(leftextractrdposy)
            text(leftextractrdposx(i),leftextractrdposy(i),num2str(leftextratrdval(i)),'FontSize',20,'HorizontalAlignment','Center');
        end
    end
end
%% fix the extra text
if strcmp(submeshplot_prop.axstyle,'ij')
    datastring{2} = {['   Pos: i: ' num2str(min(submeshplot_prop.positions{1})) '-' num2str(max(submeshplot_prop.positions{1}))] ; ['j: ' num2str(min(submeshplot_prop.positions{2})) '-' num2str(max(submeshplot_prop.positions{2}))] };
else
    if submeshplot_prop.coreinfo.core.if2x2 == 2
        pos1 = ceil(submeshplot_prop.positions{1}/2);
        pos2 = ceil(submeshplot_prop.positions{2}/2);
    else
        pos1 = submeshplot_prop.positions{1};
        pos2 = submeshplot_prop.positions{2};
    end
    if iscell(submeshplot_prop.axlabels.assemlabs.lab2)
        datastring{2} = {['   Pos: i: ' submeshplot_prop.axlabels.assemlabs.lab2{min(pos1)} '-' submeshplot_prop.axlabels.assemlabs.lab2{(max(pos1))}] ; ['j: ' submeshplot_prop.axlabels.assemlabs.lab1{min(pos2)} '-' submeshplot_prop.axlabels.assemlabs.lab1{max(pos2)}] };
    else
        datastring{2} = {['   Pos: i: ' submeshplot_prop.axlabels.assemlabs.lab2{min(pos1)} '-' submeshplot_prop.axlabels.assemlabs.lab2{(max(pos1))}] ; ['j: ' submeshplot_prop.axlabels.assemlabs.lab1(min(pos2)) '-' submeshplot_prop.axlabels.assemlabs.lab1(max(pos2))] };
    end
end
    
if submeshplot_prop.nod_plane(1) == submeshplot_prop.nod_plane(2)
    nodestring =  ['Node: ' num2str(submeshplot_prop.nod_plane(1))];
else
    nodestring = ['Nodes: ' num2str(submeshplot_prop.nod_plane(1)) ':' num2str(submeshplot_prop.nod_plane(2))];
end
datastring{3} = {['StatePoint: ' num2str(submeshplot_prop.st_pt) ...
     '  XPO: ' num2str(coreinfo.Xpo(st_pt))];
   nodestring};
for i = 2:3
    set(submeshplot_prop.nodtext(i),'String',datastring{i},'FontSize',10); 
end
%% save data
submeshplot_prop.plothand = plothand;
submeshplot_prop.width = [xwid ywid];


%% fix scale
submeshplot_prop.cbar = colorbar;
if strcmpi(submeshplot_prop.autoscale,'no')
    caxis([submeshplot_prop.scale_min submeshplot_prop.scale_max]);
elseif strcmpi(submeshplot_prop.autoscale,'yes')
    submeshplot_prop.scale_min = minval;
    submeshplot_prop.scale_max = maxval;
    if maxval ~= 0
        caxis([submeshplot_prop.scale_min submeshplot_prop.scale_max]);
    end
end
submeshplot_prop.savdat.plotxlab = submeshplot_prop.positions{1};
submeshplot_prop.savdat.plotylab = submeshplot_prop.positions{2};
submeshplot_prop.savdat.cordtyp = 'submesh';
submeshplot_prop.savdat.nsubs = nsubs{1};
set(submeshfig,'userdata',submeshplot_prop);
end



function datamat = CreatePlotMat(data,xmesh,ymesh,nsub,resolu)
xmres = ymesh/sum(ymesh)*resolu;
ymres = xmesh/sum(xmesh)*resolu;

xmres = check_mesh(xmres,resolu);
ymres = check_mesh(ymres,resolu);

for i = 1:nsub
    for j = 1:nsub
        matp{i,j} = ones(xmres(i),ymres(j))*data(i,j);
    end
end
datamat = cell2mat(matp);
end


function newmesh = check_mesh(umesh,resolu)
mcheck = sum(round(umesh)) - resolu;
if mcheck == 0
    newmesh = round(umesh);
    
elseif mcheck > 0
    diff = abs(ceil(umesh) - umesh);
    selectsz = diff(abs(diff) < 0.5);
    
    if mcheck == sum(max(selectsz) == selectsz) % check the biggest value
        newmesh = round(umesh);
        newmesh(diff == max(selectsz)) = newmesh(diff == max(selectsz)) -1;
    elseif mcheck == sum(max(selectsz(selectsz<max(selectsz))) == selectsz) 
        newmesh = round(umesh);
        newmesh(diff == max(diff(selectsz<max(selectsz)))) = newmesh(diff == max(diff(selectsz<max(selectsz)))) -1;
    end
else %% sum(mesh) < resolu
    diff = abs(floor(umesh) - umesh);
    selectsz = diff(abs(diff) < 0.5);
    
    if abs(mcheck) == sum(min(selectsz) == selectsz) % check the biggest value
        newmesh = round(umesh);
        newmesh(diff == min(selectsz)) = newmesh(diff == min(selectsz)) +1;
    elseif abs(mcheck) == sum(min(selectsz(selectsz<max(selectsz))) == selectsz) 
        newmesh = round(umesh);
        newmesh(diff == min(selectsz)) = newmesh(selectsz == min(diff(selectsz>min(selectsz)))) +1;
    end
    
end
end