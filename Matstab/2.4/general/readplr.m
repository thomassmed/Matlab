function [zzarea,zzdh,zzhta]=readplr(f_master)
%[zzarea,zzdh,zzhta]=readplr(f_master);
%Reads part length rod data from the master file.

%@(#)   readplr.m 1.2   97/06/04     08:55:17

j1 = mast2mlab(f_master,123,'I');
if length(j1)==1,
   if j1==-1, return;end
end
j2 = mast2mlab(f_master,125,'I');
j3 = mast2mlab(f_master,127,'I');
zzarea = ones(length(j1),25);
zzdh = ones(length(j1),25);
zzhta = ones(length(j1),25);

x1 = mast2mlab(f_master,122,'F');
x2 = mast2mlab(f_master,124,'F');
x3 = mast2mlab(f_master,126,'F');

jf = find(j1)';
jx = 1:25;

for n = jf,
  zzarea(n,jx) = x1(j1(n) + jx)';
  zzdh(n,jx) = x2(j2(n) + jx)';
  zzhta(n,jx) = x3(j3(n) + jx)';
end
