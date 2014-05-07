% $Id: crwea_run.m 70 2013-08-19 12:48:53Z rdj $
function crwea_run(config,cases)

% Parameters used from config:
%   simfile
%   sekvfile
%   mangrpfile
%   resultfile
%   srcfile
%   options
%   symme
%   bursteps
%

%% Define some paths and filenames
% Should be fetched from config struct
resultfile=config.resultfile;
simfile=config.simfile;
bursteps=config.bursteps;
srcfile=config.srcfile;
options=config.options;
symme=config.symme;
press=config.press;


%% Generate unique id for this instance
id=datestr(now,'yyyymmdd_HHMM_SSFFF');

t_tot=0;

%% Load data from simfile
sim=load(simfile);

res=[];

%% Save base case data
for i=1:length(bursteps)
     
    initfile=strtrim(sim.filenames(bursteps(i),:));
    
    [initcprdist,mminj,conrod,~,hy,~,ks]=readdist7(initfile,'CPR');
    initlhgrdist=readdist7(initfile,'LHGR');
    
    fbur=['B_' num2str(sim.blist(bursteps(i)))];
    
    res.(fbur).burnup=sim.blist(bursteps(i));
    res.(fbur).power=100*hy(11);
    res.(fbur).hcflow=hy(2);
    res.(fbur).lhgrmax=hy(176);
    res.(fbur).cprmin=hy(179);
    res.(fbur).status=ks(70)+2*ks(72);
    if config.cpr_save
        if strcmp(config.cpr_dim,'2D') % Save only bundle min CPR
            res.(fbur).cpr=min(initcprdist);
        else
            res.(fbur).cpr=initcprdist;
        end
    end
    if config.lhgr_save
        if strcmp(config.lhgr_dim,'2D') % Save only bundle max LHGR
            res.(fbur).lhgr=max(initlhgrdist);
        else
            res.(fbur).lhgr=initlhgrdist;
        end
    end  
    res.(fbur).mminj=mminj;
    res.(fbur).conrod=conrod;
end
    

%% Run cases in cases struct array
for i=1:length(cases)
    tic;
    
    regmod=cases(i).regmod;
    
    burnup=cases(i).burnup;
    mangrp=cases(i).mangrp;
    rod=cases(i).rod;
    wd=cases(i).wd;
    
    if strcmp(regmod,'vr')
        if isempty(rod)
            compfile=['off/comp-crwea-vr-' id '-B' num2str(burnup) '-G' ...
                num2str(mangrp) '-W' num2str(wd) '.txt'];
        else
            compfile=['off/comp-crwea-vr-' id '-B' num2str(burnup) '-G' ...
                num2str(mangrp) '-R' num2str(rod) '-W' num2str(wd) '.txt'];
        end
    elseif strcmp(regmod,'er')
        if isempty(rod)
            compfile=['off/comp-crwea-er-' id '-B' num2str(burnup) '-G' ...
                num2str(mangrp) '-W' num2str(wd) '.txt'];
        else
            compfile=['off/comp-crwea-er-' id '-B' num2str(burnup) '-G' ...
                num2str(mangrp) '-R' num2str(rod) '-W' num2str(wd) '.txt'];
        end
    else
        error('run: Unknown control mode, should be ER or VR!');
    end
    savefile=['dist/crwea-dist-' id '.dat'];
 
    
    burfile=cases(i).burfile;
    xefile=cases(i).xefile;
    conrod=cases(i).conrod;
    ktarget=cases(i).keffref;
    power=cases(i).power;
    flow=cases(i).hcflow;
    tlowp=cases(i).tlowp;
    
    
    % Start running case
    fprintf(1,'Running case: %4.0f of %4.0f - Burnup: %4.0f EFPH Mangrp: %2.0f Rod: %d = %d%% in %s\n',...
        i,length(cases),burnup,mangrp,rod,wd,upper(regmod));

    crwea_run_polca(regmod,srcfile,options,compfile,burfile,xefile,...
        savefile,symme,conrod,ktarget,power,flow,tlowp,press);
    
    % Fetch results
    [~,~,~,bb,hy,~,ks]=readdist7(savefile);
    if config.cpr_save
        cprdist=readdist7(savefile,'CPR');
    end
    if config.lhgr_save
        lhgrdist=readdist7(savefile,'LHGR');
    end
    
    % Save results in struct
    fbur=['B_' num2str(burnup)];
    fgrp=['G_' num2str(mangrp)];
    frod=['R_' num2str(rod)];
    fwd=['W_' num2str(wd)];
   
    tmp.power=100*hy(11);
    tmp.hcflow=hy(2);
    tmp.tlowp=hy(14);
    tmp.xcu=hy(4);
    tmp.keff=bb(96);
    tmp.cprmin=hy(179);
    tmp.lhgrmax=hy(176);
    tmp.status=ks(70)+2*ks(72);  
    if config.cpr_save
        if strcmp(config.cpr_dim,'2D') % Save only bundle min CPR
            tmp.cpr=min(cprdist);
        else
            tmp.cpr=cprdist;
        end
    end
    if config.lhgr_save
        if strcmp(config.lhgr_dim,'2D') % Save only bundle max LHGR
            tmp.lhgr=max(lhgrdist);
        else
            tmp.lhgr=lhgrdist;
        end
    end

    if isempty(rod)
        res.(fbur).(fgrp).(regmod).(fwd)=tmp;
    else
        res.(fbur).(fgrp).(frod).(regmod).(fwd)=tmp;
    end
    
    save(resultfile,'res','-append');
    
    % Measure time
    t_case=toc;
    t_tot=t_tot+t_case;
    t_remain=(t_tot/i)*(length(cases)-i);
    
    [te_h,te_m,te_s]=sec2hms(t_tot);
    [tr_h,tr_m,tr_s]=sec2hms(t_remain);
    
    fprintf(1,'Case %4.0f / %4.0f completed in %1.2f s, elapsed time %02.0f:%02.0f:%02.0f, estimated time left %02.0f:%02.0f:%02.0f\n\n',...
        i,length(cases),t_case,te_h,te_m,te_s,tr_h,tr_m,tr_s);
end
