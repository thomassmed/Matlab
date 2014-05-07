function mstab2excel(s3kmat,dr_meas,fd_meas,excelfil,titel,dr_s3k,fd_s3k,Qrel_meas,Wtot_meas)
%%
nin=nargin; % put nargin in nin to allow manual debugging
if nargin<8,
    Qrel_meas=Nan(length(s3kmat),1);
    Wtot_meas=Qrel_meas;
end

%% If datestr(now) from prt_drfd is passed as input argument, assign the name matsum-yyyy-mm-dd-hhmm.xls(x)  
if abs(excelfil(1))<65 % datestr assumed
    excelfil=[excelfil,filesep,'matsum'];
end
%% Pull out data from mat-files
for i=1:length(s3kmat),
    load(s3kmat{i},'Oper','stab')
    [dr(i,1),fd(i,1)]=p2drfd(stab.lam);
    Qrel(i,1)=Oper.Qrel;
    Wtot(i,1)=Oper.Wtot;
    s3kfil{i,1}=strrep(s3kmat{i},'.mat','');
end
%%  Write to excel
headers={'Case','','Qrel-mstab','Qrel-meas','Flow','Flow-meas','Meas Dr','Meas Freq','Mstab Dr','Mstab Freq'};
scs=xlswrite(excelfil,headers,'A2:J2');
if nin>5,
    headers={'S3K Dr','S3K Freq'};
    scs=xlswrite(excelfil,headers,'K2:L2');
end
for i=1:length(s3kmat)
    files{i,1}=strrep(s3kmat{i},'.mat','');
end
range=['A3:A',num2str(length(files)+2)];
scs=xlswrite(excelfil,files,range);
range=['C3:C',num2str(length(Qrel)+2)];
scs=xlswrite(excelfil,Qrel,range);
range=['D3:D',num2str(length(Qrel_meas)+2)];
scs=xlswrite(excelfil,Qrel_meas,range);
range=['E3:E',num2str(length(Wtot)+2)];
scs=xlswrite(excelfil,Wtot,range);
range=['F3:F',num2str(length(Wtot_meas)+2)];
scs=xlswrite(excelfil,Wtot_meas,range);
range=['I3:I',num2str(length(dr)+2)];
scs=xlswrite(excelfil,dr(:),range);
range=['J3:J',num2str(length(fd)+2)];
scs=xlswrite(excelfil,fd(:),range);
range=['G3:G',num2str(length(dr_meas)+2)];
scs=xlswrite(excelfil,dr_meas(:),range);
range=['H3:H',num2str(length(fd_meas)+2)];
scs=xlswrite(excelfil,fd_meas(:),range);
if nin>5,
    range=['K3:K',num2str(length(dr_s3k)+2)];
    scs=xlswrite(excelfil,dr_s3k(:),range);
end
if nin>6,
    range=['L3:L',num2str(length(fd_s3k)+2)];
    scs=xlswrite(excelfil,fd_s3k(:),range);
end
Tit{1}=titel;
scs=xlswrite(excelfil,Tit,'A1:A1');