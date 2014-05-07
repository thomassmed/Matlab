%@(#)   manshuffle.m 1.4	 10/09/09     10:50:23
%
function plvec=manshuffle(plvec);
handles=get(gcf,'userdata');
curfig=gcf;
hM=get(handles(6),'userdata');
skyffett=[];
helpfig=[];
if nargin<1,
  plvec=get(hM,'userdata');
end
curfile=setprop(5);
cminstr=setprop(7);
cmaxstr=setprop(8);
cmin=str2num(cminstr);
cmax=str2num(cmaxstr);
epsi=1.0d-4*(cmax-cmin);
ncol=get(handles(26),'userdata');
klar=ncol*4/(cmax-cmin)-ncol*cmin/(cmax-cmin)+2;
ut=ncol*7/(cmax-cmin)-ncol*cmin/(cmax-cmin)+2;
flytta=ncol*5/(cmax-cmin)-ncol*cmin/(cmax-cmin)+2;
flyttanu=ncol*6/(cmax-cmin)-ncol*cmin/(cmax-cmin)+2;
ettar=ncol*10/(cmax-cmin)-ncol*cmin/(cmax-cmin)+2;
klarnyss=ncol*3/(cmax-cmin)-ncol*cmin/(cmax-cmin)+2;
tom=-ncol*cmin/(cmax-cmin)+2;
tomnyss=ncol*2/(cmax-cmin)-ncol*cmin/(cmax-cmin)+2;
com0='';
ncomments=0;
ncomvec=0;
bocfile=get(handles(91),'userdata');
[buid,mminj,konrod,bb,hy,mz,ks,buntyp]=readdist7(curfile,'asyid');
block=getblock(curfile);
buid0=buid;
buidboc=readdist7(bocfile,'asyid');
ikan=filtcr(ones(size(konrod)),mminj,0,2);
OK=ones(1,mz(14));
[from,to,ready,fuel]=initvec(buid,buidboc,OK);
to0=to;from0=from;ready0=ready;
[allfrom,allto]=findmove([15 15],OK,from,to,fuel,mminj);
if nargin<1,
  if length(allfrom)>0,
    if allfrom(1)>0,
      plvec(allfrom)=6*ones(size(allfrom));
    end
  end
  ii=find(plvec==7&from'==0);
  plvec(ii)=8*ones(size(ii));
  plvec0=plvec;
end
[kedja,gonu]=findchain(to,from,ready,fuel);

enkedja = findslutenkedja(to,from,ready,fuel);
%skaper matriser för att spara pilpekare i.
Ppil = zeros(mz(14), 1);
Pring = Ppil;



hcross=[];
goon=1;
nrop=0;lastoper=0;
outerloop=1;
ccplot(plvec);
hand=get(gcf,'userdata');
plmat=get(hand(3),'cdata');
poolfil=get(hand(93),'userdata');
if (length(remblank(poolfil))==0),
  poolwarning;
  uiwait(gcf);
  svar=get(gcf,'userdata');
  delete(gcf);
  if strcmp(remblank(svar),'CA'),
    return;
  else
    pooluse=0;
  end
else
  pooluse=1;
  bunhistfil = input('Ange bunhistfil: ','s');
  temppoolfil = temppofil(poolfil);
  
end
mode=2;
while outerloop==1,
 fprintf('%s\n','Valj mellan foljande optioner:');
 fprintf('%s\n','     0 - Visa inga pilar');
 fprintf('%s\n','     1 - Visa pilar for bransle som inte kan skyfflas utan urladdning');
 fprintf('%s\n','     2 - Visa pilar for bransle som  kan skyfflas utan urladdning');
 fprintf('%s\n','     4 - Visa kedjor med ettaringar');
 fprintf('%s\n','   100 - Visa alla pilar');
 fprintf('%s\n\n','    -1 - Avsluta');
 stmode=input('Option <Default=-1>: ','s');
 oldmode=mode;
 if length(stmode)==0,
   mode=-1;
   goon=0;outerloop=0;
 else
   mode=str2num(stmode);
   if isequal(mode,-1),
     goon=0;outerloop=0;
   else
     goon=1;
   end
 end
 % Find once burnt-fuel to be shuffled
if isequal(mode,4),
   
   %kinf=kinf2mlab(curfile);  Orginal
   kinf = readdist7(curfile, 'khot');		%Ändrad
   
   skyffett=(kinf>1.14)'.*(1-ready);
   iskyff=find(skyffett);
   plvec=round((cmax-cmin)/ncol*(cor2vec(plmat,mminj)-2)+cmin);
   plvec(iskyff)=ones(size(iskyff'))*10;
   gonu(iskyff)=4*ones(size(iskyff));
   for k=1:length(iskyff),
     [ik(k),jk(k)]=find(kedja==iskyff(k));
     l=max(find(kedja(ik(k))>0));                
     for ll=jk(k)-1:-1:1,
       gonu(kedja(ik(k),ll))=4;     
     end
   end     
   ccplot(plvec);
 elseif oldmode==4&mode~=-1,
   [kedja,gonu]=findchain(to,from,ready,fuel);
   iskyff=0;
 end; %mode=4
 if goon>0,
   [Hpil,Hring]=plotallchains(kedja,mminj);
   [Hpil,Hring]=updatpil(Hpil,Hring,gonu,mode);
   if pooluse,
     if block=='F3',
       [hapool,hepool]=poolplot(block);
       htpool=[];
     else
       [hapool,hepool,htpool]=poolplot(block);
     end
     initpool(temppoolfil,bunhistfil,hapool,hepool,htpool);
   end
   figure(curfig);
   setlabels;
   hand=get(gcf,'userdata');
   plmat=get(hand(3),'cdata');
% 
% Skapar ett instruktionsfönster
   pos=[800 0 340 210];
   helpfig=figure('position',pos,'color',[0.8 0.8 0.8]);
   text(0.1,0.91,'ANVANDARHANDLEDNING');
   text(0.1,0.78,'Vanster knapp: Skyffla till/fran markerad position');
   text(0.1,0.65,'Hoger knapp: Ladda till/fran bassang');
   text(0.1,0.52,'Mittenknapp: Visa pilar for kedjan el ta bort pilarna');
   text(0.1,0.39,'Hoger utanfor hard: Angra senaste forflyttning');
   text(0.1,0.26,'Vanster utanfor hard: Till huvudmeny');
   text(0.1,0.13,'Mitten utanfor hard: Uppdatera skarm');
   xled=[];
   yled=[];
   set(gca,'XTicklabel',xled);
   set(gca,'YTicklabel',yled);
   figure(curfig);   
 end

 while goon>0,
  
  [xx,yy,button]=ginput(1);
  
  lastoper=0;
  nx=fix(xx);
  ny=fix(yy);
  xl=[nx nx+1;            
      nx+1 nx];
  yl=[ny ny;
     ny+1 ny+1];
  knum=cpos2knum(ny,nx,mminj);
  if button==1
    if knum>0,
      if fuel(knum)==0,
        j=strmatch(buidboc(knum,:),buid);        
        if length(j)==1,
          lfrom(nrop+1)=j;
          lto(nrop+1)=knum;
          lastoper=1;
        elseif length(j)==0,
          disp(['Bundle ',buidboc(knum,:),' is in pool, use right button to get it.']);
        elseif length(j)>1,
          disp(['Something is wrong ',buidboc(knum,:),' exists in many positions in ',curfile]);
        end
      elseif  fuel(knum)==1,
        j=strmatch(buid(knum,:),buidboc);
        if length(j)==1,
          if fuel(j)==0,
            lastoper=1;
            lfrom(nrop+1)=knum;
            lto(nrop+1)=j;
          else
            dicto=knum2cpos(j,mminj);kostr=sprintf('%s%i%s%i%s','(',dicto(1),',',dicto(2),')');
            disp(['To-position not empty: ',kostr]);
          end
        elseif length(j)==0,
          disp(['Bundle ',buid(knum,:),' should be moved to pool, use right button to do that.']);
        elseif length(j)>1,
          disp(['No shuffling made, ',buid(knum,:),' exists in many positions in ',bocfile]);
        end
      end;   % fuel(knum)==0
    else
      goon=0;
    end; % knum>0
  end; % button==1
  if button==3,
    if knum>0,
      if fuel(knum)==0,
        j=strmatch(buidboc(knum,:),buid);
        if length(j)==0,
          lfrom(nrop+1)=0;
          lto(nrop+1)=knum;
          ppos(nrop+1,:)='DMPOS';
          if pooluse,
	    clearpool(temppoolfil,buidboc(knum,:),hapool,hepool,htpool);
          end
	  lastoper=1;
        elseif length(j)==1,
          disp(['Bundle ',buidboc(knum,:),' is in core, use left button to shuffle.']);
        elseif length(j)>1,
          disp(['Warning! ',buidboc(knum,:),' exists in many positions in ',curfile]);
          s=input(['Load ',buidboc(knum,:),' anyway, <Y>/N? '],'s'); 
          ladda=1;
          if length(s)>0,
            s=remblank(s);
            if upper(s(1))=='N', ladda=0;end
          end
          if ladda==1,
            lfrom(nrop+1)=0;
            lto(nrop+1)=knum;
            lastoper=1;
          end            
        end; % length(j)==0,
      elseif fuel(knum)==1,
          lfrom(nrop+1)=knum;
          lto(nrop+1)=0;
          if pooluse,
	    ppos(nrop+1,:)=getpoolpos(temppoolfil,buid(knum,:),hapool,hepool,htpool);
          else
	    ppos(nrop+1,:)='AB123';
	  end
	  lastoper=1;
      end;  % fuel(knum)==0,
    
    
    
    
    
    
    %Har nu skrivit hit ångra koden istället
    else
      if nrop>0,
        if lfrom(nrop)>0&lto(nrop)>0     
%          buid(lto(nrop),:)=['dummy' setstr(32*ones(1,size(buid,2)-5))];
          buid(lto(nrop),:)=['vatten' setstr(32*ones(1,size(buid,2)-6))];
          buid(lfrom(nrop),:)=buidboc(lto(nrop),:);
        elseif lfrom(nrop)==0,
%          buid(lto(nrop),:)=['dummy' setstr(32*ones(1,size(buid,2)-5))];
          buid(lto(nrop),:)=['vatten' setstr(32*ones(1,size(buid,2)-6))];
        elseif lto(nrop)==0,           % Move bundle to pool
          buid(lfrom(nrop),:)=buid0(lfrom(nrop),:);
        end;  % lfrom(nrop)>0&lto(nrop)>0
        newmove=0;
        fram=-1;
        disp('Ångra:');
        if lto(nrop)~=0
          printsfg(0,lfrom(nrop),lto(nrop),lbuid(nrop,:),mminj,'',0,block);
        else
          printsfg(0,lfrom(nrop),lto(nrop),lbuid(nrop,:),mminj,ppos(nrop,:),0,block);
          if pooluse,
	    clearpool(temppoolfil,lbuid(nrop,:),hapool,hepool,htpool); %satt dit en etta
          end
	end
        if lfrom(nrop)==0&pooluse,
	  clearpool(temppoolfil,lbuid(nrop,:),hapool,hepool,htpool,1);
	end
        figure(curfig);
        [gonu,from,to,ready,fuel,plmat,ssto]=updscreen(lfrom,lto,nrop,lbuid,...
        fram,newmove,skyffett,kedja,mode,mminj,ikan,to0,from0,ready0,gonu,from,to,ready,fuel,plmat);
        sstom(nrop,:)=ssto;
%        [Hpil,Hring]=ritascr(Hpil,Hring,gonu,mode,plmat);
        lhc=length(hcross);
        if lhc>0, delete(hcross(lhc));hcross=hcross(1:lhc-1);end
        nrop=nrop-1;
        lfrom=lfrom(1:nrop);
        lto=lto(1:nrop);
        sstom=sstom(1:nrop,:);
        if length(ncomvec)>nrop,
          ncomvec=ncomvec(1:nrop);
        end
      end; % nrop>0
     
     
     
      %Koden som skrev kommentarer
      %tempcom=input('Kommentar: ','s');
      %if nrop>0,
        %ncomments=ncomments+1;
        %ncomvec(nrop,1)=1;
        %if ncomments==1,
          %comment=tempcom;
        %else        
          %comment=str2mat(comment,tempcom);
        %end
      %else
        %com0=tempcom;
      %end
    
    
    end	  %utanför eller inte
  end; % button==3
 
  if lastoper==1,
    nrop=nrop+1;
    if lfrom(nrop)>0&lto(nrop)>0,  % Shuffling in-core
       buid(lto(nrop),:)=buidboc(lto(nrop),:);
%       buid(lfrom(nrop),:)=['dummy' setstr(32*ones(1,size(buid,2)-5))];
       buid(lfrom(nrop),:)=['vatten' setstr(32*ones(1,size(buid,2)-6))];
       lbuid(nrop,:)=buidboc(lto(nrop),:);
    elseif lfrom(nrop)==0,         % Get bundle from pool
       buid(lto(nrop),:)=buidboc(lto(nrop),:);
       lbuid(nrop,:)=buidboc(lto(nrop),:);
    elseif lto(nrop)==0,           % Move bundle to pool
       lbuid(nrop,:)=buid(lfrom(nrop),:);
%       buid(lfrom(nrop),:)=['dummy' setstr(32*ones(1,size(buid,2)-5))];
       buid(lfrom(nrop),:)=['vatten' setstr(32*ones(1,size(buid,2)-6))];
    end;  % lfrom(nrop)>0&lto(nrop)>0
    newmove=1;
    fram=1;
    if lto(nrop)~=0
      printsfg(0,lfrom(nrop),lto(nrop),lbuid(nrop,:),mminj,'',0,block);
    else
      printsfg(0,lfrom(nrop),lto(nrop),lbuid(nrop,:),mminj,ppos(nrop,:),0,block);
    end
    figure(curfig);
    [gonu,from,to,ready,fuel,plmat,ssto]=updscreen(lfrom,lto,nrop,lbuid,...
    fram,newmove,skyffett,kedja,mode,mminj,ikan,to0,from0,ready0,gonu,from,to,ready,fuel,plmat);
    sstom(nrop,:)=ssto;
    hc=line(xl,yl,'color','black','erasemode','none');
    if length(hcross)==0, hcross=hc;else hcross=[hcross;hc];end
%    [Hpil,Hring]=ritascr(Hpil,Hring,gonu,mode,plmat);
  end; % lastoper==1
  if button==2,
    
    
    
    
    
    
    
    %Här började ångra, sitter nu längre upp under button==3
    %Ritar nu pilar
    if knum>0,
    	
	[Ppil,Pring]=plotonechain(enkedja,mminj, knum, Ppil, Pring);
      
      
      
      
         
    
    else
      if length(hcross)>0, delete(hcross);hcross=[];end
      [Hpil,Hring]=ritascr(Hpil,Hring,gonu,mode,plmat);
      if pooluse,
        poolupd(block,hapool,hepool,htpool)
        figure(curfig);
      end
    end
  end; % button==2
 end; %goon>0
 if outerloop>0,
   if length(hcross)>0, delete(hcross);hcross=[];end
   [Hpil,Hring]=ritascr(Hpil,Hring,gonu,mode,plmat);
 end
end; %outerloop
plvec=round((cmax-cmin)/ncol*(cor2vec(plmat,mminj)-2)+cmin);
if nrop>ncomments, ncomvec=[ncomvec;zeros(nrop-length(ncomvec),1)];end
infil=input('Spara till safeguard infil: ','s');
if length(infil)>0, sparinfil=1;else,sparinfil=0;end
comcount=0;
if sparinfil==1,
  svar=input('Spara som ny ELLER Addera till gammal fil? (<S>/A)','s');
  if length(svar)==0, svar='w';end
  svar=remblank(svar);
  if lower(svar(1))~='a', svar='w';end
  fid=fopen(infil,svar);
  if svar=='w',
    if length(com0)>0
      fprintf(fid,'%s%s\n','TEXT',com0);
    else
      fprintf(fid,'%s\n','TEXT GENERATED BY MATLAB');
    end
  end
  for i=1:nrop,
    if sstom(i,2)>0, 
      if lto(i)~=0
        printsfg(fid,lfrom(i),lto(i),'vatten',mminj,'',2,block);
      else
        printsfg(fid,lfrom(i),lto(i),'vatten',mminj,ppos(i,:),2,block);
      end
    end  
      if lto(i)~=0
        printsfg(fid,lfrom(i),lto(i),lbuid(i,:),mminj,'',0,block);
      else
        printsfg(fid,lfrom(i),lto(i),lbuid(i,:),mminj,ppos(i,:),0,block);
      end
    if sstom(i,1)>0, 
      if lto(i)~=0
        printsfg(fid,lfrom(i),lto(i),'vatten',mminj,'',1,block);
      else
        printsfg(fid,lfrom(i),lto(i),'vatten',mminj,ppos(i,:),1,block);
      end
    end  
    if ncomvec(i)==1,
      comcount=comcount+1;
      if lto(i)~=0
        printsfg(fid,0,0,'vatten',mminj,ppos(i,:),comment(comcount,:),block);
      end
    end
  end
  fclose(fid);
end
delete(helpfig);
if pooluse,
  delete(hapool);
  delete(hepool);
  if ~isempty(htpool),delete(htpool);end
end
