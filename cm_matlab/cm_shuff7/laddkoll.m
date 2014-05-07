%@(#)   laddkoll.m 1.1	 05/07/13     10:29:34
%
%@(#)   laddkoll.m 1.1	 05/07/13     10:29:34
%
% function laddkoll(fil,boc) jämför en infil till Safeguard
% (ex. fil='do87-97.txt') eller en utfil från Safeguard 
% (ex. fil='utfil87-97') med en önskad boc-fil (ex. boc='boc17.dat')
% och varnar för patroner och styrstavar som ej har samma identitet
% och position i fil och boc.
% 
function laddkoll(fil,boc)
% Roger Johansson, FTB, 1997-08-25
% Modifierad:
%   Namnbyte från jmfbocsafe till laddkoll,  Sme 980220
%
%
infi=testa_om_infil(fil);
[n m]=size(fil);
if infi==1, 
 fprintf('File %s is an input file to Safeguard \n',fil)
 [tpos,idnt,lline]=sfg2mlab(fil);
else
  fprintf('File %s is an output file from Safeguard \n',fil)
  fid=fopen(fil);
  filtext=fread(fid);
  filtext=setstr(filtext)';
  fclose(fid);
  cr=find(filtext==10);
  cr=[0 cr];
  [n m]=size(cr);
  for i=1:m-2
    rad=filtext(cr(i)+1:cr(i+1)-1);
    [m1 n1]=size(rad);
    nr=0;
    if ( m1>0 & n1>1 )
      nr=sscanf(rad(1,2:5),'%i');
    end
    if (nr>0)
      if (strcmp(rad(1:1),' ') & strcmp(rad(8:8),' ')  & ...
          strcmp(rad(22:22),' ')  & strcmp(rad(52:52),' ') & ...
          strcmp(rad(58:58),' ')  & (strcmp(rad(6:6),' ')| ...
	  strcmp(rad(6:6),'L')) )   
        buidnt(nr,:)=rad(9:14);
        cridnt(nr,:)=rad(23:28);
        strpos(nr,:)=rad(53:57);
        if ( strcmp(buidnt(nr,:),'      ') & ~strcmp(cridnt(nr,:),'      ') )
          idnt(nr,:)=cridnt(nr,:);
          lline(nr,1)='S';
          tpos(nr,:)=axis2crpos(strpos(nr,:));
        elseif ( strcmp(cridnt(nr,:),'      ') & ~strcmp(buidnt(nr,:),'      ') )
          idnt(nr,:)=buidnt(nr,:);
          lline(nr,1)='P';
          tpos(nr,:)=axis2cpos(strpos(nr,:));
        else
          fprintf('Something is wrong with your Safeguard output file\n')
          return
        end
      else
        fprintf('Something is wrong with your Safeguard output file\n')
        fprintf('Has the format changed?\n')
        return
      end
    end
  end
end        
rapportfil1=['rapport1-',fil];
rapportfil2=['rapport2-',fil];
fid1=fopen(rapportfil1,'w');
fid2=fopen(rapportfil2,'w');
[buidnt,mminj]=readdist7(boc,'asyid');
cridnt=readdist7(boc,'crid');
if min(size(cridnt))==1, cridnt=32*ones(size(buidnt));cridnt=setstr(cridnt);end
counter=[0 0];
[n,m]=size(tpos);
for i=1:n
  if ( tpos(i,:)~=0 )
    if ( lline(i,1) =='P' )
      knum=cpos2knum(tpos(i,:),mminj);
      if ( ~strcmp(remblank(idnt(i,:)),remblank(buidnt(knum,:))) )
        counter(1,1)=counter(1,1)+1;
        fprintf(fid1,'Warning, You are putting fuel bundle %s in the position of %s \n',...
                idnt(i,:),buidnt(knum,:));
      end
    elseif ( lline(i,1)=='S' )
      knum=crpos2crnum(tpos(i,:),mminj);
      if ( ~strcmp(remblank(idnt(i,:)),remblank(cridnt(knum,:))) )
        counter(1,2)=counter(1,2)+1;
        fprintf(fid2,'Warning, You are putting control rod %s in the position of %s \n',...
                idnt(i,:),cridnt(knum,:));   
      end
    end
  end
end
if ( counter(1,1)>0 ) 
  fprintf('You have %i warnings in file %s \n',counter(1,1),rapportfil1)
end
if ( counter(1,2)>0 ) 
  fprintf('You have %i warnings in file %s \n',counter(1,2),rapportfil2)
end
if ( counter(1,1)==0 & counter(1,2)==0 ) 
  fprintf('Checkinfil has no warnings to report \n')
end     
fclose(fid1);
fclose(fid2);

