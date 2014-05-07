%@(#)   crpos2knum.m 1.2	 94/08/12     12:10:11
%
%@(#)   crpos2knum.m 1.2	 94/08/12     12:10:11
%
%function knum=crpos2knum(crpos,mminj)
function knum=crpos2knum(crpos,mminj)
s=size(crpos);
v=ones(s(1),1);
cpos4=2*crpos;
cpos1=[cpos4(:,1)-v cpos4(:,2)-v];
cpos2=[cpos4(:,1)-v cpos4(:,2)];
cpos3=[cpos4(:,1) cpos4(:,2)-v];
knum1=cpos2knum(cpos1,mminj);
knum2=cpos2knum(cpos2,mminj);
knum3=cpos2knum(cpos3,mminj);
knum4=cpos2knum(cpos4,mminj);
knum=[knum1 knum2 knum3 knum4];
