classdef cax < handle
    properties
        isym
        npst
        cn
        point_nr
        caxfile
        Nburnup
        burnup
        kinf
        pow
        powl
        cornerlimit
        plr
        plrlimit
        exp
        lfu
        lpi
        fue
        pin
        pin1
        pin2
        pin3
        pin4
        pin5
        pin6
        sla1
        sla2
        sla3
        sla4
        sla5
        crd1
        crd2
        crd3
        crd4
        crd5
        bwr
        bwr_card
        pwr
        sim
        title
        pde
        sla
        spa
        crd
        dep
        gam
        nli
        hO1
        wri
        lst
        sta
        end1
        nr_fue
        nr_ba
        nr_pin
        nr_sla
        nr_crd
        %        nr_rod
        nr_enr
        enr
        rodenr
        rodba
        rod
        rodtype
        ba
        balimit
        ag
        Nlfu
        fint
        fint_crd
        fintl
        axial_zone
        oldenr
        oldpow
        oldba
        oldfint
        oldexp
        caifile
        
        btf
        maxbtf
        btf_env
        maxbtf_env
        btfaxw_env
        btfaxw
        fintp
        powp
        tmol
        type
        u235
        gUm
        gU
        standard_u235
        standard_ba
        maxfint_tab
        finttab
        max_burnup
        corner_rod
        ba_tmol
        corner_tmol
        plr_tmol
        aut_ba
        aut_balimit
        sel_rods
        sel_rods_limit
        bor
        tfu
        tmo
        voi
        channel_bow
        old_channel_bow
        burnup_crd;
        Nburnup_crd;
        kinf_crd;
        pow_crd;
        btf_crd;
        btfaxw_crd;
        btf_env_crd;
        btfaxw_env_crd;
        maxbtf_crd;
        maxbtf_env_crd;
        crd_read
        first
    end
    
    methods
        
        function  obj = cax(cn)
            obj.cn=cn;
            obj.caxfile=[];
            obj.caifile=[];
            obj.channel_bow= 0;
            obj.old_channel_bow= 0;
            obj.crd_read=0;
            obj.first=1;
        end
        
        %________________________________________________
        %   Read caxfile                                 |
        %________________________________________________|
        
        function readcaxfile(obj,file)
            obj.caxfile=file;
            fid = fopen(obj.caxfile,'r');
            TEXT = textscan(fid,'%s','delimiter','\n');
            TEXT = TEXT{1};
            fclose(fid);
            
            iCRD=find(~cellfun('isempty',regexp(TEXT,'^*I CRD')));
            iTIT=find(~cellfun('isempty',regexp(TEXT,'TIT                  ')));
            iREA=find(~cellfun('isempty',regexp(TEXT,'REA                  ')));
            iPOW=find(~cellfun('isempty',regexp(TEXT,'GPO                  ')));
            if isempty(iPOW)
                iPOW=find(~cellfun('isempty',regexp(TEXT,'POW                  ')));
            end
            
            a=0:1:20;
            b=22.5:2.5:70;
            obj.burnup=cat(2,a,b);
            
            if(~isnan(iCRD))
                obj.crd_read=1;
                iTITCRD=iTIT(find(iTIT>iCRD));
                iREACRD=iREA(find(iTIT>iCRD));
                iPOWCRD=iPOW(find(iTIT>iCRD));
                
                % Read burnup and kinf
                Nburnup_cax = length(find(iTIT<iCRD));
                Nburnup_cax_crd = length(iTIT)-length(find(iTIT<iCRD));
                
                burnup_cax_crd  = nan(Nburnup_cax_crd,1);
                kinf_cax_crd    = nan(Nburnup_cax_crd,1);
                pow_cax_crd = nan(obj.npst,obj.npst,Nburnup_cax_crd);
                
                obj.burnup_crd=cat(2,a,b);
                obj.Nburnup_crd=length(obj.burnup);
                obj.kinf_crd=nan(obj.Nburnup_crd,1);
                obj.pow_crd = nan(obj.npst,obj.npst,obj.Nburnup_crd);
                
                for i=1:Nburnup_cax_crd
                    burnup_cax_crd(i) = sscanf(TEXT{iTITCRD(i)+2}(1:5),'%f');
                    kinf_cax_crd(i)   = sscanf(TEXT{iREACRD(i)+1}(1:7),'%f');
                end
                
                % Read radiell cax crd power distribution
                for m=1:Nburnup_cax_crd
                    pow_cax_crd(:,:,m) = CasMapCell2Mat(ReadCasMap(TEXT(iPOWCRD(m)+2:iPOWCRD(m)+1+obj.npst)));
                end
                obj.pow_crd=caxinterp1(burnup_cax_crd,pow_cax_crd,obj.burnup,'cubic');
                obj.kinf_crd=interp1(burnup_cax_crd,kinf_cax_crd,obj.burnup,'cubic');
                
            else
                Nburnup_cax = length(iTIT);
            end
            
            % Read burnup and kinf
            burnup_cax  = nan(Nburnup_cax,1);
            kinf_cax    = nan(Nburnup_cax,1);
            pow_cax = nan(obj.npst,obj.npst,Nburnup_cax);
            
            
            obj.Nburnup=length(obj.burnup);
            obj.kinf=nan(obj.Nburnup,1);
            obj.pow = nan(obj.npst,obj.npst,obj.Nburnup);
            
            
            for i=1:Nburnup_cax
                burnup_cax(i) = sscanf(TEXT{iTIT(i)+2}(1:5),'%f');
                kinf_cax(i)   = sscanf(TEXT{iREA(i)+1}(1:7),'%f');
            end
            
            % Read radiell cax power distribution
            for m=1:Nburnup_cax
                pow_cax(:,:,m) = CasMapCell2Mat(ReadCasMap(TEXT(iPOW(m)+2:iPOW(m)+1+obj.npst)));
            end
            obj.pow=caxinterp1(burnup_cax,pow_cax,obj.burnup,'cubic');
            obj.kinf=interp1(burnup_cax,kinf_cax,obj.burnup,'cubic');
            
            
            % Calculate inital radial burnup distribution
            obj.oldexp = nan(obj.npst,obj.npst,obj.Nburnup);
            obj.exp = nan(obj.npst,obj.npst,obj.Nburnup);
            for i=1:obj.npst
                for j=1:obj.npst
                    obj.oldexp(i,j,1)=0;
                    obj.exp(i,j,1)=0;
                end
            end
            for m=2:obj.Nburnup
                z=0;
                k=1;
                dbur=obj.burnup(m)-obj.burnup(m-1);
                for j=1:obj.npst
                    z=z+1;
                    for i=z:obj.npst
                        obj.oldexp(i,j,m)=obj.oldexp(i,j,m-1)+obj.pow(i,j,m)*dbur;
                    end
                    k=k+6;
                end
            end
            % CPU time save
            obj.exp = obj.oldexp;
            
        end
        
        
        %________________________________________________
        %   Calculate radial burnup distribution         |                             |
        %________________________________________________|
        
        function calcexp(obj)
            
            %obj.exp = nan(obj.npst,obj.npst,obj.Nburnup);
            for i=1:obj.npst
                for j=1:obj.npst
                    obj.exp(i,j,1)=0;
                end
            end
            for m=2:obj.Nburnup
                z=0;
                k=1;
                dbur=obj.burnup(m)-obj.burnup(m-1);
                for j=1:obj.npst
                    z=z+1;
                    for i=z:obj.npst
                        obj.exp(i,j,m)=obj.exp(i,j,m-1)+obj.pow(i,j,m)*dbur;
                    end
                    k=k+6;
                end
            end
            
            % Expand half sym to full sym
            for m=2:obj.Nburnup
                if (obj.isym==2)
                    for i=1:obj.npst
                        for j=1:obj.npst
                            obj.exp(i,j,m) = obj.exp(j,i,m);
                        end
                    end
                end
            end
            
        end
        
        %________________________________________________
        %   Read casmo input file, caifile               |
        %________________________________________________|
        
        function readcaifile(obj,file)
            
            
            if (strfind(file,'inp'))
                obj.caifile = file;
                obj.caxfile = strrep(file,'inp','cax');
                fid = fopen(obj.caifile,'r');
            else
                obj.caxfile = file;
                obj.caifile = strrep(file,'cax','inp');
                fid = fopen(obj.caxfile,'r');
            end
            
            TEXT = textscan(fid,'%s','delimiter','\n');
            TEXT = TEXT{1};
            fclose(fid);
            
            iBWR=find(~cellfun('isempty',regexp(TEXT,'^BWR ')));
            iLFU=find(~cellfun('isempty',regexp(TEXT,'^LFU')));
            iLPI=find(~cellfun('isempty',regexp(TEXT,'^LPI')));
            iFUE=find(~cellfun('isempty',regexp(TEXT,'^FUE')));
            iTTL=find(~cellfun('isempty',regexp(TEXT,'^TTL')));
            iSIM=find(~cellfun('isempty',regexp(TEXT,'^SIM')));
            iPDE=find(~cellfun('isempty',regexp(TEXT,'^PDE')));
            iPIN=find(~cellfun('isempty',regexp(TEXT,'^PIN')));
            iSLA=find(~cellfun('isempty',regexp(TEXT,'^SLA')));
            iSPA=find(~cellfun('isempty',regexp(TEXT,'^SPA')));
            iCRD=find(~cellfun('isempty',regexp(TEXT,'^CRD')));
            iGAM=find(~cellfun('isempty',regexp(TEXT,'^GAM ')));
            iNLI=find(~cellfun('isempty',regexp(TEXT,'^NLI')));
            iWRI=find(~cellfun('isempty',regexp(TEXT,'^WRI')));
            iLST=find(~cellfun('isempty',regexp(TEXT,'^LST')));
            iSTA=find(~cellfun('isempty',regexp(TEXT,'^STA')));
            iEND=find(~cellfun('isempty',regexp(TEXT,'^END')));
            iPWR=find(~cellfun('isempty',regexp(TEXT,'^PWR ')));
            iBOR=find(~cellfun('isempty',regexp(TEXT,'^BOR ')));
            iTMO=find(~cellfun('isempty',regexp(TEXT,'^TMO ')));
            iTFU=find(~cellfun('isempty',regexp(TEXT,'^TFU ')));
            iHO1=find(~cellfun('isempty',regexp(TEXT,'^HO1 ')));
            iVOI=find(~cellfun('isempty',regexp(TEXT,'^VOI ')));
            
            
            % BWR or PWR card
            
            if ~isempty(iBWR),
                obj.bwr = sscanf(TEXT{iBWR(1)}(4:end),'%g');
                %Then fix the second part
                islash=strfind(TEXT{iBWR(1)},'/');
                if ~isempty(islash),
                    bwr2=sscanf(TEXT{iBWR(1)}(islash(1)+1:end),'%g');
                else
                    bwr2=[];
                end
                %TODO: bwr2=set_defaults(bwr2,[obj.bwr(4);0;2*pinradius]);
                % Only if GE11 bundle
                obj.bwr=set_defaults(obj.bwr,[obj.bwr(1:6);0;2]);
                obj.bwr=[obj.bwr;bwr2];
                obj.isym = obj.bwr(8);
                obj.npst = obj.bwr(1);
            else
                obj.pwr = sscanf(TEXT{iPWR(1)}(4:end),'%g');
                obj.isym = obj.pwr(8);
                obj.npst = obj.pwr(1);
                if (obj.isym==8 || obj.isym==4)
                    obj.npst = round(obj.npst/2);
                end
            end
            
            
            
            
            % lfu & lpi
            obj.lfu = CasMapCell2Mat(ReadCasMap(TEXT(iLFU(1)+1:iLFU(1)+obj.npst)));
            obj.lpi = CasMapCell2Mat(ReadCasMap(TEXT(iLPI(1)+1:iLPI(1)+obj.npst)));
            
            % FUE
            obj.nr_fue=length(find(iFUE<50));
            obj.fue=nan(obj.nr_fue,5);
            for i=1:obj.nr_fue
                s = sscanf(TEXT{iFUE(i)}, '%*s %i %f %*c %f %i %*c %f', [1,inf]);
                obj.fue(i,1:length(s)) = s;
            end
            
            % Number of BA rod types
            obj.nr_ba = 0;
            for i=1:obj.nr_fue
                if (obj.fue(i,5) > 0)
                    obj.nr_ba = obj.nr_ba + 1;
                end
            end
            
            % PIN
            obj.nr_pin=length(find(iPIN<500));
            obj.pin=nan(obj.nr_pin,4);
            for i=1:obj.nr_pin
                s = sscanf(TEXT{iPIN(i)}, '%*s %i %f %f %f', [1,inf]);
                obj.pin(i,1:length(s)) = s;
            end
            
            for i=1:obj.nr_pin
                if (i == 1)
                    s = sscanf(TEXT{iPIN(i)}, '%c',[1,inf]);
                    obj.pin1 = nan(length(s));
                    obj.pin1 = s;
                end
                if (i == 2)
                    s = sscanf(TEXT{iPIN(i)}, '%c',[1,inf]);
                    obj.pin2 = nan(length(s));
                    obj.pin2 = s;
                end
                if (i == 3)
                    s = sscanf(TEXT{iPIN(i)}, '%c',[1,inf]);
                    obj.pin3 = nan(length(s));
                    obj.pin3 = s;
                end
                if (i == 4)
                    s = sscanf(TEXT{iPIN(i)}, '%c',[1,inf]);
                    obj.pin4 = nan(length(s));
                    obj.pin4 = s;
                end
                if (i == 5)
                    s = sscanf(TEXT{iPIN(i)}, '%c',[1,inf]);
                    obj.pin5 = nan(length(s));
                    obj.pin5 = s;
                end
                if (i == 6)
                    s = sscanf(TEXT{iPIN(i)}, '%c',[1,inf]);
                    obj.pin6 = nan(length(s));
                    obj.pin6 = s;
                end
            end
            
            % SLA
            obj.nr_sla =length(find(iSLA<60));
            obj.crd=nan(obj.nr_sla,4);
            for i=1:obj.nr_sla
                s = sscanf(TEXT{iSLA(i)}, '%*s %i %f %f %f', [1,inf]);
                obj.sla(i,1:length(s)) = s;
            end
            
            for i=1:obj.nr_sla
                if (i == 1)
                    s = sscanf(TEXT{iSLA(i)}, '%c',[1,inf]);
                    obj.sla1 = nan(length(s));
                    obj.sla1 = s;
                end
                if (i == 2)
                    s = sscanf(TEXT{iSLA(i)}, '%c',[1,inf]);
                    obj.sla2 = nan(length(s));
                    obj.sla2 = s;
                end
                if (i == 3)
                    s = sscanf(TEXT{iSLA(i)}, '%c',[1,inf]);
                    obj.sla3 = nan(length(s));
                    obj.sla3 = s;
                end
                if (i == 4)
                    s = sscanf(TEXT{iSLA(i)}, '%c',[1,inf]);
                    obj.sla4 = nan(length(s));
                    obj.sla4 = s;
                end
                if (i == 5)
                    s = sscanf(TEXT{iSLA(i)}, '%c',[1,inf]);
                    obj.sla5 = nan(length(s));
                    obj.sla5 = s;
                end
                
            end
            
            % CRD
            
