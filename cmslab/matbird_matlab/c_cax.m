classdef c_cax < handle
    
    properties
        npst
        cnmax;
        s;
        Nburnup;
        btffile;
        btfax;
        maxbtfax;
        oldbtfax;
        oldmaxbtfax;
        u235
        btfax_env
        btfp
        btfp_btf
        maxbtfax_env
        maxbtf_tab
        btftab
        fintp_bundle
        rodenr
        rodba
        rodtype
        rodtype2
        nr_rod
        rod
        powp
%         tmol
        Y
        best
        min_btfax_env
        plotmaxfint
        plotoldmaxfint
        plotmaxbtf
        plotminbtf
        plotoldmaxbtf
        plotoldminbtf
        plotmaxkinf
        plotminkinf
        rodenr2
        rodba2
        nr_rod2
        Nrods
        First_btfax_call
        crd
        axial
        
    end
    
    methods
        
        % Class constructor
        function  obj = c_cax(s)
            obj.s=s;
            obj.npst=s(1).npst;
            obj.Nburnup=s(1).Nburnup;
            obj.btfp=zeros(obj.npst);
            obj.btfp_btf=zeros(obj.npst);
            obj.fintp_bundle=zeros(obj.npst);
            obj.powp=zeros(obj.npst);
%             obj.tmol=zeros(obj.npst);
            obj.btffile=[];
            obj.First_btfax_call = 1;
            obj.crd=100;
            obj.axial=zeros(length(s),1);
            
            obj.axial(1)=obj.s(1).axial_zone(1);
            for k=2:length(s)
                obj.axial(k)=obj.s(k).axial_zone(k)+obj.axial(k-1);
            end
        end
        
        
        % Bundle mean u235 enrichmnet
        function calc_u235(obj)
            for k=1:obj.cnmax
                obj.s(k).calc_u235;
            end
            obj.u235=0;
            gUsum=0;
            for m=1:obj.cnmax
                temp = obj.s(m).u235*obj.s(m).gU;
                obj.u235 = temp + obj.u235;
                gUsum = gUsum + obj.s(m).gU;
            end
            obj.u235 = obj.u235/gUsum;
        end
        
        
        % Bundle BTF
        function [imax,jmax]=calc_btfax(obj)
            
            obj.axial(1)=obj.s(1).axial_zone(1);
            for k=2:length(obj.s)
                obj.axial(k)=obj.s(k).axial_zone(k)+obj.axial(k-1);
            end

            for k=1:obj.cnmax
                obj.s(k).calcbtf();
            end
            obj.btfax = zeros(obj.npst,obj.npst,obj.Nburnup);
            obj.maxbtfax  = nan(obj.Nburnup,1);
            
            if(obj.crd < 100)
                crd_weight=zeros(obj.cnmax,1);
                crd_ins=(100-obj.crd)/100;
                if(crd_ins > obj.axial(1))
                    crd_weight(1)=1.0;
                else
                    crd_weight(1)= crd_ins/obj.axial(1);
                end
                for k=2:obj.cnmax
                    if(crd_ins > obj.axial(k) )
                        crd_weight(k)=1.0;
                    else
                        crd_weight(k)= (crd_ins-obj.axial(k-1))/obj.s(k).axial_zone(k);
                        if(crd_weight(k) <= 0)
                            crd_weight(k) = 0;
                        end
                    end
                end
                for k=1:obj.cnmax
                    obj.btfax = obj.btfax + crd_weight(k)*obj.s(k).btfaxw_crd + (1-crd_weight(k))*obj.s(k).btfaxw;
                end
            else
                for k=1:obj.cnmax
                    obj.btfax = obj.btfax + obj.s(k).btfaxw;
                end
            end
            
            
            
            for m=1:obj.cnmax
                for k=1:obj.Nburnup
                    maxx=0;
                    for i=1:obj.npst
                        for j=1:obj.npst
                            if(obj.btfax(i,j,k) > maxx)
                                maxx =obj.btfax(i,j,k);
                                imax=i;
                                jmax=j;
                            end
                        end
                    end
                    obj.maxbtfax(k,1) = maxx;
                end
            end
            
            if (obj.First_btfax_call == 1)
                obj.oldbtfax = obj.btfax;
                obj.oldmaxbtfax = obj.maxbtfax;
                obj.First_btfax_call = 0;
            end
        end
        
        
        % Bundle kinf envelope BTF
        function [imax,jmax]=calc_btfax_env(obj)
            
            
            for k=1:obj.cnmax
                obj.s(k).calcbtf();
            end
            obj.btfax_env = zeros(obj.npst);
            
            
            if(obj.crd < 100)
                crd_weight=zeros(obj.cnmax,1);
                crd_ins=(100-obj.crd)/100;
                if(crd_ins > obj.axial(1))
                    crd_weight(1)=1.0;
                else
                    crd_weight(1)= crd_ins/obj.axial(1);
                end
                for k=2:obj.cnmax
                    if(crd_ins > obj.axial(k) )
                        crd_weight(k)=1.0;
                    else
                        crd_weight(k)= (crd_ins-obj.axial(k-1))/obj.s(k).axial_zone(k);
                        if(crd_weight(k) <= 0)
                            crd_weight(k) = 0;
                        end
                    end
                end
                for k=1:obj.cnmax
                    obj.btfax_env = obj.btfax_env + crd_weight(k)*obj.s(k).btfaxw_env_crd + (1-crd_weight(k))*obj.s(k).btfaxw_env;
                end
            else
                for k=1:obj.cnmax
                    obj.btfax_env = obj.btfax_env + obj.s(k).btfaxw_env;
                end
            end
                    
