function [nodew,segnodw,seglist,xloadg]=GetNodalWeight(resfile,cdfile)
% GetNodalWeight - Calculates the nodal heavy metal weight
%
% [nodew,segnodw,seglist]=GetNodalWeight(restartfile[,cdfile])
%
% Input
%   resfile     - name on restart file, fue_new or resinfo
%   cdfile      - name on library file (default: library file on restart file)
%
% Output:
%   nodew       - Nodal weight (kmax by kan)
%   segnodew    - Nodal weight for specific segment
%   seglist     - List of segment names
%
% Examples:
%   [nodew,segnodw,seglist]=GetNodalWeight(resinfo);
%   [nodew,segnodw,seglist]=GetNodalWeight('boc.res','/cms/f3/cd/cd-file.lib');
%
% See also: read_cdfile, read_cdfile_data, xs_cms, ReadRes

if isstruct(resfile)% take care of fue_new, resinfo or filename as input
    if max(strcmp('core',fieldnames(resfile)))
        % resinfo
        resinfo = resfile;
        dat = ReadRes(resinfo,{'LIBRARY','DIMS'},1);
        fue_new = catstruct(dat.dims,dat.library,dat.resinfo.core);
    else
        % fue_new
        fue_new = resfile;
    end
    
elseif ischar(resfile)
        % filename
        resinfo = ReadRes(resfile);
        dat = ReadRes(resinfo,{'LIBRARY','DIMS'},1);
        fue_new = catstruct(dat.dims,dat.library,dat.resinfo.core);
end




if nargin<2, cdfile=fue_new.cd_file;end
%% Find all segments in the core
Seg=cellstr(fue_new.Segment);
iseg=unique([fue_new.Core_Seg{1}(:);fue_new.Core_Seg{2}(:)]);
iseg(iseg==0)=[];
seglist=Seg(iseg);
%% Read the weights from the cdfile
[~,~,~,~,~,rec92,~,~,segmnt]=read_cdfile_data(cdfile,seglist);
Rec92=cell2mat(rec92);
xloadg=Rec92(:,5);
xarea=Rec92(:,6);
%% Calculate scaling factor
fac=xarea/(fue_new.dxassm*fue_new.dxassm);
segnodw=fac.*xloadg*fue_new.hz*fue_new.dxassm*fue_new.dxassm/1e3; % kg
%% Distribute the nodal weights
iseg1=fue_new.Core_Seg{1};
iseg2=fue_new.Core_Seg{2};
wseg1=zeros(size(iseg1));wseg2=wseg1;
for i=1:length(iseg),
    wseg1(iseg1==iseg(i))=segnodw(i);
    wseg2(iseg2==iseg(i))=segnodw(i);
end
nodew=fue_new.Seg_w{1}.*wseg1+fue_new.Seg_w{2}.*wseg2;
    