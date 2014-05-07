%@(#)   updscreen.m 1.1	 05/07/13     10:29:44
%
%
function [gonu,from,to,ready,fuel,plmat,ssto]=updscreen(lfrom,lto,nrop,lbuid,...
fram,newmove,skyffett,kedja,mode,mminj,ikan,to0,from0,ready0,gonu,from,to,ready,fuel,plmat);
handles=get(gcf,'userdata');
hM=get(handles(6),'userdata');
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
tom=-1;
tomnyss=ncol*2/(cmax-cmin)-ncol*cmin/(cmax-cmin)+2;
ssto=[0 0];
iskyff=find(skyffett);
if isequal(fram,1),
  if nrop>1,
    if lfrom(nrop-1)>0&lto(nrop-1)>0,
      gonu(lfrom(nrop-1))=3;
      cfromnyss=knum2cpos(lfrom(nrop-1),mminj);
      ctonyss=knum2cpos(lto(nrop-1),mminj);
      plmat(cfromnyss(1),cfromnyss(2))=tom;   
      plmat(ctonyss(1),ctonyss(2))=klar;   
    elseif lfrom(nrop-1)==0,
      ctonyss=knum2cpos(lto(nrop-1),mminj);
      plmat(ctonyss(1),ctonyss(2))=klar;   
    elseif lto(nrop-1)==0,
      cfromnyss=knum2cpos(lfrom(nrop-1),mminj);
      plmat(cfromnyss(1),cfromnyss(2))=tom;   
    end;
  end; % nrop>1
  if lfrom(nrop)>0&lto(nrop)>0,  % Shuffling in-core
     %Update bundle that could be shuffled to the empty pos. 
     %Exception: When shuffling once-burnt fuel, the color should be
     %kept orange all the time for once-burnt fuel that are to be shuffled
     if from(lfrom(nrop))>0,
       cfrny=knum2cpos(from(lfrom(nrop)),mminj);
       if isequal(mode,4)
         if skyffett(from(lfrom(nrop)))==0,
           plmat(cfrny(1),cfrny(2))=flyttanu;
         end
       else
         plmat(cfrny(1),cfrny(2))=flyttanu;
       end
     end
     %Check if bundle is first in supercell
     [ik,jk]=find(ikan==lto(nrop));
     if length(ik)>0,
       l=find((1:4)~=jk);
       if max(fuel(ikan(ik,l)))==0,
         ssto(2)=1;
         disp('Obs!!! Forsta patron i supercell');
       end;
     end         
     fuel(lfrom(nrop))=0;
     fuel(lto(nrop))=1;
     [ik,jk]=find(ikan==lfrom(nrop));
     if length(ik)>0,
       l=find((1:4)~=jk);
       if max(fuel(ikan(ik,l)))==0,
         ssto(1)=1;
         disp('Varning!!! Supercell tom');
       end;
     end         
     to(lto(nrop))=lto(nrop);
     to(lfrom(nrop))=0;
     from(lto(nrop))=lto(nrop);
     ready(lto(nrop))=1;
     cfrom=knum2cpos(lfrom(nrop),mminj);  
     cto=knum2cpos(lto(nrop),mminj);  
     plmat(cfrom(1),cfrom(2))=tomnyss;
     plmat(cto(1),cto(2))=klarnyss;
  elseif lfrom(nrop)==0,         % Get bundle from pool
     from(lto(nrop))=lto(nrop);
     to(lto(nrop))=lto(nrop);
     fuel(lto(nrop))=1;
     ready(lto(nrop))=1;       
     cto=knum2cpos(lto(nrop),mminj);
     plmat(cto(1),cto(2))=klarnyss;
     %Check if bundle is first in supercell
     [ik,jk]=find(ikan==lto(nrop));
     if length(ik)>0,
       l=find((1:4)~=jk);
       if max(fuel(ikan(ik,l)))==0,
         ssto(2)=1;
         disp('Obs!!! Forsta patron i supercell');
       end;
     end         
  elseif lto(nrop)==0,           % Move bundle to pool
     if to(lfrom(nrop))>0,
       from(to(lfrom(nrop)))=0;
       to(lfrom(nrop))=0;
     end
     fuel(lfrom(nrop))=0;
     ready(lfrom(nrop))=0;
     cfrom=knum2cpos(lfrom(nrop),mminj);  
     plmat(cfrom(1),cfrom(2))=tomnyss;
     if from(lfrom(nrop))>0, 
       cfrny=knum2cpos(from(lfrom(nrop)),mminj);
       if isequal(mode,4)
         if skyffett(from(lfrom(nrop)))==0,
           plmat(cfrny(1),cfrny(2))=flyttanu;
         end
       else
         plmat(cfrny(1),cfrny(2))=flyttanu;
       end
       lf=lfrom(nrop);
       lk=find(kedja(:,1)==lf);
       if length(lk)>0,
          lengd=max(find(kedja(lk,:)>0));
          if isequal(mode,4),
            for il=1:length(lengd),
               iiii=find(iskyff==kedja(lk,il));
               if length(iiii)==0, ill(il)=0;else, ill(il)=iiii;end
            end;
            ill=max(ill);
            if ill>0,
              gonu(kedja(lk,2:ill))=4*ones(lengd-1,1);
            end
          else
            gonu(kedja(lk,2:lengd))=2*ones(lengd-1,1);
          end            
       end
     end         
     [ik,jk]=find(ikan==lfrom(nrop));
     if length(ik)>0,
       l=find((1:4)~=jk);
       if max(fuel(ikan(ik,l)))==0,
         ssto(1)=1;
         disp('Varning!!! Supercell tom');
       end;
     end         
  end;  % lfrom(nrop)>0&lto(nrop)>0
elseif isequal(fram,-1)
  if nrop>0
    if nrop>1,
      if lfrom(nrop-1)>0&lto(nrop-1)>0,
        cfromnyss=knum2cpos(lfrom(nrop-1),mminj);
        ctonyss=knum2cpos(lto(nrop-1),mminj);
        plmat(cfromnyss(1),cfromnyss(2))=tomnyss;   
        plmat(ctonyss(1),ctonyss(2))=klarnyss;   
        gonu(lfrom(nrop-1))=2;
        if isequal(mode,4),
          gonu(lfrom(nrop-1))=4;
        end
      elseif lfrom(nrop-1)==0,
        ctonyss=knum2cpos(lto(nrop-1),mminj);
        plmat(ctonyss(1),ctonyss(2))=klarnyss;   
      elseif lto(nrop-1)==0,
        cfromnyss=knum2cpos(lfrom(nrop-1),mminj);
        plmat(cfromnyss(1),cfromnyss(2))=tomnyss;   
      end;
    end; % nrop>1
    if lfrom(nrop)>0&lto(nrop)>0     
       from(lto(nrop))=lfrom(nrop);
       to(lto(nrop))=0;
       to(lfrom(nrop))=lto(nrop);
       fuel(lfrom(nrop))=1;
       fuel(lto(nrop))=0;
       ready(lto(nrop))=0;
       cfrom=knum2cpos(lfrom(nrop),mminj);
       cto=knum2cpos(lto(nrop),mminj);
       if isequal(mode,4),
         if max(iskyff==lfrom(nrop))==1,
           plmat(cfrom(1),cfrom(2))=ettar;
         else
           plmat(cfrom(1),cfrom(2))=flyttanu;
         end
       else
         plmat(cfrom(1),cfrom(2))=flyttanu;
       end
%      Kolla om forra fran ar samma som denna operations till-pos.
       if nrop>1,
         lastfrom=lfrom(nrop-1);
       else
         lastfrom=9999;
       end
       if lto(nrop)~=lastfrom,
         plmat(cto(1),cto(2))=tom;
       end
       if from(lfrom(nrop))>0,
         cfrny=knum2cpos(from(lfrom(nrop)),mminj);
         if mode==4&max(iskyff==from(lfrom(nrop)))==1,
           plmat(cfrny(1),cfrny(2))=ettar;
         else
           plmat(cfrny(1),cfrny(2))=flytta;
         end
       end
    elseif lfrom(nrop)==0,
      from(lto(nrop))=0;
      to(lto(nrop))=0;
      fuel(lto(nrop))=0;
      ready(lto(nrop))=0;
      cto=knum2cpos(lto(nrop),mminj);
      plmat(cto(1),cto(2))=tom;
    elseif lto(nrop)==0,           % Move bundle to pool
      to(lfrom(nrop))=to0(lfrom(nrop));
      if to(lfrom(nrop))>0,
        from(to(lfrom(nrop)))=from0(to(lfrom(nrop)));
      end
      fuel(lfrom(nrop))=1;
      ready(lfrom(nrop))=ready0(lfrom(nrop));
      lf=lfrom(nrop);
      lk=find(kedja(:,1)==lf);
      if length(lk)>0,
         lengd=max(find(kedja(lk,:)>0));
          if mode==4,
            for il=1:length(lengd),
               iiii=find(iskyff==kedja(lk,il));
               if length(iiii)==0, ill(il)=0;else, ill(il)=iiii;end
            end;
            ill=max(ill);
            if ill>0,
              gonu(kedja(lk,2:ill))=4*ones(lengd-1,1);
            end
          else
           gonu(kedja(lk,2:lengd))=ones(lengd-1,1);
          end
      end
      if ready(lf)==1,
         plm=klar;
      elseif to(lf)==0,
         plm=ut;
      elseif fuel(to(lf))==1,
         plm=flytta;
      elseif fuel(to(lf))==0,
         plm=flyttanu;
      end
      cfrom=knum2cpos(lfrom(nrop),mminj);
      plmat(cfrom(1),cfrom(2))=plm;
      if from(lfrom(nrop))>0,
        if ready(from(lfrom(nrop)))==0,
          cfrny=knum2cpos(from(lfrom(nrop)),mminj);
          plmat(cfrny(1),cfrny(2))=flytta;
        end
      end
    end;  % lfrom(nrop)>0&lto(nrop)>0
    nrop=nrop-1;
  end; % nrop>0
end; %fram=1