%             for k=1:obj.cnmax
%                 obj.btfax_env = obj.btfax_env + obj.s(k).btfaxw_env;
%             end
            
            obj.btfax_env = obj.btfp + obj.btfax_env;
            max=0;
            for i=1:obj.npst
                for j=1:obj.npst
                    if(obj.btfax_env(i,j) > max)
                        max=obj.btfax_env(i,j);
                        imax=i;
                        jmax=j;
                    end
                end
            end
            obj.maxbtfax_env = max;
        end
        
        % Optimizing function
        function increase_u235(obj)
            
            % Increase u235 two step
            for m=1:obj.cnmax
                for i=1:obj.npst
                    for j=1:obj.npst
                        if (obj.s(m).ba(i,j)==0 && obj.s(m).enr(i,j)>0)
                            p=1;
                            while (p < obj.s(m).lfu(i,j))
                                p=p+1;
                            end
                            k=0;
                            while (k <= 2 && p <=obj.s(m).nr_fue)
                                if (isnan(obj.s(m).fue(p,5)))
                                    obj.s(m).lfu(i,j) = p;
                                    k=k+1;
                                end
                                p=p+1;
                            end
                        end
                    end
                end
                obj.s(m).update_enr_ba();
                obj.s(m).smallcalc();
            end
            
        end
        
        
        % Optimizing function
        function decrease_u235(obj,imax,jmax)
            
            for m=1:obj.cnmax
                if (obj.s(m).lfu(imax,jmax) > 0)
                    if (obj.s(m).ba(imax,jmax) == 0)
                        k=0;
                        while (k < 1 && obj.s(m).fue(obj.s(m).lfu(imax,jmax),1) > 1)
                            obj.s(m).lfu(imax,jmax) = obj.s(m).lfu(imax,jmax) - 1;
                            if (obj.s(m).isym == 2)
                                obj.s(m).lfu(jmax,imax) = obj.s(m).lfu(imax,jmax);
                            end
                            if (isnan(obj.s(m).fue(obj.s(m).lfu(imax,jmax),5)))
                                k=k+1;
                            end
                        end
                    end
                    obj.s(m).update_enr();
                    obj.s(m).smallcalc();
                end
            end
            
        end
        
        % Optimizing function
        function decrease_u235_barod(obj,imax,jmax)
            
            for m=1:obj.cnmax
                if (obj.s(m).ba(imax,jmax) > 0)
                    [mz,~] = size(obj.s(m).standard_u235);
                    k=1;
                    while(k<=mz && obj.s(m).standard_u235(k) < obj.s(m).fue(obj.s(m).lfu(imax,jmax),3))
                        k=k+1;
                    end
                    if (k==1)
                        k=2;
                    end
                    obj.s(m).fue(obj.s(m).lfu(imax,jmax),3) = obj.s(m).standard_u235(k-1);
                    obj.s(m).update_enr();
                    obj.s(m).bigcalc();
                end
            end
            
        end
        
        % Optimizing function
        function check_min_u235(obj,imax,jmax)
            
            for m=1:obj.cnmax
                if (obj.s(m).lfu(imax,jmax) == 1)
                        [mz,~] = size(obj.s(m).standard_u235);
                        k=1;
                        while(k<=mz && obj.s(m).standard_u235(k) < obj.s(m).fue(obj.s(m).lfu(imax,jmax),3))
                            k=k+1;
                        end
                        if(k>1)
                            if (k==2)
                                k=3;
                            end
                            obj.s(m).fue(obj.s(m).lfu(imax,jmax),3) = obj.s(m).standard_u235(k-1);
                            obj.s(m).update_enr();
                            obj.s(m).bigcalc();
                        end
                end
            end
            
        end
        
        
        % Optimizing function
        function check_maxfint(obj)
            
            for k=1:obj.cnmax
                obj.s(k).checkmaxfint();
            end
            obj.fintp_bundle=zeros(obj.npst);
            for k=1:obj.cnmax
                for i=1:obj.s(k).npst
                    for j=1:obj.s(k).npst
                        if(obj.s(k).fintp(i,j) > obj.fintp_bundle(i,j))
                            obj.fintp_bundle(i,j) = obj.s(k).fintp(i,j);
                        end
                    end
                end
            end
            
        end
        
        
        % Optimizing function
        function check_maxbtf(obj)
            
            obj.btfp_btf=zeros(obj.npst);
            
            maxx = zeros(obj.npst);
            for m=1:obj.Nburnup
                for i=1:obj.npst
                    for j=1:obj.npst
                        if (obj.btfax(i,j,m) > obj.maxbtf_tab(m))
                            maxx(i,j) = 0.01 + obj.btfax(i,j,m) - obj.maxbtf_tab(m);
                            if(maxx(i,j) > obj.btfp_btf(i,j))
                                obj.btfp_btf(i,j) = maxx(i,j);
                            end
                        end
                    end
                end
            end
            
        end
        
        
        % Optimizing function
        function adjust_btfp(obj)
            
            %obj.btfp=zeros(obj.npst);
            
            for i=1:obj.npst
                for j=1:obj.npst
                    if (obj.fintp_bundle(i,j) == 1)
                        obj.btfp(i,j) = 0.01 + obj.btfp(i,j) + (obj.maxbtfax_env - obj.btfax_env(i,j));
                    end
                end
            end
            
            if (strcmp('Svea96Optima2', obj.s(1).type))
                obj.btfp(1,1) = 0;
                obj.btfp(obj.npst,1) = 0;
                obj.btfp(1,obj.npst) = 0;
                obj.btfp(obj.npst,obj.npst) = 0;
            end
            
        end
        
        % Optimizing function
        function adjust_btfp_btf(obj)
            
            obj.btfp = max(obj.btfp,obj.btfp_btf);
            
        end
        
        
        % Optimizing function
        function adjust_tmol(obj)
            
            temp=zeros(obj.npst);
            for i=1:obj.npst
                for j=1:obj.npst
                    if (obj.powp(i,j) > 0)
