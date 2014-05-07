%@(#)   kolla_oberoende_ny.m 1.1	 05/07/15     15:06:42
%
% Function kolla_oberoende_ny('dofil1.txt','dofil2.txt')
% kontrollerar om två laddscheman dofil1.txt och dofil2.txt
% har något beroende.
% 
% OBS ! Kontrollera alltid ALLA laddsheman igen efter en ändring.
%
%

% Roger Johansson, 1997-08-11
% Modified: Thomas Smed 1998-05-27
% Modified: Josefin Larsson 2005-07-15
% Modified: Jan Karjalainen 2005-07-26
% Adderad funktionalitet: Scheman behöver ej innehålla
% styrstavar och bränslepatroner.
function checkladdschem(fil1,fil2)

disp(' ');
%Fil1
fil_id=fopen(fil1);
filtext=fread(fil_id);
filtext=setstr(filtext)';
fclose(fil_id);
  
%%%%%%%%%%%%%%%%%%%%
% Variabler
%%%%%%%%%%%%%%%%%%%%
patron1 = 0;
patron2 = 0;
styrstav1 = 0;
styrstav2 = 0;

cr=find(filtext==10);
styrstav1 = 0;
for i = 1:size(cr,2)

  if i == 1
  	rad = filtext(1:cr(i)-1);
  else	
  	rad=filtext(cr(i-1)+1:cr(i)-1);
  end
  [m,n]=size(rad);
  if m>0 & n>1
    nr=sscanf(rad(1,1:4),'%i');
  else
    nr=-1;
  end
  
  
  
  %Ändrat
  if nr>0
  	opnr1(nr,:)=nr;
	
	absrad = abs(rad);
	tab = find(absrad == 9);
	
	%Patroner som flyttas
	if strcmp(rad(5:10), 'Patron')
		buidnt1(nr,:)=rad(12:17);
                patron1 = 1; % Patroner finns i schemat
	%Styrstavar som flyttas
	else
		ss1(nr,:) = rad(14:19);
		styrstav1 = 1; % Styrstavar finns i schemat
			
	end
	
	
	fpos1(nr,:) = rad(tab(3)+1:tab(3)+5);
	tpos1(nr,:) = rad(tab(6)+1:tab(6)+5);

  
  end
end


%Fil2
fil_id=fopen(fil2);
filtext=fread(fil_id);
filtext=setstr(filtext)';
fclose(fil_id);
  
cr=find(filtext==10);
styrstav2 = 0;
for i = 1:size(cr,2)
  
  if i == 1
  	rad = filtext(1:cr(i)-1);
  else	
  	rad=filtext(cr(i-1)+1:cr(i)-1);
  end
  [m,n]=size(rad);
    
  if m>0 & n>1
    nr=sscanf(rad(1,1:4),'%i');
  end
  
  
  %Ändrat
  if nr>0
    opnr2(nr,:)=nr;
    
    	absrad = abs(rad);
	tab = find(absrad == 9);
	
	%Patroner som flyttas
	if strcmp(rad(5:10), 'Patron')
		buidnt2(nr,:)=rad(12:17);
                patron2 = 1; % Patroner finns i schemat
	%Styrstavar som flyttas
	else
		ss2(nr,:) = rad(14:19);
		styrstav2 = 1; % Styrstavar finns i schemat
			
	end
	
	
	fpos2(nr,:) = rad(tab(3)+1:tab(3)+5);
	tpos2(nr,:) = rad(tab(6)+1:tab(6)+5);

    
    
    
    
    
  end
end

fprintf(1,'\n  *********  Kontroll av oberoende mellan laddschema i %s och %s  *********\n\n',fil1,fil2);


%Identitetsnummer
flag=0;
if (patron1 == 1) && (patron2 == 1)
i=mbucatch(buidnt1,buidnt2);
i1=find(i);
for k=1:length(i1),
   if abs(buidnt1(i1(k),:)) ~=[0 0 0 0 0 0]
       fprintf('Varning, operation %4i i %s och operation %4i i %s har samma bränsle id (%s)\n' ...
      ,opnr1(i1(k),:),fil1,opnr2(i(i1(k)),:),fil2,buidnt1(i1(k),:));
       flag=1;
   end
end    
end

if flag==0
disp('Bränsle id kollad.    Ingen BP förekommer i båda schemorna.                 OK');
end



%Styrstavar
if (styrstav1 == 1) && (styrstav2 == 1)
flag=0;
i=mbucatch(ss1,ss2);
i1=find(i);
for k=1:length(i1),
  if  abs(ss1(i1(k),1:6)) ~= [0 0 0 0 0 0]
     fprintf('Varning, operation %i i %s och operation %i i %s har samma styrstavs id (%s)\n' ...
    ,opnr1(i1(k),:),fil1,opnr2(i(i1(k)),:),fil2,ss1(i1(k),:))
     flag=1;
  end
end
if flag==0
disp('Styrstavs id kollad.  Ingen styrstav förekommer i båda schemorna.           OK');
end
end



%Till positioner
flag=0;
i=mbucatch(tpos1,tpos2);
i1=find(i);
for k=1:length(i1),
  if abs(tpos1(i1(k),1:5)) ~= [0 0 0 0 0]
       fprintf('Varning, till-pos. %s i op. nr. %4i i %s  =  till-pos. i op. nr. %4i i %s\n' ...
      ,tpos1(i1(k),:),opnr1(i1(k),:),fil1,opnr2(i(i1(k)),:),fil2)
       flag=1;
  end
end



%Från positioner
i=mbucatch(fpos1,fpos2);
i1=find(i);
for k=1:length(i1),
   fprintf('Varning, från-pos. %s i op. nr. %4i i %s  =  från-pos. i op. nr. %4i i %s\n' ...
  ,fpos1(i1(k),:),opnr1(i1(k),:),fil1,opnr2(i(i1(k)),:),fil2)
   flag=1;
end




%Till och från positioner
i=mbucatch(tpos2,fpos1);
i1=find(i);
for k=1:length(i1),
  flag=1;
  if abs(buidnt1(i(i1(k)),:)) == [0 0 0 0 0 0]
    id1=ss1(i(i1(k)),:);id2=ss2(i1(k),:);
  else
    id1=buidnt1(i(i1(k)),:);id2=buidnt2(i1(k),:);
  end
  if strcmp(id1,id2),
    if strcmp(fpos2(i1(k),:),tpos1(i(i1(k)),:)),
      fprintf('Varning, op. nr. %4i i %s och op. nr. %4i i %s är t.o.r. (pos. %s, pos. %s,  id %s)\n',...
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




%Från och till positioner
i=mbucatch(fpos2,tpos1);
i1=find(i);
for k=1:length(i1),
  flag=1;
  if abs(buidnt1(i(i1(k)),:)) == [0 0 0 0 0 0]
    id1=ss1(i(i1(k)),:);id2=ss2(i1(k),:);
  else
    id1=buidnt1(i(i1(k)),:);id2=buidnt2(i1(k),:);
  end
  if strcmp(id1,id2),
    if strcmp(fpos1(i(i1(k)),:),tpos2(i1(k),:)),
      fprintf('Varning, op. nr. %4i i %s och op. nr. %4i i %s är t.o.r. (pos. %s, pos. %s,  id %s)\n',...
      opnr2(i1(k),:),fil2,opnr1(i(i1(k)),:),fil1,tpos2(i1(k),:),fpos2(i1(k),:),id1);
    else    
      fprintf('Varning, op. %4i i %s måste utföras före op. %4i i %s (pos. %s,    id %s)\n',...
      opnr1(i(i1(k)),:),fil1,opnr2(i1(k),:),fil2,fpos2(i1(k),:),id1);
    end
  else
    fprintf('Varning, op. %4i i %s måste utföras före op. %4i i %s (pos. %s)\n',...
    opnr2(i1(k),:),fil2,opnr1(i(i1(k)),:),fil1,fpos2(i1(k),:));
  end
end



if flag==0   
disp('Positioner kollade.   Ingen position förekommer i båda schemorna.           OK');
end
disp(' ');
disp(' ');
