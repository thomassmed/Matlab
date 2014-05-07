function distname=GetDistName(coreinfo,name)

distname='';
if nargin<2,
    name='POWER';
end


switch upper(name)
    case 'POWER'
        indx=findrow(coreinfo.distlist,'Ppower');
        if ~isempty(indx),
            distname=coreinfo.distlist(indx(1));
            return;
        end
        
        indx=findrow(coreinfo.distlist,'3RPF');
        if ~isempty(indx),
            distname=coreinfo.distlist(indx(1));
            return;
        end
        
        indx=findrow(coreinfo.distlist,'RPF');
        if ~isempty(indx),
            distname=coreinfo.distlist(indx(1));
            return;
        end
        
        indx=findrow(coreinfo.distlist,'POWER');
        if ~isempty(indx),
            distname=coreinfo.distlist(indx(1));
            return;
        end
    case 'NHYD'
        indx=findrow(coreinfo.distlist,'NHYD');
        if ~isempty(indx),
            distname=coreinfo.distlist(indx(1));
            return;
        end
        indx=findrow(coreinfo.misclist,'NHYD');
        if ~isempty(indx),
            distname=coreinfo.misclist(indx(1));
            return;
        end
    case 'NFT'
        indx=findrow(coreinfo.distlist,'NFT');
        if ~isempty(indx),
            distname=coreinfo.distlist(indx(1));
            return;
        end           
        indx=findrow(coreinfo.misclist,'NFT');
        if ~isempty(indx),
            distname=coreinfo.misclist(indx(1));
            return;
        end   
        indx=findrow(coreinfo.misclist,'FUE.TYP');
        if ~isempty(indx),
            distname=coreinfo.misclist(indx(1));
            return;
        end   
        indx=findrow(coreinfo.distlist,'ASYTYP');
        if ~isempty(indx),
            distname=coreinfo.distlist(indx(1));
            return;
        end   
    case 'BAT'
        indx=findrow(coreinfo.misclist,'BAT');
        if ~isempty(indx),
            distname=coreinfo.misclist(indx(1));
            return;
        end   
        indx=findrow(coreinfo.misclist,'FUE.BAT');
        if ~isempty(indx),
            distname=coreinfo.misclist(indx(1));
            return;
        end           
end
