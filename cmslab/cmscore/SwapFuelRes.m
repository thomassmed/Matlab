function SwapFuelRes(resfile,ch,fue_new)

if nargin<3,
    fue_new=read_restart_bin(resfile);
end

[fid,msg]=fopen(resfile,'r+','ieee-be');

ij=knum2cpos(ch,fue_new.mminj);

iafull=fue_new.iafull;
iadrh=find(strncmp('HEAVY METAL',fue_new.Lab,11));
startAddress=fue_new.Adr(iadrh)-3*iafull*iafull*6-100;
fseek(fid,startAddress,-1);
% 
next_record=get_next_record(fid,'LABELS   ');
% NFTID
ia=ij(1,1);ja=ij(1,2);
ia2=ij(2,1);ja2=ij(2,2);
adr1=next_record.data_pos+(ja-1)*iafull*6+(ia-1)*6;
adr2=next_record.data_pos+(ja2-1)*iafull*6+(ia2-1)*6;
ResSwapBinData(fid,adr1,adr2,6)
% SERIAL
adr1=adr1+iafull*iafull*6+8;
adr2=adr2+iafull*iafull*6+8;
ResSwapBinData(fid,adr1,adr2,6)
% NFTIDO
adr1=adr1+iafull*iafull*6+8;
adr2=adr2+iafull*iafull*6+8;
ResSwapBinData(fid,adr1,adr2,6)
% HEAVY METAL
adr1=fue_new.Adr(iadrh)+36+(ja-1)*iafull*4+(ia-1)*4;
adr2=fue_new.Adr(iadrh)+36+(ja2-1)*iafull*4+(ia2-1)*4;
ResSwapBinData(fid,adr1,adr2,4)

% LOCATION
iadr=find(strncmp('FIXED MAPS',fue_new.Lab,10));
startAddress=fue_new.Adr(iadr)-2*(iafull+2)*(iafull+2)*4-200;
fseek(fid,startAddress,-1);
loc=get_next_record(fid,'LOCATION   ');
% NFTA
adr1=loc.data_pos+ja*(iafull+2)*4+ia*4;
adr2=loc.data_pos+ja2*(iafull+2)*4+ia2*4;
ResSwapBinData(fid,adr1,adr2,4)
% NFT
adr1=adr1+loc.blk_size+8;
adr2=adr2+loc.blk_size+8;
ResSwapBinData(fid,adr1,adr2,4)

assmaps=get_next_record(fid,'ASSEMBLY MAPS',10000);
% BPSA
adr1=assmaps.data_pos+(ja-1)*iafull*4+(ia-1)*4;
adr2=assmaps.data_pos+(ja2-1)*iafull*4+(ia2-1)*4;
ResSwapBinData(fid,adr1,adr2,4)
% IBAT
adr1=adr1+iafull*iafull*4+8;
adr2=adr2+iafull*iafull*4+8;
ResSwapBinData(fid,adr1,adr2,6)
% IBATF
adr1=adr1+iafull*iafull*4+8;
adr2=adr2+iafull*iafull*4+8;
ResSwapBinData(fid,adr1,adr2,6)



iadr=find(strncmp('ASSEMBLY DATA',fue_new.Lab,13));
iadr2=find(strncmp('ASSEMBLY LABELS',fue_new.Lab,15));
DataSpace=fue_new.Adr(iadr2(2))-fue_new.Adr(iadr2(1));
fseek(fid,fue_new.Adr(iadr),-1);
MoreAssData=get_next_record(fid,'MORE ASSEMBLY DATA');
DataLen=MoreAssData.abs_pos-fue_new.Adr(iadr)-44;

adr1=fue_new.Adr(iadr)+44+(ch(1)-1)*DataSpace;
adr2=fue_new.Adr(iadr)+44+(ch(2)-1)*DataSpace;
ResSwapBinData(fid,adr1,adr2,DataLen)

adr11=MoreAssData.abs_pos+44+(ch(1)-1)*DataSpace;
adr21=MoreAssData.abs_pos+44+(ch(2)-1)*DataSpace;
ResSwapBinData(fid,adr11,adr21,24)

adr12=fue_new.Adr(iadr2(1))+48+(ch(1)-1)*DataSpace;
adr22=fue_new.Adr(iadr2(1))+48+(ch(2)-1)*DataSpace;
ResSwapBinData(fid,adr12,adr22,20)

fclose(fid);
