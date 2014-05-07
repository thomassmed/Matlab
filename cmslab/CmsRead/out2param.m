function [kmax,iafull,irmx,ilmx,nref,ihave,iofset,if2x2,ida,jda]=out2param(blob)

%% Read file if filename
if length(blob)<100, 
    fid = fopen(blob);      % open file
    blob = fread(fid)';     % read file
    fclose(fid);            % close file
    blob = char(blob);      % convert to ascii equivalents to characters
end
%% IAFULL
% TODO fix for s3k-outfiles
iE=strfind(blob,[10,' Full Core Assembly Map Width . IAFULL']);
if numel(iE)==0,
    iE=strfind(blob,[10,' FULL CORE ASSEMBLY MAP WIDTH . IAFULL']);
end
if numel(iE)==0,
    iE=strfind(blob,[10,'Full Core Assembly Map Width . IAFULL']);
end
iE=iE(1);
blob=char(blob(iE:iE+800));
iafull=sscanf(blob(41:44),'%i');


iE=strfind(blob,'Axial Nodes (Incl. Refl.). . . . . KD');
if numel(iE)==0,
    iE=strfind(blob,'AXIAL NODES  . . . . . . . . . . . KD');
end
iE=iE(1);
kd=sscanf(blob(iE+38:iE+41),'%i');

iE=strfind(blob,'Reflector Layers . . . . . . . . NREF');
if numel(iE)==0,
    iE=strfind(blob,'REFLECTOR LAYERS . . . . . . . . NREF');
end
iE=iE(1);
nref=sscanf(blob(iE+38:iE+41),'%i');

kmax=kd-2*nref;


%% IRMX
if nargout>2,
    iE=strfind(blob,'Control Rod Map Width  . . . . . IRMX');
    if numel(iE)==0,
        iE=strfind(blob,upper('Control Rod Map Width  . . . . . IRMX'));
    end
    iE=iE(1);
    irmx=sscanf(char(blob(iE+38:iE+41)),'%i');
end
%% ILMX
if nargout>3,
    iE=strfind(blob,'Detector Map Width . . . . . . . ILMX');
    if numel(iE)==0,
         iE=strfind(blob,upper('Detector Map Width . . . . . . . ILMX'));
    end
    iE=iE(1);
    ilmx=sscanf(char(blob(iE+38:iE+41)),'%i');
end
%% IHAVE
if nargout>5,
    iE=strfind(blob,'Core Fraction Flag . . . . . . .IHAVE');
    if numel(iE)==0,
        iE=strfind(blob,upper('Core Fraction Flag . . . . . . .IHAVE'));
    end
    iE=iE(1);
    ihave=sscanf(char(blob(iE+38:iE+41)),'%i');
end
%% IOFFSET
if nargout>6,
    iE=strfind(blob,'Offset Assemblies Flag . . . . IOFSET');
    if numel(iE)==0,
        iE=strfind(blob,upper('Offset Assemblies Flag . . . . IOFSET'));
    end
    iE=iE(1);
    iofset=sscanf(char(blob(iE+38:iE+41)),'%i');
end
%% IF2X2
if nargout>7,
    iE=strfind(blob,'Node Mesh per Assembly . . . . .IF2X2');
    if numel(iE)==0,
        iE=strfind(blob,upper('Node Mesh per Assembly . . . . .IF2X2'));
    end
    iE=iE(1);
    if2x2=sscanf(char(blob(iE+38:iE+41)),'%i');
end
%% IDA
if nargout>8,
    iE=strfind(blob,'FUE.MAP Dimensions . . . . . . IDA');
    if numel(iE)==0,
        iE=strfind(blob,upper('FUE.MAP Dimensions . . . . . . IDA'));
    end
    iE=iE(1);
    ida=sscanf(char(blob(iE+39:iE+42)),'%i');
    jda=sscanf(char(blob(iE+51:iE+53)),'%i');
end
%% 