%@(#)   checkladdschema.m 1.1	 05/07/13     10:29:28
%
%
% Function checkladdschem(fil) kontrollerar beroenden i ett laddschema,
% d.v.s. en utfil fr�n Safeguard. Ingen kontroll om styrstavarna �r 
% �tkomliga utf�rs.
%
function checkladdschema(fil)
fprintf('OBS ingen kontroll om styrstavar �r �tkomliga\n')
fid=fopen(fil);
filtxt=fread(fid,inf);
filtxt=setstr(filtxt)';
fclose(fid);
cr=[0 cr];
cr=find(filtxt==10);
[n m]=size(cr);
for i=1:m-2
  rad=filtxt(cr(i)+1:cr(i+1)-1);
  [m1 n1]=size(rad);
  if ( m1>0 & n1>1 ) 
    nr=sscanf(rad(1,2:5),'%i');
  end
  if ( nr>0 )
    opnr(nr,:)=nr;
    buidnt(nr,:)=rad(9:14);
    cridnt(nr,:)=rad(23:28);
    fpos(nr,:)=rad(31:35);
    tpos(nr,:)=rad(53:57);
  end
end
flag=[0 0 0 0 0 0];
[m n]=size(opnr);
for i=1:m
  for j=1:m
    if ( ~strcmp(buidnt(i,:),'      ') )
      if ( strcmp(cridnt(i,:),'      ') )
        if ( i~=j & strcmp(buidnt(i,:),buidnt(j,:)) & i<j )
          fprintf('Varning, operation %i och %i har samma br�nsle id\n',...
          opnr(i,:),opnr(j,:))
          flag(1,1)=flag(1,1)+1;
        end
      else
        fprintf('�r operation %i en br�nslepatron eller en styrstav?\n',i)
        fprintf('Kontrollera formatet p� utfilen fr�n Safeguard\n')
        return
      end
    elseif ( strcmp(buidnt(i,:),'      ') )
      if     ( ~strcmp(cridnt(i,:),'      ') ) 
        if ( i~=j & strcmp(cridnt(i,:),cridnt(j,:)) & i<j )
          fprintf('Varning, operation %i och %i har samma styrstavs id\n',...
          opnr(i,:),opnr(j,:))
          flag(1,2)=flag(1,2)+1;
        end
      else
        fprintf('�r operation %i en br�nslepatron eller en styrstav?\n',i)
        fprintf('Kontrollera formatet p� utfilen fr�n Safeguard\n')
        return
      end
    end
  end
end
if ( flag(1,1)==0 ); fprintf('OK, Br�nsle id f�rekommer endast en g�ng\n'); end;
if ( flag(1,2)==0 ); fprintf('OK, Styrstavs id f�rekommer endast en g�ng\n'); end;
for i=1:m
  for j=1:m
    if ( i~=j & strcmp(tpos(i,:),tpos(j,:)) & i<j )
      fprintf('Varning, operation %i och %i har samma tillposition\n',...
               opnr(i,:),opnr(j,:))
      flag(1,3)=flag(1,3)+1;
    end
    if ( i~=j & strcmp(fpos(i,:),fpos(j,:)) & i<j )      
      fprintf('Varning, operation %i och %i har samma fr�nposition\n',...
               opnr(i,:),opnr(j,:))
      flag(1,4)=flag(1,4)+1;
    end
    if ( i==j & strcmp(tpos(i,:),fpos(j,:)) )
        fprintf('Varning, operation %i har samma till- och fr�nposition\n',...
        opnr(i,:))
        flag(1,5)=flag(1,5)+1;
    end         
    if ( i~=j & strcmp(tpos(i,:),fpos(j,:)) )
        fprintf('Varning, operation %i m�ste g�ras f�re operation %i \n',...
        opnr(j,:),opnr(i,:))
        flag(1,6)=flag(1,6)+1;
    end           
  end
end
if ( flag(1,3)==0 ); fprintf('OK, Tillpositioner f�rekommer endast en g�ng\n'); end;
if ( flag(1,4)==0 ); fprintf('OK, Fr�npositioner f�rekommer endast en g�ng\n'); end;
if ( flag(1,5)==0 ); fprintf('OK, Ingen operation har samma till- som fr�nposition\n'); end;
if ( flag(1,6)==0 ); fprintf('OK, Ingen operation �r beroende av n�gon annan \n'); end;

