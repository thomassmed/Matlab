function Autotip_XP_marg(basefil,updatfil,onlposcpr,onlposlhgr)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Autotip_XP_marg v1.0
% Detta är ett underprogram till Autotip_XP
% Programmet är en vidareutveckling av autotip.m
% Som inparametrar anges base och updat filerna.
% Vidare anges de kritiska positionerna för CPR
% och LHGR i updat efter kalibrering.
% Programerad av Jan Karjalainen, FTB 2004
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% från polca7
[base_lhgr,mminj]=readdist7(basefil,'LHGR');
updat_lhgr=readdist7(updatfil,'LHGR');
base_cpr=readdist7(basefil,'CPR');
updat_cpr=readdist7(updatfil,'CPR');
base_lhgrmarg=readdist7(basefil,'FL_LHGR1');
updat_lhgrmarg=readdist7(updatfil,'FL_LHGR1');
base_cprmarg=readdist7(basefil,'FL_CPR');
updat_cprmarg=readdist7(updatfil,'FL_CPR');

% fixar till marginalen

ettor=ones(size(base_lhgr));
base_lhgrmarg=(ettor-base_lhgrmarg)*100;
updat_lhgrmarg=(ettor-updat_lhgrmarg)*100;
base_cprmarg=(ettor-base_cprmarg)*100;
updat_cprmarg=(ettor-updat_cprmarg)*100;

% msta marginal i POLCA och UPDAT/TIP
mbase_cprmarg=min(min(base_cprmarg));
mupdat_cprmarg=min(min(updat_cprmarg));

mbase_lhgrmarg=min(min(base_lhgrmarg));
mupdat_lhgrmarg=min(min(updat_lhgrmarg));

%CPR och LHGR i POLCA och UPDAT/TIP DDR SDMSTA MARGINALEN EFTER KAL.DR
[i1,j1]=find(mbase_lhgrmarg==base_lhgrmarg);
[i2,j2]=find(mbase_cprmarg==base_cprmarg);
[i3,j3]=find(mupdat_lhgrmarg==updat_lhgrmarg);
[i4,j4]=find(mupdat_cprmarg==updat_cprmarg);

lhgrbasepos=knum2cpos(j1,mminj);
l1=[lhgrbasepos(1,:) i1(1)];
cprbasepos=knum2cpos(j2,mminj);
c1=[cprbasepos(1,:) i2(1)];
lhgrupdatpos=knum2cpos(j3,mminj);
l2=[lhgrupdatpos(1,:) i3(1)];
cprupdatpos=knum2cpos(j4,mminj);
c2=[cprupdatpos(1,:) i4(1)];


lhgrbase=base_lhgr(i1(1),j1(1))/100;
cprbase=base_cpr(i2(1),j2(1));
lhgrupdat=updat_lhgr(i3(1),j3(1))/100;
cprupdat=updat_cpr(i4(1),j4(1));

%CPR och LHGR i POLCA och UPDAT/TIP DDR UPDAT/ONLINES mSTA MARG DR

cprkanal=cpos2knum(onlposcpr,mminj);
lhgrkanal=cpos2knum(onlposlhgr,mminj);
cprnod=onlposcpr(3);
lhgrnod=onlposlhgr(3);

base_lhgrmarg=base_lhgrmarg';
updat_lhgrmarg=updat_lhgrmarg';
base_cprmarg=base_cprmarg';
updat_cprmarg=updat_cprmarg';

base_lhgr=base_lhgr';
updat_lhgr=updat_lhgr';
base_cpr=base_cpr';
updat_cpr=updat_cpr';

mbase_cprmarg1=base_cprmarg(cprkanal,cprnod);
mupdat_cprmarg1=updat_cprmarg(cprkanal,cprnod);
mbase_lhgrmarg1=base_lhgrmarg(lhgrkanal,lhgrnod);
mupdat_lhgrmarg1=updat_lhgrmarg(lhgrkanal,lhgrnod);

mbase_cpr1=base_cpr(cprkanal,cprnod);
mupdat_cpr1=updat_cpr(cprkanal,cprnod);
mbase_lhgr1=base_lhgr(lhgrkanal,lhgrnod)/100;
mupdat_lhgr1=updat_lhgr(lhgrkanal,lhgrnod)/100;

%Check om inte min-cpr ligger i samma nod som updat-onl

checkpolcacpr=min(base_cpr(cprkanal,:));
checkpolcanod=find(base_cpr(cprkanal,:)==checkpolcacpr);

