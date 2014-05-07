%@(#)   matvarget.m 1.2	 94/01/25     12:42:55
%
function EVALMATVAR=matvarget;
handles=get(gcf,'userdata');
h1=handles(6);
hmatlab=get(h1,'userdata');
varstring=get(hmatlab,'label');
EVALMATVAR=['ccplot(',varstring,');'];
