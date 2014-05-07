function spy_thnod(Ahyd,nodnr,opt)
%spy_thnod
%
%spy_thnod(Ahyd,nodnr,opt)
%Shows a T/H-node in Ahyd where nodnr is the number of
%the node.
%opt = 'neig' gives the neighbour to the node

%@(#)   spy_thnod.m 1.4   97/11/21     15:30:01

nv = get_varsize;
k = ind_tnk(1,nv);
if nargin==2,
  k = k(nodnr);
  Atmp = [Ahyd(1,[k:(k+nv-1),1]);[Ahyd(k:(k+nv-1),k:(k+nv-1)),Ahyd(k:(k+nv-1),1)]];
  titstr=['Termohydraulisk nod nr:' num2str(nodnr)];
else
  neig = get_thneig(nodnr);if isempty(neig),return,end
  k1 = k(neig);
  k2 = k(nodnr);
  Atmp = [Ahyd(1,[k:(k+nv),1]);[Ahyd(k2:(k2+nv),k1:(k1+nv)) Ahyd(k2:(k2+nv),1)]];
  titstr=['Termohydraulisk granne till nod nr:' num2str(nodnr)];
end 
spy(Atmp)
set(gca,'Xtick',0:(nv+2)),set(gca,'Ytick',0:(nv))
xstr=['  '
      'al'
      'E '
      '  '
      'Wl'
      'ga'
      'qw'
      'tl'
      'tw'
      'Wg'
      'wg'
      'S '
      'jm'
      'ph'
      'P '];
set(gca,'XtickLabels',xstr)
ystr=['      '
      'dP/dt '
      'dal/dt'
      'dE/dt '
      '  0   '
      '  0   '
      '  0   '
      '  0   '
      '  0   '
      '  0   '
      '  0   '
      '  0   '
      '  0   '
      '  0   '
      '  0   '
      '      '];
set(gca,'YtickLabels',ystr)
title(titstr)
grid,set(gca,'GridLineStyle',':')
[r,k]=find(Atmp);
for n=1:nnz(Atmp),
  text(k(n),r(n),num2str(Atmp(r(n),k(n))),'FontSize',8,'Color',[0 0 1],...
    'HorizontalAlignment','center','VerticalAlignment','top')
end 
