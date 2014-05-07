%@(#)   kolla_oberoende.m 1.1	 05/07/13     10:29:33
%
%
% Function kolla_oberoende(fil1,fil2), kontrollerar om två laddscheman
% (fil1 och fil2) har något beroende 
%

% Roger Johansson, 1997-08-11
% Modified: Thomas Smed 1998-05-27
function checkladdschem(fil1,fil2)
fil_id=fopen(fil1);
filtext=fread(fil_id);
filtext=setstr(filtext)';
fclose(fil_id);
  

cr=find(filtext==10);

for i = 1:size(cr,2)-2
  rad=filtext(cr(i)+1:cr(i+1)-1);
  [m,n]=size(rad);
  if m>0 & n>1
    nr=sscanf(rad(1,1:4),'%i');
  else
    nr=-1;
  end
  if nr>0
    opnr1(nr,:)=nr;
    buidnt1(nr,:)=rad(9:14);
    ss1(nr,:)=rad(23:28);
    fpos1(nr,:)=rad(31:35);
    tpos1(nr,:)=rad(53:57);
  end
end


fil_id=fopen(fil2);
filtext=fread(fil_id);
filtext=setstr(filtext)';
fclose(fil_id);
  
cr=find(filtext==10);

for i = 1:size(cr,2)-2
  rad=filtext(cr(i)+1:cr(i+1)-1);
  [m,n]=size(rad);
  if m>0 & n>1
    nr=sscanf(rad(1,1:4),'%i');
  end
  if nr>0
    opnr2(nr,:)=nr;
    buidnt2(nr,:)=rad(9:14);
    ss2(nr,:)=rad(23:28);
    fpos2(nr,:)=rad(31:35);
    tpos2(nr,:)=rad(53:57);
  end
end

fprintf(1,'\n  *********  Kontroll av oberoende mellan laddschema i %s och %s  *********\n\n',fil1,fil2);
flag=0;
i=mbucatch(buidnt1,buidnt2);
i1=find(i);
for k=1:length(i1),
   if ~strcmp(buidnt1(i1(k),:),'      '),
       fprintf('Varning, operation %4i i %s och operation %4i i %s har samma bränsle id (%s)\n' ...
      ,opnr1(i1(k),:),fil1,opnr2(i(i1(k)),:),fil2,buidnt1(i1(k),:));
       flag=1;
   end
end    

if flag==0
disp('Bränsle id kollad. Ingen BP förekommer i båda schemorna.                    OK');
end

flag=0;
i=mbucatch(ss1,ss2);
i1=find(i);
for k=1:length(i1),
  if  ~strcmp(ss1(i1(k),1:6),'      '),
     fprintf('Varning, operation %i i %s och operation %i i %s har samma styrstavs id (%s)\n' ...
    ,opnr1(i1(k),:),fil1,opnr2(i(i1(k)),:),fil2,ss1(i1(k),:))
     flag=1;
  end
end
if flag==0
disp('Styrstavs id kollad.  Ingen styrstav förekommer i båda schemorna.           OK');
end


flag=0;
i=mbucatch(tpos1,tpos2);
i1=find(i);
for k=1:length(i1),
  if ~strcmp(tpos1(i1(k),1:5),'     '),
       fprintf('Varning, till-pos. %s i op. nr. %i i %s  = till-pos. i op. nr. %i i %s\n' ...
      ,tpos1(i1(k),:),opnr1(i1(k),:),fil1,opnr2(i(i1(k)),:),fil2)
       flag=1;
  end
end

i=mbucatch(fpos1,fpos2);
i1=find(i);
for k=1:length(i1),
   fprintf('Varning, från-pos. %s i op nr %4i i %s = från-pos. i op nr. %4i i %s\n' ...
  ,fpos1(i1(k),:),opnr1(i1(k),:),fil1,opnr2(i(i1(k)),:),fil2)
   flag=1;
end

i=mbucatch(tpos2,fpos1);
i1=find(i);
for k=1:length(i1),
  flag=1;
  if strcmp(buidnt1(i(i1(k)),:),'      '),
    id1=ss1(i(i1(k)),:);id2=ss2(i1(k),:);
  else
    id1=buidnt1(i(i1(k)),:);id2=buidnt2(i1(k),:);
  end
  if strcmp(id1,id2),
    if strcmp(fpos2(i1(k),:),tpos1(i(i1(k)),:)),
      fprintf('OBS! Op. nr. %4i i %s och op. nr. %4i i %s är t.o.r. (pos. %s, pos. %s,  id %s)\n',...
      opnr2(i1(k),:),fil2,opnr1(i(i1(k)),:),fil1,tpos2(i1(k),:),fpos2(i1(k),:),id1);
    else    
      fprintf('Operation %4i i %s måste utföras före operation %4i i %s (pos. %s,   id %s)\n',...
      opnr2(i1(k),:),fil2,opnr1(i(i1(k)),:),fil1,tpos2(i1(k),:),id2);
    end
  else
    fprintf('Operation %4i i %s måste utföras före operation %4i i %s (pos. %s)\n',...
    opnr1(i(i1(k)),:),fil1,opnr2(i1(k),:),fil2,tpos2(i1(k),:));
  end
end

i=mbucatch(fpos2,tpos1);
i1=find(i);
for k=1:length(i1),
  flag=1;
  if strcmp(buidnt1(i(i1(k)),:),'      '),
    id1=ss1(i(i1(k)),:);id2=ss2(i1(k),:);
  else
    id1=buidnt1(i(i1(k)),:);id2=buidnt2(i1(k),:);
  end
  if strcmp(id1,id2),
    if strcmp(fpos1(i(i1(k)),:),tpos2(i1(k),:)),
      fprintf('OBS! Op. nr. %4i i %s och op. nr. %4i i %s är t.o.r. (pos. %s, pos. %s,  id %s)\n',...
      opnr2(i1(k),:),fil2,opnr1(i(i1(k)),:),fil1,tpos2(i1(k),:),fpos2(i1(k),:),id1);
    else    
      fprintf('Operation %4i i %s måste utföras före operation %4i i %s (pos. %s,    id %s)\n',...
      opnr1(i(i1(k)),:),fil1,opnr2(i1(k),:),fil2,fpos2(i1(k),:),id1);
    end
  else
    fprintf('Operation %4i i %s måste utföras före operation %4i i %s (pos. %s)\n',...
    opnr2(i1(k),:),fil2,opnr1(i(i1(k)),:),fil1,fpos2(i1(k),:));
  end
end



if flag==0   
disp('Positioner kollade.  Ingen position förekommer i båda schemorna.            OK');
end
