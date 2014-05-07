function res=brusutv(file,ch);

% load(file)            Old MD
% data=data(1:18001,:);
% [m,n]=size(data);
% signaler=char(signaler);
% sig=signaler(3:end,5:21);
% cesig=(cellstr(sig));
% be=signaler(3:end,68:end);
% cebe=(cellstr(be));

load(file)
%data=data(1:18001,:);
[m,n]=size(data);
signaler=char(signaler);
sig=signaler(4:end,5:21);
cesig=(cellstr(sig));
be=signaler(4:end,68:end);
cebe=(cellstr(be));

if ch==1
    [tmp,inp]=xlsread('K-punkter-sort-storskr.xls');
    kp=inp(2:end,1);
    bes=inp(2:end,2);
    for i=1:length(kp)
        tmp(i)=strmatch(kp(i),cesig,'exact')+1;  % +1 pga att tiden är bortplockad....
    end
    tmp=tmp';
    for i=1:length(tmp)
        res.medel(i)=mean(data(:,tmp(i)));
        res.tt(i)=max(data(:,tmp(i)))-min(data(:,tmp(i)));
        res.std(i)=std(data(:,tmp(i)));
    end
    cesig=kp;
    cebe=bes;

else
    for i=2:n
        res.medel(i-1)=mean(data(:,i));
        res.tt(i-1)=max(data(:,i))-min(data(:,i));
        res.std(i-1)=std(data(:,i));
    end
end

filename=[file(1:end-3),'xls'];
%filename='test.xls';
head={'K-pkt','Beskrivning','Medelvärde','Topp-topp värde','Standardavvikelse'};
xlswrite(filename,head,'Blad1','A1');
xlswrite(filename,cesig, 'Blad1','A2');
xlswrite(filename,cebe, 'Blad1','B2');
xlswrite(filename,res.medel','Blad1','C2');
xlswrite(filename,res.tt','Blad1','D2');
xlswrite(filename,res.std','Blad1','E2');

% xlswrite(filename,head,'Blad1','F1');
% xlswrite(filename,cesig, 'Blad1','F2');
% xlswrite(filename,cebe, 'Blad1','G2');
% xlswrite(filename,res.medel,'Blad1','H2');
% xlswrite(filename,res.tt,'Blad1','I2');
% xlswrite(filename,res.std,'Blad1','J2');