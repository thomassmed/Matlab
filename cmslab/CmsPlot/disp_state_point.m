function disp_state_point
%%
hfig=gcf;
cmsplot_prop=get(hfig,'userdata');
pos0=get(hfig,'position');
pos1=pos0;
pos1(3)=0.95*pos0(3);
pos1(4)=0.6*pos0(4);
hwin=figure('position',pos1);
set(hwin,'menubar','none');
axes('visible','off')

if ~isfield(cmsplot_prop,'Power'),
    cmsplot_prop.Power=ReadCore(cmsplot_prop.coreinfo,GetDistName(cmsplot_prop.coreinfo,'POWER'));
end


if strcmp(cmsplot_prop.filetype,'.hms'),
    n=12;
    sock=cmsplot_prop.sock;
    Qrel=pp2_command(sock,'do get_var2 HY_QREL');
    Qnom=pp2_command(sock,'do get_var2 HY_QNOM');
    Qtot=Qrel*Qnom;
    Wtot=pp2_command(sock,'do get_var2 HY_FLOTOT');
    Wnom=pp2_command(sock,'do get_var2 HY_RATFLO');
    Wrel=Wtot/Wnom;
    av_bur=pp2_command(sock,'do get_var2 BB_EMED');
    keff=pp2_command(sock,'do get_var2 BB_KEFF');
    Hinlet=pp2_command(sock,'do get_var2 HY_HFLOWP');
    tlp=pp2_command(sock,'do get_var2 HY_TLOWP');

    text(-0.05,(n-1)/n,'Power:');           text(0.5,(n-1)/n,sprintf('%8.2f %s',100*Qrel,'%'));
    text(-0.05,(n-2)/n,'Power:');           text(0.5,(n-2)/n,sprintf('%8i %s',round(Qtot/1e6),'MW'));
    text(-0.05,(n-3)/n,'Flow:');            text(0.5,(n-3)/n,sprintf('%8.2f %s',100*Wrel,'%'));
    text(-0.05,(n-4)/n,'Flow:');            text(0.5,(n-4)/n,sprintf('%8i %s',round(Wtot),'kg/s'));
    text(-0.05,(n-5)/n,'CRSUM:');           text(0.5,(n-5)/n,sprintf('%8i',sum(cmsplot_prop.konrod)));
    text(-0.05,(n-6)/n,'Average Burnup:');  text(0.5,(n-6)/n,sprintf('%8.2f',av_bur));
    text(-0.05,(n-7)/n,'FRAD:');            text(0.5,(n-7)/n,sprintf('%8.2f',mean(max(cmsplot_prop.Power))));
    text(-0.05,(n-8)/n,'PPF');              text(0.5,(n-8)/n,sprintf('%8.2f',max(max(cmsplot_prop.Power))));
    text(-0.05,(n-9)/n,'keff:');            text(0.5,(n-9)/n,sprintf('%8.5f',keff));
    text(-0.05,(n-10)/n,'Hinlet:');         text(0.5,(n-10)/n,sprintf('%8i %s',round(Hinlet/1e3),'kJ/kg'));
    text(-0.05,(n-11)/n,'Tinlet:');         text(0.5,(n-11)/n,sprintf('%8i %s',round(tlp),'C'));

