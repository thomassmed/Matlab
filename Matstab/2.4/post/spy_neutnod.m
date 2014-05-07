function spy_neutnod(Atot,nodnr)
%spy_neutnod
%
%spy on a neutonic node in Atot 
%nodnr is the node number

%@(#)   spy_neutnod.m 1.2   96/08/21     13:57:50

k = 12*(nodnr-1)+1+get_hydsize;
Atmp = Atot(k:(k+11),k:(k+11));
titstr=['Neutron-nod nr:' num2str(nodnr)];
spy(Atmp)
set(gca,'Xtick',0:13),set(gca,'Ytick',0:13)
xstr=['    '
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
grid,set(gca,'GridLineStyle',':')
[r,k]=find(Atmp);
for n=1:nnz(Atmp),
  text(k(n),r(n),num2str(Atmp(r(n),k(n))),'FontSize',12,'Color',[0 0 1],...
    'HorizontalAlignment','center','VerticalAlignment','top')
end 
zoom on