%             if (~isempty(iCRD))
%                 obj.nr_crd =length(find(iCRD<60));
%                 obj.crd=nan(obj.nr_crd,6);
%                 for i=1:obj.nr_crd
%                     s = sscanf(TEXT{iCRD(i)}, '%*s %f %f %f %f %f %f', [1,inf]);
%                     obj.crd(i,1:length(s)) = s;
%                 end
%                 
%                 for i=1:obj.nr_crd
%                     if (i == 1)
%                         s = sscanf(TEXT{iCRD(i)}, '%c',[1,inf]);
%                         obj.crd1 = nan(length(s));
%                         obj.crd1 = s;
%                     end
%                     if (i == 2)
%                         s = sscanf(TEXT{iCRD(i)}, '%c',[1,inf]);
%                         obj.crd2 = nan(length(s));
%                         obj.crd2 = s;
%                     end
%                     if (i == 3)
%                         s = sscanf(TEXT{iCRD(i)}, '%c',[1,inf]);
%                         obj.crd3 = nan(length(s));
%                         obj.crd3 = s;
%                     end
%                     if (i == 4)
%                         s = sscanf(TEXT{iCRD(i)}, '%c',[1,inf]);
%                         obj.crd4 = nan(length(s));
%                         obj.crd4 = s;
%                     end
%                     if (i == 5)
%                         s = sscanf(TEXT{iCRD(i)}, '%c',[1,inf]);
%                         obj.crd5 = nan(length(s));
%                         obj.crd5 = s;
%                     end
%                 end
%             end


            if (~isempty(iCRD))
                s = sscanf(TEXT{iCRD(1)}, '%c',[1,inf]);
                length(s);
                obj.crd = nan(length(s));
                obj.crd = s;
            end
            
            s = sscanf(TEXT{iTTL(1)}, '%c',[1,inf]);
            length(s);
            obj.title = nan(length(s));
            obj.title = s;
            
            s = sscanf(TEXT{iSIM(1)}, '%c',[1,inf]);
            length(s);
            obj.sim = nan(length(s));
            obj.sim = s;
            
            s = sscanf(TEXT{iPDE(1)}, '%c',[1,inf]);
            length(s);
            obj.pde = nan(length(s));
            obj.pde = s;
            
            
            %             obj.nr_pin=length(find(iPIN<500));
            
            
            
            if(iSPA(1) < iEND)
                s = sscanf(TEXT{iSPA(1)}, '%c',[1,inf]);
                length(s);
                obj.spa = nan(length(s));
                obj.spa = s;
            else
                obj.spa='SPA';
            end
            
            if (~isempty(iGAM))
                s = sscanf(TEXT{iGAM(1)}, '%c',[1,inf]);
                length(s);
                obj.gam = nan(length(s));
                obj.gam = s;
            end
            
            
            if (~isempty(iNLI))
                s = sscanf(TEXT{iNLI(1)}, '%c',[1,inf]);
                length(s);
                obj.nli = nan(length(s));
                obj.nli = s;
            end
            
            
            if (~isempty(iWRI))
                s = sscanf(TEXT{iWRI(1)}, '%c',[1,inf]);
                length(s);
                obj.wri = nan(length(s));
                obj.wri = s;
            end
            
            if (~isempty(iLST))
                s = sscanf(TEXT{iLST(1)}, '%c',[1,inf]);
                length(s);
                obj.lst = nan(length(s));
                obj.lst = s;
            end
            
            if (~isempty(iBOR))
                s = sscanf(TEXT{iBOR(1)}, '%c',[1,inf]);
                length(s);
                obj.bor = nan(length(s));
                obj.bor = s;
            end
            
            if (~isempty(iTFU))
                s = sscanf(TEXT{iTFU(1)}, '%c',[1,inf]);
                length(s);
                obj.tfu = nan(length(s));
                obj.tfu = s;
            end
            
            if (~isempty(iTMO))
                s = sscanf(TEXT{iTMO(1)}, '%c',[1,inf]);
                length(s);
                obj.tmo = nan(length(s));
                obj.tmo = s;
            end
            
            if (~isempty(iVOI))
                s = sscanf(TEXT{iVOI(1)}, '%c',[1,inf]);
                length(s);
                obj.voi = nan(length(s));
                obj.voi = s;
            end
            
            if (~isempty(iHO1))
                s = sscanf(TEXT{iHO1(1)}, '%c',[1,inf]);
                length(s);
                obj.hO1 = nan(length(s));
                obj.hO1 = s;
            end
            
            if (~isempty(iBWR))
                s = sscanf(TEXT{iBWR(1)}, '%c',[1,inf]);
                length(s);
                obj.bwr_card = nan(length(s));
                obj.bwr_card = s;
            end
            
            s = sscanf(TEXT{iSTA(1)}, '%c',[1,inf]);
            length(s);
            obj.sta = nan(length(s));
            obj.sta = s;
            
            
            s = sscanf(TEXT{iEND(1)}, '%c',[1,inf]);
            length(s);
            obj.end1 = nan(length(s));
            obj.end1 = s;
            
            
            
        end
        
        
        %________________________________________________
        %  Post processing of read cax data              |
        %________________________________________________|
        
        function init(obj)
            
            obj.point_nr=1;
            
            % Radiell U235
            obj.enr = nan(obj.npst,obj.npst);
            for i=1:obj.npst
                for j=1:obj.npst
                    x=isnan(obj.lfu(i,j));
                    if(x == 0)
                        if(obj.lfu(i,j) > 0)
                            for k=1:obj.nr_fue
                                if (obj.lfu(i,j) == obj.fue(k,1))
                                    k1=k;
                                    break;
                                end
                            end
                            obj.enr(i,j) = obj.fue(k1,3);
                        else
                            obj.enr(i,j) = 0;
                        end
                    end
                end
            end
            obj.oldenr = obj.enr;
            
            % Save old radial pin power
            obj.oldpow = obj.pow;
            
            % Save old fint
            obj.oldfint = squeeze(max(max(obj.oldpow)));
            
            % Radial BA
            obj.ba = nan(obj.npst,obj.npst);
            for i=1:obj.npst
                for j=1:obj.npst
                    x=isnan(obj.lfu(i,j));
                    if(x == 0)
                        if(obj.lfu(i,j) > 0)
                            for k=1:obj.nr_fue
                                if (obj.lfu(i,j) == obj.fue(k,1))
                                    k1=k;
                                    break;
                                end
                            end
                            y=isnan(obj.fue(k1,4));
                            if(y==0)
                                obj.ba(i,j) = obj.fue(k1,5);
                            else
                                obj.ba(i,j) = 0;
                            end
                        else
                            obj.ba(i,j) = 0;
                        end
                    end
                end
            end
            %Save old ba
            obj.oldba = obj.ba;
            
            % Number of pin neihbours
            
            if (obj.isym==8)
                for i=1:obj.npst
                    for j=1:obj.npst
                        
                        if ((i==obj.npst) && (j==obj.npst))
                            obj.ag(i,j) = 3;
                        elseif ((i==1 && j==obj.npst))
                            obj.ag(i,j) = 5;
                        elseif ((j==1 && i==obj.npst))
                            obj.ag(i,j) = 5;
                        elseif ((j==obj.npst))
                            obj.ag(i,j) = 5;
                        elseif ((i==obj.npst))
                            obj.ag(i,j) = 5;
                        else
                            obj.ag(i,j) = 8;
                        end
                    end
                end
            else
                for i=1:obj.npst
                    for j=1:obj.npst
                        
                        if ((i==1) && (j==1))
                            obj.ag(i,j) = 3;
                        elseif ((i==1) && (j==obj.npst))
                            obj.ag(i,j) = 3;
                        elseif ((i==obj.npst) && (j==1))
                            obj.ag(i,j) = 3;
                        elseif ((i==obj.npst) && (j==obj.npst))
                            obj.ag(i,j) = 3;
                        elseif ((i==1))
                            obj.ag(i,j) = 5;
                        elseif ((j==1))
                            obj.ag(i,j) = 5;
                        elseif ((j==obj.npst))
                            obj.ag(i,j) = 5;
                        elseif ((i==obj.npst))
                            obj.ag(i,j) = 5;
                        else
                            obj.ag(i,j) = 8;
                        end
                    end
                end
            end
            
            
            % Expand half sym to full sym
            obj.Nlfu = 0;
            if (obj.isym==2)
                for i=1:obj.npst
                    for j=1:obj.npst
                        obj.enr(i,j) = obj.enr(j,i);
                        obj.oldenr(i,j) = obj.oldenr(j,i);
                        obj.lfu(i,j) = obj.lfu(j,i);
                        obj.lpi(i,j) = obj.lpi(j,i);
                        obj.ba(i,j)  = obj.ba(j,i);
                    end
                end
                for i=1:obj.npst
                    for j=1:obj.npst
                        if (obj.enr(i,j) > 0)
                            obj.Nlfu=obj.Nlfu+1;
                        end
                    end
                end
                for k=1:obj.Nburnup
                    obj.pow(:,:,k) = SetSym(obj.pow(:,:,k));
                    obj.oldexp(:,:,k) = SetSym(obj.oldexp(:,:,k));
                    obj.exp(:,:,k) =  SetSym(obj.exp(:,:,k));
                    obj.oldpow(:,:,k) = SetSym(obj.oldpow(:,:,k));
                end
            end
            
            if (obj.isym==8)
                for i=1:obj.npst
                    for j=1:obj.npst
                        obj.enr(i,j) = obj.enr(j,i);
                        obj.oldenr(i,j) = obj.oldenr(j,i);
                        obj.lfu(i,j) = obj.lfu(j,i);
                        obj.lpi(i,j) = obj.lpi(j,i);
                        obj.ba(i,j)  = obj.ba(j,i);
                    end
                end
                for i=1:obj.npst
                    for j=1:obj.npst
                        if (obj.enr(i,j) > 0)
                            if (i == 1 && j == 1)
                                obj.Nlfu=obj.Nlfu+1;
                            elseif (i == 1 || j == 1)
                                obj.Nlfu=obj.Nlfu+2;
                            else
                                obj.Nlfu=obj.Nlfu+4;
                            end
                        end
                    end
                end
                for k=1:obj.Nburnup
                    obj.pow(:,:,k) = SetSym(obj.pow(:,:,k));
                    obj.oldexp(:,:,k) = SetSym(obj.oldexp(:,:,k));
                    obj.exp(:,:,k) =  SetSym(obj.exp(:,:,k));
                    obj.oldpow(:,:,k) = SetSym(obj.oldpow(:,:,k));
                end
            end
            
            
            
            
            % Fint
            obj.fint  = squeeze(max(max(obj.pow)));
            if(~isempty(obj.pow_crd))
                obj.fint_crd  = squeeze(max(max(obj.pow_crd)));
            end
            
            % volume fuel/axial length
            gsum=0;
            for i=1:obj.npst
                for j=1:obj.npst
                    if (obj.enr(i,j) > 0)
                        lpinr=obj.lpi(i,j);
                        
                        for k=1:obj.nr_fue
                            if (obj.lfu(i,j) == obj.fue(k,1))
                                k1=k;
                                break;
                            end
                        end
                        fuenr = k1;
                        dens = obj.fue(fuenr,2);
                        g=obj.pin(lpinr,2)^2*pi*dens;
                        gsum=g+gsum;
                    end
                end
            end
            obj.gUm=gsum;
            
            obj.btfaxw_env = zeros(obj.npst);
            obj.fintp = zeros(obj.npst);
            obj.powp = zeros(obj.npst);
