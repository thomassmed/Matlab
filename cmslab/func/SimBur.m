function SimBur(fid,crpattern,qrel,hc,hcrel,Tin,efph,tit,mminj,crmminj,refnum,tid,Spartid,Spardatstr)

%%
Spartid=Spartid-tid(1);
Spartid=Spartid*24;
dtid=tid-tid(1);
dtid=24*dtid;
for i=1:length(Spartid), [dum,ii(i)]=min(abs(Spartid(i)-dtid));end
%%
wre='''WRE'' ';       
cas='''TIT.CAS''  '; %F2 C31 31S-01- 14376 1 - 28 EFPH. UTBR STEG NR 001'/
ref='''TIT.REF''        ';        %-1 27.54 /		TIP date & exposure
sta='''COM'' ''DEP.STA''   ';  %'AVE' 0.00 27.54 / EFPH (delta-EFPH= 27.54)
fpd='''DEP.FPD''   ';   %2 /	I,XE=equ Pm,Sm=depl
hrs='''DEP.HRS'' ''AVE'' ';
ope='''COR.OPE''  ';    %49.70   44.74  7.00e+06/	POW=49.70  FLOW=4921 kg/s  PRE=70.0 bar
tin='''COR.TIN''  ';    %272.40         /		Tin=272.40 C
crdpos='''CRD.POS''  1 \n';

%%
crsum=sum(crpattern');
ispar=1;
    fprintf(fid,'''RES'' ''../c31/res/tip-130312.res'' 6504.92 / \n');
    fprintf(fid,'''CMS.EDT'' ''ON'' ''2RPF'' ''3RPF'' ''2EXP'' / \n');
    fprintf(fid,'\n');
for i=1:length(Tin),
    fprintf(fid,cas);
    fprintf(fid,tit);
    if i==1,
        fprintf(fid,' Grundfall'' /');
    else
        fprintf(fid,'%i %8.2f EFPH; %s STEG %i ''',round(crsum(i)),efph(i),datestr(tid(i)),i);
    end
    fprintf(fid,'\n');
    fprintf(fid,ref);
    fprintf(fid,'%6i %7.3f / mmddhh  Hours',str2double(refnum(i)),dtid(i));
    fprintf(fid,'\n');
    if i==1,
        fprintf(fid,'''DEP.CYC'' ''F2-Prov'' 0 / \n');
    end
    if i>1,
        fprintf(fid,sta);
        fprintf(fid,'''AVE'' %8.2f %8.2f / EFPH (delta-EFPH= %4.2f)',efph(i-1),efph(i),(efph(i)-efph(i-1)));
        fprintf(fid,'\n');
    end
    fprintf(fid,hrs);
    fprintf(fid,'%7.3f / Hours',dtid(i));
    fprintf(fid,'\n');
%    fprintf(fid,fpd);
%    fprintf(fid,'2 / I,XE=equ Pm,Sm=depl');
%    fprintf(fid,'\n');
    fprintf(fid,ope);
    fprintf(fid,'%5.2f %5.2f 7.00e+6/ POW=%5.2f FLOW=%i',qrel(i),hcrel(i),qrel(i),round(hc(i)));
    fprintf(fid,'\n');
    fprintf(fid,tin);
    fprintf(fid,'%5.2f         /      Tin=%5.2f C',Tin(i),Tin(i));
    fprintf(fid,'\n');
    fprintf(fid,crdpos);
    crmap=cr2map(crpattern(i,:),mminj);
    SimCRMAP(fid,crmap,crmminj);
    if i==ii(ispar),
        fprintf(fid,wre);
        fprintf(fid,' ''res-%s.res'' /',Spardatstr{ispar});
        fprintf(fid,'\n');
        ispar=ispar+1;
    end
    fprintf(fid,'''STA''    0 / \n');
    fprintf(fid,'\n');
end 