function [a,b,c]=ldracs_new(filename,measnr)
% [a,b,c]=ldracs(filename,measnr)
%    filename �r namn p� racsfil tex 'stor1.data'
%    measnr �r nummer p� m�tning tex 1 (default = 1)
%    besk �r m�tbeskrivning
%    info �r signalinformation
%    sign �r signalerna som redovisas i info lagrade i 
%    kolumnvis orientering

%    P�r Lans�ker 1992-02-15, 1994-11-02


newf1f2=[];
if nargin==0
   thispath=pwd;
   [fil,pathname]=uigetfile('*.dat','RACS-FILER');
   if fil==0,eval(['cd ' thispath]),return,end
   eval(['cd ' pathname])
   eval(['[a,b,c]=getracs(''' fil ''');'])
   eval(['cd ' thispath])
elseif nargin==1
   if strcmp(filename(end-3:end),'.mat')
     % fil fr�n nya m�tdatorn
     newf1f2=1;
     [a,b,c]=ldnewf1f2(filename);
   else
     [a,b,c]=getracs(filename);
   end
else
   [a,b,c]=getracs(filename,measnr);
end

if isempty(newf1f2)
  j1=find(a<10);a(j1)=20*ones(1,length(j1));
  j2=find(b<10);b(j2)=20*ones(1,length(j2));
  a=setstr(a);
  b=setstr(b);
end

function [a,b,c]=ldnewf1f2(filename)
% laddar fil fr�n nya m�tdatorn p� F1 F2 och konverterar 
% till gamla formatet

load(filename);
a=beskrivning;
% g�r om matrisen signaler till samma format som b fr�n racsfil
b=signaler;
if char(b(2,1))~='+'
    b(3:end+1,:)=b(2:end,:); b(2,:)='+'; % extra rad med plus-tecken
end
b(:,100)=10;   % l�gg in radbrytning
b=b'; b=b(:)';
c=data;
