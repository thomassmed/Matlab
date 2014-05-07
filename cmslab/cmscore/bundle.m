classdef bundle < handle
    properties
        bn
        pos
        power
        burnup
        dens
        evoid
        void
        kinf
        color
        crd
        flp
        fla
        lhg
        apl
        ser
        zon
        nfra
        rand
        crdzon
    end
    
    methods
        
        function  obj = bundle(i,fileinfo,core)
            obj.bn=i;
            obj.color=1;
            obj.pos=fileinfo.ij(i,:);

            obj.power=nan(fileinfo.kmax,1,length(fileinfo.xpo));
            obj.burnup=nan(fileinfo.kmax,1,length(fileinfo.xpo));
            obj.dens=nan(fileinfo.kmax,1,length(fileinfo.xpo));
            obj.evoid=nan(fileinfo.kmax,1,length(fileinfo.xpo));
            obj.void=nan(fileinfo.kmax,1,length(fileinfo.xpo));
            obj.kinf=nan(fileinfo.kmax,1,length(fileinfo.xpo));
            obj.kinf=zeros(fileinfo.kmax,1,length(fileinfo.xpo));
            obj.flp=zeros(fileinfo.kmax,1,length(fileinfo.xpo));
            obj.fla=zeros(fileinfo.kmax,1,length(fileinfo.xpo));
            obj.lhg=zeros(fileinfo.kmax,1,length(fileinfo.xpo));
            obj.apl=zeros(fileinfo.kmax,1,length(fileinfo.xpo));
            
            obj.crd=nan(1,length(fileinfo.xpo));
            
            if(core)
                obj.ser=fileinfo.ser(i,:);
%                                 obj.zon=fileinfo.crdzon(obj.pos(1),obj.pos(2));
                obj.zon=fileinfo.zones(obj.pos(1),obj.pos(2));
                obj.nfra=fileinfo.nfra(obj.pos(1),obj.pos(2));
                obj.rand=fileinfo.rand(obj.pos(1),obj.pos(2));
                obj.crdzon=fileinfo.crdzon(obj.pos(1),obj.pos(2));
                
                if(obj.crdzon==3 && obj.nfra==3)
                    obj.zon=9;
                end
                if(obj.crdzon==3 && obj.nfra==1)
                    obj.zon=8;
                end
                if(obj.crdzon==3 && obj.nfra==2)
                    obj.zon=7;
                end
                if(obj.crdzon==3 && obj.nfra==0)
                    obj.zon=6;
                end
                
                for j=1:length(fileinfo.xpo)
                    obj.power(:,:,j)=fileinfo.rpf(:,i,j);
                    obj.burnup(:,:,j)=fileinfo.EXP3D(:,i,j);
                    obj.dens(:,:,j)=fileinfo.DENS3D(:,i,j);
                    obj.evoid(:,:,j)=fileinfo.EVOID3D(:,i,j);
                    obj.kinf(:,:,j)=fileinfo.kinf(:,i,j);
                    obj.void(:,:,j)=fileinfo.voi(:,i,j);
                    obj.flp(:,:,j)=fileinfo.flp(:,i,j);
                    obj.fla(:,:,j)=fileinfo.fla(:,i,j);
                    obj.lhg(:,:,j)=fileinfo.lhg(:,i,j);
                    obj.apl(:,:,j)=fileinfo.apl(:,i,j);
                    obj.crd(:,j)=fileinfo.corekonrod(fileinfo.ij(i,1),fileinfo.ij(i,2),j);
                end
            end
        end
        
    end
end