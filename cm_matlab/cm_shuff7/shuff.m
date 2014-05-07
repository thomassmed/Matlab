%@(#)   shuff.m 1.1	 05/07/13     10:29:41
%
%
%function [buidnt,burnup,vhist,sshist]=shuffle(curfile,bocfile,OK,maxop,prifil,curpos)
function [buidnt,burnup,vhist,sshist]=shuffle(curfile,bocfile,OK,maxop,prifil,curpos)
if isstr(prifil),
  fid=fopen(prifil,'w');
  clo=1;
elseif prifil~=0
  fid=prifil;
  clo=0;
else
  disp('error in function shuffle, argument fil must not be = 0');
end;
[buid,mminj,konrod,bb,hy,mz,ks,buntyp]=readdist7(curfile,'asyid');
crid=readdist7(curfile,'crid');
buidboc=readdist7(bocfile,'asyid');
burnup=readdist7(curfile,'burnup');		%ändra
%kinf=kinf2mlab(curfile);
vhist=readdist7(curfile,'vhist');		%ändra
sshist=readdist7(curfile,'sshist');		%ändra
buntyp=readdist7(curfile,'asytyp');		
kkan=mz(14);
ikan=fastcatch('dummy',crid);
if length(ikan)>0,
  OK(ikan)=zeros(length(ikan),1);
end
[from,to,ready,fuel]=initvec(buid,buidboc,OK);
idum=find(fuel==0);idum=idum(1);
burndum=burnup(:,idum);			%ändra
vhidum=vhist(:,idum);			%ändra
sshidum=sshist(:,idum);			%ändra
bundum=buntyp(idum,:);
%kinfdum=kinf(idum);
IOK=find(OK==1);
conv=0;
for i1=1:maxop,
  [ifrom,ito]=findmove(curpos,OK,from,to,fuel,mminj);
  if max(ifrom)==0, conv=-1;break;end
%  printfil(fid,ifrom,ito,buid,mminj);
  curpos=knum2cpos(ifrom,mminj);
  fuel(ifrom)=0;
  fuel(ito)=1;
  ready(ito)=1;
  burnup(:,ito)=burnup(:,ifrom);	%ändra
  sshist(:,ito)=sshist(:,ifrom);	%ändra
  vhist(:,ito)=vhist(:,ifrom);		%ändra
  buid(ito,:)=buid(ifrom,:);
  if all(ready(iok)==1), conv=1;break;end
end  
if conv==-1,
  disp('Shuffling no longer possible in defined area');
elseif conv==0,
  disp('Maximum number of operations given by  user reached');
elseif conv==1,
  disp('All shuffling in defined area completed');  
end
ierr=0;
ierr=writedist7(curfile,'asyid',buidnt);
if ierr>0, disp(['error when writing asyid to ',curfile]);end		%ändra och kolla
ierr=writedist7(curfile,'asytyp',buntyp);
if ierr>0, disp(['error when writing asytyp to ',curfile]);end
ierr=writedist7(curfile,'BURNUP',burnup);
if ierr>0, disp(['error when writing burnup to ',curfile]);end
ierr=writedist7(curfile,'SSHIST',sshist);
if ierr>0, disp(['error when writing sshist to ',curfile]);end
ierr=writedist7(curfile,'VHIST',vhist);
if ierr>0, disp(['error when writing vhist to ',curfile]);end
end