else
    if strcmp(cmsplot_prop.filetype,'.res'),
        Oper = ReadCore(cmsplot_prop.coreinfo,'Oper',cmsplot_prop.state_point);
        burnup = ReadCore(cmsplot_prop.coreinfo,'burnup',cmsplot_prop.state_point);
        text(-0.05,1,cmsplot_prop.titcas);
        n=13;

        text(-0.05,(n-1)/n,'Power:');       text(0.5,(n-1)/n,sprintf('%8.2f %s',Oper.Qrel,'%'));
        text(-0.05,(n-2)/n,'Power:');       text(0.5,(n-2)/n,sprintf('%8i %s',round(Oper.Qtot/1e6),'MW'));
        text(-0.05,(n-3)/n,'Flow:');        text(0.5,(n-3)/n,sprintf('%8.2f %s',Oper.Wrel,'%'));
        text(-0.05,(n-4)/n,'Flow:');        text(0.5,(n-4)/n,sprintf('%8i %s',round(Oper.Wtot),'kg/s'));
        text(-0.05,(n-5)/n,'CRSUM:');       text(0.5,(n-5)/n,sprintf('%8i',sum(cmsplot_prop.konrod)));
        text(-0.05,(n-6)/n,'Average Burnup:');   text(0.5,(n-6)/n,sprintf('%8.2f',mean(mean(burnup))));
        text(-0.05,(n-7)/n,'FRAD:');        text(0.5,(n-7)/n,sprintf('%8.2f',mean(max(Oper.Power))));
        text(-0.05,(n-8)/n,'PPF');          text(0.5,(n-8)/n,sprintf('%8.2f',max(max(Oper.Power))));
        text(-0.05,(n-9)/n,'keff:');        text(0.5,(n-9)/n,sprintf('%8.5f',Oper.keff));
        text(-0.05,(n-10)/n,'Hinlet:');        text(0.5,(n-10)/n,sprintf('%8i %s',round(Oper.Hinlet),'kJ/kg'));
        text(-0.05,(n-11)/n,'Tinlet:');        text(0.5,(n-11)/n,sprintf('%8i %s',round(Oper.tlp),'C'));
        text(-0.05,(n-12)/n,'Tinlet:');        text(0.5,(n-12)/n,sprintf('%8i %s',round(Oper.tlp_F),'F'));
    
    else
        if strcmp(cmsplot_prop.filetype,'.sum')
            Oper=get_data_from_sumfile_summary(cmsplot_prop.coreinfo,cmsplot_prop.state_point);
    %    else
    %        Oper=cmsplot_prop.Oper;
        end
    
        if strcmp(cmsplot_prop.filetype,'.mat'),
            load(cmsplot_prop.filename,'Oper','fue_new','steady','stab');
            n=16;harm=0;
            if isfield(cmsplot_prop,'stabh'),
                harm=1;
                n=20;
            end
            text(-0.05,1,cmsplot_prop.titmat);
        else
            n=13;
            text(-0.05,1,cmsplot_prop.titcas);
        end

        text(-0.05,(n-1)/n,'Power:');       text(0.5,(n-1)/n,sprintf('%8.2f %s',Oper.Qrel,'%'));
        text(-0.05,(n-2)/n,'Power:');       text(0.5,(n-2)/n,sprintf('%8i %s',round(Oper.Qtot/1e6),'MW'));
        text(-0.05,(n-3)/n,'Flow:');        text(0.5,(n-3)/n,sprintf('%8.2f %s',Oper.Wrel,'%'));
        text(-0.05,(n-4)/n,'Flow:');        text(0.5,(n-4)/n,sprintf('%8i %s',round(Oper.Wtot),'kg/s'));
        text(-0.05,(n-5)/n,'CRSUM:');       text(0.5,(n-5)/n,sprintf('%8i',sum(cmsplot_prop.konrod)));
        text(-0.05,(n-6)/n,'Average Burnup:');   text(0.5,(n-6)/n,sprintf('%8.2f',mean(mean(fue_new.burnup))));
        text(-0.05,(n-7)/n,'FRAD:');        text(0.5,(n-7)/n,sprintf('%8.2f',max(mean(cmsplot_prop.Power))));
        text(-0.05,(n-8)/n,'PPF');          text(0.5,(n-8)/n,sprintf('%8.2f',max(max(cmsplot_prop.Power))));
        text(-0.05,(n-9)/n,'keff:');        text(0.5,(n-9)/n,sprintf('%8.5f',Oper.keff));
        text(-0.05,(n-10)/n,'Hinlet:');        text(0.5,(n-10)/n,sprintf('%8i %s',round(Oper.Hinlet),'kJ/kg'));
        text(-0.05,(n-11)/n,'Tinlet:');        text(0.5,(n-11)/n,sprintf('%8i %s',round(Oper.tlp),'C'));
        text(-0.05,(n-12)/n,'Tinlet:');        text(0.5,(n-12)/n,sprintf('%8i %s',round(Oper.tlp_F),'F'));
        if strcmp(cmsplot_prop.filetype,'.mat'),
            [dr,fd]=p2drfd(stab.lam);
            text(-0.05,(n-13)/n,'Matstab keff:');     text(0.5,(n-13)/n,sprintf('%8.5f',steady.keff));
            text(-0.05,(n-14)/n,'Decay ratio:');      text(0.5,(n-14)/n,sprintf('%8.4f',dr));
            text(-0.05,(n-15)/n,'Frequency:');        text(0.5,(n-15)/n,sprintf('%8.4f %s',fd,'Hz'));
            if harm,
                [drh,fdh]=p2drfd(cmsplot_prop.stab.lamh);
                text(-0.05,(n-16)/n,'Dr harmonic 1:');      text(0.5,(n-16)/n,sprintf('%8.4f',drh(1)));
                text(-0.05,(n-17)/n,'Freq harmonic 1:');        text(0.5,(n-17)/n,sprintf('%8.4f %s',fdh(1),'Hz'));
                text(-0.05,(n-18)/n,'Dr harmonic 2:');      text(0.5,(n-18)/n,sprintf('%8.4f',drh(2)));
                text(-0.05,(n-19)/n,'Freq harmonic 2:');        text(0.5,(n-19)/n,sprintf('%8.4f %s',fdh(2),'Hz'));
            end
        end
    end
end