%@(#)   crpos2axis.m 1.1	 05/07/13     10:29:29
%
%
%function axstr=crpos2axis(crpos,safeg)
%gives name on supercell with cr-pos as input
%if safeg=1, the name is given as 50UO etc,
%if safeg=0, the name is given as U50
%Default safeg=1
function axstr=crpos2axis(crpos,safeg)
if nargin<2, safeg=1;end
ivecstr=['XVUTSRPOMLKIHGF']';
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
if safeg==0,
  axstr=[ivecstr(crpos(1)),jvecstr(crpos(2),:)];
else
  axstr=[jvecstr(crpos(2),:),ivecstr(crpos(1)),'O'];
end
