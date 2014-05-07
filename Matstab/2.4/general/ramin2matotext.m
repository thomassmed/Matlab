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
po=[0;find(file==10)];				% söker positioner för returns
dat=zeros(1600,40);				% initierar dat, begränsar antal data per rad till 40 och antal inlästa rader till 1600

j=1;						% antal inlästa rader vilka börjar med kortnummer (+1)

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
  [dat1,nout]=sscanf(setstr(file(po(i)+1:po(i+1)-1)'),'%f');			% sök kortnummer i början av rad
  if ~isempty(dat1)								% om kortnummer hittas!
    if dat1(1)==332000								% om kortnummer är 332000
      if flag33==2, 
        disp('Warning Input card 332000 MUST NOT be combined');
        disp('with input card 529900!');					
      end
      flag33=1;
      rad=setstr(file(po(i)+1:po(i+1)-1)');					
      dat1=sscanf(rad,'%f%f%s')';						% läs in information från rad i dat1
      fnutt=find(abs(rad)==34); 						% sök position för " i rad                                                  
      bunpol(dat1(2),1:fnutt(2)-fnutt(1)-1)=rad(fnutt(1)+1:fnutt(2)-1);		% bunpol: rad anger bränslenummer data anger bränsleid
      ibnr=ibnr+1;								% antal ibnr ökas
      
    elseif dat1(1)==529900,							% om kortnummer är 529900
      if flag33==1, 
        disp('Warning Input card 332000 MUST NOT be combined');			
        disp('with input card 529900!');
      end
      flag33=2;
      rad=setstr(file(po(i)+1:po(i+1)-1)');
      dat1=sscanf(rad,'%f%f%s%s')';						% ex: dat1 = 529900 3  "S96"  "DU96,DS96,DS98,DU98,..."
      fnutt=find(abs(rad)==34);    						% leta position för "  								                                             
      ptyp(dat1(2),1:fnutt(2)-fnutt(1)-1)=setstr(rad(fnutt(1)+1:fnutt(2)-1));	% ptyp, rad anger bränslenr för rad 3 fås från ovan S96
      ityp=ityp+1;								% antal typer
      btyps=setstr(rad(fnutt(3)+1:fnutt(4)-1));					% btyps, rad anger bränslenr för rad 3 fås DU96,DS96,...
      ibt=find(btyps==',');							% leta position för ,
      ibt=[0 ibt length(btyps)+1];						% ibt anger positioner i btyps för ,
      for i1=1:length(ibt)-1,
        bunpol(ibnr,1:ibt(i1+1)-ibt(i1)-1)=btyps(ibt(i1)+1:ibt(i1+1)-1);	% bunpol(1,:) = DU96, bunpol(2,:) = DS96 ...
        bunnr(ibnr)=dat1(2);							% bunnr(1) = 3, bunnr(2) = 3 ...
	ibnr=ibnr+1;
      end
    
    
%-------------------------------------------------------------------------------%    
    elseif dat1(1)==525000							% om kortnummer är 525000 (tabeller!)
      ii = ii+1;								% öka antal hittade tabeller med ett
      nfustyp(ii,1)		= dat1(2);					% antal bränsle-sorter för vilka tabellen är giltiga
      if size(dat1,1)~=dat1(2)+2
        fprintf(1,['Warning:\tCard 525000\n'...
	               '\t\tNumber of fuel types specified (K1)\n'...
	               '\t\tand fuel type specification (NFUEL)\n'... 
		       '\t\tdo not match.\n'...
		       '\t\tCheck your ParaFile.\n']);
      end		       
      fustyp(ii,1:nfustyp(ii,1))= dat1(3:nfustyp(ii,1)+2);			% bränsle-sorter för vilka tabellen är giltig
      clear t b y ord;
      for k=1:7									% läs in data för parameter 1-7
	while dat1(1)~=525100							% leta rätt på 525100
          dat1 = [];
          while isempty(dat1)
	    i=i+1;
            [dat1,nout]=sscanf(char(file(po(i)+1:po(i+1)-1)'),'%f');		% läser in numeriska värden från rad i till vektorn dat1
          end
	end  
        [ord1]=sscanf(char(file(po(i)+1:po(i+1)-1)'),'%f%s');
        ord(k,1:4)=ord1(3:6);							% ord(k,:) indikerar vilken parameter som behandlas
        while dat1(1)~=525200							% leta rätt på 525200
          dat1 = [];
          while isempty(dat1)
            i=i+1;
            [dat1,nout]=sscanf(char(file(po(i)+1:po(i+1)-1)'),'%f');
          end
        end
	jj=2;																
        flag=0;									% signalerar om temp eller burnup behandlas
	t(k,1) = 0;								% antal inlästa temperaturer för parameter k
	b(k,1) = 0;								% antal inlästa utbränningspunkter för parameter k
        while dat1(1)~=525400							% leta rätt på 525400
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
          elseif dat1(1)==525200						% om två variabler så temp
	    jj=2;
	    flag=1;
          end		
        end
        m=1;									% m=motsvarande värde utbränning
        n=1;									% n=motsvarande värde temperatur							
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
       dat(j,1:nout)=dat1';							% annars - läs in data
    end
    j=j+1;									% öka på antal rader inlästa vilka börjar med kortnummer
  end
end

i=find(dat(:,1)>99999 & dat(:,1) < 1000000);					% sortera bort rader vilka inte inleds med kortnummer
dat=dat(i,:);									% korrigera data
num=dat(:,1);									% sätt kortnummer i egen vektor
dat(:,1)=[];									% separera kortnummer från data

bunpol=bunpol(1:ibnr-1,:);							% plockar bort överflödiga element i bunpol
ptyp=ptyp(1:ityp-1,:);								% plockar bort överflödiga element i ptyp
bunnr=bunnr(1:ibnr-1);								% plockar bort överflödiga element i bunnr

fclose(fid);




