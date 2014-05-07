%@(#)   crtyp.m 1.3	 06/03/21     08:01:41
%
%function t=crtyp(typfil,distfil)
function t=crtyp(typfil,distfil)
[a,b,c,d]=textread(typfil,'%s%s%s%s');
[crid,mminj]=readdist7(distfil,'crid');
for i=1:size(crid,1)
  for j=1:size(b,1)
    if strcmp(remblank(crid(i,:)),cell2mat(b(j)));
      switch cell2mat(d(j))
        case '70'
          t(i,1:4)='CR70';
          break;
        case '82'
          t(i,1:4)='CR82';
          break;
        case '82M'
          t(i,1:4)='C82M';
          break;
        case '82M-1'
          t(i,1:4)='82M1';
          break;
        case '82M-1U'
          t(i,1:4)='82MU';
          break;
        case '85M+'
          t(i,1:4)='C85M';
          break;
        case '99'
          t(i,1:4)='CR99';
          break;
        otherwise
          if strcmp(cell2mat(c(j)),'Marathon')
            t(i,1:4)='MARA';
          else
            t(i,1:4)='AAST';
          end
          break;
      end
    end
  end
  if j==size(b,1)
    fprintf('No such control rod %s in typfil %s\n',remblank(crid(i,:)),typfil)
  end
end
lm=length(mminj);
tx=32*ones(lm/2,5*lm/2);
for i=1:length(t)
  crpos=crnum2crpos(i,mminj);
  tx(crpos(1),crpos(2)*5-4:crpos(2)*5-1)=t(i,:);
end
setstr(tx)
