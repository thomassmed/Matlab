% $Id: crwea_plot_case.m 44 2012-07-16 10:18:15Z rdj $
%
function crwea_plot_case(resultfile,bur,grp,rod,powlimit,flowlimit,slmcpr)

load(resultfile,'res');

mminj=res.(['B_' num2str(bur)]).mminj;

fbur=['B_' num2str(bur)];
fgrp=['G_' num2str(grp)];
if isempty(rod)
    casedata=crwea_fetch_case_data(res.(fbur).(fgrp),true);
else
    frod=['R_' num2str(crpos2crnum(axis2crpos(rod),mminj))];
    casedata=crwea_fetch_case_data(res.(fbur).(fgrp).(frod),true);
end


data=[];
h1=0;h2=0;ax=0;

legh=[];
legstr={};

% Read ER data
if isfield(casedata,'er')
    figure;
    
    data=casedata.er;
    [~,ind]=sort(data.pos);
      
    [ax,h1,h2]=plotyy(data.pos(ind),data.cprmin(ind),data.pos(ind),data.hcflow(ind));
    set(h1,'LineWidth',1);
    set(h1,'Marker','s');
    set(h1,'MarkerSize',8);
    set(h1,'Color','b');
    set(h2,'Marker','x');
    set(h2,'MarkerSize',8);
    
    hold(ax(1),'on');
    hold(ax(2),'on');
    
    % Add SLMCPR-line
    slmcprh=line([0 100],[slmcpr slmcpr]);
    set(slmcprh,'LineWidth',2);
    set(slmcprh,'LineStyle','--');
    set(slmcprh,'Color',[1 0 0]);

    [crpos_intp,cprmin_intp]=crwea_interp(data.pos(ind),...
        data.hcflow(ind),data.cprmin(ind),flowlimit);
    
    if isnan(cprmin_intp)
        [cprmin_intp,flind]=min(data.cprmin);
        crpos_intp=data.pos(flind);
    end
    
    axes(ax(1));
    fh=plot(crpos_intp,cprmin_intp);
    set(fh,'Marker','diamond');
    set(fh,'MarkerSize',8);
    set(fh,'MarkerEdgeColor',[0 0 0]);
    set(fh,'MarkerFaceColor','b');
    
    % Flow limit line
    axes(ax(2));
    flh=line([0 100],[flowlimit flowlimit]);
    set(flh,'LineStyle','--');
    
    legh=[legh h1 fh slmcprh h2 flh];
    legstr=[legstr 'CPR_{min}' 'Interpolated CPR_{min}' 'SLMCPR' 'HC-flow' 'HC-flow limit'];
       
    titlestr=['ER - BURNUP: ' num2str(bur) ' EFPH     '];
    titlestr=[titlestr 'MANGRP: ' num2str(grp)];
    if ~isempty(rod)
        titlestr=[titlestr ' ROD: ' num2str(rod)];
    end
    title(titlestr);
    set(ax(1),'YLim',[0.8 1.8]);
    set(ax(1),'YGrid','on');
    set(ax(1),'YTickMode','auto');
    ylabel(ax(1),'CPR_{min}');
    set(ax(1),'XTick',[]);
    ylabel(ax(2),'HC-flow [kg/s]');
    
    xlabel(ax(1),'\newline % Control rod withdrawal');
    set(ax(2),'XTick',data.pos(ind));
    set(ax(2),'XTickLabel',data.pos(ind));
    set(ax(2),'YTickMode','manual');
    
    % Add legend
    legend(legh,legstr);
end


legh=[];
legstr={};

% Read VR data
if isfield(casedata,'vr');
    figure;
    
    data=casedata.vr;
    [~,ind]=sort(data.pos);
    
    [ax,h1,h2]=plotyy(data.pos(ind),data.cprmin(ind),data.pos(ind),data.power(ind));
    set(h1,'LineWidth',1);
    set(h1,'Marker','s');
    set(h1,'MarkerSize',8);
    set(h1,'Color','b');
    set(h2,'Marker','x');
    set(h2,'MarkerSize',8);
    
    hold(ax(1),'on');
    hold(ax(2),'on');
    
    % Add SLMCPR-line
    slmcprh=line([0 100],[slmcpr slmcpr]);
    set(slmcprh,'LineWidth',2);
    set(slmcprh,'LineStyle','--');
    set(slmcprh,'Color',[1 0 0]);
    
    [crpos_intp,cprmin_intp]=crwea_interp(data.pos(ind),...
        data.power(ind),data.cprmin(ind),powlimit);
    
    if isnan(cprmin_intp)
        [cprmin_intp,powind]=min(data.cprmin);
        crpos_intp=data.pos(powind);
    end
    
    axes(ax(1));
    ph=plot(crpos_intp,cprmin_intp);
    set(ph,'Marker','diamond');
    set(ph,'MarkerSize',8);
    set(ph,'MarkerEdgeColor',[0 0 0]);
    set(ph,'MarkerFaceColor','b');
    
    % Power limit line
    axes(ax(2));
    plh=line([0 100],[powlimit powlimit]);
    set(plh,'LineStyle','--');
    
    legh=[legh h1 ph slmcprh h2 plh];
    legstr=[legstr 'CPR_{min}' 'Interpolated CPR_{min}' 'SLMCPR' 'Power' 'Power limit'];
    
    titlestr=['VR - BURNUP: ' num2str(bur) ' EFPH     '];
    titlestr=[titlestr 'MANGRP: ' num2str(grp)];
    if ~isempty(rod)
        titlestr=[titlestr ' ROD: ' num2str(rod)];
    end
    title(titlestr);
    set(ax(1),'YLim',[0.8 1.8]);
    set(ax(1),'YGrid','on');
    set(ax(1),'YTickMode','auto');
    ylabel(ax(1),'CPR_{min}');
    xlabel(ax(1),'\newline % Control rod withdrawal');
    set(ax(1),'XTick',[]);
    ylabel(ax(2),'Power [%]');
    set(ax(2),'XTick',data.pos(ind));
    set(ax(2),'XTickLabel',data.pos(ind));
    set(ax(2),'YTickMode','manual');
    
    % Add legend
    legend(legh,legstr);
end






