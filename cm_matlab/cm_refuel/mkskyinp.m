function mkskyinp(refufile, bocbunt, bocbuid, bocburn, mminj)

% Load refufile
if exist(refufile,'file')
    refu=load(refufile);
else
    error('Refufile not found!');
end

%
% Skapa SKYFFEL-inputfil
%

% Read assembly weights
fw=fopen(refu.asyweifile,'r');
ind=1;
while 1
  line = fgetl(fw);
  if ~ischar(line), break, end
  as(ind,1:4)=sprintf('%s',line(1:4));
  we(ind)=str2num(sprintf('%s',line(5:length(line))));
  ind=ind+1;
end
fclose(fw);



% Open files
fa=fopen(refu.asytypfile,'w');
ft=fopen(refu.crtypfile,'r');

% Write CRTYP map

while 1
  line = fgetl(ft);
  if ~ischar(line), break, end
  fprintf(fa,'%s\n',line);
end
fclose(ft);

% Write ASYTYP map
l=length(mminj);
fprintf(fa,'ASYTYP\n');
ind=1;
for i=1:length(mminj),
  for j=1:mminj(i)-1,
    fprintf(fa,'     ');
  end
  for j=mminj(i):length(mminj)-mminj(i)+1
    fprintf(fa,' %s',bocbunt(ind,:));
    ind=ind+1;
  end
  fprintf(fa,'\n');
end

% Write ASYWEI map
fprintf(fa,'COMMENT ------ ASYWEI -------\n');
fprintf(fa,'ASYWEI\n');
ind=1;
for i=1:length(mminj),
  for j=1:mminj(i)-1,
    fprintf(fa,'       ');
  end
  for j=mminj(i):length(mminj)-mminj(i)+1
    s=bocbunt(ind,:);
    k=strmatch(s,as);
    if ~isempty(k),fprintf(fa,' %5.2f',we(k));end
    if isempty(k),fprintf(fa,'  %4s',s);end
    ind=ind+1;
  end
  fprintf(fa,'\n');
end
fclose(fa);


% Write ASYID map
fa=fopen(refu.asyidfile,'w');
l=length(mminj);
fprintf(fa,'ASYID\n');
for ind=1:length(bocburn)
  b=bocburn(1,ind);
  s=sprintf('%d',ind);
  if ind<100,s=['0' s];end
  if ind<10,s=['0' s];end
  if b==0,
    s=sprintf('NY%s',s);
    bocbuid(ind,:)=[s char(ones(1,size(bocbuid,2)-length(s))*' ')];
  end
end
asyidmap=ascdist2map(bocbuid, mminj);
fprintf(fa, '%s', asyidmap);

% Write CRID map
cridfil='templ/crid.txt';
ft=fopen(cridfil,'r');
while 1
  line = fgetl(ft);
  if ~ischar(line), break, end
  fprintf(fa,'%s\n',line);
end
fclose(fa);
fclose(ft);