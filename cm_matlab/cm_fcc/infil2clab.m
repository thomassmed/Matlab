%@(#)   infil2clab.m 1.2	 94/08/12     12:15:14
%
%function infil2clab(infil,matfil,batchfil)
%Generates an inputfile 
%
%
%
%
function infil2clab(infil,matfil,batchfil)
reakdir=findreakdir;
if nargin<2,
  matfil=[reakdir,'div/bunhist/utfil.mat'];
end
load(matfil)
if nargin<3, batchfil=[reakdir,'div/bunhist/batch-data.txt'];end
[dum,buidclab]=sfg2mlab(infil);
ib=size(buidclab,1);
[cycstart,cycslut]=findcyctid(CYCNAM,MASFIL(5:6));
inut='';
for i=1:ib,
  ic=bucatch(buidclab(i,:),BUIDNT);
  burnclab(i)=BURNUP(ic,ITOT(ic));
  icyc=ICYC(ic,1:ITOT(ic));
  inut=[inut;[cycstart(min(icyc),:),'  ',cycslut(max(icyc),:)]];
  dicyc=diff(icyc);
  if max(dicyc)>1,
    ANM='Pool: ';  
    for j=min(icyc)+1:max(icyc)-1, 
      if length(find(icyc==j))==0,
        ANM=[ANM,remblank(CYCNAM(j,:)),','];
      end
    end
    ANM=ANM(1:length(ANM)-1);
  else
    ANM='       -';
  end % max(dicyc)>1
  anm=str2mat(anm,ANM);
  iclab(i)=ic;
end
anm(1,:)='';
bunclab=BUNTYP(iclab,:);
[enr,typ,stav]=sortbatchclab(bunclab,batchfil);
pri2wingz(infil,buidclab,typ,bunclab,stav,enr,inut,burnclab,anm,MASFIL(5:6));
