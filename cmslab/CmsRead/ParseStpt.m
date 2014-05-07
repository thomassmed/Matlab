function stpt=ParseStpt(stpt,coreinfo)
nxp=length(coreinfo.Xpo);
if ischar(stpt)
    switch upper(stpt)
        case 'FIRST'
            stpt = 1;
        case 'LAST'
            stpt = length(coreinfo.Xpo);
        case 'ALL'
            stpt = 1:nxp;
    end
elseif isnumeric(stpt)
    if max(abs(round(stpt)-stpt))==0 && max(stpt)<=nxp,
        return;
    end
    nxp=length(stpt);
    tmpr = 1;
    for i = 1:nxp
        [indic p] = max(abs(coreinfo.Xpo - stpt(i)) < 0.01);
        if indic == 1
            stpt(tmpr) = p;
            tmpr = tmpr + 1;
        end
    end
    if stpt == 10000
        stpt = 1;
    elseif stpt == 20000
        stpt = length(coreinfo.Xpo);
    end
end