%@(#)   checkpilar.m 1.1	 05/07/13     10:29:28
%
%
function hcpil=checkpilar(mode,kedja,mminj,lfrom,lto,hcpil)

if (mode==0|mode==1|mode==2|mode==4),
  [cpil,hcpil]=plottobas(kedja,mminj,hcpil);
  [bpil,bring]=plottocore(mminj,lfrom,lto);
else
 [cpil,hcpil]=plottobas(kedja,mminj,hcpil,cpil);
 [bpil,bring]=plottocore(mminj,lfrom,lto,bpil,bring);
end
