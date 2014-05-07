classdef storage < handle
    properties
        s
        xpo
        tot_kan;
        mminj;
        number_of_bundles;
    end
    
    
    methods
        
        function  obj = storage(cc)
            obj.s=cc.s;
            obj.number_of_bundles=0;
        end
        
        
        function calc_number_of_bundles(obj)
            
            obj.number_of_bundles=0;
            
            for k=1:obj.tot_kan;
                if(obj.s(k).color>1)
                    obj.number_of_bundles=obj.number_of_bundles+1;
                end
            end
        end
        
        
    end
end