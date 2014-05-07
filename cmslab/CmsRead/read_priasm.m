function [asmth,asmdp]=read_priasm(outfile)
%% find the edit in the file
fid=fopen(outfile,'r');
file=fread(fid)';
iE=strfind(file,'PRI.ASM Axial T-H Edit');
iE1=strfind(file,'PRI.ASM Axial Pressure Distribution Edit'); 
%% find out the number of edited nodes
kan=length(iE);
fseek(fid,iE(1),-1);
for i=1:5,
    fgetl(fid);
end
c=textscan(fid,'%n',12);
kd=c{1}(1);
no_of_pts=kd*12;
% Preallocate now when we know the dimension
asmth.RPF=nan(kd,kan);
asmth.Q2P=nan(kd,kan);
asmth.H=nan(kd,kan);
asmth.Xeq=nan(kd,kan);
asmth.Xed=nan(kd,kan);
asmth.Xflow=nan(kd,kan);
asmth.DEN=nan(kd,kan);
asmth.VOID=nan(kd,kan);
asmth.CO=nan(kd,kan);
asmth.Vgj=nan(kd,kan);
asmth.Slip=nan(kd,kan);
% Populate the uppermost node in first channel
asmth.RPF(kd,1)=c{1}(2);
asmth.Q2P(kd,1)=c{1}(3);
asmth.H(kd,1)=c{1}(4);
asmth.Xeq(kd,1)=c{1}(5);
asmth.Xed(kd,1)=c{1}(6);
asmth.Xflow(kd,1)=c{1}(7);
asmth.DEN(kd,1)=c{1}(8);
asmth.VOID(kd,1)=c{1}(9);
asmth.CO(kd,1)=c{1}(10);
asmth.Vgj(kd,1)=c{1}(11);
asmth.Slip(kd,1)=c{1}(12);
% Populate the other nodes in the first channel
c1=textscan(fid,'%n',no_of_pts-12);
data=reshape(c1{1},12,kd-1);
asmth.RPF(kd-1:-1:1,1)=data(2,:)';
asmth.Q2P(kd-1:-1:1,1)=data(3,:)';
asmth.H(kd-1:-1:1,1)=data(4,:)';
asmth.Xeq(kd-1:-1:1,1)=data(5,:)';
asmth.Xed(kd-1:-1:1,1)=data(6,:)';
asmth.Xflow(kd-1:-1:1,1)=data(7,:)';
asmth.DEN(kd-1:-1:1,1)=data(8,:)';
asmth.VOID(kd-1:-1:1,1)=data(9,:)';
asmth.CO(kd-1:-1:1,1)=data(10,:)';
asmth.Vgj(kd-1:-1:1,1)=data(11,:)';
asmth.Slip(kd-1:-1:1,1)=data(12,:)';
%% populate channel 2 thru kan
for i=2:kan
    fseek(fid,iE(i),-1);
    for i1=1:5,fgetl(fid);end
    c=textscan(fid,'%n',no_of_pts);
    data=reshape(c{1},12,kd);
    asmth.RPF(kd:-1:1,i)=data(2,:)';
    asmth.Q2P(kd:-1:1,i)=data(3,:)';
    asmth.H(kd:-1:1,i)=data(4,:)';
    asmth.Xeq(kd:-1:1,i)=data(5,:)';
    asmth.Xed(kd:-1:1,i)=data(6,:)';
    asmth.Xflow(kd:-1:1,i)=data(7,:)';
    asmth.DEN(kd:-1:1,i)=data(8,:)';
    asmth.VOID(kd:-1:1,i)=data(9,:)';
    asmth.CO(kd:-1:1,i)=data(10,:)';
    asmth.Vgj(kd:-1:1,i)=data(11,:)';
    asmth.Slip(kd:-1:1,i)=data(12,:)';
end
% Preallocate for pressure drops
asmdp.ELE=nan(kd,kan);
asmdp.PrDrop=nan(kd,kan);
asmdp.DP=nan(kd,kan);
asmdp.DPEL=nan(kd,kan);
asmdp.DPACC=nan(kd,kan);
asmdp.DPEXP=nan(kd,kan);
asmdp.DPWF=nan(kd,kan);
asmdp.MFF=nan(kd,kan);
asmdp.PHI2LO=nan(kd,kan);
asmdp.DPSP=nan(kd,kan);
asmdp.DPLL=nan(kd,kan);
asmdp.PHI2LL=nan(kd,kan);
asmdp.DPCHAN=nan(kd,kan);

no_of_pts1=kd*14;
for i=1:length(iE1),
    fseek(fid,iE1(i),-1);
    for i1=1:5,fgetl(fid);end
    c=textscan(fid,'%n',no_of_pts1);
    data=reshape(c{1},14,kd);
    asmdp.ELE(kd:-1:1,i)=data(2,:)';
    asmdp.PrDrop(kd:-1:1,i)=data(3,:)';
    asmdp.DP(kd:-1:1,i)=data(4,:)';
    asmdp.DPEL(kd:-1:1,i)=data(5,:)';
    asmdp.DPACC(kd:-1:1,i)=data(6,:)';
    asmdp.DPEXP(kd:-1:1,i)=data(7,:)';
    asmdp.DPWF(kd:-1:1,i)=data(8,:)';
    asmdp.MFF(kd:-1:1,i)=data(9,:)';
    asmdp.PHI2LO(kd:-1:1,i)=data(10,:)';
    asmdp.DPSP(kd:-1:1,i)=data(11,:)';
    asmdp.DPLL(kd:-1:1,i)=data(12,:)';
    asmdp.PHI2LL(kd:-1:1,i)=data(13,:)';
    asmdp.DPCHAN(kd:-1:1,i)=data(14,:)';
end
fclose(fid);

