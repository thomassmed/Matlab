%@(#)   manadf3.m 1.1	 06/01/02     13:56:12
%
%function manadf3(block,manad)
%
% ex manadf3('f1','1997-10');
function manadf3(block,manad)
figure;
manad1(block,manad);
figure;
manad3f3(block,manad);
%figure;
%manad4(block,manad);
skriv=input('Till vilken skrivare? ','s');
if ~isempty(skriv),
  evstr=['!lpr -P' skriv ' tmp1.ps'];
  eval(evstr);
  evstr=['!lpr -P' skriv ' tmp2.ps'];
  eval(evstr);
end
!rm tmp1.ps tmp2.ps 
