%@(#)   crfilt.m 1.3	 05/12/08     08:32:56
%
function crfilt
handles=get(gcf,'userdata');
hpl=handles(2);
if gca~=hpl, axes(hpl);end
ud=get(hpl,'userdata');
ud(12,1:3)='yes';
set(hpl,'Userdata',ud);
distfile=ud(5,:);
[dist,mminj,konrod,bb,hy,mz,ks,asytyp,asyref,distlist,...
staton,masfil,rubrik,detpos,fu,op,au,flopos,soufil]=readdist7(distfile);
ikan=filtcr(konrod,mminj,0,99);
ika=[ikan(:,1)',ikan(:,2)',ikan(:,3)',ikan(:,4)'];
crfiltvec=zeros(1,mz(14));
crfiltvec(ika(1,:))=ones(1,length(ika));
set(handles(21),'userdata',crfiltvec);
