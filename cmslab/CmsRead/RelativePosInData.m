function [relpos idcon] = RelativePosInData(dist,kmax,resinfo,stptinp) 
% RelativePosInData returns the relative positions for reading some
% distrubutions or the distribution using idcon (found in dimensions in
% restartfile)
if nargin >1
dimens = resinfo.data.Dimensions;
conorder = dimens{1,4}(2:end);
loopcount = 1;
distc = {dist};
else
    loopcount = 1:length(dist);
    distc = mat2cell(dist,1,ones(1,length(dist)));
end
relpos = cell(length(loopcount),1);
for i = loopcount;
switch distc{i};
    case {'BURNUP','EXPOSURE','EXP'}
        idcon = 1;
        idpos = find(idcon == conorder) - 1;
        relpos{i} = 4*kmax*(idpos) + 32 + 8*idpos;
    case 'VHIST'
        idcon = 3;
        idpos = find(idcon == conorder) - 1;
        relpos{i} = 4*kmax*(idpos) + 32 + 8*idpos;
    case 'TFUHIST'
        idcon = 5;
        idpos = find(idcon == conorder) - 1;
        relpos{i} = 4*kmax*(idpos) + 32 + 8*idpos;
    case 'DENHIST'
        idcon = 7;
        idpos = find(idcon == conorder) - 1;
        relpos{i} = 4*kmax*(idpos) + 32 + 8*idpos;
    case 'BORONDENS'
        idcon = 9;
        idpos = find(idcon == conorder) - 1;
        relpos{i} = 4*kmax*(idpos) + 32 + 8*idpos;
    case 'CRDHIST'
        idcon = 11;
        idpos = find(idcon == conorder) - 1;
        relpos{i} = 4*kmax*(idpos) + 32 + 8*idpos;
    case 'SURFEXPYM'
        idcon = 15;
        idpos = find(idcon == conorder) - 1;
        relpos{i} = 4*kmax*(idpos) + 32 + 8*idpos;
    case 'SURFEXPXP'
        idcon = 16;
        idpos = find(idcon == conorder) - 1;
        relpos{i} = 4*kmax*(idpos) + 32 + 8*idpos;
    case 'SURFEXPYP'
        idcon = 17;
        idpos = find(idcon == conorder) - 1;
        relpos{i} = 4*kmax*(idpos) + 32 + 8*idpos;
    case 'SURFEXPXM'
        idcon = 18;
        idpos = find(idcon == conorder) - 1;
        relpos{i} = 4*kmax*(idpos) + 32 + 8*idpos;
    case 'SPECHIST'
        idcon = 19;
        idpos = find(idcon == conorder) - 1;
        relpos{i} = 4*kmax*(idpos) + 32 + 8*idpos;
    case 'SPECHISTYM'
        idcon = 20;
        idpos = find(idcon == conorder) - 1;
        relpos{i} = 4*kmax*(idpos) + 32 + 8*idpos;
    case 'SPECHISTXP'
        idcon = 21;
        idpos = find(idcon == conorder) - 1;
        relpos{i} = 4*kmax*(idpos) + 32 + 8*idpos;
    case 'SPECHISTYP'
        idcon = 22;
        idpos = find(idcon == conorder) - 1;
        relpos{i} = 4*kmax*(idpos) + 32 + 8*idpos;
    case 'SPECHISTXM'
        idcon = 23;
        idpos = find(idcon == conorder) - 1;
        relpos{i} = 4*kmax*(idpos) + 32 + 8*idpos;
    case 'EB1'
        idcon = 25;
        idpos = find(idcon == conorder) - 1;
        relpos{i} = 4*kmax*(idpos) + 32 + 8*idpos;
    case 'BP1' 
        idcon = 26;
        idpos = find(idcon == conorder) - 1;
        relpos{i} = 4*kmax*(idpos) + 32 + 8*idpos;
    case 'BP10'
        idcon = 27;
        idpos = find(idcon == conorder) - 1;
        relpos{i} = 4*kmax*(idpos) + 32 + 8*idpos;
    case 'BP2'
        idcon = 28;
        idpos = find(idcon == conorder) - 1;
        relpos{i} = 4*kmax*(idpos) + 32 + 8*idpos;
    case 'BP20' 
        idcon = 29;
        idpos = find(idcon == conorder) - 1;
        relpos{i} = 4*kmax*(idpos) + 32 + 8*idpos;
    case 'EB2'
        idcon = 30;
        idpos = find(idcon == conorder) - 1;
        relpos{i} = 4*kmax*(idpos) + 32 + 8*idpos;
    case 'XTF'
        idcon = 31;
        idpos = find(idcon == conorder) - 1;
        relpos{i} = 4*kmax*(idpos) + 32 + 8*idpos;
    case 'FLN'
        idcon = 32;
        idpos = find(idcon == conorder) - 1;
        relpos{i} = 4*kmax*(idpos) + 32 + 8*idpos;
    case 'FLNYM'
        idcon = 33;
        idpos = find(idcon == conorder) - 1;
        relpos{i} = 4*kmax*(idpos) + 32 + 8*idpos;
    case 'FLNXP'
        idcon = 34;
        idpos = find(idcon == conorder) - 1;
        relpos{i} = 4*kmax*(idpos) + 32 + 8*idpos;
    case 'FLNYP'
        idcon = 35;
        idpos = find(idcon == conorder) - 1;
        relpos{i} = 4*kmax*(idpos) + 32 + 8*idpos;
    case 'FLNXM'
        idcon = 36;
        idpos = find(idcon == conorder) - 1;
        relpos{i} = 4*kmax*(idpos) + 32 + 8*idpos;
    case 'IODINE'
        idcon = 101;
        idpos = find(idcon == conorder) - 1;
        relpos{i} = 4*kmax*(idpos) + 32 + 8*idpos;
    case 'XENON'
        idcon = 102;
        idpos = find(idcon == conorder) - 1;
        relpos{i} = 4*kmax*(idpos) + 32 + 8*idpos;
    case 'PROMETHIUM'
        idcon = 103;
        idpos = find(idcon == conorder) - 1;
        relpos{i} = 4*kmax*(idpos) + 32 + 8*idpos;
    case 'SAMARIUM'
        idcon = 104;
        idpos = find(idcon == conorder) - 1;
        relpos{i} = 4*kmax*(idpos) + 32 + 8*idpos;
    case 1
        relpos{i} = 'BURNUP';
    case 3
        relpos{i} = 'VHIST';
    case 5
        relpos{i} = 'TFUHIST';
    case 7
        relpos{i} = 'DENHIST';
    case 9
        relpos{i} = 'BORONDENS';
    case 11
        relpos{i} = 'CRDHIST';
    case 15
        relpos{i} = 'SURFEXPYM';
    case 16
        relpos{i} = 'SURFEXPXP';
    case 17
        relpos{i} = 'SURFEXPYP';
    case 18
        relpos{i} = 'SURFEXPXM';
    case 19
        relpos{i} = 'SPECHIST';
    case 20
        relpos{i} = 'SPECHISTYM';
    case 21
        relpos{i} = 'SPECHISTXP';
    case 22
        relpos{i} = 'SPECHISTYP';
    case 23
        relpos{i} = 'SPECHISTXM';
    case 25
        relpos{i} = 'EB1';
    case 26
        relpos{i} = 'BP1';
    case 27
        relpos{i} = 'BP10';
    case 28
        relpos{i} = 'BP2';
    case 29
        relpos{i} = 'BP20';
    case 30
        relpos{i} = 'EB2';
    case 31
        relpos{i} = 'XTF';
    case 32
        relpos{i} = 'FLN';
    case 33
        relpos{i} = 'FLNYM';
    case 34
        relpos{i} = 'FLNXP';
    case 35
        relpos{i} = 'FLNYP';
    case 36
        relpos{i} = 'FLNXM';
    case 101
        relpos{i} = 'IODINE';
    case 102
        relpos{i} = 'XENON';
    case 103
        relpos{i} = 'PROMETHIUM';
    case 104
        relpos{i} = 'SAMARIUM';
end
if loopcount == 1
    relpos = relpos{1};
end
end