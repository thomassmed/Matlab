%@(#)   bunwei.m 1.2	 98/09/22     15:35:12
%
%function [w,ftyp]=bunwei(masfil,buntyp);
function [w,ftyp]=bunwei(masfil,buntyp);
weight=mast2mlab(masfil,32,'F');
bunref=mast2mlab(masfil,45,'C2');
bucomp=mast2mlab(masfil,73,'I');
ll=length(bunref)/4;
bunref=flipud(rot90(reshape(bunref,4,ll)));
i=bucatch(buntyp,bunref);
if i=='', error([buntyp ', No such buntyp in ' masfil]);end
ll=length(bucomp)/25;
bucomp=flipud(rot90(reshape(bucomp',25,ll)));
ftyp=bucomp(i,:);
w=weight(ftyp)';
