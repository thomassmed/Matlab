%@(#)   readkinf.m 1.3	 94/03/16     14:39:53
%
function readkinf
set(gcf,'pointer','watch')
h=get(gcf,'userdata');
eocfile=get(h(4),'string');
kinf=kinf2mlab(eocfile);
set(h(4),'userdata',kinf)
set(gcf,'pointer','arrow')
