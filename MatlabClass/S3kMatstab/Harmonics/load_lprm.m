function [lprm2,lprm4,aprm1,aprmm,q,fl,p]=load_lprm(ch)
% load_lprm
% ch='a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i'

filnamn=['/Measured_Data/r1/lprm90/lprm',ch,'/lprm.',ch,'00'];
load(filnamn);
aprm1=lprm;
filnamn=['/Measured_Data/r1/lprm90/lprm',ch,'/lprm.',ch,'01'];
load(filnamn);
aprmm=lprm;
filnamn=['/Measured_Data/r1/lprm90/lprm',ch,'/lprm.',ch,'02'];
load(filnamn);
fl=lprm;
filnamn=['/Measured_Data/r1/lprm90/lprm',ch,'/lprm.',ch,'09'];
load(filnamn);
p=lprm;
la=length(aprm1);
lprm2=zeros(la,36);lprm4=lprm2;

%% Level 2
for i=1:36,
    filnamn=['/Measured_Data/r1/lprm90/lprm',ch,'/lprm.',ch,sprintf('%2i',2*i+15)];
    load(filnamn);
    lprm2(:,i)=lprm(1:la);
end
%% Level 4
for i=1:36,
    filnamn=['/Measured_Data/r1/lprm90/lprm',ch,'/lprm.',ch,sprintf('%2i',2*i+16)];
    load(filnamn);
    lprm4(:,i)=lprm(1:la);
end
q=mean(aprmm);
