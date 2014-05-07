%@(#)   mdialog.m 1.1	 05/07/13     10:29:35
%
%
function mdialog
	
hmain=gcf;
pos=get(hmain,'position');
hmm=figure('position',[pos(1:2)+pos(3:4)-[560 810],560,340],...
'numbertitle','off','name','Shuffle','color',[1 1 1]*.8); 
axes('visible','off');
%-------------------------------------
%Dialog-rutans knappar och ledtexter>>
%-------------------------------------
hpbutton(1)=uicontrol('style','Pushbutton','position',[10 250 130 45],...
'callback','s=mon(1);if s==1, mframat; end;','string','Stega framåt');
hpbutton(2)=uicontrol('style','Pushbutton','position',[10 200 130 45],...
'callback','s=mon(2);if s==1, mbakat; end;','string','Stega bakåt');
hpbutton(3)=uicontrol('style','Pushbutton','position',[445 105 90 45],...
'callback','s=mon(3);if s==1, mupdate; end;','string','Uppdatera'); 
hpbutton(4)=uicontrol('style','Pushbutton','position',[452 30 75 45],...
'callback','delete(gcf)','string','EXIT');
heinfil(1)=uicontrol('style','Edit','position',[10 175 150 20],...
'string','Infil >>');
heinfil(2)=uicontrol('style','Edit','position',[58 175 140 20],'callback',...
'mcalc(1)'); 
heinfil(3)=uicontrol('style','Edit','position',[289 175 250 20],...
'string','Spara till safeguard infil >>');
heinfil(4)=uicontrol('style','Edit','position',[460 175 90 20]); 
hrbutton(1)=uicontrol('style','Radiobutton','position',[10 135 400 25],...
'callback','radiobcheck(1);setmode(0,1);','string','Visa inga pilar');
hrbutton(2)=uicontrol('style','Radiobutton','position',[10 105 400 25],...
'callback','radiobcheck(2);setmode(1,2);','string',...
'Visa pilar for bränsle som inte kan skyfflas utan urladdning');
hrbutton(3)=uicontrol('style','Radiobutton','position',[10 75 400 25],...
'callback','radiobcheck(3);setmode(2,3);','string',...
'Visa pilar for bränsle som kan skyfflas utan urladdning');
hrbutton(4)=uicontrol('style','Radiobutton','position',[10 45 400 25],...
'callback','radiobcheck(4);setmode(4,4);','string','Visa kedjor med ettaringar');
hrbutton(5)=uicontrol('style','Radiobutton','position',[10 15 400 25],...
'callback','radiobcheck(5);setmode(100,5);','string','Visa alla pilar');
hfchoice(1)=uicontrol('style','Radiobutton','position',[10 300 130 22],...
'callback','radiobcheck(''rmonitor'');','string','Monitor');
hfchoice(2)=uicontrol('style','Radiobutton','position',[335 300 130 22],...
'callback','s=radiobcheck(''rmanual'');if s==1, mshuffle; end;',...
'string','Manualshuffle','Interruptible','yes');
hrcrods=uicontrol('style','Radiobutton','position',[220 276 40 22],...
'callback','radiobcheck(11)','string','S');
hrbundles=uicontrol('style','Radiobutton','position',[220 300 40 22],...
'callback','radiobcheck(10)','string','P');
hmanualshuffletext(1)=text(.6,.915,'Markera med musen','color','k');
hmanualshuffletext(2)=text(.5,.850,'Knapp 1: Skyffla till/från markerad position','color','k');
hmanualshuffletext(3)=text(.5,.790,'Knapp 2: Ångra senaste förflyttning','color','k');
hmanualshuffletext(4)=text(.5,.730,'Knapp 3: Ladda till/från bassang','color','k');
hmanualshuffletext(5)=text(.5,.670,'Knapp 3 Utanför härd: Kommentar','color','k');
hmanualshuffletext(6)=text(.5,.610,'Knapp 1 Utanför härd: Avsluta ','color','k'); 
%------------------------------------------------------
%"Dummy" objekt for att kunna anvanda dess 'userdata'>>
%------------------------------------------------------
for i=1:13, haxel(i)=axes('Visible','off');end;
hax=axes('Visible','off');
for i=1:27, haxlar(i)=axes('Visible','off');end;
mode=-1;
set(haxlar(23),'userdata',hrbundles);
set(haxlar(24),'userdata',hrcrods);
set(hmm,'userdata',...
[hrbutton hpbutton haxel hmain mode hax hfchoice heinfil haxlar]);
mcalc(2,hmm);
set(hmm,'Visible','on');
%--------------------------------------------------------------------------
% Userdata mdialog : 1-5=hrbutton, 6-9=hpbutton, 10-22=haxel, 23=hmain,...
% 24=mode, 25=hax, 26-27=hfchoice, 28-31=heinfil, 32-58=haxlar
%--------------------------------------------------------------------------
% Handtag:      Userdata:   
%-------------------------------------------------------------------------- 
% userdata(1) =>lbuid   
% userdata(2) =>kedja
% userdata(3) =>mminj
% userdata(4) =>to0
% userdata(5) =>from0
% userdata(6) =>nrop
% userdata(7) =>maxop
% userdata(8) =>lfrom
% userdata(9) =>lto
% userdata(10)=>ready0
% userdata(11)=>gonu
% userdata(12)=>from
% userdata(13)=>to
% userdata(14)=>ready
% userdata(15)=>fuel
% userdata(16)=>skyffett
% userdata(17)=>ikan
% userdata(18)=>hcross
% userdata(19)=>Hpil
% userdata(20)=>Hring
% userdata(21)=>hp
% userdata(22)=>plmat
% hmain
% mode
% userdata(25)=>hri
% userdata(26)=>buid
% userdata(27)=>buid0
% userdata(28)=>buidboc
% userdata(29)=>updateflag
% userdata(30)=>sstom
% userdata(31)=>hcpil
% userdata(32)=>lp
% userdata(33)=>crid0
% userdata(34)=>crfrom0
% userdata(35)=>crto0
% userdata(36)=>crready0
% userdata(37)=>crod0
% userdata(38)=>crid
% userdata(39)=>crfrom
% userdata(40)=>crto
% userdata(41)=>crready
% userdata(42)=>crod
% userdata(43)=>cridboc
% userdata(44)=>lcrid
% userdata(45)=>lcrfrom
% userdata(46)=>lcrto
% userdata(47)=>hcrcross
% userdata(48)=>crnrop
% userdata(49)=>crmaxop
% userdata(50)=>psop
% userdata(51)=>typ
% userdata(52)=>bnrop
% userdata(53)=>lline
% userdata(54)=>hrbundles
% userdata(55)=>hrcrods
% userdata(56)=>buidnt
% userdata(57)=>tot
% userdata(58)=>fromt


