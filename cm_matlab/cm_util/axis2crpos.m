%@(#)   axis2crpos.m 1.1	 05/07/13     10:29:27
%
%
%function crpos=axis2crpos(axstr)
%
%The format of axstr can be either '45UO', '45U',  or 'U45'
function crpos=axis2crpos(axstr)
if abs(axstr(1,1))>60,
  axstr=[axstr(:,2:3),axstr(:,1)];
end
jj=[100 1]';
ivecstr=['XVUTSRPOMLKIHGF']';
ivec=abs(ivecstr);
axi=abs(axstr(3));
crpi=find(ivec==axi);
jvecstr=['15'
           '20'
           '25'
           '30'
           '35'
           '40'
           '45'
           '50'
           '55'
           '60'
           '65'
           '70'
           '75'
           '80'
           '85'];
jvec=abs(jvecstr)*jj;
axj=abs(axstr(1:2))*jj;
crpj=find(jvec==axj);
if (length(crpi)>0)&(length(crpj))>0,
  crpos=[crpi crpj];
else
  crpos=[0 0];
end
