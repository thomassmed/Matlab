% function plot_sskryp(res,dd_fcn,powlimit,flowlimit,slmcpr)
%
%  res       - Resultat från sskryp()
%  dd_fcn    - Funktionshandtag till driftområdesplotfunktion 
%              t.ex. @f1dd, @f1dd eller @f2dd_120 för effekthöjd F2
%  powlimit  - Effektgränser för stav resp. grupp ex. [114 117]
%  flowlimit - Flödesgränser för stav resp. grupp ex. [7817 ??]
%  slmcpr    - SLMCPR gräns ex. 1.06
%
function plot_sskryp(res,dd_fcn,powlimit,flowlimit,slmcpr)

manvec=mgrp2vec('sim/mangrp.txt');

% Burnup steps
for i=1:length(res)
    
    mminj=res{i}.mminj;
    
    % GRPS / RODS
    for ii=1:length(res{i}.grp)
        grp=res{i}.grp{ii};
        
        cases=[];
        if isfield(grp,'er')|isfield(grp,'vr')
            cases{1}=grp;
        end
        if isfield(grp,'rods')
            cases=[cases res{i}.grp{ii}.rods];
        end
        
        for c=1:length(cases)
            casedata=cases{c};
            
            figure;
            % RODPOS vs CPRMIN
            ax1=subplot(3,1,1);
            set(ax1,'YGrid','on');
            hold(ax1,'on');
            
            % CPRMAP
            ax2=subplot(3,1,2);
            axis([1 31 1 31]);
            colorbar;
            caxis(ax2,[0.8 1.8]);
            set(ax2,'YDir','reverse');
            colormap(ax2,flipud(colormap));
            hold(ax2,'on');
            
            % POWER-FLOW MAP
            ax3=subplot(3,1,3);
            axes(ax3);
            dd_fcn(1,1);
            axis(ax3,[6000 12000 85 135]);
            axis(ax3,'manual');
            xlabel('Flow [kg/s]');
            ylabel('Power [%]');
            grid(ax3,'on');
            hold(ax3,'on');
            
            mincpr_er=1/eps;
            mincpr_vr=1/eps;
            mincpr_er_ind=[];
            mincpr_vr_ind=[];
            data=[];
            
            h1=0;h2=0;ax=0;
            
            if isfield(data,'rodnr')
               limit_index=1;
            else
               limit_index=2;
            end
            
            % Read ER data
            if isfield(casedata,'er')
                data=casedata.er;
                [mincpr_er,mincpr_er_ind]=min(cellfun(@(x) min(min(x)), casedata.er.cpr));
                
                xind=1:length(casedata.er.pos);
                [ax,h1,h2]=plotyy(ax1,xind,casedata.er.cprmin,xind,100-casedata.er.pos,@plot,@bar);
                set(h1,'LineWidth',1);
                set(h1,'Marker','v');
                set(h1,'MarkerSize',8);
                set(h1,'Color','b');
                set(h2,'BarWidth',0.6);
                set(h2,'FaceColor','none');
                
                plot(ax3,casedata.er.flow,casedata.er.power,'b-o');
                
                flind=find(casedata.er.flow<=flowlimit(limit_index));
                if ~isempty(flind)
                    flowh=line([xind(flind(1))-0.55 xind(flind(1))-0.55],[0.8 1.8]);
                    set(flowh,'LineWidth',2);
                    set(flowh,'LineStyle','--');
                    set(flowh,'Color',[0 0 1]);
                end
                
                for iii=1:length(xind)
                    if isfield(casedata.er,'status')
                        if casedata.er.status(iii)>0
                            text(ax3,xind(iii),1.6,'No conv');
                        end
                    end
                end
            end
            
            % Read VR data
            if isfield(casedata,'vr');
                data=casedata.vr;
                [mincpr_vr,mincpr_vr_ind]=min(cellfun(@(x) min(min(x)), casedata.vr.cpr));
                
                xind=1:length(casedata.vr.pos);
                
                if ax==0
                    [ax,h1,h2]=plotyy(ax1,xind,casedata.vr.cprmin,xind,100-casedata.vr.pos,@plot,@bar);
                    set(h1,'LineWidth',1);
                    set(h1,'Marker','^');
                    set(h1,'MarkerSize',8);
                    set(h1,'Color','m');
                    set(h2,'BarWidth',0.6);
                    set(h2,'FaceColor','none');
                else
                    h1=plot(ax(1),xind,casedata.vr.cprmin,'m-^');
                    set(h1,'LineWidth',1);
                    set(h1,'MarkerSize',8);
                end
                
                plot(ax3,casedata.vr.flow,casedata.vr.power,'m-o');
                
                powind=find(casedata.vr.power>=powlimit(limit_index));
                if ~isempty(powind)
                    powh=line([xind(powind(1))-0.5 xind(powind(1))-0.5],[0.8 1.8]);
                    set(powh,'LineWidth',2);
                    set(powh,'LineStyle','--');
                    set(powh,'Color',[1 0 1]);
                end
                
                for iii=1:length(xind)
                    if isfield(casedata.vr,'status')
                        if casedata.vr.status(iii)>0
                            text(ax3,xind(iii),1.6,'No conv');
                        end
                    end
                end
            end
            
            titlestr=['MANGRP: ' num2str(data.mangrp(1))];
            if isfield(data,'rodnr')
               titlestr=[titlestr ' RODNR: ' num2str(data.rodnr(1))]; 
            end
            title(ax1,titlestr);
            set(ax(2),'YLim',[0 100]);
            set(ax(1),'YLim',[0.8 1.8]);
            set(ax(1),'YTickMode','auto');
            ylabel(ax(1),'CPRMIN');
            ylabel(ax(2),'ROD Position');
            set(ax(1),'XTick',[]);
            set(ax(2),'XTick',xind);
            set(ax(2),'XTickLabel',data.pos);
            set(ax(2),'YTickMode','manual');
            rodticks=[0 20 40 60 80 100];
            set(ax(2),'YTick',rodticks);
            set(ax(2),'YTickLabel',100-rodticks);
            
            % Add SLMCPR-line
            slmcprh=line([xind(1)-1 xind(end)+1],[slmcpr slmcpr]);
            set(slmcprh,'LineWidth',2);
            set(slmcprh,'LineStyle','--');
            set(slmcprh,'Color',[1 0 0]);
            
            if mincpr_er < mincpr_vr
                map=vec2core_nan(min(casedata.er.cpr{mincpr_er_ind}),mminj);
                mincpr=mincpr_er;
                mincpr_ind=mincpr_er_ind;
                modstr='ER';
            else
                map=vec2core_nan(min(casedata.vr.cpr{mincpr_vr_ind}),mminj);
                mincpr=mincpr_vr;
                mincpr_ind=mincpr_vr_ind;
                modstr='VR';
            end
            pcolor(ax2,[[map nan(length(mminj),1)]; nan(1,length(mminj)+1)]);
            title(ax2,['CPR (min CPR = ' num2str(mincpr,'%1.2f') ') at rod position ' ...
                       num2str(data.pos(mincpr_ind),'%d') '% in ' modstr]);
            
            % Plot rod positions
            if isfield(data,'rodnr')
                rodc=crpos2knum(crnum2crpos(data.rodnr(1),mminj),mminj);
                rodpos=knum2cpos(rodc(1),mminj);
                axes(ax2);
                rectangle('Position',[rodpos(2) rodpos(1) 2 2],'LineWidth',2.5,'EdgeColor','white');
            else
                for r=1:length(grp.rodnrs)
                    rodc=crpos2knum(crnum2crpos(grp.rodnrs(r),mminj),mminj);
                    rodpos=knum2cpos(rodc(1),mminj);
                    axes(ax2);
                    rectangle('Position',[rodpos(2) rodpos(1) 2 2],'LineWidth',2.5,'EdgeColor','white');
                end
            end
        end
    end
end