%                         temp(i,j) = 1.0*(max(max(obj.btfax_env)) - obj.btfax_env(i,j));
                        temp(i,j) = 0.005+(max(max(obj.btfax_env)) - obj.btfax_env(i,j));
                    end
                end
            end
            
            obj.btfp = obj.btfp + temp;
            
        end
        
        
        function calc_powp(obj)
            
            for m=1:obj.cnmax
                maxx=zeros(obj.npst);
                for k=1:obj.Nburnup
                    if (obj.s(m).burnup(k) <= obj.s(m).max_burnup)
                        for i=1:obj.npst
                            for j=1:obj.npst
                                if(obj.s(m).powl(i,j,k) >= obj.s(m).fintl(k))
                                    if (obj.s(m).powl(i,j,k) - obj.s(m).fintl(k) >= maxx(i,j)+0.001)
                                        maxx(i,j) = obj.s(m).powl(i,j,k) - obj.s(m).fintl(k);
                                    end
                                end
                            end
                        end
                        obj.s(m).powp = maxx;
                    end
                end
            end
            
            maxx=zeros(obj.npst);
            for m=1:obj.cnmax
                for i=1:obj.npst
                    for j=1:obj.npst
                        if (obj.s(m).powp(i,j) > maxx(i,j))
                            maxx(i,j) = obj.s(m).powp(i,j);
                        end
                    end
                end
            end
            obj.powp = maxx;
        end
        
        
        
        function calc_rod(obj)
            
            obj.rodenr=zeros(obj.npst);
            obj.rodba=zeros(obj.npst);
            obj.rodtype=zeros(obj.npst);
            
            for k=1:obj.cnmax
                obj.rodtype = obj.rodtype + obj.s(k).lfu*obj.s(k).axial_zone(k)*k;
                obj.rodenr = obj.rodenr + obj.s(k).enr*obj.s(k).axial_zone(k);
                obj.rodba = obj.rodba + obj.s(k).ba*obj.s(k).axial_zone(k);
            end
            
            A=unique(obj.rodtype);
            A(A==0) = [];
            [obj.nr_rod,~] = size(A);
            obj.rod = nan(obj.cnmax*obj.nr_rod,3);
            obj.rod(1:obj.nr_rod,1) = A(:,1);
            
            for k=1:obj.nr_rod
                for i=1:obj.npst
                    for j=1:obj.npst
                        if (obj.rodtype(i,j) == obj.rod(k,1))
                            obj.rod(k,2) = obj.rodenr(i,j);
                            obj.rod(k,3) = obj.rodba(i,j);
                        end
                    end
                end
            end
            
            for m=1:obj.cnmax
                for n=obj.nr_rod+1:2*obj.nr_rod
                    for i=1:obj.npst
                        for j=1:obj.npst
                            if (obj.rodtype(i,j) == obj.rod(n-obj.nr_rod,1))
                                obj.rod(n,m) = obj.s(m).enr(i,j);
                            end
                        end
                    end
                end
            end
            
            for m=1:obj.cnmax
                for n=2*obj.nr_rod+1:3*obj.nr_rod
                    for i=1:obj.npst
                        for j=1:obj.npst
                            if (obj.rodtype(i,j) == obj.rod(n-2*obj.nr_rod,1))
                                obj.rod(n,m) = obj.s(m).ba(i,j);
                            end
                        end
                    end
                end
            end
            
            obj.rodtype2 = obj.rod(1:obj.nr_rod,1);
            obj.rodenr2 = obj.rod(1:obj.nr_rod,2);
            obj.rodba2 = obj.rod(1:obj.nr_rod,3);
            
            obj.nr_rod2 = zeros(obj.nr_rod,1);
            
            obj.Nrods = 0;
            for i=1:obj.npst
                for j=1:obj.npst
                    if (obj.rodtype(i,j) > 0)
                        for m=1:obj.nr_rod
                            if (obj.rodtype2(m) == obj.rodtype(i,j))
                                obj.nr_rod2(m) = obj.nr_rod2(m) + 1;
                                obj.Nrods = obj.Nrods + 1;
                            end
                        end
                    end
                end
            end
            
        end
        
        %________________________________________________
        %  Increase btfp                                 |
        %________________________________________________|
        
        function increase_btfp(obj,i,j)
            
            if (obj.rodenr(i,j))
                obj.btfp(i,j)=obj.btfp(i,j) + 0.01;
            end
            
            if (obj.s(1).isym==2)
                obj.btfp(j,i) = obj.btfp(i,j);
            end
            
        end
        
        %________________________________________________
        %  Decrease btfp                                 |
        %________________________________________________|
        
        function decrease_btfp(obj,i,j)
            
            if (obj.rodenr(i,j))
                obj.btfp(i,j)=obj.btfp(i,j) - 0.01;
                if (obj.btfp(i,j) < 0)
                    obj.btfp(i,j) = 0;
                end
            end
            
            if (obj.s(1).isym==2)
                obj.btfp(j,i) = obj.btfp(i,j);
            end
            
        end
        
        %________________________________________________
        %  Reset btfp to zero                            |
        %________________________________________________|
        
        function reset_btfp(obj)
            
            obj.btfp = zeros(obj.npst);
            obj.btfp_btf = zeros(obj.npst);
            
        end
        
        %_____________________________________________________
        %  Max permited btf                                   |
        %_____________________________________________________|
        
        function calc_maxbtf_tab(obj,tab)
            
            obj.maxbtf_tab = nan(obj.Nburnup,1);
            [nrbur,col] = size(tab);
            obj.btftab = nan(nrbur,col);
            
            obj.btftab = tab;
            
            for m=1:obj.Nburnup
                k=1;
                bur = obj.s(1).burnup(m);
                while (k <= nrbur && tab(k,1) <= bur)
                    p=k;
                    k=k+1;
                end
                bur1 = tab(p,1);
                if (p == nrbur)
                    obj.maxbtf_tab(m) = tab(p,2);
                else
                    bur2 = tab(p+1,1);
                    btf1 = tab(p,2);
                    btf2 = tab(p+1,2);
                    obj.maxbtf_tab(m) = (btf2-btf1)/(bur2-bur1)*(bur-bur1) + btf1;
                end
            end
            
        end
        
        
