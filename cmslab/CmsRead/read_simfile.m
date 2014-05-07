function blob=read_simfile(filename)
% Reads in simulate input files and parses 'INC.FIL' cards
% blob=read_simfile(filename)
if isempty(filename), blob=[];return;end
absolute_addr=is_absolute(filename);
%test=java.io.File(filename);
%absolute_addr=test.isAbsolute();
if ~absolute_addr,
   filename=expandpath(filename);
end
[direc,filnam,ext]=fileparts(filename);
direc=[direc,'/'];
fid=fopen(filename);
blob=fread(fid,inf,'*char')';
fclose(fid);
card='''INC.FIL''';
card=char([10,card]);
inc=strfind(blob,card);
cr=find(blob==10);

% TODO remember to ut in <cr> first in inc-files

while ~isempty(inc),
    istop=find(cr>inc(1),1);
    card_str=blob(inc(1)+10:cr(istop));
    blips=find(card_str==39);
    incfile=char(card_str(blips(1)+1:blips(2)-1));
    absolute_addr_inc=is_absolute(incfile);
    if ~absolute_addr_inc,
      incfile=[direc,incfile];
    end
    fid=fopen(incfile,'r');
    if fid<0,
        error(['File not found: ',incfile]);
    end
    blob_inc=fread(fid,inf,'*char')';
    fclose(fid);
    blob=[blob(1:inc(1)) blob_inc blob(cr(istop):end)];
    inc=strfind(blob,card);
    cr=find(blob==10);
end
blob=char([10 blob]);
blob(blob==13)=[];