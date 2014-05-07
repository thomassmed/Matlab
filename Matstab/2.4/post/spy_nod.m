function Aout=spy_nod(Atot,nodnr,s)
%spy_nod
%
%Aout=spy_nod(Atot,nodnr,s)

%nodnr:  the number of the node
% s= 0:  the numbers are not displayed
% s=-1:  no plot
%Aout :  optional

%@(#)   spy_nod.m 1.2   96/08/21     13:57:35

if nargin==2,s=1;end
nvt = get_varsize;
nvn = get_varsize('neut');
[r,k]=get_neutnodes;
r = r(nodnr);
k = k(nodnr);

Atmp = [Atot(r:(r+nvt-1),r:(r+nvt-1)),Atot(r:(r+nvt-1),k:(k+nvn-1));...
        Atot(k:(k+nvn-1),r:(r+nvt-1)) Atot(k:(k+nvn-1),k:(k+nvn-1))];
if nargout==1,Aout=Atmp;end
if s==-1,return,end

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
grid,set(gca,'GridLineStyle',':')

if s
  if s<6,s=10;end
  [r,k]=find(Atmp);
  for n=1:nnz(Atmp),
    str = sprintf('%1.1d',Atmp(r(n),k(n)));
    text(k(n),r(n),str,'FontSize',s,'Color',[0 0 1],...
      'HorizontalAlignment','center','VerticalAlignment','top')
  end 
end

zoom on




