function [nlp,lpnr,axpos,kpunkt,apnr,r_kpunkt]=racsb2lprm(b,f3,sampl)
% [nlp,lpnr,axpos,kpunkt,apnr,r_kpunkt]=racsb2lprm(b,f3,sampl)
% if f3==0, så antages det att f1/f2 är aktuellt block  
% sampl nödvändig för f3 mätningar
if nargin<2,
  f3=0;
end
if min(size(b))>1,
   btemp=abs(b);
   b=[];
   for i=1:size(btemp,1),
      b=[b btemp(i,:) 10];
   end
   b=setstr(b);
end
if f3==0,                   %Forsmark 1/2
  nyrad=findstr(b,10);
  nnlp=findstr(b,'531K8');
  nnlp=[nnlp,findstr(b,'531K9')];
  for i=1:length(nnlp),
      knr=str2num(b(nnlp(i)+4:nnlp(i)+6));
      nrtest=ceil((knr-800)/4);
      if nrtest<37,
        lpnr(i)=ceil((knr-800)/4);
        axpos(i)=knr-ceil(knr/4)*4+4;
        nlp(i)=max(find(nnlp(i)>nyrad))-1;
        kpunkt(i,:)=b(nnlp(i):nnlp(i)+6);
      end
  end
  kk=find(lpnr);
  lpnr=lpnr(kk);
  axpos=axpos(kk);
  nlp=nlp(kk);
  kpunkt=kpunkt(kk,:);
  nnap=findstr(b,'531K081');
  apnr=max(find(nnap>nyrad))-1;
  r_kpunkt=kpunkt;
else                  %Forsmark 3
  Asub=[2 11 16 21 32 35 4 13 23];   
  Bsub=[9 12 14 22 26 34 1 18 30];   
  Csub=[5 7 17 19 29 33 15 31 36];   
  Dsub=[3 6  20 24 25 28 8 10 27 37];
  if exist('sampl','var') 
    if ~isempty(sampl)
      [mdkpunkt,real_kpunkt]=read_mdtabell(sampl(1,1),sampl(1,2),sampl(1,3));
    end
  else
    warning('Saknar sampl')
    %[mdkpunkt,real_kpunkt]=read_mdtabell('B'); % om inte sampl finns är det en gammal f3 mätning, dvs före 93
  end
    
  k=0;
  nyrad=findstr(b,10);
  nyrad=[0;nyrad(:)];
  for i=1:length(nyrad)-1,
    ind=nyrad(i)+1;
    if length(findstr(b(ind:ind+20),'531KA7'))>0,  
       ista=findstr(b(ind:ind+20),'531KA7')-1;
       j=get_realkpunkt(b(ind+ista:ind+ista+7),mdkpunkt,real_kpunkt);
       if ~isempty(j)
         siffra=str2num(real_kpunkt(j,6:8))-700;
       else
         siffra=str2num(b(ind+ista+5:ind+ista+7))-700;
       end
       k=k+1;
       Alpnr=floor((siffra-1)/4)+1;              
       axpos(k)=siffra-4*(Alpnr-1);
       nlp(k)=i;
       kpunkt(k,:)=b(ind+ista:ind+ista+7);
       lpnr(k)=Asub(Alpnr);
       if ~isempty(j)
         r_kpunkt(k,:)=real_kpunkt(j,:);
       else
         r_kpunkt(k,:)=kpunkt(k,:);
       end	 
    elseif length(findstr(b(ind:ind+20),'531KB7'))>0,  
       ista=findstr(b(ind:ind+20),'531KB7')-1;
       j=get_realkpunkt(b(ind+ista:ind+ista+7),mdkpunkt,real_kpunkt);
       if ~isempty(j)
         siffra=str2num(real_kpunkt(j,6:8))-700;
       else
         siffra=str2num(b(ind+ista+5:ind+ista+7))-700;
       end
       k=k+1;
       Blpnr=floor((siffra-1)/4)+1;              
       axpos(k)=siffra-4*(Blpnr-1);
       nlp(k)=i;
       kpunkt(k,:)=b(ind+ista:ind+ista+7);
       lpnr(k)=Bsub(Blpnr);
       if ~isempty(j)
         r_kpunkt(k,:)=real_kpunkt(j,:);
       else
         r_kpunkt(k,:)=kpunkt(k,:);
       end
    elseif length(findstr(b(ind:ind+20),'531KC7'))>0,  
       ista=findstr(b(ind:ind+20),'531KC7')-1;
       j=get_realkpunkt(b(ind+ista:ind+ista+7),mdkpunkt,real_kpunkt);
       if ~isempty(j)
         siffra=str2num(real_kpunkt(j,6:8))-700;
       else
         siffra=str2num(b(ind+ista+5:ind+ista+7))-700;
       end
       k=k+1;
       Clpnr=floor((siffra-1)/4)+1;              
       axpos(k)=siffra-4*(Clpnr-1);
       nlp(k)=i;
       kpunkt(k,:)=b(ind+ista:ind+ista+7);
       lpnr(k)=Csub(Clpnr);
       if ~isempty(j)
         r_kpunkt(k,:)=real_kpunkt(j,:);
       else
         r_kpunkt(k,:)=kpunkt(k,:);
       end
    elseif length(findstr(b(ind:ind+20),'531KD7'))>0,  
       ista=findstr(b(ind:ind+20),'531KD7')-1;
       j=get_realkpunkt(b(ind+ista:ind+ista+7),mdkpunkt,real_kpunkt);
       if ~isempty(j)
         siffra=str2num(real_kpunkt(j,6:8))-700;
       else
         siffra=str2num(b(ind+ista+5:ind+ista+7))-700;
       end
       k=k+1;
       Dlpnr=floor((siffra-1)/4)+1;              
       axpos(k)=siffra-4*(Dlpnr-1);
       nlp(k)=i;
       kpunkt(k,:)=b(ind+ista:ind+ista+7);
       lpnr(k)=Dsub(Dlpnr);
       if ~isempty(j)
         r_kpunkt(k,:)=real_kpunkt(j,:);
       else
         r_kpunkt(k,:)=kpunkt(k,:);
       end
    elseif length(findstr(b(ind:ind+20),'531KA077'))>0,  
       apnr(1)=i;
    elseif length(findstr(b(ind:ind+20),'531KB077'))>0,  
       apnr(2)=i;
    elseif length(findstr(b(ind:ind+20),'531KC077'))>0,  
       apnr(3)=i;
    elseif length(findstr(b(ind:ind+20),'531KD077'))>0,  
       apnr(4)=i;
    end 
  end
end
