function distname=GetPowerDist(coreinfo)

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
