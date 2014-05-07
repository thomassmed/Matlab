function [dat,num,bunpol,bunnr,ptyp,nfustyp,fustyp,tt,bb,yy]=ramin2matotext(f_ramona);

% [dat,num,bunpol,bunnr,ptyp]=ramin2mat(f_ramona);
%
% reads all lines that start with a cardnumber from a ramona inputdesk.
%
% num = vector with card numbers
% dat = corresponding data
%
% ex: i=find(num==200000); KMAX=dat(i,3);
%
%	Emma Lundgren 050930
%



f_ramona=expand(f_ramona,'inp');
fid=fopen(f_ramona);
file = fread(fid);
po=[0;find(file==10)];				% s�ker positioner f�r returns
dat=zeros(1600,40);				% initierar dat, begr�nsar antal data per rad till 40 och antal inl�sta rader till 1600

j=1;						% antal inl�sta rader vilka b�rjar med kortnummer (+1)

bunpol=setstr(zeros(200,4));			
ptyp=setstr(zeros(100,8));
bunnr=zeros(200,1);
ityp=1;
ibnr=1;
flag33=0;
ii = 0;

i = 0;
while i<length(po)-1
  i = i+1;
  [dat1,nout]=sscanf(setstr(file(po(i)+1:po(i+1)-1)'),'%f');			% s�k kortnummer i b�rjan av rad
  if ~isempty(dat1)								% om kortnummer hittas!
    if dat1(1)==332000								% om kortnummer �r 332000
      if flag33==2, 
        disp('Warning Input card 332000 MUST NOT be combined');
        disp('with input card 529900!');					
      end
      flag33=1;
      rad=setstr(file(po(i)+1:po(i+1)-1)');					
      dat1=sscanf(rad,'%f%f%s')';						% l�s in information fr�n rad i dat1
      fnutt=find(abs(rad)==34); 						% s�k position f�r " i rad                                                  
      bunpol(dat1(2),1:fnutt(2)-fnutt(1)-1)=rad(fnutt(1)+1:fnutt(2)-1);		% bunpol: rad anger br�nslenummer data anger br�nsleid
      ibnr=ibnr+1;								% antal ibnr �kas
      
    elseif dat1(1)==529900,							% om kortnummer �r 529900
      if flag33==1, 
        disp('Warning Input card 332000 MUST NOT be combined');			
        disp('with input card 529900!');
      end
      flag33=2;
      rad=setstr(file(po(i)+1:po(i+1)-1)');
      dat1=sscanf(rad,'%f%f%s%s')';						% ex: dat1 = 529900 3  "S96"  "DU96,DS96,DS98,DU98,..."
      fnutt=find(abs(rad)==34);    						% leta position f�r "  								                                             
      ptyp(dat1(2),1:fnutt(2)-fnutt(1)-1)=setstr(rad(fnutt(1)+1:fnutt(2)-1));	% ptyp, rad anger br�nslenr f�r rad 3 f�s fr�n ovan S96
      ityp=ityp+1;								% antal typer
      btyps=setstr(rad(fnutt(3)+1:fnutt(4)-1));					% btyps, rad anger br�nslenr f�r rad 3 f�s DU96,DS96,...
      ibt=find(btyps==',');							% leta position f�r ,
      ibt=[0 ibt length(btyps)+1];						% ibt anger positioner i btyps f�r ,
      for i1=1:length(ibt)-1,
        bunpol(ibnr,1:ibt(i1+1)-ibt(i1)-1)=btyps(ibt(i1)+1:ibt(i1+1)-1);	% bunpol(1,:) = DU96, bunpol(2,:) = DS96 ...
        bunnr(ibnr)=dat1(2);							% bunnr(1) = 3, bunnr(2) = 3 ...
	ibnr=ibnr+1;
      end
    
    
%-------------------------------------------------------------------------------%    
    elseif dat1(1)==525000							% om kortnummer �r 525000 (tabeller!)
      ii = ii+1;								% �ka antal hittade tabeller med ett
      nfustyp(ii,1)		= dat1(2);					% antal br�nsle-sorter f�r vilka tabellen �r giltiga
      if size(dat1,1)~=dat1(2)+2
        fprintf(1,['Warning:\tCard 525000\n'...
	               '\t\tNumber of fuel types specified (K1)\n'...
	               '\t\tand fuel type specification (NFUEL)\n'... 
		       '\t\tdo not match.\n'...
		       '\t\tCheck your ParaFile.\n']);
      end		       
      fustyp(ii,1:nfustyp(ii,1))= dat1(3:nfustyp(ii,1)+2);			% br�nsle-sorter f�r vilka tabellen �r giltig
      clear t b y ord;
      for k=1:7									% l�s in data f�r parameter 1-7
	while dat1(1)~=525100							% leta r�tt p� 525100
          dat1 = [];
          while isempty(dat1)
	    i=i+1;
            [dat1,nout]=sscanf(char(file(po(i)+1:po(i+1)-1)'),'%f');		% l�ser in numeriska v�rden fr�n rad i till vektorn dat1
          end
	end  
        [ord1]=sscanf(char(file(po(i)+1:po(i+1)-1)'),'%f%s');
        ord(k,1:4)=ord1(3:6);							% ord(k,:) indikerar vilken parameter som behandlas
        while dat1(1)~=525200							% leta r�tt p� 525200
          dat1 = [];
          while isempty(dat1)
            i=i+1;
            [dat1,nout]=sscanf(char(file(po(i)+1:po(i+1)-1)'),'%f');
          end
        end
	jj=2;																
        flag=0;									% signalerar om temp eller burnup behandlas
	t(k,1) = 0;								% antal inl�sta temperaturer f�r parameter k
	b(k,1) = 0;								% antal inl�sta utbr�nningspunkter f�r parameter k
        while dat1(1)~=525400							% leta r�tt p� 525400
          dat1 = [];
          while isempty(dat1)
	    i=i+1;
            [dat1,nout]=sscanf(char(file(po(i)+1:po(i+1)-1)'),'%f');
          end
          if dat1(1)==525300							% om kort 525300 hittas...
            if (ord1(8)==1)||(flag==1)
	      t(k,1) = t(k,1) + nout - 1;
	      t(k,jj:(jj+nout-2))=dat1(2:nout);	
	    else
	      b(k,1) = b(k,1) + nout - 1;
	      b(k,jj:(jj+nout-2))=dat1(2:nout);
	    end
	    jj=jj+nout-1;
          elseif dat1(1)==525200						% om tv� variabler s� temp
	    jj=2;
	    flag=1;
          end		
        end
        m=1;									% m=motsvarande v�rde utbr�nning
        n=1;									% n=motsvarande v�rde temperatur							
        while dat1(1)==525400
          y(k,n:(n+nout-2))=dat1(2:nout);
	  n=n+nout-1;

          if i+1~=length(po)
            dat1 = [];
          else
            dat1(1) = 10;
          end
          while isempty(dat1)
	    i=i+1;
            [dat1,nout]=sscanf(char(file(po(i)+1:po(i+1)-1)'),'%f');
            if i+1==length(po)
              dat1=10;
            end
          end
        end
	n = n - 1;
	if (b(k,1)==0 && t(k,1) ~= n) || (b(k,1)~=0 && t(k,1)*b(k,1) ~= n)
          fprintf(1,['Warning:\tCard 525400, 525300\n'...
	               '\t\tNumber of elements in table\n'...
		       '\t\tand number of entries (NBURN,NTEMP).\n'...
		       '\t\tdo not match.\n'...
		       '\t\tCheck your ParaFile.\n']);
        end
      end
      i=i-1;
      ord = sum(ord');
      [ord,k]=sort(ord);
      t = t(k,:);
      b = b(k,:);
      y = y(k,:);
      tt(1:size(t,1),1:size(t,2),ii) = t;
      bb(1:size(b,1),1:size(b,2),ii) = b;
      yy(1:size(y,1),1:size(y,2),ii) = y;
%-------------------------------------------------------------------------------%  

    else
       dat(j,1:nout)=dat1';							% annars - l�s in data
    end
    j=j+1;									% �ka p� antal rader inl�sta vilka b�rjar med kortnummer
  end
end

i=find(dat(:,1)>99999 & dat(:,1) < 1000000);					% sortera bort rader vilka inte inleds med kortnummer
dat=dat(i,:);									% korrigera data
num=dat(:,1);									% s�tt kortnummer i egen vektor
dat(:,1)=[];									% separera kortnummer fr�n data

bunpol=bunpol(1:ibnr-1,:);							% plockar bort �verfl�diga element i bunpol
ptyp=ptyp(1:ityp-1,:);								% plockar bort �verfl�diga element i ptyp
bunnr=bunnr(1:ibnr-1);								% plockar bort �verfl�diga element i bunnr

fclose(fid);




