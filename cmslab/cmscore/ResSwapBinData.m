function ResSwapBinData(fid,adr1,adr2,n)
fseek(fid,adr1,-1);
bindata1=fread(fid,n,'uint8=>uint8');
fseek(fid,adr2,-1);
bindata2=fread(fid,n,'uint8=>uint8');
fseek(fid,adr1,-1);
fwrite(fid,bindata2,'uint8');
fseek(fid,adr2,-1);
fwrite(fid,bindata1,'uint8');
