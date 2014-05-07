function dists = GetResData(resinfo,distlab,stptinp,asspos)


if ~isstruct(resinfo) && strcmpi(strtrim(resinfo),'EXCEPTIONS') && isscalar(distlab)
    Sim = distlab;
    if2x2 = stptinp;
    if Sim == 3
        if if2x2 == 2
            dists = GetResDataS3_2x2('exceptions');
        else
            dists = GetResDataS3_1x1('exceptions');
        end
    elseif Sim == 5     
        if if2x2 == 2
            dists = GetResDataS5_2x2('exceptions');
        else
            dists = GetResDataS5_1x1('exceptions');
        end
    end
    return
elseif ~isstruct(resinfo) && strcmpi(strtrim(resinfo),'NONDISTS') && isscalar(distlab)
    Sim = distlab;
    if2x2 = stptinp;
    if Sim == 3
        dists = GetResDataS3('nondists');
    elseif Sim == 5     
        dists = GetResDataS5('nondists');
    end
    return
else
    Sim = resinfo.fileinfo.Sim;
end

if strcmpi(strtrim(distlab),'EXCEPTIONS')
    if Sim == 3
        dists = GetResDataS3('exceptions');
    elseif Sim ==5     
        dists = GetResDataS5('exceptions');
    end
    return
end
if nargin <4 || (length(asspos)==1 && asspos == 0)
    if Sim == 3
        if resinfo.core.if2x2 == 2
            dists = GetResDataS3_2x2(resinfo,distlab,stptinp);
        else
            dists = GetResDataS3_1x1(resinfo,distlab,stptinp);
        end
    elseif Sim == 5
        if resinfo.core.if2x2 == 2
            dists = GetResDataS5_2x2(resinfo,distlab,stptinp);
        else
            dists = GetResDataS5_1x1(resinfo,distlab,stptinp);
        end
    end
else
    if Sim == 3
        if resinfo.core.if2x2 == 2
            dists = GetResDataS3_2x2(resinfo,distlab,stptinp,asspos);
        else
            dists = GetResDataS3_1x1(resinfo,distlab,stptinp,asspos);
        end
    elseif Sim == 5
        if resinfo.core.if2x2 == 2
            dists = GetResDataS5_2x2(resinfo,distlab,stptinp,asspos);
        else
            dists = GetResDataS5_1x1(resinfo,distlab,stptinp,asspos);
        end
    end
end