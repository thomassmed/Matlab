%@(#)   utbyten.m 1.1	 05/07/13     10:29:44
%
%
function utbyten(curfil,bocfil,printfil)
%function utbyten(curfil,bocfil,printfil)
if nargin<3, printfil='utbyten.lis';disp('Results will be written on utbyten.lis');end
fid=fopen(printfil,'w');
[buidboc,mminj]=readdist7(bocfil,'asyid');
burnboc=mean(readdist7(bocfil,'burnup'));
buid=readdist7(curfil,'asyid');
kkan=size(buid,1);
OK=ones(1,kkan);
[from,to,ready,fuel]=initvec(buid,buidboc,OK);
utbytvec=fuel.*(to==0).*(from==0).*(ready==0);

%kinf=kinf2mlab(curfil);
%kinfboc=kinf2mlab(bocfil);

kinf = readdist7(curfil, 'khot');		%Uppdaterat
kinfboc = readdist7(bocfil, 'khot');		%Uppdaterat


[right,left]=knumhalf(mminj);
vec=kinf>kinfboc;
rv=0*vec;rv(right)=ones(length(right),1);
lv=0*vec;lv(left)=ones(length(left),1);
comment='************* Kinf-sankande *************';
printutbyt(fid,buid,buidboc,burnboc,utbytvec,vec,mminj,comment);
totvec=vec;
vec=(burnboc>15000).*(totvec==0);
comment='************* BURNUP>15000, hoger *************';
printutbyt(fid,buid,buidboc,burnboc,utbytvec,vec.*rv,mminj,comment);
comment='************* BURNUP>15000, vanster *************';
printutbyt(fid,buid,buidboc,burnboc,utbytvec,vec.*lv,mminj,comment);
totvec=totvec+vec;
vec=(totvec==0);
comment='************* Resten, hoger *************';
printutbyt(fid,buid,buidboc,burnboc,utbytvec,vec.*rv,mminj,comment);
comment='************* Resten, vanster *************';
printutbyt(fid,buid,buidboc,burnboc,utbytvec,vec.*lv,mminj,comment);
fclose(fid);
end