%             obj.tmol = zeros(obj.npst);
            obj.rodenr = zeros(obj.npst);
            obj.rodba = zeros(obj.npst);
            obj.rodtype = zeros(obj.npst);
            
            if(obj.first==1)
                obj.first=0;
                obj.tmol = zeros(obj.npst);
                obj.aut_balimit = zeros(obj.npst,obj.npst,obj.Nburnup);
                obj.sel_rods_limit = zeros(obj.npst,obj.npst,obj.Nburnup);
                obj.cornerlimit=1;
                obj.plrlimit=1;
                obj.balimit=1;
            end
            
            obj.corner_rod = zeros(obj.npst);
            obj.corner_rod(obj.npst,obj.npst) = 1;
            obj.corner_rod(1,obj.npst) = 1;
            obj.corner_rod(obj.npst,1) = 1;
            obj.corner_rod(1,1) = 1;
            obj.powl = zeros(obj.npst,obj.npst,obj.Nburnup);
            obj.plr = zeros(obj.npst);
            %             obj.aut_balimit = zeros(obj.npst,obj.npst,obj.Nburnup);
            %             obj.sel_rods_limit = zeros(obj.npst,obj.npst,obj.Nburnup);
            %             obj.cornerlimit=1;
            %             obj.plrlimit=1;
            %             obj.balimit=1;
            obj.ba_tmol=0;
            obj.plr_tmol=0;
            obj.corner_tmol=0;
            obj.aut_ba=0;
            obj.sel_rods=0;
            obj.fintl = zeros(obj.Nburnup,1);
            obj.max_burnup=30;
            obj.number_enrichments();
        end
        
        
        %____________________________________________________________________
        %  Perturbation pin power model for U235 rods (automatic optimizing) |
        %____________________________________________________________________|
        
        function smallcalc(obj)
            
            % Perturbation modell for U235 rods
            for k=1:obj.Nburnup
                for i=1:obj.npst
                    for j=1:obj.npst
                        c2 = -0.01973*obj.oldenr(i,j)^2+0.1677*obj.oldenr(i,j)-0.4557;
                        kk = 10^((0.008403*obj.enr(i,j)+c2)*obj.burnup(k)/obj.ag(i,j));
                        dpow=(obj.oldpow(i,j,k)*(-0.9125*obj.enr(i,j)^2+22.56*obj.enr(i,j)+9.937)/ ...
                            (-0.9125*obj.oldenr(i,j)^2+22.56*obj.oldenr(i,j)+9.937) - obj.oldpow(i,j,k))*kk;
                        obj.pow(i,j,k) = obj.oldpow(i,j,k)+dpow;
                    end
                end
            end
            
            % Normalize
            
            
            if (obj.isym==2)
                for k=1:obj.Nburnup
                    sum=0;
                    for i=1:obj.npst
                        for j=1:obj.npst
                            sum = sum + obj.pow(i,j,k);
                        end
                    end
                    for i=1:obj.npst
                        for j=1:obj.npst
                            obj.pow(i,j,k) = obj.pow(i,j,k)/sum*obj.Nlfu;
                        end
                    end
                end
            end
            
            
            
            if (obj.isym==8)
                for k=1:obj.Nburnup
                    sum=0;
                    for i=1:obj.npst
                        for j=1:obj.npst
                            if (obj.enr(i,j) > 0)
                                if (i == 1 && j == 1)
                                    sum = sum + obj.pow(i,j,k);
                                elseif (i == 1 || j == 1)
                                    sum = sum + 2*obj.pow(i,j,k);
                                else
                                    sum = sum + 4*obj.pow(i,j,k);
                                end
                            end
                        end
                    end
                    for i=1:obj.npst
                        for j=1:obj.npst
                            obj.pow(i,j,k) = obj.pow(i,j,k)/sum*obj.Nlfu;
                        end
                    end
                end
            end
            
            
            
            %             if (obj.isym==8)
            %                 for k=1:obj.Nburnup
            %                     sum=0;
            %                     for i=1:obj.npst
            %                         for j=1:obj.npst
            %                             sum = sum + obj.pow(i,j,k);
            %                             if (i ~= 1 || j ~= 1)
            %                                 sum = sum + obj.pow(i,j,k);
            %                             end
            %                         end
            %                     end
            %                     for i=1:obj.npst
            %                         for j=1:obj.npst
            %                             obj.pow(i,j,k) = obj.pow(i,j,k)/sum*obj.Nlfu;
            %                         end
            %                     end
            %                 end
            %             end
            
            obj.fint=squeeze(max(max(obj.pow)));
            
        end
        
        
        %______________________________________________________
        %  Perturbation pin power model for U235 and BA rods   |
        %______________________________________________________|
        
        function bigcalc(obj)
            
            % Perturbation modell for U235 rods
            for k=1:obj.Nburnup
                for i=1:obj.npst
                    for j=1:obj.npst
                        % U235 rods
                        if (obj.ba(i,j) == 0 && obj.oldba(i,j) == 0 || obj.ba(i,j) == obj.oldba(i,j))
                            c2 = -0.01973*obj.oldenr(i,j)^2+0.1677*obj.oldenr(i,j)-0.4557;
                            kk = 10^((0.008403*obj.enr(i,j)+c2)*obj.burnup(k)/obj.ag(i,j));
                            dpow=(obj.oldpow(i,j,k)*(-0.9125*obj.enr(i,j)^2+22.56*obj.enr(i,j)+9.937)/ ...
                                (-0.9125*obj.oldenr(i,j)^2+22.56*obj.oldenr(i,j)+9.937) - obj.oldpow(i,j,k))*kk;
                            obj.pow(i,j,k) = obj.oldpow(i,j,k)+dpow;
                            % BA rods
                        elseif (obj.ba(i,j) > 0 && obj.oldba(i,j) > 0)
                            % point 0
                            % Relative new power
                            k1 =  0.0005 + 0.00185*obj.enr(i,j);
                            k2 = -0.0065 - 0.0184*obj.enr(i,j);
                            k3 =  0.17 + 0.133*obj.enr(i,j);
                            rpow0 = k1*obj.ba(i,j)^ 2+ k2*obj.ba(i,j) + k3;
                            % Relative old power
                            k1 =  0.0005 + 0.00185*obj.oldenr(i,j);
                            k2 = -0.0065 - 0.0184*obj.oldenr(i,j);
                            k3 =  0.17 + 0.133*obj.oldenr(i,j);
                            roldpow0 = k1*obj.oldba(i,j)^2 + k2*obj.oldba(i,j) + k3;
                            % Power change
                            dpow0 = rpow0 - roldpow0;
                            % New Power
                            pow0 = obj.oldpow(i,j,1) + dpow0;
                            
                            % Point 1
                            dep1 = 2*obj.ba(i,j);
                            % Relative new power
                            a1 = -0.0000444*obj.ba(i,j)^2 + 0.0005768*obj.ba(i,j) - 0.008484;
                            a2 = 0.001129*obj.ba(i,j)^2 - 0.01432*obj.ba(i,j) + 0.2101;
                            a3 = -0.0026*obj.ba(i,j)^2 + 0.05934*obj.ba(i,j) + 0.1528;
                            rpow1 = a1*obj.enr(i,j)^2 + a2*obj.enr(i,j) + a3;
                            % Relative old powe
                            a1 = -0.0000444*obj.oldba(i,j)^2 + 0.0005768*obj.oldba(i,j) - 0.008484;
                            a2 = 0.001129*obj.oldba(i,j)^2 - 0.01432*obj.oldba(i,j) + 0.2101;
                            a3 = -0.0026*obj.oldba(i,j)^2 + 0.05934*obj.oldba(i,j) + 0.1528;
                            roldpow1 = a1*obj.oldenr(i,j)^2 + a2*obj.oldenr(i,j) + a3;
                            % Power change
                            dpow1 = rpow1 - roldpow1;
                            % New Power at dep1
                            for m=1:obj.Nburnup
                                if (obj.burnup(m) >= dep1)
                                    z=m;
                                    break;
                                end
                            end
                            pow1 = dpow1 + obj.oldpow(i,j,z);
                            
                            % Point 2
                            dep2=max(5.5+1.6*obj.ba(i,j),5.5+1.6*obj.oldba(i,j));
                            % Power change
                            b1 = 0.000667;
                            b2 = -0.0002237*obj.oldenr(i,j)^2 + 0.002884*obj.oldenr(i,j) - 0.0217;
                            b3 = 0.0008345*obj.oldenr(i,j)^2 - 0.01878*obj.oldenr(i,j) + 0.2786;
                            c1 = -0.2573 + 0.03525*obj.oldenr(i,j);
                            c2 = 0.02543 - 0.004036*obj.oldenr(i,j);
                            denr = obj.enr(i,j)-obj.oldenr(i,j);
                            % Find dep2 point number
                            for m=1:obj.Nburnup
                                if (obj.burnup(m) >= dep2)
                                    z=m;
                                    break;
                                end
                            end
                            % Power change
                            kk = 10^((c1+c2*obj.enr(i,j))*obj.oldexp(i,j,z)/obj.ag(i,j));
                            dpow2 = denr*(b1*obj.enr(i,j)^2+b2*obj.enr(i,j)+b3)*kk+0.01*denr;
                            % New Power at dep2
                            pow2 = dpow2 + obj.oldpow(i,j,z);
                            
                            % Point 3
                            dep3=30;
                            % Find dep3 point number
                            for m=1:obj.Nburnup
                                if (obj.burnup(m) >= dep3)
                                    z=m;
                                    break;
                                end
                            end
                            % Power change
                            kk = 10^((c1+c2*obj.enr(i,j))*obj.oldexp(i,j,z)/obj.ag(i,j));
                            dpow3 = denr*(b1*obj.enr(i,j)^2+b2*obj.enr(i,j)+b3)*kk+0.01*denr;
                            % New Power at dep3
                            pow3 = dpow3 + obj.oldpow(i,j,z);
                            
                            % Point 4
                            dep4 = ((pow2-pow0)-(pow3-pow2)*dep2/(dep3-dep2))/(((pow1-pow0)/dep1)-(pow3-pow2)/(dep3-dep2));
                            
                            % New rod power
                            if (obj.burnup(k) <= dep4)
                                obj.pow(i,j,k) = pow0 + (pow1-pow0)/dep1*obj.burnup(k);
                            elseif (obj.burnup(k) > dep4 && obj.burnup(k) <= dep2)
                                obj.pow(i,j,k) = (pow3-pow2)/(dep3-dep2)*obj.burnup(k) + pow2 - (pow3-pow2)/(dep3-dep2)*dep2;
                            elseif (obj.burnup(k) > dep2)
                                kk = 10^((c1+c2*obj.enr(i,j))*obj.oldexp(i,j,k)/obj.ag(i,j));
                                obj.pow(i,j,k) = obj.oldpow(i,j,k) + denr*(b1*obj.enr(i,j)^2+b2*obj.enr(i,j)+b3)*kk+0.01*denr;
                            end
                            
                            %  Add BA rod
                        elseif (obj.ba(i,j) > 0 && obj.oldba(i,j) == 0)
                            % Add BA rod
                            % point 0
                            % Relative rod power before (U235 rod)
                            roldpow0 = -0.01043*obj.oldenr(i,j)^2 + 0.2826*obj.oldenr(i,j) + 0.1514;
                            % Relative power for new BA rod
                            k1 =  0.0005 + 0.00185*obj.enr(i,j);
                            k2 = -0.0065 - 0.0184*obj.enr(i,j);
                            k3 =  0.17 + 0.133*obj.enr(i,j);
                            rpow0 = k1*obj.ba(i,j)^ 2+ k2*obj.ba(i,j) + k3;
                            % Power change
                            dpow0 = rpow0 - roldpow0;
                            % New Power
                            pow0 = obj.oldpow(i,j,1) + dpow0;
                            
                            % Point 2
                            dep2=15;
                            % Power change new BA rod
                            b1 = 0.000667;
                            b2 = -0.0002237*obj.oldenr(i,j)^2 + 0.002884*obj.oldenr(i,j) - 0.0217;
                            b3 = 0.0008345*obj.oldenr(i,j)^2 - 0.01878*obj.oldenr(i,j) + 0.2786;
                            c1 = -0.2573 + 0.03525*obj.oldenr(i,j);
                            c2 = 0.02543 - 0.004036*obj.oldenr(i,j);
                            denr = obj.enr(i,j)-obj.oldenr(i,j);
                            % Find dep2 point number
                            for m=1:obj.Nburnup
                                if (obj.burnup(m) >= dep2)
                                    z=m;
                                    break;
                                end
                            end
                            
                            % Power change
                            kk = 10^((c1+c2*obj.enr(i,j))*obj.oldexp(i,j,z)/obj.ag(i,j));
                            dpow2 = denr*(b1*obj.enr(i,j)^2+b2*obj.enr(i,j)+b3)*kk+0.01*denr;
                            % New Power at dep2
                            pow2 = dpow2 + obj.oldpow(i,j,z);
                            
                            % Point 3
                            dep3=20;
                            % Power change new BA rod
                            b1 = 0.000667;
                            b2 = -0.0002237*obj.oldenr(i,j)^2 + 0.002884*obj.oldenr(i,j) - 0.0217;
                            b3 = 0.0008345*obj.oldenr(i,j)^2 - 0.01878*obj.oldenr(i,j) + 0.2786;
                            c1 = -0.2573 + 0.03525*obj.oldenr(i,j);
                            c2 = 0.02543 - 0.004036*obj.oldenr(i,j);
                            denr = obj.enr(i,j)-obj.oldenr(i,j);
                            % Find dep2 point number
                            for m=1:obj.Nburnup
                                if (obj.burnup(m) >= dep3)
                                    z=m;
                                    break;
                                end
                            end
                            % Power change
                            kk = 10^((c1+c2*obj.enr(i,j))*obj.oldexp(i,j,z)/obj.ag(i,j));
                            dpow3 = denr*(b1*obj.enr(i,j)^2+b2*obj.enr(i,j)+b3)*kk+0.01*denr;
                            % New Power at dep2
                            pow3 = dpow3 + obj.oldpow(i,j,z);
                            
                            % Point 4
                            dep4 = 2.04*obj.ba(i,j) + 0.95;
                            pow4 = (pow3-pow2)/(dep3-dep2)*dep4 + pow2 - (pow3-pow2)/(dep3-dep2)*dep2;
                            
                            % New rod power
                            if (obj.burnup(k) <= dep4)
                                obj.pow(i,j,k) = pow0 + (pow4-pow0)/dep4*obj.burnup(k);
                                
                            elseif (obj.burnup(k) > dep4 && obj.burnup(k) <= dep2)
                                obj.pow(i,j,k) = (pow3-pow2)/(dep3-dep2)*obj.burnup(k) + pow2 -(pow3-pow2)/(dep3-dep2)*dep2;
                                
                            elseif (obj.burnup(k) > dep2)
                                
                                b1 = 0.000667;
                                b2 = -0.0002237*obj.enr(i,j)^2 + 0.002884*obj.enr(i,j) - 0.0217;
                                b3 = 0.0008345*obj.enr(i,j)^2 - 0.01878*obj.enr(i,j) + 0.2786;
                                c1 = -0.2573 + 0.03525*obj.enr(i,j);
                                c2 = 0.02543 - 0.004036*obj.enr(i,j);
                                denr = obj.enr(i,j)-obj.oldenr(i,j);
                                % Find dep2 point number
                                for m=1:obj.Nburnup
                                    if (obj.burnup(m) >= dep2)
                                        z=m;
                                        break;
                                    end
                                end
                                
                                % Power change
                                kk = 10^((c1+c2*obj.enr(i,j))*obj.oldexp(i,j,k)/obj.ag(i,j));
                                dpow = denr*(b1*obj.enr(i,j)^2+b2*obj.enr(i,j)+b3)*kk+0.01*denr;
                                obj.pow(i,j,k) = obj.oldpow(i,j,k) + dpow;
                                obj.pow(i,j,k) = obj.oldpow(i,j,k) + denr*(b1*obj.enr(i,j)^2+b2*obj.enr(i,j)+b3)*kk+0.01*denr;
                                
                            end
                            
                            %  Remove BA rod
                        elseif (obj.ba(i,j) == 0 && obj.oldba(i,j) > 0)
                            % point 0
                            % Relative power for new BU235 rod
                            rpow0 = -0.01043*obj.enr(i,j)^2 + 0.2826*obj.enr(i,j) + 0.1514;
                            % Relative power for old BA rod
                            k1 =  0.00135 + 0.00197*obj.oldenr(i,j);
                            k2 = -0.009 - 0.01994*obj.oldenr(i,j);
                            k3 =  0.17 + 0.133*obj.oldenr(i,j);
                            roldpow0 = k1*obj.oldba(i,j)^ 2+ k2*obj.oldba(i,j) + k3;
                            % Power change
                            dpow0 = rpow0 - roldpow0;
                            % New Power
                            pow0 = obj.oldpow(i,j,1) + dpow0;
                            
                            % Point 2
                            dep2=15;
                            % Power change new BA rod
                            b1 = 0.000667;
                            b2 = -0.0002237*obj.oldenr(i,j)^2 + 0.002884*obj.oldenr(i,j) - 0.0217;
                            b3 = 0.0008345*obj.oldenr(i,j)^2 - 0.01878*obj.oldenr(i,j) + 0.2786;
                            c1 = -0.2573 + 0.03525*obj.oldenr(i,j);
                            c2 = 0.02543 - 0.004036*obj.oldenr(i,j);
                            denr = obj.enr(i,j)-obj.oldenr(i,j);
                            % Find dep2 point number
                            for m=1:obj.Nburnup
                                if (obj.burnup(m) >= dep2)
                                    z=m;
                                    break;
                                end
                            end
                            
                            % Power change
                            kk = 10^((c1+c2*obj.enr(i,j))*obj.oldexp(i,j,z)/obj.ag(i,j));
                            dpow2 = denr*(b1*obj.enr(i,j)^2+b2*obj.enr(i,j)+b3)*kk+0.01*denr;
                            % New Power at dep2
                            pow2 = dpow2 + obj.oldpow(i,j,z);
                            
                            % Point 3
                            dep3=20;
                            % Power change new BA rod
                            b1 = 0.000667;
                            b2 = -0.0002237*obj.oldenr(i,j)^2 + 0.002884*obj.oldenr(i,j) - 0.0217;
                            b3 = 0.0008345*obj.oldenr(i,j)^2 - 0.01878*obj.oldenr(i,j) + 0.2786;
                            c1 = -0.2573 + 0.03525*obj.oldenr(i,j);
                            c2 = 0.02543 - 0.004036*obj.oldenr(i,j);
                            denr = obj.enr(i,j)-obj.oldenr(i,j);
                            % Find dep2 point number
                            for m=1:obj.Nburnup
                                if (obj.burnup(m) >= dep3)
                                    z=m;
                                    break;
                                end
                            end
                            % Power change
                            kk = 10^((c1+c2*obj.enr(i,j))*obj.oldexp(i,j,z)/obj.ag(i,j));
                            dpow3 = denr*(b1*obj.enr(i,j)^2+b2*obj.enr(i,j)+b3)*kk+0.01*denr;
                            % New Power at dep2
                            pow3 = dpow3 + obj.oldpow(i,j,z);
                            
                            % Point 4
                            dep4 = 7.5;
                            pow4 = (pow3-pow2)/(dep3-dep2)*dep4 + pow2 - (pow3-pow2)/(dep3-dep2)*dep2;
                            
                            % New rod power
                            if (obj.burnup(k) <= dep4)
                                obj.pow(i,j,k) = pow0 + (pow4-pow0)/dep4*obj.burnup(k);
                                
                            elseif (obj.burnup(k) > dep4 && obj.burnup(k) <= dep2)
                                obj.pow(i,j,k) = (pow3-pow2)/(dep3-dep2)*obj.burnup(k) + pow2 -(pow3-pow2)/(dep3-dep2)*dep2;
                                
                            elseif (obj.burnup(k) > dep2)
                                b1 = 0.000667;
                                b2 = -0.0002237*obj.enr(i,j)^2 + 0.002884*obj.enr(i,j) - 0.0217;
                                b3 = 0.0008345*obj.enr(i,j)^2 - 0.01878*obj.enr(i,j) + 0.2786;
                                c1 = -0.2573 + 0.03525*obj.enr(i,j);
                                c2 = 0.02543 - 0.004036*obj.enr(i,j);
                                denr = obj.enr(i,j)-obj.oldenr(i,j);
                                % Find dep2 point number
                                for m=1:obj.Nburnup
                                    if (obj.burnup(m) >= dep2)
                                        z=m;
                                        break;
                                    end
                                end
                                
                                % Power change
                                kk = 10^((c1+c2*obj.enr(i,j))*obj.oldexp(i,j,k)/obj.ag(i,j));
                                obj.pow(i,j,k) = obj.oldpow(i,j,k) + denr*(b1*obj.enr(i,j)^2+b2*obj.enr(i,j)+b3)*kk+0.01*denr;
                            end
                        end
                    end
                end
            end
            
            
            % Add BA rod
            if (max(max(obj.ba-obj.oldba)))
                for k=1:obj.Nburnup
                    for i=1:obj.npst
                        for j=1:obj.npst
                            if (obj.oldba(i,j)==0 && obj.ba(i,j)>0)
                                if (obj.burnup(k) < 2*max(max(obj.ba)));
                                    if (i-1 > 0 && obj.enr(i-1,j))
                                        obj.pow(i-1,j,k) = obj.pow(i-1,j,k)-0.1*(2*obj.ba(i,j)-obj.burnup(k))/(2*obj.ba(i,j));
                                    end
                                    if (i+1 < obj.npst+1 && obj.enr(i+1,j))
                                        obj.pow(i+1,j,k) = obj.pow(i+1,j,k)-0.1*(2*obj.ba(i,j)-obj.burnup(k))/(2*obj.ba(i,j));
                                    end
                                    if (j-1 > 0 && obj.enr(i,j-1))
                                        obj.pow(i,j-1,k) = obj.pow(i,j-1,k)-0.1*(2*obj.ba(i,j)-obj.burnup(k))/(2*obj.ba(i,j));
                                    end
                                    if (j+1 < obj.npst+1 && obj.enr(i,j+1))
                                        obj.pow(i,j+1,k) = obj.pow(i,j+1,k)-0.1*(2*obj.ba(i,j)-obj.burnup(k))/(2*obj.ba(i,j));
                                    end
                                end
                                if (obj.burnup(k) < max(max(obj.ba)));
                                    if (i-1 > 0 && j-1 > 0 && obj.enr(i-1,j-1))
                                        obj.pow(i-1,j-1,k) = obj.pow(i-1,j-1,k)-0.05*(1*obj.ba(i,j)-obj.burnup(k))/(1*obj.ba(i,j));
                                    end
                                    if (i+1 < obj.npst+1 && j+1 < obj.npst+1 && obj.enr(i+1,j+1))
                                        obj.pow(i+1,j+1,k) = obj.pow(i+1,j+1,k)-0.05*(1*obj.ba(i,j)-obj.burnup(k))/(1*obj.ba(i,j));
                                    end
                                    if (i-1 > 0 && j+1 < obj.npst+1 && obj.enr(i-1,j+1))
                                        obj.pow(i-1,j+1,k) = obj.pow(i-1,j+1,k)-0.05*(1*obj.ba(i,j)-obj.burnup(k))/(1*obj.ba(i,j));
                                    end
                                    if (i+1 < obj.npst+1 && j-1 > 0 && obj.enr(i+1,j-1))
                                        obj.pow(i+1,j-1,k) = obj.pow(i+1,j-1,k)-0.05*(1*obj.ba(i,j)-obj.burnup(k))/(1*obj.ba(i,j));
                                    end
                                end
                            end
                        end
                    end
                end
            end
            
            
            % Remove BA rod
            if (max(max(obj.oldba-obj.ba)))
                for k=1:obj.Nburnup
                    for i=1:obj.npst
                        for j=1:obj.npst
                            if (obj.ba(i,j)==0 && obj.oldba(i,j)>0)
                                if (obj.burnup(k) < 2*max(max(obj.oldba)));
                                    if (i-1 > 0 && obj.enr(i-1,j))
                                        obj.pow(i-1,j,k) = obj.pow(i-1,j,k)+0.1*(2*obj.oldba(i,j)-obj.burnup(k))/(2*obj.oldba(i,j));
                                    end
                                    if (i+1 < obj.npst+1 && obj.enr(i+1,j))
                                        obj.pow(i+1,j,k) = obj.pow(i+1,j,k)+0.1*(2*obj.oldba(i,j)-obj.burnup(k))/(2*obj.oldba(i,j));
                                    end
                                    if (j-1 > 0 && obj.enr(i,j-1))
                                        obj.pow(i,j-1,k) = obj.pow(i,j-1,k)+0.1*(2*obj.oldba(i,j)-obj.burnup(k))/(2*obj.oldba(i,j));
                                    end
                                    if (j+1 < obj.npst+1 && obj.enr(i,j+1))
                                        obj.pow(i,j+1,k) = obj.pow(i,j+1,k)+0.1*(2*obj.oldba(i,j)-obj.burnup(k))/(2*obj.oldba(i,j));
                                    end
                                end
                                if (obj.burnup(k) < max(max(obj.oldba)));
                                    if (i-1 > 0 && j-1 > 0 && obj.enr(i-1,j-1))
                                        obj.pow(i-1,j-1,k) = obj.pow(i-1,j-1,k)+0.05*(1*obj.oldba(i,j)-obj.burnup(k))/(1*obj.oldba(i,j));
                                    end
                                    if (i+1 < obj.npst+1 && j+1 < obj.npst+1 && obj.enr(i+1,j+1))
                                        obj.pow(i+1,j+1,k) = obj.pow(i+1,j+1,k)+0.05*(1*obj.oldba(i,j)-obj.burnup(k))/(1*obj.oldba(i,j));
                                    end
                                    if (i-1 > 0 && j+1 < obj.npst+1 && obj.enr(i-1,j+1))
                                        obj.pow(i-1,j+1,k) = obj.pow(i-1,j+1,k)+0.05*(1*obj.oldba(i,j)-obj.burnup(k))/(1*obj.oldba(i,j));
                                    end
                                    if (i+1 < obj.npst+1 && j-1 > 0 && obj.enr(i+1,j-1))
                                        obj.pow(i+1,j-1,k) = obj.pow(i+1,j-1,k)+0.05*(1*obj.oldba(i,j)-obj.burnup(k))/(1*obj.oldba(i,j));
                                    end
                                end
                            end
                        end
                    end
                end
            end
            
            
            %  Normalize
            
            if (obj.isym==2)
                for k=1:obj.Nburnup
                    sum=0;
                    for i=1:obj.npst
                        for j=1:obj.npst
                            sum = sum + obj.pow(i,j,k);
                        end
                    end
                    for i=1:obj.npst
                        for j=1:obj.npst
                            obj.pow(i,j,k) = obj.pow(i,j,k)/sum*obj.Nlfu;
                        end
                    end
                end
            end
            
            
            if (obj.isym==8)
                for k=1:obj.Nburnup
                    sum=0;
                    for i=1:obj.npst
                        for j=1:obj.npst
                            if (obj.enr(i,j) > 0)
                                if (i == 1 && j == 1)
                                    sum = sum + obj.pow(i,j,k);
                                elseif (i == 1 || j == 1)
                                    sum = sum + 2*obj.pow(i,j,k);
                                else
                                    sum = sum + 4*obj.pow(i,j,k);
                                end
                            end
                        end
                    end
                    for i=1:obj.npst
                        for j=1:obj.npst
                            obj.pow(i,j,k) = obj.pow(i,j,k)/sum*obj.Nlfu;
                        end
                    end
                end
            end
            
            obj.fint=squeeze(max(max(obj.pow)));
            calc_powl(obj,obj.balimit,obj.plrlimit,obj.cornerlimit,obj.ba_tmol,obj.plr_tmol,obj.corner_tmol);
        end
        
        
        
        
        %________________________________________________
        %  Increase pin enrichment                       |
        %________________________________________________|
        
        function increase_enr(obj,i,j)
            
            if (obj.enr(i,j) &&  (obj.lfu(i,j)+1) <= obj.nr_fue)
                obj.lfu(i,j)=obj.lfu(i,j)+1;
                obj.enr(i,j)=obj.fue(obj.lfu(i,j),3);
                if (obj.fue(obj.lfu(i,j),5) > 0)
                    obj.ba(i,j)=obj.fue(obj.lfu(i,j),5);
                else
                    obj.ba(i,j)=0;
                end
            end
            
            if (obj.isym==2 || obj.isym==8)
                obj.lfu(j,i) = obj.lfu(i,j);
                obj.enr(j,i) = obj.enr(i,j);
                obj.ba(j,i) = obj.ba(i,j);
            end
            
        end
        
        %________________________________________________
        %  Decrease pin enrichment                       |
        %________________________________________________|
        
        function decrease_enr(obj,i,j)
            
            if (obj.enr(i,j) &&  (obj.lfu(i,j)-1) > 0)
                obj.lfu(i,j)=obj.lfu(i,j)-1;
                obj.enr(i,j)=obj.fue(obj.lfu(i,j),3);
                if (obj.fue(obj.lfu(i,j),5) > 0)
                    obj.ba(i,j)=obj.fue(obj.lfu(i,j),5);
                else
                    obj.ba(i,j)=0;
                end
            end
            
            if (obj.isym==2 || obj.isym==8)
                obj.lfu(j,i) = obj.lfu(i,j);
                obj.enr(j,i) = obj.enr(i,j);
                obj.ba(j,i) = obj.ba(i,j);
            end
            
        end
        
        
        %________________________________________________
        %   Write caifil                                 |
        %________________________________________________|
        
        function writecaifile(obj,file)
            obj.caifile=file;
            fid = fopen(obj.caifile,'wt');
            
            fprintf(fid,'%s\n',obj.title);
            fprintf(fid,'%s\n',obj.sim);
            if (~isempty(obj.bor))
                fprintf(fid,'%s\n',obj.bor);
            end
            if (~isempty(obj.tfu))
                fprintf(fid,'%s\n',obj.tfu);
            end
            if (~isempty(obj.tmo))
                fprintf(fid,'%s\n',obj.tmo);
            end
            
            if (~isempty(obj.voi))
                fprintf(fid,'%s\n',obj.voi);
            end
            
            for i=1:obj.nr_fue
                fprintf(fid,'FUE ');
                fprintf(fid,'%d ',obj.fue(i,1));
                fprintf(fid,'%5.3f/',obj.fue(i,2));
                fprintf(fid,'%5.3f ',obj.fue(i,3));
                if (isnan(obj.fue(i,4))==0)
                    fprintf(fid,'%d=',obj.fue(i,4));
                    fprintf(fid,'%4.2f\n',obj.fue(i,5));
                else
                    fprintf(fid,'\n');
                end
            end
            
            fprintf(fid,'LFU \n');
            if (obj.isym == 1)
                for i=1:obj.npst
                    for j=1:obj.npst
                        fprintf(fid,'%d ',obj.lfu(i,j));
                    end
                    fprintf(fid,'\n');
                end
            else
                for i=1:obj.npst
                    for j=1:obj.npst
                        if (j<= i)
                            fprintf(fid,'%d ',obj.lfu(i,j));
                        end
                    end
                    fprintf(fid,'\n');
                end
            end
            
            fprintf(fid,'%s\n',obj.pde);
            
            
            if (~isempty(obj.hO1))
                fprintf(fid,'%s\n',obj.hO1);
            end
            
            
            %             if (~isempty(obj.bwr))
            %                 fprintf(fid,'BWR ');
            %                 fprintf(fid,'%d ',obj.bwr(1,1));
            %                 fprintf(fid,'%5.3f ',obj.bwr(2,1));
            %                 fprintf(fid,'%6.3f ',obj.bwr(3,1));
            %                 fprintf(fid,'%5.3f ',obj.bwr(4,1));
            %                 fprintf(fid,'%6.4f ',obj.bwr(5,1));
            %                 fprintf(fid,'%6.4f ',obj.bwr(6,1));
            %                 fprintf(fid,'%5.3f ',obj.bwr(7,1));
            %                 fprintf(fid,'%d\n',obj.bwr(8,1));
            %             end
            
            if (~isempty(obj.bwr_card))
                fprintf(fid,'%s\n',obj.bwr_card);
            end
            
            
            
            if (~isempty(obj.pwr))
                fprintf(fid,'PWR ');
                fprintf(fid,'%d ',obj.pwr(1,1));
                fprintf(fid,'%5.3f ',obj.pwr(2,1));
                fprintf(fid,'%6.3f ',obj.pwr(3,1));
                fprintf(fid,'%5.3f ',obj.pwr(4,1));
                fprintf(fid,'%6.4f ',obj.pwr(5,1));
                fprintf(fid,'%6.4f ',obj.pwr(6,1));
                fprintf(fid,'%5.3f ',obj.pwr(7,1));
                fprintf(fid,'%d\n',obj.pwr(8,1));
            end
            
            for i=1:obj.nr_pin
                if (i == 1 && i <= obj.nr_pin)
                    fprintf(fid,'%s\n',obj.pin1);
                end
                if (i == 2 && i <= obj.nr_pin)
                    fprintf(fid,'%s\n',obj.pin2);
                end
                if (i == 3 && i <= obj.nr_pin)
                    fprintf(fid,'%s\n',obj.pin3);
                end
                if (i == 4 && i <= obj.nr_pin)
                    fprintf(fid,'%s\n',obj.pin4);
                end
                if (i == 5 && i <= obj.nr_pin)
                    fprintf(fid,'%s\n',obj.pin5);
                end
                if (i == 6 && i <= obj.nr_pin)
                    fprintf(fid,'%s\n',obj.pin6);
                end
            end
            
            for i=1:obj.nr_sla
                if (i == 1 && i <= obj.nr_sla)
                    fprintf(fid,'%s\n',obj.sla1);
                end
                if (i == 2 && i <= obj.nr_sla)
                    fprintf(fid,'%s\n',obj.sla2);
                end
                if (i == 3 && i <= obj.nr_sla)
                    fprintf(fid,'%s\n',obj.sla3);
                end
                if (i == 4 && i <= obj.nr_sla)
                    fprintf(fid,'%s\n',obj.sla4);
                end
                if (i == 5 && i <= obj.nr_sla)
                    fprintf(fid,'%s\n',obj.sla5);
                end
            end
            
            fprintf(fid,'LPI \n');
            if (obj.isym == 1)
                for i=1:obj.npst
                    for j=1:obj.npst
                        fprintf(fid,'%d ',obj.lpi(i,j));
                    end
                    fprintf(fid,'\n');
                end
            else
                for i=1:obj.npst
                    for j=1:obj.npst
                        if (j<= i)
                            fprintf(fid,'%d ',obj.lpi(i,j));
                        end
                    end
                    fprintf(fid,'\n');
                end
            end
            
            fprintf(fid,'%s\n',obj.spa);
            

            %             for i=1:obj.nr_crd
            %                 if (i == 1 && i <= obj.nr_crd)
            %                     fprintf(fid,'%s\n',obj.crd1);
            %                 end
            %                 if (i == 2 && i <= obj.nr_crd)
            %                     fprintf(fid,'%s\n',obj.crd2);
            %                 end
            %                 if (i == 3 && i <= obj.nr_crd)
            %                     fprintf(fid,'%s\n',obj.sla3);
            %                 end
            %                 if (i == 4 && i <= obj.nr_crd)
            %                     fprintf(fid,'%s\n',obj.crd4);
            %                 end
            %                 if (i == 5 && i <= obj.nr_crd)
            %                     fprintf(fid,'%s\n',obj.crd5);
            %                 end
            %             end
            
            fprintf(fid,'%s\n','DEP 0.1 0.25 -70');
            
            
            if (~isempty(obj.gam))
                fprintf(fid,'%s\n',obj.gam);
            end
            
            if (~isempty(obj.nli))
                fprintf(fid,'%s\n',obj.nli);
            end
            
            if (~isempty(obj.wri))
                fprintf(fid,'%s\n',obj.wri);
            end
            
            if (~isempty(obj.lst))
                fprintf(fid,'%s\n',obj.lst);
            end
            
            if (~isempty(obj.sta))
                fprintf(fid,'%s\n',obj.sta);
            end

            if (~isempty(obj.crd))
                
                fprintf(fid,'%s\n','TTL');
                fprintf(fid,'%s\n','RES,,0 0.5 1.5 2.5 5.0 7.5 10.0 12.5 15.0 17.5 20.0 25 30 40 50 60 70');
                fprintf(fid,'%s\n',obj.crd);
                fprintf(fid,'%s\n','NLI');
                fprintf(fid,'%s\n','STA');
            end
            
            fprintf(fid,'%s\n',obj.end1);
            
            fclose(fid);
        end
        
        
        %_____________________________________________________
        %  Calc BTF (dryout performance, R-fact, K-fact etc)  |
        %_____________________________________________________|
        
        function calcbtf(obj)
            
            
            %             if (strcmp('Svea96Optima2', obj.type) || strcmp('GE14', obj.type) || strcmp('Atrium10', obj.type))
            
            
            %   Additiv constants
            addconst=zeros(11);
            if (strcmp('Svea96Optima2', obj.type))
                addconst(1,:)  = [ 0.20,-0.10,-0.10,-0.10,-0.10, 0.00,-0.10,-0.10,-0.10,-0.10, 0.20];
                addconst(2,:)  = [-0.10,-0.09,-0.09,-0.09,-0.09, 0.00,-0.09,-0.09,-0.09,-0.09,-0.10];
                addconst(3,:)  = [-0.10,-0.09,-0.09,-0.09,-0.09, 0.00,-0.09,-0.09,-0.09,-0.09,-0.10];
                addconst(4,:)  = [-0.10,-0.09,-0.09,-0.09, 0.20, 0.00, 0.20,-0.09,-0.09,-0.09,-0.10];
                addconst(5,:)  = [-0.10,-0.09,-0.09, 0.20, 0.00, 0.00, 0.00, 0.20,-0.09,-0.09,-0.10];
                addconst(6,:)  = [ 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00];
                addconst(7,:)  = [-0.10,-0.09,-0.09, 0.20, 0.00, 0.00, 0.00, 0.20,-0.09,-0.09,-0.10];
                addconst(8,:)  = [-0.10,-0.09,-0.09,-0.09, 0.20, 0.00, 0.20,-0.09,-0.09,-0.09,-0.10];
                addconst(9,:)  = [-0.10,-0.09,-0.09,-0.09,-0.09, 0.00,-0.09,-0.09,-0.09,-0.09,-0.10];
                addconst(10,:) = [-0.10,-0.09,-0.09,-0.09,-0.09, 0.00,-0.09,-0.09,-0.09,-0.09,-0.10];
                addconst(11,:) = [ 0.20,-0.10,-0.10,-0.10,-0.10, 0.00,-0.10,-0.10,-0.10,-0.10, 0.20];
            elseif (strcmp('GE14', obj.type))
                addconst(1,:)  = [-0.061,-0.078,-0.084,-0.083,-0.073,-0.074,-0.095,-0.084,-0.104,-0.086,0];
                addconst(2,:)  = [-0.078, 0.450,-0.016, 0.450,-0.007,-0.003, 0.450,-0.055, 0.450,-0.116,0];
                addconst(3,:)  = [-0.084,-0.016,-0.025, 0.005,-0.003,-0.031,-0.049,-0.020,-0.066,-0.113,0];
                addconst(4,:)  = [-0.083, 0.450, 0.005,-0.008,-0.011, 0.000, 0.000,-0.058, 0.450,-0.134,0];
                addconst(5,:)  = [-0.073,-0.007,-0.003,-0.011, 0.450, 0.000, 0.000,-0.041,-0.043,-0.122,0];
                addconst(6,:)  = [-0.074,-0.003,-0.031, 0.000, 0.000, 0.450,-0.022,-0.041,-0.042,-0.127,0];
                addconst(7,:)  = [-0.095, 0.450,-0.049, 0.000, 0.000,-0.022,-0.023,-0.031, 0.450,-0.148,0];
                addconst(8,:)  = [-0.084,-0.055,-0.020,-0.058,-0.041,-0.041,-0.031,-0.042,-0.083,-0.138,0];
                addconst(9,:)  = [-0.104, 0.450,-0.066, 0.450,-0.043,-0.042, 0.450,-0.083, 0.450,-0.150,0];
                addconst(10,:) = [-0.086,-0.116,-0.113,-0.134,-0.122,-0.127,-0.148,-0.138,-0.150,-0.131,0];
                addconst(11,:) = [0,0,0,0,0,0,0,0,0,0,0];
                
                %                       elseif (strcmp('GNF2', obj.type))
                %                         addconst(1,:)  = [ 0.008,-0.017,-0.026,-0.043, 0.270, 0.270,-0.050,-0.033,-0.045,-0.023,0];
                %                         addconst(2,:)  = [-0.017,-0.035,-0.021,-0.031,-0.064,-0.066,-0.061,-0.060,-0.045,-0.058,0];
                %                         addconst(3,:)  = [-0.026,-0.021,-0.049,-0.041,-0.082,-0.082,-0.071,-0.088,-0.091,-0.068,0];
                %                         addconst(4,:)  = [-0.043,-0.031,-0.041,-0.084, 1.300, 0.000,-0.201,-0.101,-0.075,-0.106,0];
                %                         addconst(5,:)  = [ 0.270,-0.064,-0.082, 1.300, 1.300, 0.000,-0.195,-0.101,-0.109, 0.270,0];
                %                         addconst(6,:)  = [ 0.270,-0.066,-0.082, 0.000,-0.171, 1.300, 1.300,-0.109,-0.127, 0.270,0];
                %                         addconst(7,:)  = [-0.050,-0.061,-0.071, 0.000,-0.162, 1.300,-0.105,-0.089,-0.091,-0.123,0];
                %                         addconst(8,:)  = [-0.033,-0.060,-0.088,-0.101,-0.101,-0.109,-0.089,-0.089,-0.116,-0.099,0];
                %                         addconst(9,:)  = [-0.045,-0.045,-0.091,-0.075,-0.109,-0.127,-0.091,-0.116,-0.098,-0.098,0];
                %                         addconst(10,:) = [-0.023,-0.058,-0.068,-0.106, 0.270, 0.270,-0.123,-0.099,-0.098,-0.074,0];
                %                         addconst(11,:) = [0,0,0,0,0,0,0,0,0,0,0];
                
            elseif (strcmp('GNF2', obj.type))
                addconst(1,:)  = [-0.022,-0.017,-0.026,-0.043, 0.270, 0.270,-0.050,-0.033,-0.045,-0.037,0];
                addconst(2,:)  = [-0.017,-0.035,-0.021,-0.031,-0.064,-0.066,-0.061,-0.060,-0.045,-0.058,0];
                addconst(3,:)  = [-0.026,-0.021,-0.049,-0.041,-0.082,-0.082,-0.071,-0.088,-0.091,-0.068,0];
                addconst(4,:)  = [-0.043,-0.031,-0.041,-0.084, 1.300, 0.000,-0.201,-0.101,-0.075,-0.106,0];
                addconst(5,:)  = [ 0.270,-0.064,-0.082, 1.300, 1.300, 0.000,-0.195,-0.101,-0.109, 0.270,0];
                addconst(6,:)  = [ 0.270,-0.066,-0.082, 0.000,-0.171, 1.300, 1.300,-0.109,-0.127, 0.270,0];
                addconst(7,:)  = [-0.050,-0.061,-0.071, 0.000,-0.162, 1.300,-0.105,-0.089,-0.091,-0.123,0];
                addconst(8,:)  = [-0.033,-0.060,-0.088,-0.101,-0.101,-0.109,-0.089,-0.089,-0.116,-0.099,0];
                addconst(9,:)  = [-0.045,-0.045,-0.091,-0.075,-0.109,-0.127,-0.091,-0.116,-0.098,-0.098,0];
                addconst(10,:) = [-0.037,-0.058,-0.068,-0.106, 0.270, 0.270,-0.123,-0.099,-0.098,-0.074,0];
                addconst(11,:) = [0,0,0,0,0,0,0,0,0,0,0];
            elseif (strcmp('Atrium10', obj.type))
                addconst(1,:)  = [-0.15,-0.12,-0.12,-0.12,-0.12,-0.12,-0.12,-0.12,-0.12,-0.15,0];
                addconst(2,:)  = [-0.12,-0.05,-0.05,-0.05,-0.05,-0.05,-0.05,-0.05,-0.05,-0.12,0];
                addconst(3,:)  = [-0.12,-0.05,-0.05,-0.05,-0.05,-0.05,-0.05,-0.05,-0.05,-0.12,0];
                addconst(4,:)  = [-0.12,-0.05,-0.05,-0.05,-0.08,-0.08,-0.08,-0.05,-0.05,-0.12,0];
                addconst(5,:)  = [-0.12,-0.05,-0.05,-0.08,-0.00,-0.00,-0.00,-0.08,-0.05,-0.12,0];
                addconst(6,:)  = [-0.12,-0.05,-0.05,-0.08,-0.00,-0.00,-0.00,-0.10,-0.05,-0.12,0];
                addconst(7,:)  = [-0.12,-0.05,-0.05,-0.08,-0.00,-0.00,-0.00,-0.09,-0.05,-0.12,0];
                addconst(8,:)  = [-0.12,-0.05,-0.05,-0.05,-0.08,-0.10,-0.09,-0.05,-0.05,-0.12,0];
                addconst(9,:)  = [-0.12,-0.05,-0.05,-0.05,-0.05,-0.05,-0.05,-0.05,-0.05,-0.12,0];
                addconst(10,:) = [-0.15,-0.12,-0.12,-0.12,-0.12,-0.12,-0.12,-0.12,-0.12,-0.12,0];
                addconst(11,:) = [0,0,0,0,0,0,0,0,0,0,0];
            end
            
            % Weight factors
            weight_side = 0.2;
            weight_corner = 0.05;
            
            % Help matrix for calculation of number of corner and side neighbour rods
            wp=zeros(obj.npst+2);
            for j=2:obj.npst+1
                for i=2:obj.npst+1
                    if (obj.pow(i-1,j-1,1) > 0)
                        wp(i,j) = 1;
                    else
                        wp(i,j) = 0;
                    end
                end
            end
            
            % Number of corner and side neighbour rods
            nr_corner=zeros(obj.npst);
            nr_side=zeros(obj.npst);
            
            % Summary of corner and side pin power square root help matrix
            sq1_corner=zeros(obj.npst+2,obj.npst+2,obj.Nburnup);
            sq1_side=zeros(obj.npst+2,obj.npst+2,obj.Nburnup);
            
            % Pin power, help matrix
            pow1=zeros(obj.npst+2,obj.npst+2,obj.Nburnup);
            
            % local btf-factor
            obj.btf = zeros(obj.npst,obj.npst,obj.Nburnup);
            obj.btf_env = zeros(obj.npst,obj.npst);
            
            obj.btfaxw_env = zeros(obj.npst);
            
            % local weighted btf-factor
            obj.btfaxw = zeros(obj.npst,obj.npst,obj.Nburnup);
            
            for j=2:obj.npst+1
                for i=2:obj.npst+1
                    if (obj.pow(i-1,j-1,1) > 0)
                        nr_corner(i-1,j-1) = wp(i-1,j-1)+wp(i+1,j-1)+wp(i-1,j+1)+wp(i+1,j+1);
                        nr_side(i-1,j-1) = wp(i-1,j)+wp(i+1,j)+wp(i,j+1)+wp(i,j-1);
                    end
                end
            end
            
            for m=1:obj.Nburnup
                for j=2:obj.npst+1
                    for i=2:obj.npst+1
                        pow1(i,j,m)=obj.pow(i-1,j-1,m);
                    end
                end
            end
            
            for m=1:obj.Nburnup
                for j=2:obj.npst+1
                    for i=2:obj.npst+1
                        if (pow1(i,j,m) > 0)
                            sq1_corner(i,j,m)=sqrt(pow1(i-1,j-1,m))+sqrt(pow1(i+1,j-1,m))+sqrt(pow1(i-1,j+1,m))+sqrt(pow1(i+1,j+1,m));
                            sq1_side(i,j,m)=sqrt(pow1(i-1,j,m))+sqrt(pow1(i+1,j,m))+sqrt(pow1(i,j+1,m))+sqrt(pow1(i,j-1,m));
                        end
                    end
                end
            end
            sq_rod = sqrt(obj.pow);
            
            sq_corner=sq1_corner;
            sq_corner(end,:,:)=[];
            sq_corner(:,end,:)=[];
            sq_corner(:,1,:)=[];
            sq_corner(1,:,:)=[];
            sq_side=sq1_side;
            sq_side(end,:,:)=[];
            sq_side(:,end,:)=[];
            sq_side(:,1,:)=[];
            sq_side(1,:,:)=[];
            
            % Calculation of btf distribution (r-factor, k-factor etc)
            for m=1:obj.Nburnup
                for j=1:obj.npst
                    for i=1:obj.npst
                        if (obj.pow(i,j,m) > 0)
                            obj.btf(i,j,m)=(sq_rod(i,j,m)+sq_side(i,j,m)*weight_side+sq_corner(i,j,m)*weight_corner)/ ...
                                (1 + nr_corner(i,j)*weight_corner + nr_side(i,j)*weight_side);
                            obj.btf(i,j,m) = obj.btf(i,j,m) + addconst(i,j);
                            obj.btfaxw(i,j,m)=obj.btf(i,j,m)*obj.axial_zone(obj.cn);
                        else
                            obj.btf(i,j,m) = 0;
                        end
                    end
                end
            end
            
            % kinf weight btf (local and axial)
            kinf_weight_sum=0;
            temp1=zeros(obj.npst);
            temp2=zeros(obj.npst);
            for m=1:obj.Nburnup
                kinf_weight = sqrt(obj.kinf(m));
                kinf_weight_sum = kinf_weight + kinf_weight_sum;
                temp1=obj.btf(:,:,m)*kinf_weight + temp1;
                temp2=obj.btfaxw(:,:,m)*kinf_weight + temp2;
            end
            obj.btf_env    = temp1/kinf_weight_sum;
            obj.btfaxw_env = temp2/kinf_weight_sum;
            
            % Assembly btf-factor (input to dryout correlation)
            obj.maxbtf  = nan(obj.Nburnup,1);
            
            for k=1:obj.Nburnup
                maxx=0;
                for i=1:obj.npst
                    for j=1:obj.npst
                        if(obj.btf(i,j,k) > maxx)
                            maxx = obj.btf(i,j,k);
                        end
                    end
                end
                obj.maxbtf(k,1) = maxx;
            end
            
            % Limited btf_env (f(kinf)) rod
            maxx=0;
            for i=1:obj.npst
                for j=1:obj.npst
                    if(obj.btf_env(i,j) > maxx)
                        maxx = obj.btf_env(i,j);
                    end
                end
            end
            obj.maxbtf_env = maxx;
            
            
            
