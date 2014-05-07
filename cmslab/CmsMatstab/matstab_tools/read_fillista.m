function [casenr,f_polca_list,date,qrel,hc,drmeas,fdmeas,stdmeas,modord,racsfil]=read_fillista(fil_lista)
fid=fopen(fil_lista);
filtext=fread(fid);
cr=find(filtext==10);cr=cr(:)';
cr=[0 cr];
filtext=filtext(:)';
itab=find(filtext==9);
if ~isempty(itab),
  filtext(itab)=ones(size(itab))*32;
end
filtext=char(filtext);
f_polca_list=[];
n=0;
Racsdir=0;
for i=1:length(cr)-1,
  rad=filtext(cr(i)+1:cr(i+1)-1);
  rad=remleadblank(rad);
  rad=remtab(rad);
  if ~isempty(rad),
    if ~strcmp(rad(1),'%'),
     if strcmpi(rad(1:4),'RACS'),
      Racsdir=1;
      [dum,rad]=get_arg(rad,' ','%s');
      racsdir=get_arg(rad); 
     else
       n=n+1;
      [casenr(n),rad]=get_arg(rad,' ','%i');
      [nyfil,rad]=get_arg(rad,' ','%s');
      [datum,rad]=get_arg(rad,' ','%s');
      [qrel(n),rad]=get_arg(rad,' ','%f');
      [hc(n),rad]=get_arg(rad,' ','%f');
      [drmeas(n),rad]=get_arg(rad,' ','%f');
      [fdmeas(n),rad]=get_arg(rad,' ','%f');
      [stdmeas(n),rad]=get_arg(rad,' ','%f');
      [modord(n),rad]=get_arg(rad,' ','%f');
      if ~isempty(rad),
         [nyracs,rad]=get_arg(rad,' ','%s');
      else
         nyracs=' ';
      end              
      if n==1,
        f_polca_list=nyfil;
        date=datum;
        racsfil=nyracs;
      else
        f_polca_list=str2mat(f_polca_list,nyfil);
        date=str2mat(date,datum);
        racsfil=str2mat(racsfil,nyracs);
      end 
     end
    end
  end
end
if Racsdir,
  racsdir=remblank(racsdir);
  lr=length(racsdir);
  if ~strcmp(racsdir(lr:lr),'/'), racsdir=[racsdir,'/'];end
  rfil=racsfil;racsfil=[racsdir,remblank(rfil(1,:))];
  for i=2:size(rfil,1),
     racsfil=str2mat(racsfil,[racsdir,remblank(rfil(i,:))]);
  end
end     
    
