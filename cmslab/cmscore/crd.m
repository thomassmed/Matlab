classdef crd < handle
    properties
        nr
%         crdsteps
        pos
        konrod

    end
    
    
    methods
        
        function  obj = crd(i,fileinfo)
            obj.nr=i;
            obj.pos=fileinfo.conrodcoor(i,:);
%             obj.crdsteps=fileinfo.crdsteps;
            
            
            obj.konrod=zeros(1,length(fileinfo.xpo));
            
            for j=1:length(fileinfo.xpo)
            
            obj.konrod(1,j)=fileinfo.konrod(1,i,j);
           
            end
            

        end
        
    end
end