% CRD btf            
            
            if(~isempty(obj.pow_crd))
                for m=1:obj.Nburnup
                    for j=2:obj.npst+1
                        for i=2:obj.npst+1
                            pow1(i,j,m)=obj.pow_crd(i-1,j-1,m);
                        end
                    end
                end
                
                for m=1:obj.Nburnup
                    for j=2:obj.npst+1
                        for i=2:obj.npst+1
                            if (pow1(i,j,m) > 0)
                                sq1_corner(i,j,m)=sqrt(pow1(i-1,j-1,m))+sqrt(pow1(i+1,j-1,m))+sqrt(pow1(i-1,j+1,m))+sqrt(pow1(i+1,j+1,m));
                                sq1_side(i,j,m)=sqrt(pow1(i-1,j,m))+sqrt(pow1(i+1,j,m))+sqrt(pow1(i,j+1,m))+sqrt(pow1(i,j-1,m));
                            end
                        end
                    end
                end
                sq_rod = sqrt(obj.pow_crd);
                
                sq_corner=sq1_corner;
                sq_corner(end,:,:)=[];
                sq_corner(:,end,:)=[];
                sq_corner(:,1,:)=[];
                sq_corner(1,:,:)=[];
                sq_side=sq1_side;
                sq_side(end,:,:)=[];
                sq_side(:,end,:)=[];
                sq_side(:,1,:)=[];
                sq_side(1,:,:)=[];
                
                % Calculation of btf distribution (r-factor, k-factor etc)
                for m=1:obj.Nburnup
                    for j=1:obj.npst
                        for i=1:obj.npst
                            if (obj.pow_crd(i,j,m) > 0)
                                obj.btf_crd(i,j,m)=(sq_rod(i,j,m)+sq_side(i,j,m)*weight_side+sq_corner(i,j,m)*weight_corner)/ ...
                                    (1 + nr_corner(i,j)*weight_corner + nr_side(i,j)*weight_side);
                                obj.btf_crd(i,j,m) = obj.btf_crd(i,j,m) + addconst(i,j);
                                obj.btfaxw_crd(i,j,m)=obj.btf_crd(i,j,m)*obj.axial_zone(obj.cn);
                            else
                                obj.btf_crd(i,j,m) = 0;
                            end
                        end
                    end
                end
                
                % kinf weight btf (local and axial)
                kinf_weight_sum=0;
                temp1=zeros(obj.npst);
                temp2=zeros(obj.npst);
                for m=1:obj.Nburnup
                    kinf_weight = sqrt(obj.kinf(m));
                    kinf_weight_sum = kinf_weight + kinf_weight_sum;
                    temp1=obj.btf_crd(:,:,m)*kinf_weight + temp1;
                    temp2=obj.btfaxw_crd(:,:,m)*kinf_weight + temp2;
                end
                obj.btf_env_crd    = temp1/kinf_weight_sum;
                obj.btfaxw_env_crd = temp2/kinf_weight_sum;
                
                % Assembly btf-factor (input to dryout correlation)
                obj.maxbtf_crd  = nan(obj.Nburnup,1);
                
                for k=1:obj.Nburnup
                    maxx=0;
                    for i=1:obj.npst
                        for j=1:obj.npst
                            if(obj.btf_crd(i,j,k) > maxx)
                                maxx = obj.btf_crd(i,j,k);
                            end
                        end
                    end
                    obj.maxbtf_crd(k,1) = maxx;
                end
                
                % Limited btf_env (f(kinf)) rod
                maxx=0;
                for i=1:obj.npst
                    for j=1:obj.npst
                        if(obj.btf_env_crd(i,j) > maxx)
                            maxx = obj.btf_env_crd(i,j);
                        end
                    end
                end
                obj.maxbtf_env_crd = maxx;
                
            end
            
  
        end
        
        %_____________________________________________________
        %  Get Fuel assembly type, (Svea96, Atrium. GE12 etc  |
        %_____________________________________________________|
        
        function gettype(obj)
            
            obj.axial_zone=zeros(25,1);
            if (obj.nr_sla > 0)
                if (obj.bwr(1) > 1.275)
                    if (obj.lfu(5,5) == 0 && ...
                            obj.lfu(5,5) == 0 && ...
                            obj.lfu(5,6) == 0 && ...
                            obj.lfu(5,7) == 0 && ...
                            obj.lfu(6,5) == 0 && ...
                            obj.lfu(6,6) == 0 && ...
                            obj.lfu(6,7) == 0 && ...
                            obj.lfu(7,5) == 0 && ...
                            obj.lfu(7,5) == 0 && ...
                            obj.lfu(7,7) == 0)
                        obj.type={'Svea96Optima2'};
                        obj.axial_zone(1)=9/25;
                        obj.axial_zone(2)=8/25;
                        obj.axial_zone(3)=8/25;
                        obj.axial_zone(4)=0.1;
                        obj.axial_zone(5)=0.1;
                        obj.axial_zone(6)=0.1;
                        obj.axial_zone(7)=0.1;
                        obj.axial_zone(8)=0.1;
                        obj.axial_zone(9)=0.1;
                        obj.axial_zone(10)=0.1;
                        obj.standard_u235=zeros(20,1);
                        obj.standard_u235(1)=0.71;
                        obj.standard_u235(2)=1.40;
                        obj.standard_u235(3)=1.60;
                        obj.standard_u235(4)=1.80;
                        obj.standard_u235(5)=2.00;
                        obj.standard_u235(6)=2.20;
                        obj.standard_u235(7)=2.40;
                        obj.standard_u235(8)=2.60;
                        obj.standard_u235(9)=2.80;
                        obj.standard_u235(10)=3.00;
                        obj.standard_u235(11)=3.20;
                        obj.standard_u235(12)=3.40;
                        obj.standard_u235(13)=3.60;
                        obj.standard_u235(14)=3.80;
                        obj.standard_u235(15)=4.00;
                        obj.standard_u235(16)=4.20;
                        obj.standard_u235(17)=4.40;
                        obj.standard_u235(18)=4.60;
                        obj.standard_u235(19)=4.80;
                        obj.standard_u235(20)=4.95;
                        obj.standard_ba=zeros(18,1);
                        obj.standard_ba(1)=1.00;
                        obj.standard_ba(2)=1.50;
                        obj.standard_ba(3)=2.00;
                        obj.standard_ba(4)=2.50;
                        obj.standard_ba(5)=3.00;
                        obj.standard_ba(6)=3.50;
                        obj.standard_ba(7)=4.00;
                        obj.standard_ba(8)=4.50;
                        obj.standard_ba(9)=5.00;
                        obj.standard_ba(10)=5.50;
                        obj.standard_ba(11)=6.00;
                        obj.standard_ba(12)=6.50;
                        obj.standard_ba(13)=7.00;
                        obj.standard_ba(14)=7.50;
                        obj.standard_ba(15)=8.00;
                        obj.standard_ba(16)=8.50;
                        obj.standard_ba(17)=9.00;
                        obj.standard_ba(18)=9.50;
                        %obj.plr(1,1) = 1;
                        %obj.plr(1,11) = 1;
                        %obj.plr(11,1) = 1;
                        %obj.plr(11,11) = 1;
                        obj.plr(5,4) = 1;
                        obj.plr(4,5) = 1;
                        obj.plr(7,4) = 1;
                        obj.plr(4,7) = 1;
                        obj.plr(8,5) = 1;
                        obj.plr(5,8) = 1;
                        obj.plr(8,7) = 1;
                        obj.plr(7,8) = 1;
                    end
                end
            end
            
            if (obj.npst == 10)
                if(obj.lfu(4,6) == 0 && ...
                        obj.lfu(4,6) == 0 && ...
                        obj.lfu(4,7) == 0 && ...
                        obj.lfu(5,6) == 0 && ...
                        obj.lfu(5,7) == 0 && ...
                        obj.lfu(6,4) == 0 && ...
                        obj.lfu(6,5) == 0 && ...
                        obj.lfu(7,4) == 0 && ...
                        obj.lfu(7,5) == 0 && obj.pin(1,2) < 0.44)
                    obj.type={'GE14'};
                    obj.axial_zone(1)=243.84/375.92;
                    obj.axial_zone(2)=132.08/375.92;
                    obj.axial_zone(3)=0.01;
                    obj.axial_zone(4)=0.01;
                    obj.axial_zone(5)=0.01;
                    obj.axial_zone(6)=0.01;
                    obj.axial_zone(7)=0.01;
                    obj.axial_zone(8)=0.01;
                    obj.axial_zone(9)=0.01;
                    obj.axial_zone(10)=0.01;
                    %                     obj.axial_zone(1)=14/25;
                    %                     obj.axial_zone(2)=11/25;
                    %                     obj.axial_zone(3)=0.1;
                    %                     obj.axial_zone(4)=0.1;
                    %                     obj.axial_zone(5)=0.1;
                    %                     obj.axial_zone(6)=0.1;
                    %                     obj.axial_zone(7)=0.1;
                    %                     obj.axial_zone(8)=0.1;
                    %                     obj.axial_zone(9)=0.1;
                    %                     obj.axial_zone(10)=0.1;
                    obj.standard_u235=zeros(11,1);
                    obj.standard_u235(1)=0.71;
                    obj.standard_u235(2)=1.60;
                    obj.standard_u235(3)=2.00;
                    obj.standard_u235(4)=2.40;
                    obj.standard_u235(5)=2.80;
                    obj.standard_u235(6)=3.20;
                    obj.standard_u235(7)=3.60;
                    obj.standard_u235(8)=4.00;
                    obj.standard_u235(9)=4.40;
                    obj.standard_u235(10)=4.80;
                    obj.standard_u235(11)=4.95;
                    obj.standard_ba=zeros(18,1);
                    obj.standard_ba(1)=1.00;
                    obj.standard_ba(2)=1.50;
                    obj.standard_ba(3)=2.00;
                    obj.standard_ba(4)=2.50;
                    obj.standard_ba(5)=3.00;
                    obj.standard_ba(6)=3.50;
                    obj.standard_ba(7)=4.00;
                    obj.standard_ba(8)=4.50;
                    obj.standard_ba(9)=5.00;
                    obj.standard_ba(10)=5.50;
                    obj.standard_ba(11)=6.00;
                    obj.standard_ba(12)=6.50;
                    obj.standard_ba(13)=7.00;
                    obj.standard_ba(14)=7.50;
                    obj.standard_ba(15)=8.00;
                    obj.standard_ba(16)=8.50;
                    obj.standard_ba(17)=9.00;
                    obj.standard_ba(18)=9.50;
                    obj.plr(2,2) = 1;
                    obj.plr(4,2) = 1;
                    obj.plr(2,4) = 1;
                    obj.plr(5,5) = 1;
                    obj.plr(6,6) = 1;
                    obj.plr(7,2) = 1;
                    obj.plr(2,7) = 1;
                    obj.plr(9,2) = 1;
                    obj.plr(2,9) = 1;
                    obj.plr(9,9) = 1;
                    obj.plr(9,4) = 1;
                    obj.plr(9,9) = 1;
                    obj.plr(9,7) = 1;
                    obj.plr(7,9) = 1;
                    obj.plr(9,9) = 1;
                elseif(obj.lfu(4,6) == 0 && ...
                        obj.lfu(4,6) == 0 && ...
                        obj.lfu(4,7) == 0 && ...
                        obj.lfu(5,6) == 0 && ...
                        obj.lfu(5,7) == 0 && ...
                        obj.lfu(6,4) == 0 && ...
                        obj.lfu(6,5) == 0 && ...
                        obj.lfu(7,4) == 0 && ...
                        obj.lfu(7,5) == 0 && obj.pin(1,2) > 0.44)
                    obj.type={'GNF2'};
                    obj.axial_zone(1)=9/25;
                    obj.axial_zone(2)=8/25;
                    obj.axial_zone(3)=8/25;
                    obj.axial_zone(4)=0.05;
                    obj.axial_zone(5)=0.05;
                    obj.axial_zone(6)=0.05;
                    obj.axial_zone(7)=0.05;
                    obj.axial_zone(8)=0.05;
                    obj.axial_zone(9)=0.05;
                    obj.axial_zone(10)=0.05;
                    obj.standard_u235=zeros(11,1);
                    obj.standard_u235(1)=0.71;
                    obj.standard_u235(2)=1.60;
                    obj.standard_u235(3)=2.00;
                    obj.standard_u235(4)=2.40;
                    obj.standard_u235(5)=2.80;
                    obj.standard_u235(6)=3.20;
                    obj.standard_u235(7)=3.60;
                    obj.standard_u235(8)=4.00;
                    obj.standard_u235(9)=4.40;
                    obj.standard_u235(10)=4.80;
                    obj.standard_u235(11)=4.95;
                    obj.standard_ba=zeros(18,1);
                    obj.standard_ba(1)=1.00;
                    obj.standard_ba(2)=1.50;
                    obj.standard_ba(3)=2.00;
                    obj.standard_ba(4)=2.50;
                    obj.standard_ba(5)=3.00;
                    obj.standard_ba(6)=3.50;
                    obj.standard_ba(7)=4.00;
                    obj.standard_ba(8)=4.50;
                    obj.standard_ba(9)=5.00;
                    obj.standard_ba(10)=5.50;
                    obj.standard_ba(11)=6.00;
                    obj.standard_ba(12)=6.50;
                    obj.standard_ba(13)=7.00;
                    obj.standard_ba(14)=7.50;
                    obj.standard_ba(15)=8.00;
                    obj.standard_ba(16)=8.50;
                    obj.standard_ba(17)=9.00;
                    obj.standard_ba(18)=9.50;
                    obj.plr(2,2) = 1;
                    obj.plr(4,2) = 1;
                    obj.plr(2,4) = 1;
                    obj.plr(5,5) = 1;
                    obj.plr(6,6) = 1;
                    obj.plr(7,2) = 1;
                    obj.plr(2,7) = 1;
                    obj.plr(9,2) = 1;
                    obj.plr(2,9) = 1;
                    obj.plr(9,9) = 1;
                    obj.plr(9,4) = 1;
                    obj.plr(9,9) = 1;
                    obj.plr(9,7) = 1;
                    obj.plr(7,9) = 1;
                    obj.plr(9,9) = 1;
                elseif    (obj.lfu(5,5) == 0 && ...
                        obj.lfu(5,6) == 0 && ...
                        obj.lfu(5,7) == 0 && ...
                        obj.lfu(6,5) == 0 && ...
                        obj.lfu(6,6) == 0 && ...
                        obj.lfu(6,7) == 0 && ...
                        obj.lfu(7,5) == 0 && ...
                        obj.lfu(7,6) == 0 && ...
                        obj.lfu(7,7) == 0)
                    obj.type={'Atrium10'};
                    obj.axial_zone(1)=11/25;
                    obj.axial_zone(2)=14/25;
                    obj.axial_zone(3)=0.1;
                    obj.axial_zone(4)=0.1;
                    obj.axial_zone(5)=0.1;
                    obj.axial_zone(6)=0.1;
                    obj.axial_zone(7)=0.1;
                    obj.axial_zone(8)=0.1;
                    obj.axial_zone(9)=0.1;
                    obj.axial_zone(10)=0.1;
                    obj.standard_u235=zeros(39,1);
                    obj.standard_u235(1)=0.71;
                    obj.standard_u235(2)=1.30;
                    obj.standard_u235(3)=1.40;
                    obj.standard_u235(4)=1.50;
                    obj.standard_u235(5)=1.60;
                    obj.standard_u235(6)=1.70;
                    obj.standard_u235(7)=1.80;
                    obj.standard_u235(8)=1.90;
                    obj.standard_u235(9)=2.00;
                    obj.standard_u235(10)=2.10;
                    obj.standard_u235(11)=2.20;
                    obj.standard_u235(12)=2.30;
                    obj.standard_u235(13)=2.40;
                    obj.standard_u235(14)=2.50;
                    obj.standard_u235(15)=2.60;
                    obj.standard_u235(16)=2.70;
                    obj.standard_u235(17)=2.80;
                    obj.standard_u235(18)=2.90;
                    obj.standard_u235(19)=3.00;
                    obj.standard_u235(20)=3.10;
                    obj.standard_u235(21)=3.20;
                    obj.standard_u235(22)=3.30;
                    obj.standard_u235(23)=3.40;
                    obj.standard_u235(24)=3.50;
                    obj.standard_u235(25)=3.60;
                    obj.standard_u235(26)=3.70;
                    obj.standard_u235(27)=3.80;
                    obj.standard_u235(28)=3.90;
                    obj.standard_u235(29)=4.00;
                    obj.standard_u235(30)=4.10;
                    obj.standard_u235(31)=4.20;
                    obj.standard_u235(32)=4.30;
                    obj.standard_u235(33)=4.40;
                    obj.standard_u235(34)=4.50;
                    obj.standard_u235(35)=4.60;
                    obj.standard_u235(36)=4.70;
                    obj.standard_u235(37)=4.80;
                    obj.standard_u235(38)=4.90;
                    obj.standard_u235(39)=5.00;
                    obj.standard_ba=zeros(18,1);
                    obj.standard_ba(1)=1.00;
                    obj.standard_ba(2)=1.50;
                    obj.standard_ba(3)=2.00;
                    obj.standard_ba(4)=2.50;
                    obj.standard_ba(5)=3.00;
                    obj.standard_ba(6)=3.50;
                    obj.standard_ba(7)=4.00;
                    obj.standard_ba(8)=4.50;
                    obj.standard_ba(9)=5.00;
                    obj.standard_ba(10)=5.50;
                    obj.standard_ba(11)=6.00;
                    obj.standard_ba(12)=6.50;
                    obj.standard_ba(13)=7.00;
                    obj.standard_ba(14)=7.50;
                    obj.standard_ba(15)=8.00;
                    obj.standard_ba(16)=8.50;
                    obj.standard_ba(17)=9.00;
                    obj.standard_ba(18)=9.50;
                    obj.plr(2,2) = 1;
                    obj.plr(5,3) = 1;
                    obj.plr(3,5) = 1;
                    obj.plr(7,3) = 1;
                    obj.plr(3,7) = 1;
                    obj.plr(7,8) = 1;
                    obj.plr(8,7) = 1;
                    obj.plr(9,2) = 1;
                    obj.plr(2,9) = 1;
                    obj.plr(9,9) = 1;
                    obj.plr(8,5) = 1;
                    obj.plr(5,8) = 1;
                end
            end
            
            if (obj.npst == 8)
                if (obj.bwr(1) > 1.6)
                    obj.type={'GE8'};
                    obj.axial_zone(1)=14/25;
                    obj.axial_zone(2)=11/25;
                    obj.axial_zone(3)=0.1;
                    obj.axial_zone(4)=0.1;
                    obj.axial_zone(5)=0.1;
                    obj.axial_zone(6)=0.1;
                    obj.axial_zone(7)=0.1;
                    obj.axial_zone(8)=0.1;
                    obj.axial_zone(9)=0.1;
                    obj.axial_zone(10)=0.1;
                    obj.standard_u235=zeros(11,1);
                    obj.standard_u235(1)=0.71;
                    obj.standard_u235(2)=1.60;
                    obj.standard_u235(3)=2.00;
                    obj.standard_u235(4)=2.40;
                    obj.standard_u235(5)=2.80;
                    obj.standard_u235(6)=3.20;
                    obj.standard_u235(7)=3.60;
                    obj.standard_u235(8)=4.00;
                    obj.standard_u235(9)=4.40;
                    obj.standard_u235(10)=4.80;
                    obj.standard_u235(11)=4.95;
                    obj.standard_ba=zeros(18,1);
                    obj.standard_ba(1)=1.00;
                    obj.standard_ba(2)=1.50;
                    obj.standard_ba(3)=2.00;
                    obj.standard_ba(4)=2.50;
                    obj.standard_ba(5)=3.00;
                    obj.standard_ba(6)=3.50;
                    obj.standard_ba(7)=4.00;
                    obj.standard_ba(8)=4.50;
                    obj.standard_ba(9)=5.00;
                    obj.standard_ba(10)=5.50;
                    obj.standard_ba(11)=6.00;
                    obj.standard_ba(12)=6.50;
                    obj.standard_ba(13)=7.00;
                    obj.standard_ba(14)=7.50;
                    obj.standard_ba(15)=8.00;
                    obj.standard_ba(16)=8.50;
                    obj.standard_ba(17)=9.00;
                    obj.standard_ba(18)=9.50;
                end
            end
            
            if (obj.npst == 9)
                if (obj.bwr(1) > 1.4)
                    obj.type={'GE11'};
                    obj.axial_zone(1)=14/25;
                    obj.axial_zone(2)=11/25;
                    obj.axial_zone(3)=0.1;
                    obj.axial_zone(4)=0.1;
                    obj.axial_zone(5)=0.1;
                    obj.axial_zone(6)=0.1;
                    obj.axial_zone(7)=0.1;
                    obj.axial_zone(8)=0.1;
                    obj.axial_zone(9)=0.1;
                    obj.axial_zone(10)=0.1;
                    obj.standard_u235=zeros(11,1);
                    obj.standard_u235(1)=0.71;
                    obj.standard_u235(2)=1.60;
                    obj.standard_u235(3)=2.00;
                    obj.standard_u235(4)=2.40;
                    obj.standard_u235(5)=2.80;
                    obj.standard_u235(6)=3.20;
                    obj.standard_u235(7)=3.60;
                    obj.standard_u235(8)=4.00;
                    obj.standard_u235(9)=4.40;
                    obj.standard_u235(10)=4.80;
                    obj.standard_u235(11)=4.95;
                    obj.standard_ba=zeros(18,1);
                    obj.standard_ba(1)=1.00;
                    obj.standard_ba(2)=1.50;
                    obj.standard_ba(3)=2.00;
                    obj.standard_ba(4)=2.50;
                    obj.standard_ba(5)=3.00;
                    obj.standard_ba(6)=3.50;
                    obj.standard_ba(7)=4.00;
                    obj.standard_ba(8)=4.50;
                    obj.standard_ba(9)=5.00;
                    obj.standard_ba(10)=5.50;
                    obj.standard_ba(11)=6.00;
                    obj.standard_ba(12)=6.50;
                    obj.standard_ba(13)=7.00;
                    obj.standard_ba(14)=7.50;
                    obj.standard_ba(15)=8.00;
                    obj.standard_ba(16)=8.50;
                    obj.standard_ba(17)=9.00;
                    obj.standard_ba(18)=9.50;
                end
            end
            
            
            
            
            
            if (~isempty(obj.pwr))
                for i=1:25
                    %                     obj.axial_zone(i)=1/25;
                    obj.axial_zone(i)=1;
                end
                obj.type={'pwr'};
            end
            
            
        end
        
        %_____________________________________________________
        %  Update U235 and BA radial matrix                   |
        %_____________________________________________________|
        
        function update_enr_ba(obj)
            
            % Radial U235
            for i=1:obj.npst
                for j=1:obj.npst
                    if(obj.lfu(i,j) > 0)
                        obj.enr(i,j) = obj.fue(obj.lfu(i,j),3);
                    else
                        obj.enr(i,j) = 0;
                    end
                end
            end
            
            % Radial BA
            for i=1:obj.npst
                for j=1:obj.npst
                    if(obj.lfu(i,j) > 0)
                        y=isnan(obj.fue(obj.lfu(i,j),4));
                        if(y==0)
                            obj.ba(i,j) = obj.fue(obj.lfu(i,j),5);
                        else
                            obj.ba(i,j) = 0;
                        end
                    else
                        obj.ba(i,j) = 0;
                    end
                end
            end
            
        end
        
        %_____________________________________________________
        %  Update U235  radial matrix                         |
        %_____________________________________________________|
        
        function update_enr(obj)
            
            % Radial U235
            for i=1:obj.npst
                for j=1:obj.npst
                    if(obj.lfu(i,j) > 0)
                        obj.enr(i,j) = obj.fue(obj.lfu(i,j),3);
                    else
                        obj.enr(i,j) = 0;
                    end
                end
            end
            
        end
        %_____________________________________________________
        %  Mean U235 enrichment and gU/cm                     |
        %_____________________________________________________|
        
        function calc_u235(obj)
            
            u235_sum=0;
            masssum=0;
            for i=1:obj.npst
                for j=1:obj.npst
                    if (obj.enr(i,j) > 0)
                        lpinr=obj.lpi(i,j);
                        
                        for k=1:obj.nr_fue
                            if (obj.lfu(i,j) == obj.fue(k,1))
                                k1=k;
                                break;
                            end
                        end
                        fuenr = k1;
                        %fuenr = obj.lfu(i,j);
                        vol=obj.pin(lpinr,2)^2*pi;
                        dens = obj.fue(fuenr,2);
                        mass=vol*dens;
                        masssum=mass+masssum;
                        u235_sum=mass*obj.enr(i,j)+u235_sum;
                    end
                end
            end
            obj.u235=u235_sum/masssum;
            obj.gU=obj.gUm*obj.axial_zone(obj.cn);
            
        end
        
        %_____________________________________________________
        %  Max permited fint                                  |
        %_____________________________________________________|
        
        function calc_maxfint_tab(obj,tab)
            
            obj.maxfint_tab = nan(obj.Nburnup,1);
            [nrbur,col] = size(tab);
            obj.finttab = nan(nrbur,col);
            
            obj.finttab = tab;
            
            for m=1:obj.Nburnup
                k=1;
                bur = obj.burnup(m);
                while (k <= nrbur && tab(k,1) <= bur)
                    p=k;
                    k=k+1;
                end
                bur1 = tab(p,1);
                if (p == nrbur)
                    obj.maxfint_tab(m) = tab(p,2);
                else
                    bur2 = tab(p+1,1);
                    fint1 = tab(p,2);
                    fint2 = tab(p+1,2);
                    obj.maxfint_tab(m) = (fint2-fint1)/(bur2-bur1)*(bur-bur1) + fint1;
                end
            end
            
        end
        
        
        %________________________________________________
        %  Increase tmol                                 |
        %________________________________________________|
        
        function increase_tmol(obj,i,j)
            
            if (obj.enr(i,j))
                if (obj.tmol(i,j) == 0)
                    obj.tmol(i,j)=obj.tmol(i,j) + 0.001;
                else
                    obj.tmol(i,j)=obj.tmol(i,j) + 0.01;
                end
            end
            
            if (obj.isym==2 || obj.isym==8)
                obj.tmol(j,i) = obj.tmol(i,j);
            end
            
        end
        
        
        %________________________________________________
        %  Decrease tmol                                 |
        %________________________________________________|
        
        function decrease_tmol(obj,i,j)
            
            if (obj.enr(i,j))
                obj.tmol(i,j)=obj.tmol(i,j) - 0.01;
                if (obj.tmol(i,j) < 0)
                    obj.tmol(i,j) = 0;
                end
            end
            
            if (obj.isym==2 || obj.isym==8)
                obj.tmol(j,i) = obj.tmol(i,j);
            end
            
        end
        
        %________________________________________________
        %  Reset tmol to zero                            |
        %________________________________________________|
        
        function reset_tmol(obj)
            
            obj.tmol = zeros(obj.npst);
            
        end
        
        %________________________________________________
        %  Increase powp                                 |
        %________________________________________________|
        
        function increase_powp(obj,i,j)
            
            if (obj.enr(i,j))
                obj.powp(i,j)=obj.powp(i,j) + 0.01;
            end
            
            if (obj.isym==2 || obj.isym==8)
                obj.powp(j,i) = obj.powp(i,j);
            end
            
        end
        
        %________________________________________________
        %  Decrease powp                                 |
        %________________________________________________|
        
        function decrease_powp(obj,i,j)
            
            if (obj.enr(i,j))
                obj.powp(i,j)=obj.powp(i,j) - 0.01;
                if (obj.powp(i,j) < 0)
                    obj.powp(i,j) = 0;
                end
            end
            
            if (obj.isym==2 || obj.isym==8)
                obj.powp(j,i) = obj.powp(i,j);
            end
            
        end
        
        %         %________________________________________________
        %         %  Reset powp to zero                            |
        %         %________________________________________________|
        %
        %         function reset_powp(obj)
        %
        %             obj.powp = zeros(obj.npst);
        %
        %         end
        
        
        %________________________________________________
        %  Check if power > maxfint and adjust fintp      |
        %________________________________________________|
        
        function checkmaxfint(obj)
            
            check = zeros(obj.npst);
            obj.fintp = zeros(obj.npst);
            for m=1:obj.Nburnup
                for j=1:obj.npst
                    for i=1:obj.npst
                        if (check(i,j)==0 && obj.pow(i,j,m) > obj.maxfint_tab(m))
                            obj.fintp(i,j) =  obj.fintp(i,j) + 1;
                            check(i,j) = 1;
                        end
                    end
                end
            end
            
        end
        
        
        %________________________________________________
        %  Calc. max permited power                      |
        %________________________________________________|
        
        function calc_powl(obj,balimit,plrlimit,cornerlimit,ba_tmol,plr_tmol,corner_tmol)
            
            obj.balimit     = balimit;
            obj.plrlimit    = plrlimit;
            obj.cornerlimit = cornerlimit;
            obj.ba_tmol = ba_tmol;
            obj.plr_tmol = plr_tmol;
            obj.corner_tmol = corner_tmol;
            obj.powl = obj.pow;
            ba_rod=zeros(obj.npst);
            for i=1:obj.npst
                for j=1:obj.npst
                    if (obj.ba(i,j) > 0)
                        ba_rod(i,j) = 1;
                    end
                end
            end
            
            
            if(obj.sel_rods == 1)
                for m=1:obj.Nburnup
                    obj.sel_rods_limit(:,:,m)=obj.tmol(:,:)+1;
                end
            end
            
            
            if (obj.aut_ba == 0)
                obj.aut_balimit = zeros(obj.npst,obj.npst,obj.Nburnup);
            elseif (obj.aut_ba == 1)
                for m=1:obj.Nburnup
                    for i=1:obj.npst
                        for j=1:obj.npst
                            if (obj.ba(i,j) > 0)
                                if (obj.exp(i,j,m) <= 23)
                                    obj.aut_balimit(i,j,m)=1/(1-0.016*obj.ba(i,j));
                                elseif(obj.exp(i,j,m) <= 57)
                                    obj.aut_balimit(i,j,m)=1/(1-0.016*obj.ba(i,j)*(57-obj.exp(i,j,m))/34);
                                else
                                    obj.aut_balimit(i,j,m)=1;
                                end
                            end
                        end
                    end
                end
            end
            
            for m=1:obj.Nburnup
                for i=1:obj.npst
                    for j=1:obj.npst
                        if (ba_rod(i,j) == 1 && obj.ba_tmol == 1)
                            obj.powl(i,j,m) = 0;
                        end
                        if (obj.plr(i,j) == 1 && obj.plr_tmol == 1)
                            obj.powl(i,j,m) = 0;
                        end
                    end
                end
                if (obj.corner_tmol == 1)
                    obj.powl(obj.npst,obj.npst,m) = 0;
                    obj.powl(1,obj.npst,m) = 0;
                    obj.powl(obj.npst,1,m) = 0;
                    obj.powl(1,1,m) = 0;
                end
            end
            for m=1:obj.Nburnup
                for i=1:obj.npst
                    for j=1:obj.npst
                        E=ba_rod(i,j)*obj.aut_balimit(i,j,m);
                        F=ba_rod(i,j)*balimit;
                        A=max(E,F);
                        B=obj.plr(i,j)*plrlimit;
                        C=max(A,B);
                        D=max(C,obj.corner_rod(i,j)*cornerlimit);
                        G=max(D,obj.sel_rods_limit(i,j));
                        obj.powl(i,j,m)=max(G*obj.pow(i,j,m),obj.pow(i,j,m));
                        %                         obj.powl(i,j,m)=max(D*obj.pow(i,j,m),obj.pow(i,j,m));
                    end
                end
            end
            check_fint=ones(obj.npst);
            obj.fintl= zeros(obj.Nburnup,1);
            for m=1:obj.Nburnup
                for i=1:obj.npst
                    for j=1:obj.npst
                        if (ba_rod(i,j) > 0 && obj.ba_tmol == 1)
                            check_fint(i,j) = 0;
                        end
                        if (obj.corner_rod(i,j) > 0 && obj.corner_tmol == 1)
                            check_fint(i,j) = 0;
                        end
                        if (obj.plr(i,j) > 0 && obj.plr_tmol == 1)
                            check_fint(i,j) = 0;
                        end
                        if (obj.sel_rods_limit(i,j) > 1)
                            check_fint(i,j) = 0;
                        end
                        
                        if (check_fint(i,j) == 1)
                            if (obj.pow(i,j,m) > obj.fintl(m))
                                obj.fintl(m) = obj.pow(i,j,m);
                            end
                        end
                        
                    end
                end
            end
            %  Normalize
            for k=1:obj.Nburnup
                sum=0;
                for i=1:obj.npst
                    for j=1:obj.npst
                        sum = sum + obj.powl(i,j,k);
                    end
                end
                for i=1:obj.npst
                    for j=1:obj.npst
                        obj.powl(i,j,k) = obj.powl(i,j,k)/sum*obj.Nlfu;
                    end
                end
            end
        end
        
        
        %________________________________________________
        %  u235 sorting rods                             |
        %________________________________________________|
        
        function sortrods(obj)
            
            temp=nan(obj.nr_fue,5);
            [~,indx]=sort(obj.fue(:,3));
            for i=1:obj.nr_fue
                temp(i,1) = i;
                temp(i,2) = obj.fue(indx(i),2);
                temp(i,3) = obj.fue(indx(i),3);
                temp(i,4) = obj.fue(indx(i),4);
                temp(i,5) = obj.fue(indx(i),5);
            end
            obj.fue=temp;
            
            for i=1:obj.npst
                for j=1:obj.npst
                    if(obj.lfu(i,j) > 0)
                        m=1;
                        while (obj.lfu(i,j) ~= indx(m))
                            m=m+1;
                        end
                        obj.lfu(i,j) = m;
                    end
                end
            end
            
            m=1;
            while (obj.fue(m,5) > 0)
                m=m+1;
            end
            nr = m;
            
            for i=1:obj.npst
                for j=1:obj.npst
                    if(obj.lfu(i,j) > obj.nr_fue)
                        obj.lfu(i,j) = nr;
                    end
                end
            end
            
            obj.update_enr_ba();
            
            
        end
        
        
        %________________________________________________
        %  Delete one rod                                |
        %________________________________________________|
        
        function delrod(obj,i)
            
            obj.fue(i,1)=nan;
            obj.fue(i,2)=nan;
            obj.fue(i,3)=nan;
            obj.fue(i,4)=nan;
            obj.fue(i,5)=nan;
            obj.nr_fue=obj.nr_fue-1;
            
        end
        
        %________________________________________________
        %  Add one rod                                   |
        %________________________________________________|
        
        function addrod(obj,i)
            
            obj.fue(obj.nr_fue+1,1)=obj.nr_fue+1;
            obj.fue(obj.nr_fue+1,2)=obj.fue(i,2);
            obj.fue(obj.nr_fue+1,3)=obj.fue(i,3);
            obj.fue(obj.nr_fue+1,4)=obj.fue(i,4);
            obj.fue(obj.nr_fue+1,5)=obj.fue(i,5);
            obj.nr_fue=obj.nr_fue+1;
            
        end
        
        
        function calc_channel_bow(obj, channel_bow)
            
            obj.channel_bow = channel_bow;
            
            %   Channel bow sensitive/mm
            bow=zeros(obj.npst);
            if (strcmp('Svea96Optima2', obj.type))
                bow(1,:)  = [ 0.068, 0.062, 0.056, 0.051, 0.046, 0.000, 0.041, 0.041, 0.033, 0.019, 0.000];
                bow(2,:)  = [ 0.062, 0.022, 0.038, 0.013, 0.027, 0.000, 0.024, 0.008, 0.015, 0.000,-0.019];
                bow(3,:)  = [ 0.056, 0.038, 0.023, 0.017, 0.015, 0.000, 0.011, 0.003, 0.000,-0.015,-0.032];
                bow(4,:)  = [ 0.051, 0.013, 0.017, 0.010, 0.007, 0.000, 0.004,-0.001,-0.003,-0.008,-0.041];
                bow(5,:)  = [ 0.046, 0.027, 0.015, 0.007, 0.000, 0.000, 0.000,-0.004,-0.012,-0.024,-0.041];
                bow(6,:)  = [ 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000];
                bow(7,:)  = [ 0.041, 0.024, 0.011, 0.004, 0.000, 0.000, 0.000,-0.007,-0.015,-0.028,-0.046];
                bow(8,:)  = [ 0.041, 0.008, 0.003,-0.001,-0.004, 0.000,-0.007,-0.010,-0.017,-0.012,-0.051];
                bow(9,:)  = [ 0.033, 0.015, 0.000,-0.003,-0.012, 0.000,-0.015,-0.017,-0.023,-0.038,-0.056];
                bow(10,:) = [ 0.019, 0.000,-0.015,-0.008,-0.024, 0.000,-0.028,-0.012,-0.038,-0.021,-0.062];
                bow(11,:) = [ 0.000,-0.019,-0.032,-0.041,-0.041, 0.000,-0.046,-0.051,-0.056,-0.062,-0.068];
            elseif (strcmp('GE14', obj.type))
                bow(1,:)  = [0.052,	0.049, 0.046, 0.043, 0.039, 0.036, 0.033, 0.026, 0.013, 0.000];
                bow(2,:)  = [0.049,	0.044, 0.015, 0.027, 0.025, 0.021, 0.018, 0.006,-0.001,-0.014];
                bow(3,:)  = [0.046,	0.015, 0.019, 0.017, 0.015, 0.012, 0.009, 0.002,-0.005,-0.026];
                bow(4,:)  = [0.043,	0.027, 0.017, 0.012, 0.008, 0.000, 0.000,-0.003,-0.018,-0.034];
                bow(5,:)  = [0.039,	0.025, 0.015, 0.008, 0.004, 0.000 ,0.000,-0.010,-0.022,-0.041];
                bow(6,:)  = [0.036,	0.021, 0.012, 0.000, 0.000,-0.003,-0.005,-0.012,-0.008,-0.045];
                bow(7,:)  = [0.033,	0.018, 0.009, 0.000, 0.000,-0.005,-0.009,-0.018,-0.030, 0.048];
                bow(8,:)  = [0.026,	0.006, 0.002,-0.003,-0.010,-0.012,-0.018,-0.023,-0.015 -0.053];
                bow(9,:)  = [0.013,-0.001,-0.005,-0.018,-0.022,-0.008,-0.030,-0.015,-0.044,-0.056];
                bow(10,:) = [0.000,-0.014,-0.026,-0.034,-0.041,-0.045,-0.048,-0.053,-0.056,-0.060];
            elseif (strcmp('GNF2', obj.type))
                bow(1,:)  = [0.052,	0.049, 0.046, 0.043, 0.039, 0.036, 0.033, 0.026, 0.013, 0.000];
                bow(2,:)  = [0.049,	0.044, 0.015, 0.027, 0.025, 0.021, 0.018, 0.006,-0.001,-0.014];
                bow(3,:)  = [0.046,	0.015, 0.019, 0.017, 0.015, 0.012, 0.009, 0.002,-0.005,-0.026];
                bow(4,:)  = [0.043,	0.027, 0.017, 0.012, 0.008, 0.000, 0.000,-0.003,-0.018,-0.034];
                bow(5,:)  = [0.039,	0.025, 0.015, 0.008, 0.004, 0.000 ,0.000,-0.010,-0.022,-0.041];
                bow(6,:)  = [0.036,	0.021, 0.012, 0.000, 0.000,-0.003,-0.005,-0.012,-0.008,-0.045];
                bow(7,:)  = [0.033,	0.018, 0.009, 0.000, 0.000,-0.005,-0.009,-0.018,-0.030, 0.048];
                bow(8,:)  = [0.026,	0.006, 0.002,-0.003,-0.010,-0.012,-0.018,-0.023,-0.015 -0.053];
                bow(9,:)  = [0.013,-0.001,-0.005,-0.018,-0.022,-0.008,-0.030,-0.015,-0.044,-0.056];
                bow(10,:) = [0.000,-0.014,-0.026,-0.034,-0.041,-0.045,-0.048,-0.053,-0.056,-0.060];
            elseif (strcmp('Atrium10', obj.type))
                bow(1,:)  = [0.058, 0.052, 0.050, 0.047, 0.042,	0.039, 0.036, 0.026, 0.015, 0.000];
                bow(2,:)  = [0.052,	0.045, 0.036, 0.012, 0.027, 0.024, 0.020, 0.003, 0.001,-0.015];
                bow(3,:)  = [0.050,	0.036, 0.026, 0.018, 0.014, 0.012, 0.008,-0.001,-0.011,-0.027];
                bow(4,:)  = [0.047,	0.012, 0.018, 0.012, 0.007, 0.000, 0.000,-0.004,-0.008,-0.035];
                bow(5,:)  = [0.042,	0.027, 0.014, 0.007, 0.000, 0.000, 0.000,-0.010,-0.020,-0.040];
                bow(6,:)  = [0.039,	0.024, 0.012, 0.000, 0.000, 0.000, 0.000,-0.012,-0.025,-0.044];
                bow(7,:)  = [0.036,	0.020, 0.008, 0.000, 0.000, 0.000, 0.000,-0.014,-0.013,-0.050];
                bow(8,:)  = [0.026,	0.003,-0.001,-0.004,-0.010,-0.012,-0.014,-0.023,-0.035,-0.052];
                bow(9,:)  = [0.015,	0.001,-0.011,-0.008,-0.020,-0.025,-0.013,-0.035,-0.046,-0.057];
                bow(10,:) = [0.000,-0.015,-0.027,-0.035,-0.040,-0.044,-0.050,-0.052,-0.057,-0.062];
            end
            
            
            for k=1:obj.Nburnup
                obj.pow(:,:,k)=obj.pow(:,:,k)./(1+bow*obj.old_channel_bow);
                obj.pow(:,:,k)=obj.pow(:,:,k).*(1+bow*obj.channel_bow);
            end
            
            obj.old_channel_bow=obj.channel_bow;
        end
        
        function number_enrichments (obj)
            
            obj.nr_enr = zeros(obj.nr_fue,1);
            
            for i=1:obj.npst
                for j=1:obj.npst
                    if (obj.lfu(i,j) > 0)
                        obj.nr_enr(obj.lfu(i,j),1) = obj.nr_enr(obj.lfu(i,j),1) + 1;
                    end
                end
            end
            
        end
        
        %
        %   End of functions
        %
    end
    
    
    
    %________________________________________________
    %   End                                          |
    %________________________________________________|
end



function casmap=ReadCasMap(Text,Format)
if nargin<2, Format='%g';end
N=length(Text);
casmap=cell(N,1);
for i=1:N,
    casmap{i}=sscanf(Text{i},Format);
end
end


function A=CasMapCell2Mat(Acell)

N=length(Acell);
A=NaN(N);
for i=1:N,
    Ni=length(Acell{i});
    A(i,1:Ni)=Acell{i};
end
A=SetSym(A);
end


function A=SetSym(A)

At=A';
ii=find(isnan(A));
A(ii)=At(ii);
end


