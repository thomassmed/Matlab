classdef reactor < handle
    properties
        s
        sc
        xpo
        kmax
        crdsteps
        iafull;
        tot_kan;
        irmx;
        tot_crd;
        mminj;
        power;
        
    end
    
    
    methods
        
        function  obj = reactor(cc)
            obj.s=cc.s;
            obj.sc=cc.sc;
        end
        
        
        
        % Core mean distribution
        function calc_core_mean(obj,dist)
            
            if(strcmp(dist,'power'))
                
                obj.power=zeros(obj.kmax,1,length(obj.xpo));
                
                for m=1:length(obj.xpo)
                    for k=1:obj.tot_kan
                        obj.power(:,:,m)=obj.power(:,:,m)+obj.s(k).power(:,:,m);
                    end
                    obj.power(:,:,m)=obj.power(:,:,m)/obj.tot_kan;
                end
                
            end
            
            
        end
        
        
        
        
    end
end