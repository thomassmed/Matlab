%@(#)   manad.m 1.5	 06/02/02     08:09:23
%
%function manad(block,manad)
%
% ex manad('f1','1997-10');
function manad(block,manad)
figure;
manad1(block,manad);
%figure;
%manad2(block,manad);
figure;
manad3(block,manad);
%figure;
%manad4(block,manad);
skriv=input('Till vilken skrivare? ','s');
if ~isempty(skriv),
  evstr=['!lpr -P' skriv ' tmp1.ps'];
  eval(evstr);
  evstr=['!lpr -P' skriv ' tmp2.ps'];
  eval(evstr);
  evstr=['!lpr -P' skriv ' tmp3.ps'];
  eval(evstr);
 %evstr=['!lpr -P' skriv ' tmp4.ps'];
 %eval(evstr);
end
!rm tmp1.ps tmp2.ps tmp3.ps 
