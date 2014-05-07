% $Id: crwea_plot_map.m 44 2012-07-16 10:18:15Z rdj $
%
function crwea_plot_map(resultfile,bur,grp,rod)

load(resultfile,'res');

mminj=res.(['B_' num2str(bur)]).mminj;

fbur=['B_' num2str(bur)];
fgrp=['G_' num2str(grp)];

rodnr=[];
if isempty(rod)
    casedata=crwea_fetch_case_data(res.(fbur).(fgrp),true);
else
    rodnr=crpos2crnum(axis2crpos(rod),mminj);
    frod=['R_' num2str(rodnr)];
    casedata=crwea_fetch_case_data(res.(fbur).(fgrp).(frod),true);
end

rodnrs=[];
if isempty(rod)
   rodfields=fieldnames(res.(fbur).(fgrp));
   rodind=strmatch('R_',rodfields);
   for i=1:length(rodind)
      rodi=fliplr(strtok(fliplr(rodfields{rodind(i)}),'_'));
      rodnrs=[rodnrs str2double(rodi)];
   end
end

sel_cpr_ind=1;
sel_mod={};
if isfield(casedata,'er')
    sel_mod=[sel_mod 'er'];
end
if isfield(casedata,'vr')
    sel_mod=[sel_mod 'vr'];
end
    
data=casedata.(sel_mod{1});

f=figure;
set(f,'Renderer','painters'); % Painters is faster for this fairly simple graphic
ax=axes();
colormap(ax,flipud(colormap));

nsteps=length(data.cpr);
uicontrol('Style','slider','Position',[0 0 200 20],...
    'Min',1,'Max',nsteps,'Value',sel_cpr_ind,'SliderStep',[1/(nsteps-1) 1/(nsteps-1)],...
    'Callback',@slider_callback);

uicontrol('Style','popupmenu','Position',[220 0 50 20],'String',sel_mod,...
    'Callback',@regmod_callback);

update_plot(data,ax,mminj,rod,rodnr,rodnrs,sel_cpr_ind);

    function slider_callback(hObject,eventdata)
        sel_cpr_ind=round(get(hObject,'value'));
        update_plot(data,ax,mminj,rod,rodnr,rodnrs,sel_cpr_ind);
    end

    function regmod_callback(hObject,eventdata)
        data=casedata.(sel_mod{get(hObject,'value')});
        update_plot(data,ax,mminj,rod,rodnr,rodnrs,sel_cpr_ind);
    end
end




function update_plot(data,ax,mminj,rod,rodnr,rodnrs,sel_cpr_ind)

[~,ind]=sort(data.pos);

% CPRMAP
cla(ax);
axis([1 length(mminj)+1 1 length(mminj)+1]);
colorbar;
caxis(ax,[0.8 1.8]);
set(ax,'YDir','reverse');
hold(ax,'on');

set(ax,'XTick',0.5:2:length(mminj)+1.5);
set(ax,'YTick',0.5:2:length(mminj)+1.5);

set(ax,'XTickLabel',0:2:length(mminj)+1);
set(ax,'YTickLabel',0:2:length(mminj)+1);


map=vec2core_nan(data.cpr{ind(sel_cpr_ind)},mminj);
[mincpr,mincpr_ind]=sort(data.cpr{ind(sel_cpr_ind)});
map=[[map nan(length(mminj),1)]; nan(1,length(mminj)+1)];
pcolor(ax,map);

if isempty(rod)
    titlestr='GRP=';
else
    titlestr=[rod '='];
end
titlestr=[titlestr num2str(data.pos(ind(sel_cpr_ind))) '%  CPRmin = ' num2str(mincpr(1),'%1.2f')];
titlestr=[titlestr ' Power = ' num2str(data.power(ind(sel_cpr_ind)),'%3.1f') '%'];
titlestr=[titlestr ' Flow = ' num2str(data.hcflow(ind(sel_cpr_ind)),'%5.0f') ' kg/s'];
title(ax,titlestr);

% Plot rod positions
if ~isempty(rodnr)
    rodc=crpos2knum(crnum2crpos(rodnr,mminj),mminj);
    rodpos=knum2cpos(rodc(1),mminj);
    axes(ax);
    rectangle('Position',[rodpos(2) rodpos(1) 2 2],'LineWidth',2.5,'EdgeColor','white');
else
    for r=1:length(rodnrs)
        rodc=crpos2knum(crnum2crpos(rodnrs(r),mminj),mminj);
        rodpos=knum2cpos(rodc(1),mminj);
        axes(ax);
        rectangle('Position',[rodpos(2) rodpos(1) 2 2],'LineWidth',2.5,'EdgeColor','white');
    end
end

% Plot 10 worst mincpr positions
for i=1:10
    cprpos=knum2cpos(mincpr_ind(i),mminj);
    text(cprpos(2)+0.2,cprpos(1)+0.6,num2str(i,'%2.0f'));
end

end