checkupdatcpr=min(updat_cpr(cprkanal,:));
checkupdatnod=find(updat_cpr(cprkanal,:)==checkupdatcpr);

% skriva till fil
prifil=['Autotip_XP.lis'];
fid=fopen(prifil,'w');

fprintf(fid,'\n');
fprintf(fid,'\n');
fprintf(fid,'\n');
fprintf(fid,'\n');
fprintf(fid,'\n');
fprintf(fid,'LHGR och CPR-värden  som ger sämsta marginal');
fprintf(fid,'\n');
fprintf(fid,'\n');
fprintf(fid,'%17s%3.1f%23s%2.2f\n','POLCA-LHGR(W/cm) ',lhgrbase,'POLCA-CPR ',cprbase);
fprintf(fid,'%22s%4.1f%30s%4.1f\n','POLCA-LHGR-MARGINAL(%) ',mbase_lhgrmarg,'POLCA-CPR-MARGINAL(%) ',mbase_cprmarg);
fprintf(fid,'%19s%3.0f%3.0f%3.0f%25s%3.0f%3.0f%3.0f\n','POLCA-LHGR-POSITION',l1(1),l1(2),l1(3),'POLCA-CPR-POSITION',c1(1),c1(2),c1(3));
fprintf(fid,'\n');
fprintf(fid,'\n');
fprintf(fid,'%20s%3.1f%23s%1.2f\n','UPDAT/TIP-LHGR(W/cm) ',lhgrupdat,'UPDAT/TIP-CPR ',cprupdat);
fprintf(fid,'%20s%4.1f%30s%4.1f\n','UPDAT/TIP-LHGR-MARGINAL(%) ',mupdat_lhgrmarg,'UPDAT/TIP-CPR-MARGINAL(%) ',mupdat_cprmarg);
fprintf(fid,'%20s%3.0f%3.0f%3.0f%25s%3.0f%3.0f%3.0f\n','UPDAT/TIP-LHGR-POSITION ',l2(1),l2(2),l2(3),'UPDAT/TIP-CPR-POSITION ',c2(1),c2(2),c2(3));
fprintf(fid,'\n');
fprintf(fid,'\n');
fprintf(fid,'LHGR och CPR-värden  som i UPDAT/ONLINE efter kalibrering ger sämsta marginal');
fprintf(fid,'\n');
fprintf(fid,'\n');
fprintf(fid,'%17s%3.1f%23s%2.2f\n','POLCA-LHGR(W/cm) ',mbase_lhgr1,'POLCA-CPR ',mbase_cpr1);
fprintf(fid,'%22s%4.1f%30s%4.1f\n','POLCA-LHGR-MARGINAL(%) ',mbase_lhgrmarg1,'POLCA-CPR-MARGINAL(%) ',mbase_cprmarg1);
fprintf(fid,'%19s%3.0f%3.0f%3.0f%25s%3.0f%3.0f%3.0f\n','POLCA-LHGR-POSITION',onlposlhgr(1),onlposlhgr(2),onlposlhgr(3),'POLCA-CPR-POSITION',onlposcpr(1),onlposcpr(2),onlposcpr(3));
fprintf(fid,'\n');
fprintf(fid,'\n');
fprintf(fid,'%20s%3.1f%23s%1.2f\n','UPDAT/TIP-LHGR(W/cm) ',mupdat_lhgr1,'UPDAT/TIP-CPR ',mupdat_cpr1);
fprintf(fid,'%20s%4.1f%29s%4.1f\n','UPDAT/TIP-LHGR-MARGINAL(%) ',mupdat_lhgrmarg1,'UPDAT/TIP-CPR-MARGINAL(%)',mupdat_cprmarg1);
fprintf(fid,'%20s%3.0f%3.0f%3.0f%26s%3.0f%3.0f%3.0f\n','UPDAT/TIP-LHGR-POSITION',onlposlhgr(1),onlposlhgr(2),onlposlhgr(3),'UPDAT/TIP-CPR-POSITION ',onlposcpr(1),onlposcpr(2),onlposcpr(3));
fprintf(fid,'\n');
fprintf(fid,'Kontroll av cpr på den patron som ger sämst marginal i UPDAT/ONLINE efter kalibrering');
fprintf(fid,'\n');
fprintf(fid,'\n');
fprintf(fid,'%17s%3.3f%23s%2.2f\n','POLCA-CPR    ',checkpolcacpr,'NOD ',checkpolcanod);
fprintf(fid,'%17s%3.3f%23s%2.2f\n','UPDAT-CPR    ',checkupdatcpr,'NOD ',checkupdatnod);

fclose(fid);
