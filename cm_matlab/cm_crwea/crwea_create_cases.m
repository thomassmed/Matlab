% $Id: crwea_create_cases.m 70 2013-08-19 12:48:53Z rdj $
%
function [cases]=crwea_create_cases(config)

% Parameters used from config:
%   simfile
%   bursteps
%   dstep
%   run_er
%   run_vr
%   run_grps
%   run_rods
%
simfile=config.simfile;
bursteps=config.bursteps;
dstep=config.dstep;
run_er=config.run_er;
run_vr=config.run_vr;
max_initial_withdrawal=config.max_initial_withdrawal;

%% Load data from simfile
load(simfile);

%% Create mangrp vector
manvec=mgrp2vec(mangrpfile);

res=[];
cases=[];
icase=1;

%% Run calculations for the selected burnup steps
for i=1:length(bursteps)
    clear mangrps;
    [mangrps(:,1),mangrps(:,2)]=strread(strtrim(conrod(bursteps(i),:)),'%n=%n','delimiter',',');
    
    % Polca simulation are assumed to run with NOPOWEND option
    if bursteps(i)==1
        burfile=bocfile;
        powfile=strtrim(filenames(bursteps(1),:));
    else
        burfile=strtrim(filenames(bursteps(i)-1,:));
        powfile=strtrim(filenames(bursteps(i),:));
    end
    
    [~,~,~,bb]=readdist7(powfile);
    keffref=bb(96);
    
    %% Withdraw entire groups
    for n=1:size(mangrps,1)
        if find(mangrps(n,1)==config.grps)
            if mangrps(n,2)<max_initial_withdrawal
                res{i}.grp{n}.rodnrs=find(manvec==mangrps(n,1));
                
                steps=ceil((100-mangrps(n,2))/dstep);
                
                for d=0:steps
                    mangrpcase=mangrps;
                    mangrpcase(n,2)=min(100,round(mangrps(n,2)+d*dstep));
                    
                    % Run in VR
                    if run_vr==1
                        if d>0
                            cases(icase).mangrp=mangrpcase(n,1);
                            cases(icase).rod=[];
                            cases(icase).wd=mangrpcase(n,2);
                            cases(icase).regmod='vr';
                            cases(icase).burfile=burfile;
                            cases(icase).xefile=powfile;
                            cases(icase).conrod=mangrpcase;
                            cases(icase).keffref=keffref;
                            cases(icase).burnup=blist(bursteps(i));
                            cases(icase).power=str2double(pow(bursteps(i),:));
                            cases(icase).hcflow=str2double(hc(bursteps(i),:));
                            cases(icase).tlowp=str2double(tlowp(bursteps(i),:));
                            
                            icase=icase+1;
                        end
                    end
                    
                    % Run in ER
                    if run_er==1
                        if d>0
                            cases(icase).mangrp=mangrpcase(n,1);
                            cases(icase).rod=[];
                            cases(icase).wd=mangrpcase(n,2);
                            cases(icase).regmod='er';
                            cases(icase).burfile=burfile;
                            cases(icase).xefile=powfile;
                            cases(icase).conrod=mangrpcase;
                            cases(icase).keffref=keffref;
                            cases(icase).burnup=blist(bursteps(i));
                            cases(icase).power=str2double(pow(bursteps(i),:));
                            cases(icase).hcflow=str2double(hc(bursteps(i),:));
                            cases(icase).tlowp=str2double(tlowp(bursteps(i),:));
                            
                            icase=icase+1;
                        end
                    end
                end
            end
        end
    end
    
    
    %% Withdraw single rods
    crvec=100*ones(1,length(manvec));
    for ii=1:size(mangrps,1);
        rods=find(manvec==mangrps(ii,1));
        crvec(rods)=mangrps(ii,2)*ones(1,length(rods));
    end
    
    for n=1:size(mangrps,1)
        if mangrps(n,2)<max_initial_withdrawal
            steps=ceil((100-mangrps(n,2))/dstep);
            
            rods=find(manvec==mangrps(n,1));
            
            % Run for each rod in mangrp
            for r=1:length(rods)
                if find(rods(r)==config.rods)
                    crveccase=crvec;
                    
                    for d=0:steps
                        crveccase(rods(r))=min(100,round(mangrps(n,2)+d*dstep));
                        
                        % Run in VR
                        if run_vr==1
                            if d>0
                                cases(icase).mangrp=mangrps(n,1);
                                cases(icase).rod=rods(r);
                                cases(icase).wd=crveccase(rods(r));
                                cases(icase).regmod='vr';
                                cases(icase).burfile=burfile;
                                cases(icase).xefile=powfile;
                                cases(icase).conrod=crveccase;
                                cases(icase).keffref=keffref;
                                cases(icase).burnup=blist(bursteps(i));
                                cases(icase).power=str2double(pow(bursteps(i),:));
                                cases(icase).hcflow=str2double(hc(bursteps(i),:));
                                cases(icase).tlowp=str2double(tlowp(bursteps(i),:));
                                
                                icase=icase+1;
                            end
                        end
                        
                        % Run in ER
                        if run_er==1
                            if d>0
                                cases(icase).mangrp=mangrps(n,1);
                                cases(icase).rod=rods(r);
                                cases(icase).wd=crveccase(rods(r));
                                cases(icase).regmod='er';
                                cases(icase).burfile=burfile;
                                cases(icase).xefile=powfile;
                                cases(icase).conrod=crveccase;
                                cases(icase).keffref=keffref;
                                cases(icase).burnup=blist(bursteps(i));
                                cases(icase).power=str2double(pow(bursteps(i),:));
                                cases(icase).hcflow=str2double(hc(bursteps(i),:));
                                cases(icase).tlowp=str2double(tlowp(bursteps(i),:));
                                
                                icase=icase+1;
                            end
                        end
                    end
                end
            end
        end
    end
end