%         function [mz]=enr_combinations(obj)
%             
%             enr_comb = nan(obj.s(1).nr_fue,3);
%             for ii=1:obj.s(1).nr_fue
%                 if (isnan(obj.s(1).fue(ii,5)))
%                     enr_comb(ii,2) =  obj.s(1).fue(ii,3);
%                 end
%             end
%             [mz,~] = size(obj.s(1).standard_u235);
%             for ii=1:obj.s(1).nr_fue
%                 m=1;
%                 if (isnan(obj.s(1).fue(ii,5)))
%                     while(obj.s(1).standard_u235(m) < enr_comb(ii,2))
%                         m=m+1;
%                     end
%                     if (m == 1)
%                         enr_comb(ii,1) = (obj.s(1).standard_u235(m));
%                         enr_comb(ii,3) = (obj.s(1).standard_u235(m+1));
%                     elseif (m == mz)
%                         enr_comb(ii,1) = (obj.s(1).standard_u235(m-1));
%                         enr_comb(ii,3) = (obj.s(1).standard_u235(m));
%                     else
%                         enr_comb(ii,1) = (obj.s(1).standard_u235(m-1));
%                         enr_comb(ii,3) = (obj.s(1).standard_u235(m+1));
%                     end
%                 end
%             end
%             
%             obj.Y=GenPer(enr_comb);
%             [~,mz]=size(obj.Y);
%             
%             function Y=GenPer(X)
%                 ikeep=find(~isnan(X(:,1)));
%                 [r,c]=size(X(ikeep,:));
%                 jmax=c^r;
%                 Y=nan(size(X,1),jmax);
%                 for i=1:r,
%                     for j=1:c,
%                         for i1=1:c^(i-1),
%                             jind=(i1+(j-1)*c^(i-1)):c^i:jmax;
%                             Y(ikeep(i),jind)=X(ikeep(i),j);
%                         end
%                     end
%                 end
%             end
%             
%         end
        


        function [mz]=enr_combinations(obj)
            
            enr_comb = nan(obj.s(2).nr_fue,3);
            for ii=1:obj.s(2).nr_fue
                if (isnan(obj.s(2).fue(ii,5)))
                    enr_comb(ii,2) =  obj.s(2).fue(ii,3);
                end
            end
            [mz,~] = size(obj.s(2).standard_u235);
            for ii=1:obj.s(2).nr_fue
                m=1;
                if (isnan(obj.s(2).fue(ii,5)))
                    while(obj.s(2).standard_u235(m) < enr_comb(ii,2))
                        m=m+1;
                    end
                    if (m == 1)
                        enr_comb(ii,1) = (obj.s(2).standard_u235(m));
                        enr_comb(ii,3) = (obj.s(2).standard_u235(m+1));
                    elseif (m == mz)
                        enr_comb(ii,1) = (obj.s(2).standard_u235(m-1));
                        enr_comb(ii,3) = (obj.s(2).standard_u235(m));
                    else
                        enr_comb(ii,1) = (obj.s(2).standard_u235(m-1));
                        enr_comb(ii,3) = (obj.s(2).standard_u235(m+1));
                    end
                end
            end
            
            obj.Y=GenPer(enr_comb);
            [~,mz]=size(obj.Y);
            
            function Y=GenPer(X)
                ikeep=find(~isnan(X(:,1)));
                [r,c]=size(X(ikeep,:));
                jmax=c^r;
                Y=nan(size(X,1),jmax);
                for i=1:r,
                    for j=1:c,
                        for i1=1:c^(i-1),
                            jind=(i1+(j-1)*c^(i-1)):c^i:jmax;
                            Y(ikeep(i),jind)=X(ikeep(i),j);
                        end
                    end
                end
            end
            
        end
        



        function enr_opt(obj,mm)
            
            for k=1:obj.cnmax
                for i=1:obj.s(k).nr_fue
                    if (isnan(obj.s(k).fue(i,5)))
                        obj.s(k).fue(i,3) = obj.Y(i,mm);
                    end
                end
                obj.s(k).update_enr();
                obj.s(k).smallcalc();
                obj.s(k).calcbtf();
            end
            obj.btfax_env=zeros(obj.npst);
            for k=1:obj.cnmax
                obj.btfax_env = obj.btfax_env + obj.s(k).btfaxw_env;
            end
            obj.btfax_env = obj.btfp + obj.btfax_env;
            maxx=0;
            for i=1:obj.npst
                for j=1:obj.npst
                    if(obj.btfax_env(i,j) > maxx)
                        maxx =obj.btfax_env(i,j);
                    end
                end
            end
            obj.maxbtfax_env = maxx;
            if (obj.maxbtfax_env < obj.min_btfax_env)
                obj.min_btfax_env = obj.maxbtfax_env;
                obj.best=mm;
            end
            for k=1:obj.cnmax
                for i=1:obj.s(k).nr_fue
                    if (isnan(obj.s(k).fue(i,5)))
                        obj.s(k).fue(i,3) = obj.Y(i,obj.best);
                    end
                end
                obj.s(k).update_enr();
                obj.s(k).smallcalc();
                obj.s(k).calcbtf();
            end
        end
        
        
        function max_corner_fint(obj)
            
            if (strcmp('Svea96Optima2', obj.s(1).type))
                ok=0;
                k=0;
                no_increase = 0;
                while (ok==0 && k < 100)
                    m=1;
                    while (ok == 0 && m <= obj.Nburnup && k < 100)
                        k=k+1;
                        if (ok == 0 && obj.s(1).pow(1,1,m) > obj.s(1).maxfint_tab(m))
                            u0=obj.s(1).enr(1,1);
                            obj.decrease_u235(1,1);
                            u1=obj.s(1).enr(1,1);
                            if(u0 == u1)
                                no_increase = 1;
                            end
                            ok = 1;
                        end
                        m=m+1;
                    end
                    m=1;
                    while (ok == 1 && m <= obj.Nburnup && k < 100)
                        if (ok==1 && obj.s(1).pow(1,1,m) > obj.s(1).maxfint_tab(m))
                            ok=0;
                        end
                        m=m+1;
                    end
                end
                ok=0;
                k=0;
                while (ok==0 && k < 100)
                    m=1;
                    while (ok == 0 && m <= obj.Nburnup && k < 100)
                        k=k+1;
                        if (ok == 0 && obj.s(1).pow(obj.npst,1,m) > obj.s(1).maxfint_tab(m))
                            u0=obj.s(1).enr(obj.npst,1);
                            obj.decrease_u235(obj.npst,1);
                            u1=obj.s(1).enr(obj.npst,1);
                            if(u0 == u1)
                                no_increase = 1;
                            end
                            ok = 1;
                        end
                        m=m+1;
                    end
                    m=1;
                    while (ok == 1 && m <= obj.Nburnup && k < 100)
                        if (ok==1 && obj.s(1).pow(obj.npst,1,m) > obj.s(1).maxfint_tab(m))
                            ok=0;
                        end
                        m=m+1;
                    end
                end
                if (obj.s(1).isym == 1)
                    ok=0;
                    k=0;
                    while (ok==0 && k < 100)
                        m=1;
                        while (ok == 0 && m <= obj.Nburnup && k < 100)
                            k=k+1;
                            if (ok == 0 && obj.s(1).pow(1,obj.npst,m) > obj.s(1).maxfint_tab(m))
                                u0=obj.s(1).enr(1,obj.npst);
                                obj.decrease_u235(1,obj.npst);
                                u1=obj.s(1).enr(1,obj.npst);
                                if(u0 == u1)
                                    no_increase = 1;
                                end
                                ok = 1;
                            end
                            m=m+1;
                        end
                        m=1;
                        while (ok == 1 && m <= obj.Nburnup && k < 100)
                            if (ok==1 && obj.s(1).pow(1,obj.npst,m) > obj.s(1).maxfint_tab(m))
                                ok=0;
                            end
                            m=m+1;
                        end
                    end
                end
                ok=0;
                k=0;
                while (ok==0 && k < 100)
                    m=1;
                    while (ok == 0 && m <= obj.Nburnup && k < 100)
                        k=k+1;
                        if (ok == 0 && obj.s(1).pow(obj.npst,obj.npst,m) > obj.s(1).maxfint_tab(m))
                            u0=obj.s(1).enr(obj.npst,obj.npst);
                            obj.decrease_u235(obj.npst,obj.npst);
                            u1=obj.s(1).enr(obj.npst,obj.npst);
                            if(u0 == u1)
                                no_increase = 1;
                            end
                            ok = 1;
                        end
                        m=m+1;
                    end
                    m=1;
                    while (ok == 1 && m <= obj.Nburnup && k < 100)
                        if (ok==1 && obj.s(1).pow(obj.npst,obj.npst,m) > obj.s(1).maxfint_tab(m))
                            ok=0;
                        end
                        m=m+1;
                    end
                end
                if (no_increase == 1)
                    if (obj.s(1).lfu(1,1) == 1)
                        obj.check_min_u235(1,1);
                        
                    elseif (obj.s(1).lfu(obj.npst,1) == 1)
