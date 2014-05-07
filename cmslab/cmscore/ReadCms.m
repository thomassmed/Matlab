function [cmscore]=ReadCms(cmsfile)


if(exist(cmsfile,'file') == 2)
    [cmsinfo,ScalarData,NodeData,ScalarStruct,dim,info] = read_cms(cmsfile);
    
    for k=1:length(cmsinfo.distlist)
        if(strcmp(cmsinfo.distlist(k),'3LHG - Linear Heat Generation Rate - LHGR'))
            [lhg,Names,index]=read_cms_dist(cmsinfo,'3LHG - Linear Heat Generation Rate - LHGR');
            break;
        end
    end
    
    for k=1:length(cmsinfo.distlist)
        if(strcmp(cmsinfo.distlist(k),'3FLP - Fraction of LHGR Operating Limit - MFLPD'))
            [flp,Names,index]=read_cms_dist(cmsinfo,'3FLP - Fraction of LHGR Operating Limit - MFLPD');
            break;
        end
    end
    
    for k=1:length(cmsinfo.distlist)
        if(strcmp(cmsinfo.distlist(k),'3APL - Average Planar Heat Generation Rate'))
            [apl,Names,index]=read_cms_dist(cmsinfo,'3APL - Average Planar Heat Generation Rate');
            break;
        end
    end
    
    for k=1:length(cmsinfo.distlist)
        if(strcmp(cmsinfo.distlist(k),'3FLA - Fraction of MAPLHGR Operating Limit'))
            [fla,Names,index]=read_cms_dist(cmsinfo,'3FLA - Fraction of MAPLHGR Operating Limit');
            break;
        end
    end
    
    for k=1:length(cmsinfo.distlist)
        if(strcmp(cmsinfo.distlist(k),'3VOI - Inchannel Void Fraction'))
            [voi,Names,index]=read_cms_dist(cmsinfo,'3VOI - Inchannel Void Fraction');
            break;
        end
    end
    
    for k=1:length(cmsinfo.distlist)
        if(strcmp(cmsinfo.distlist(k),'3RPF - Relative Power Fraction'))
            [rpf,Names,index]=read_cms_dist(cmsinfo,'3RPF - Relative Power Fraction');
            break;
        end
    end
    
    for k=1:length(cmsinfo.distlist)
        if(strcmp(cmsinfo.distlist(k),'CRD.POS'))
            [crd,Names,index]=read_cms_dist(cmsinfo,'CRD.POS');
            break;
        end
    end
    
    
    for k=1:length(cmsinfo.distlist)
        if(strcmp(cmsinfo.distlist(k),'3EXP  - Exposure - GWd/t'))
            [exp,Names,index]=read_cms_dist(cmsinfo,'3EXP  - Exposure - GWd/t');
            break;
        end
    end
    
    
    cmscore.lhg=reshape(cell2mat(lhg),cmsinfo.core.kmax,cmsinfo.core.kan,length(lhg));
    cmscore.apl=reshape(cell2mat(apl),cmsinfo.core.kmax,cmsinfo.core.kan,length(apl));
    cmscore.fla=reshape(cell2mat(fla),cmsinfo.core.kmax,cmsinfo.core.kan,length(fla));
    cmscore.flp=reshape(cell2mat(flp),cmsinfo.core.kmax,cmsinfo.core.kan,length(flp));
    cmscore.voi=reshape(cell2mat(voi),cmsinfo.core.kmax,cmsinfo.core.kan,length(voi));
    cmscore.rpf=reshape(cell2mat(rpf),cmsinfo.core.kmax,cmsinfo.core.kan,length(rpf));
    cmscore.exp=reshape(cell2mat(exp),cmsinfo.core.kmax,cmsinfo.core.kan,length(exp));
    cmscore.konrod=reshape(cell2mat(crd),1,max(size(crd{1})),length(crd));
    
    for i=1:length(crd)
        cmscore.corekonrod(:,:,i)=cr2core(cmscore.konrod(:,:,i),cmsinfo.core.mminj,cmsinfo.core.crmminj);
    end
    
    
    cmscore.NodeData=NodeData;
    
 
end


end






