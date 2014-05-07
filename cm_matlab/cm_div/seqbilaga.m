%@(#)   seqbilaga.m 1.2	 99/11/29     08:08:35
%
function seqbilaga(sumfil)

%seqbilaga('sumfil')

s=sum2mlab7(sumfil);


subplot(2,1,1);

plot(s(82,:),s(25,:))
axis([min(s(82,:)) max(s(82,:)) min(s(25,:)) 1]);
ylabel('FLPD marginal (%)')
xlabel('EFPH')
a=title('TERMISKA MARGINALER');
set(a,'fontsize',[14]);

subplot(2,1,2);
plot(s(82,:),s(26,:))
axis([min(s(82,:)) max(s(82,:)) min(s(26,:)) 1]);

ylabel('CPR marginal (%)')
xlabel('EFPH')

set(gcf,'paperposition',[1 3.8 20 22.5]);
print -dps graf
skriv=input('Till vilken skrivare? ','s');
   if ~isempty(skriv),
     evstr=['!lpr -P' skriv ' graf.ps'];
     eval(evstr);
   end
!rm graf.ps