%                         obj.check_min_u235(obj,obj.npst,1);
                        obj.check_min_u235(obj.npst,1);
                        
                    elseif (obj.s(1).lfu(1,obj.npst) == 1)
%                         obj.check_min_u235(obj,1,obj.npst);
                        obj.check_min_u235(1,obj.npst);
                        
                    elseif (obj.s(1).lfu(obj.npst,obj.npst) == 1)
%                         obj.check_min_u235(obj,obj.npst,obj.npst);
                        obj.check_min_u235(obj.npst,obj.npst);
                    end
                end
            end
        end
        
        
        function max_corner_tmol(obj)
            
            if (strcmp('Svea96Optima2', obj.s(1).type))
                obj.s(1).calc_powl(obj.s(1).balimit,obj.s(1).plrlimit,obj.s(1).cornerlimit,0,0,obj.s(1).corner_tmol);
                ok=0;
                k=0;
                no_increase = 0;
                while (ok==0 && k < 100)
                    m=1;
                    while (ok == 0 && m <= obj.Nburnup && k < 100 && obj.s(1).burnup(m) < obj.s(1).max_burnup)
                        k=k+1;
                        if (ok == 0 && obj.s(1).powl(1,1,m) > obj.s(1).fintl(m))
                            u0=obj.s(1).enr(1,1);
                            obj.decrease_u235(1,1);
                            u1=obj.s(1).enr(1,1);
                            if(u0 == u1)
                                no_increase = 1;
                            end
                            ok = 1;
                        end
                        m=m+1;
                    end
                    m=1;
                    while (ok == 0 && m <= obj.Nburnup && k < 100 && obj.s(1).burnup(m) < obj.s(1).max_burnup)
                        if (ok==1 && obj.s(1).powl(1,1,m) > obj.s(1).fintl(m))
                            ok=0;
                        end
                        m=m+1;
                    end
                end
                ok=0;
                k=0;
                while (ok==0 && k < 100)
                    m=1;
                    while (ok == 0 && m <= obj.Nburnup && k < 100 && obj.s(1).burnup(m) < obj.s(1).max_burnup)
                        k=k+1;
                        if (ok == 0 && obj.s(1).powl(obj.npst,1,m) > obj.s(1).fintl(m))
                            u0=obj.s(1).enr(obj.npst,1);
                            obj.decrease_u235(obj.npst,1);
                            u1=obj.s(1).enr(obj.npst,1);
                            if(u0 == u1)
                                no_increase = 1;
                            end
                            ok = 1;
                        end
                        m=m+1;
                    end
                    m=1;
                    while (ok == 0 && m <= obj.Nburnup && k < 100 && obj.s(1).burnup(m) < obj.s(1).max_burnup)
                        if (ok==1 && obj.s(1).powl(obj.npst,1,m) > obj.s(1).fintl(m))
                            ok=0;
                        end
                        m=m+1;
                    end
                end
                if (obj.s(1).isym == 1)
                    ok=0;
                    k=0;
                    while (ok==0 && k < 100)
                        m=1;
                        while (ok == 0 && m <= obj.Nburnup && k < 100 && obj.s(1).burnup(m) < obj.s(1).max_burnup)
                            k=k+1;
                            if (ok == 0 && obj.s(1).powl(1,obj.npst,m) > obj.s(1).fintl(m))
                                u0=obj.s(1).enr(1,obj.npst);
                                obj.decrease_u235(1,obj.npst);
                                u1=obj.s(1).enr(1,obj.npst);
                                if(u0 == u1)
                                    no_increase = 1;
                                end
                                ok = 1;
                            end
                            m=m+1;
                        end
                        m=1;
                        while (ok == 0 && m <= obj.Nburnup && k < 100 && obj.s(1).burnup(m) < obj.s(1).max_burnup)
                            if (ok==1 && obj.s(1).powl(1,obj.npst,m) > obj.s(1).fintl(m))
                                ok=0;
                            end
                            m=m+1;
                        end
                    end
                end
                ok=0;
                k=0;
                while (ok==0 && k < 100)
                    m=1;
                    while (ok == 0 && m <= obj.Nburnup && k < 100 && obj.s(1).burnup(m) < obj.s(1).max_burnup)
                        k=k+1;
                        if (ok == 0 && obj.s(1).powl(obj.npst,obj.npst,m) > obj.s(1).fintl(m))
                            u0=obj.s(1).enr(obj.npst,obj.npst);
                            obj.decrease_u235(obj.npst,obj.npst);
                            u1=obj.s(1).enr(obj.npst,obj.npst);
                            if(u0 == u1)
                                no_increase = 1;
                            end
                            ok = 1;
                        end
                        m=m+1;
                    end
                    m=1;
                    while (ok == 0 && m <= obj.Nburnup && k < 100 && obj.s(1).burnup(m) < obj.s(1).max_burnup)
                        if (ok==1 && obj.s(1).powl(obj.npst,obj.npst,m) > obj.s(1).fintl(m))
                            ok=0;
                        end
                        m=m+1;
                    end
                end
                if (no_increase == 1)
                    if (obj.s(1).lfu(1,1) == 1)
                        obj.check_min_u235(1,1);
                        
                    elseif (obj.s(1).lfu(obj.npst,1) == 1)
                        %                         obj.check_min_u235(obj,obj.npst,1);
                        obj.check_min_u235(obj.npst,1);
                        
                    elseif (obj.s(1).lfu(1,obj.npst) == 1)
                        %                         obj.check_min_u235(obj,1,obj.npst);
                        obj.check_min_u235(1,obj.npst);
                        
                    elseif (obj.s(1).lfu(obj.npst,obj.npst) == 1)
                        %                         obj.check_min_u235(obj,obj.npst,obj.npst);
                        obj.check_min_u235(obj.npst,obj.npst);
                    end
                end
            end
        end
        
        function maxmin_values(obj)
            
            temp = nan(obj.cnmax,1);
            
            
            
            for k=1:obj.cnmax
                temp(k) =  max(obj.s(k).fint);
            end
            temp1 = max(temp);
            obj.plotmaxfint = round(100*(temp1+0.01))/100;
            
            
            
            
            for k=1:obj.cnmax
                temp(k) =  max(obj.s(k).oldfint);
            end
            temp1 = max(temp);
            obj.plotoldmaxfint = round(100*(temp1+0.01))/100;
            
            
            
            
            if (strcmp('pwr', obj.s(1).type))
                obj.plotmaxbtf = 2;
                obj.plotminbtf = 0;
            else
                temp1 =  max(obj.maxbtfax);
                obj.plotmaxbtf = round(100*(temp1+0.0075))/100;
                temp1 =  min(obj.maxbtfax);
                obj.plotminbtf = round(100*(temp1-0.0075))/100;
                
                temp1 =  max(obj.oldmaxbtfax);
                obj.plotoldmaxbtf = round(100*(temp1+0.0075))/100;
                temp1 =  min(obj.oldmaxbtfax);
                obj.plotoldminbtf = round(100*(temp1-0.0075))/100;
                
            end
            
            
            temp = nan(obj.cnmax,1);
            for k=1:obj.cnmax
                temp(k) =  max(obj.s(k).kinf);
            end
            temp1 = max(temp);
            obj.plotmaxkinf = round(100*(temp1+0.015))/100;
            
            temp = nan(obj.cnmax,1);
            for k=1:obj.cnmax
                temp(k) =  min(obj.s(k).kinf);
            end
            temp1 = min(temp);
            obj.plotminkinf = round(100*(temp1-0.015))/100;
            
        end
        
        
        
        %________________________________________________
        %   Write btffile                                |
        %________________________________________________|
        
        function writebtffile(obj)
            
            
            dir=file('dirname',obj.s(1).caxfile);
            obj.btffile = strcat(dir,'/btf_file');
            fid = fopen(obj.btffile,'w');
            
            %             if(~isempty(obj.crd))
            if(obj.s(1).crd_read==1)
                
                
                
                oldcrd = obj.crd;
                tab=zeros(20,11);
                for k=1:11
                    obj.crd = 100-10*(k-1);
                    calc_btfax(obj);
                    tab(1,k)=obj.maxbtfax(1);
                    tab(2,k)=obj.maxbtfax(2);
                    tab(3,k)=obj.maxbtfax(3);
                    tab(4,k)=obj.maxbtfax(4);
                    tab(5,k)=obj.maxbtfax(5);
                    tab(6,k)=obj.maxbtfax(6);
                    tab(7,k)=obj.maxbtfax(7);
                    tab(8,k)=obj.maxbtfax(9);
                    tab(9,k)=obj.maxbtfax(11);
                    tab(10,k)=obj.maxbtfax(13);
                    tab(11,k)=obj.maxbtfax(15);
                    tab(12,k)=obj.maxbtfax(17);
                    tab(13,k)=obj.maxbtfax(19);
                    tab(14,k)=obj.maxbtfax(21);
                    tab(15,k)=obj.maxbtfax(23);
                    tab(16,k)=obj.maxbtfax(25);
                    tab(17,k)=obj.maxbtfax(29);
                    tab(18,k)=obj.maxbtfax(33);
                    tab(19,k)=obj.maxbtfax(37);
                    tab(20,k)=obj.maxbtfax(41);
                end

                str = '''CPR.FUE'' ''GE'' = ''GNF2'' ''ASSEMBLY'' ''GNF'' ,,, ''CPRMOD''/ ';
                fprintf(fid,'%s\n\n',str);
                str = '''CPR.BTF'' ''GE'' = ''ASM-CE'' 11,20';
                fprintf(fid,'%s\n',str);
                str = sprintf(' 0.00  0.10  0.20  0.30  0.40  0.50  0.60  0.70  0.80  0.90  1.00');
                fprintf(fid,'%s\n',str);
                
                str = sprintf(' %4.1f %4.1f %4.1f %4.1f %4.1f %4.1f %4.1f %4.1f %4.1f %4.1f'...
                    ,obj.s(1).burnup(1),obj.s(1).burnup(2),obj.s(1).burnup(3),obj.s(1).burnup(4),obj.s(1).burnup(5)...
                    ,obj.s(1).burnup(6),obj.s(1).burnup(7),obj.s(1).burnup(9),obj.s(1).burnup(11),obj.s(1).burnup(13));
                fprintf(fid,'%s\n',str);
                str = sprintf(' %4.1f %4.1f %4.1f %4.1f %4.1f %4.1f %4.1f %4.1f %4.1f %4.1f %4.1f'...
                    ,obj.s(1).burnup(15),obj.s(1).burnup(17),obj.s(1).burnup(19),obj.s(1).burnup(21),obj.s(1).burnup(23)...
                    ,obj.s(1).burnup(25),obj.s(1).burnup(29),obj.s(1).burnup(33),obj.s(1).burnup(37),obj.s(1).burnup(41));
                fprintf(fid,'%s\n',str);
                for k=1:20
                    for m=1:11
                        str=sprintf(' %6.4f',tab(k,m));
                        fprintf(fid,'%s',str);
                    end
                    if(k<20)
                        fprintf(fid,'\n');
                    else
                        fprintf(fid,'/');
                    end
                end
                obj.crd = oldcrd;
                
            else
                
                str = '''CPR.FUE'' ''GE'' = ''GNF2'' ''ASSEMBLY'' ''GNF'' ,,, ''CPRMOD''/ ';
                fprintf(fid,'%s\n\n',str);
                str = '''CPR.BTF'' ''GE'' = ''EBUN'' 20';
                fprintf(fid,'%s',str);
                
                str = sprintf(' %4.1f %4.1f %4.1f %4.1f %4.1f %4.1f %4.1f %4.1f %4.1f %4.1f'...
                    ,obj.s(1).burnup(1),obj.s(1).burnup(2),obj.s(1).burnup(3),obj.s(1).burnup(4),obj.s(1).burnup(5)...
                    ,obj.s(1).burnup(6),obj.s(1).burnup(7),obj.s(1).burnup(9),obj.s(1).burnup(11),obj.s(1).burnup(13));
                fprintf(fid,'%s\n',str);
                str = sprintf('                           %4.1f %4.1f %4.1f %4.1f %4.1f %4.1f %4.1f %4.1f %4.1f %4.1f %4.1f'...
                    ,obj.s(1).burnup(15),obj.s(1).burnup(17),obj.s(1).burnup(19),obj.s(1).burnup(21),obj.s(1).burnup(23)...
                    ,obj.s(1).burnup(25),obj.s(1).burnup(29),obj.s(1).burnup(33),obj.s(1).burnup(37),obj.s(1).burnup(41));
                fprintf(fid,'%s\n',str);
                
                str = sprintf('%8.6f %8.6f %8.6f %8.6f %8.6f %8.6f %8.6f %8.6f %8.6f %8.6f'...
                    ,obj.maxbtfax(1),obj.maxbtfax(2),obj.maxbtfax(3),obj.maxbtfax(4),obj.maxbtfax(5)...
                    ,obj.maxbtfax(6),obj.maxbtfax(7),obj.maxbtfax(9),obj.maxbtfax(11),obj.maxbtfax(13));
                fprintf(fid,'%s\n',str);
                str = sprintf('%8.6f %8.6f %8.6f %8.6f %8.6f %8.6f %8.6f %8.6f %8.6f %8.6f'...
                    ,obj.maxbtfax(15),obj.maxbtfax(17),obj.maxbtfax(19),obj.maxbtfax(21),obj.maxbtfax(23)...
                    ,obj.maxbtfax(25),obj.maxbtfax(29),obj.maxbtfax(33),obj.maxbtfax(37),obj.maxbtfax(41));
                fprintf(fid,'%s/',str);
  
            end
            
            fclose(fid);
        end
            % End of methods
        end
    
end

