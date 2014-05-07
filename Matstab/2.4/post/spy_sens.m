function Asens=spy_sens(Atot,e,v,nodnr,ifas)
%spy_sens
%
%Asens=spy_sens(Atot,e,v,nodnr,ifas)
%Sensitivity study in a node

%@(#)   spy_sens.m 1.2   96/08/21     13:57:51

nvt = get_varsize;
nvn = get_varsize('neut');
[r,k]=get_neutnodes;
r = r(nodnr);
k = k(nodnr);
Atmp = [Atot(r:(r+nvt-1),r:(r+nvt-1)),Atot(r:(r+nvt-1),k:(k+nvn-1));...
        Atot(k:(k+nvn-1),r:(r+nvt-1)) Atot(k:(k+nvn-1),k:(k+nvn-1))];
e=[e(r:(r+nvt-1));e(k:(k+nvn-1))];
v=[v(r:(r+nvt-1));v(k:(k+nvn-1))];
titstr=['Neutron-nod nr:' num2str(nodnr)];
spy(Atmp)
set(gca,'Xtick',0:(nvt+nvn+2)),set(gca,'Ytick',0:(nvt+nvn+2))
xstr=['    '
      'al  '
      'E   '
      '    '
      'Wl  '
      'ga  '
      'qw  '
      'tl  '
      'tw  '
      'Wg  '
      'wg  '
      'S   '
      'jm  '
      'ph  '
      'Fa1 '
      'Fa2 '
      'Ksi '
      'fn1 '
      'D0.5'
      'q_3f'
      'Tf1 '
      'Tf2 '
      'Tf3 '
      'Tf4 '
      'Tc1 '
      'Tc2 '
      '    '];
set(gca,'XtickLabels',xstr)
ystr=['       '
      'dal/dt '
      'dE/dt  '
      '  0    '
      '  0    '
      '  0    '
      '  0    '
      '  0    '
      '  0    '
      '  0    '
      '  0    '
      '  0    '
      '  0    '
      '  0    '
      'dFa1/dt'
      'dFa2/dt'
      'dKsi/dt'
      '  0    '
      '  0    '
      '  0    '
      'dTf1/dt'
      'dTf2/dt'
      'dTf3/dt'
      'dTf4/dt'
      'dTc1/dt'
      'dTc2/dt'
      '       '];
set(gca,'YtickLabels',ystr)
title(titstr)
grid
[r,k,xa]=find(Atmp);
for n=1:nnz(Atmp),
  Atmp(r(n),k(n))=v(r(n))*e(k(n))*xa(n);
  if ifas==0,
    str = sprintf('%i',round(v(r(n))*e(k(n))*xa(n)*1e3));
  else
    str = sprintf('%i',round(180/pi*angle(v(r(n))*e(k(n)))));
  end
  text(k(n),r(n),str,'FontSize',8,'Color',[1 1 0],...
    'HorizontalAlignment','center','VerticalAlignment','top')
end 
if nargout==1,Asens=Atmp;end
