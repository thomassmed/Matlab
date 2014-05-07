function [XS1,rubrik,FL,XS0,FL0,Betag,Lamdag,Delay,TF]=ReadKin(kinfile)
% ReadKin - Reads kinetic data from the kin file, output from 
%           Simulate when option 'KIN.EDT'  'ON'  '1-D'/ is used
%
% Input:
%    kinfile - Name on kinetic out file (.kin)
%    
% Output:
%    XS1    - Edit X-S.1-D
%    rubrik - Heading for each case
%    FL     - Edit X-S.EDT
%    XS0    - Edit X-S.0-D
%    FL0    - Edit DAT.0-D
%    Betag  - First half of edit KIN.0-D
%    Lamdag - Second half of edit KIN.0-D
%    Delay  - Edit KIN.1-D
%    TF     - Edit EDT.1-D
%
% Example:
%    [XS1,rubrik,FL,XS0,FL0,Betag,Lamdag,Delay,TF]=ReadKin('sim-1D.kin');
fid=fopen(kinfile);
fseek(fid,0,-1);
bryt=false;
for j=1:20,
    for i=1:2000,
        rad=fgetl(fid);
        if rad==-1, bryt=true;end
        if bryt, break;end
        if ~isempty(strfind(rad,'PRT.COE')),
            rubrik{j,1}=rad;
        end
        if ~isempty(strfind(rad,'X-S.1-D')),
            break;
        end
    end
    if ~bryt,
        XS1{j}=cell2mat(textscan(fid,'%f %f %f %f %f %f %f %f %f %f'));
        fgetl(fid);fgetl(fid);
        FL{j}=cell2mat(textscan(fid,'%f %f %f %f %f %f %f %f %f %f'));
        fgetl(fid);
        rad=fgetl(fid);
        XS0{j}=sscanf(rad,'%g')';
        fgetl(fid);fgetl(fid);
        rad=fgetl(fid);
        FL0{j}=sscanf(rad,'%g')';
        for i=1:50,
            rad=fgetl(fid);
            if ~isempty(strfind(rad,'KIN.0-D')),
                break;
            end
        end
        rad=fgetl(fid);
        Betag{j}=sscanf(rad(13:end),'%g')';
        rad=fgetl(fid);
        Lamdag{j}=sscanf(rad(13:end),'%g')';
        for i=1:50,
            rad=fgetl(fid);
            if ~isempty(strfind(rad,'KIN.1-D')),
                break;
            end
        end
        Delay{j}=cell2mat(textscan(fid,'%f %f %f %f %f %f %f'));
        rad=fgetl(fid);
        TF{j}=cell2mat(textscan(fid,'%f %f %f %f %f %f'));
    end
    if bryt, break;end
end
fclose(fid);