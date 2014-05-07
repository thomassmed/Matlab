%@(#)   asc2sim.m 1.8	 06/11/06     13:49:28
%
%function asc2sim(ascfile,simfile);
function asc2sim(ascfile,simfile);
blist=[];
tx=readtextfile(ascfile);
ind=strmatch('STEPS',tx(:,1:5));
steps=str2num(tx(ind+1,:));
ind=strmatch('BLIST',tx(:,1:5));
for i=ind+1:ind+1+steps
  blist=[blist; str2num(tx(i,:))];
end
ind=strmatch('BOCFIL',tx(:,1:6));
bocfile=remblank(tx(ind+1,:));
im=strmatch('MANGRP',tx(:,1:6));
mangrpfile=remblank(tx(im+1,:));
ic=strmatch('CONROD',tx(:,1:6));
ifi=strmatch('FILENA',tx(:,1:6));
isd=strmatch('SDMFIL',tx(:,1:6));
ih=strmatch('HC',tx(:,1:2));
ip=strmatch('POWER',tx(:,1:5));
it=strmatch('TLOWP',tx(:,1:5));
for i=1:steps
  c=remblank(tx(i+ic,:));
  conrod(i,1:length(c))=c;
  c=remblank(tx(i+ifi,:));
  filenames(i,1:length(c))=c;
  c=remblank(tx(i+isd,:));
  sdmfiles(i,1:length(c))=c;
  hcf(i)=str2num(tx(i+ih,:));
  p(i)=str2num(tx(i+ip,:));
  tlow(i)=str2num(tx(i+it,:));
end
i=find(conrod==0);if ~isempty(i),conrod(i)=setstr(32*ones(1,length(i)));end
i=find(filenames==0);if ~isempty(i),filenames(i)=setstr(32*ones(1,length(i)));end
i=find(sdmfiles==0);if ~isempty(i),sdmfiles(i)=setstr(32*ones(1,length(i)));end

% Nedanstående behöver ej ändras

for i=1:size(filenames,1)
  hc(i,1:7)=sprintf('%7.1f',hcf(i));
  pow(i,1:5)=sprintf('%5.1f',p(i));
  tlowp(i,1:5)=sprintf('%5.1f',tlow(i));
  bustep(i,1:4)=sprintf('%4.0f',blist(i+1)-blist(i));
end
evstr=['!rm ' simfile];
eval(evstr);
evstr=['save ' simfile ' blist bocfile bustep conrod filenames sdmfiles mangrpfile hc pow tlowp'];
eval(evstr);
