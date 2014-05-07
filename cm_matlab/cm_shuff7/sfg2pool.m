%@(#)   sfg2pool.m 1.2	 10/09/09     10:42:27
%
%function sfg2pool(sfgfil,poolfil);
function sfg2pool(sfgfil,poolfil);
tx=readtextfile(sfgfil);
sbr=strmatch('SAFE',tx(:,2:5));
j=1;
for i=1:length(sbr)-3
  for row=sbr(i)+4:4:sbr(i+1)
    chk=tx(row,2:6);
    if strcmp(chk,remblank(chk))
      pos(j,1:5)=chk;
      t=remblank(tx(row+1,2:7));
      lb=length(t);
      buid(j,1:6)=sprintf('%s%s',setstr(32*ones(1,6-lb)),t);
      pbox(j,1:6)=tx(row+2,2:7);
      j=j+1;
      for k=1:9
        chk=tx(row,2+8*k:6+8*k);
        if strcmp(chk,remblank(chk))
          pos(j,1:5)=chk;
          t=remblank(tx(row+1,2+8*k:7+8*k));
          lb=length(t);
          buid(j,1:6)=sprintf('%s%s',setstr(32*ones(1,6-lb)),t);
          pbox(j,1:6)=tx(row+2,2+8*k:7+8*k);
          j=j+1;
        end
      end
    end
  end
end
evstr=['save ' poolfil ' pos buid pbox'];
eval(evstr);
