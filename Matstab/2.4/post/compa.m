function [maxx,maxr,maxk]=compa(A1,A2,s1,s2)

% compares two spare matrixes A1 ans A2
% the size of the dots in the spy figure are a measure of the relatif error
% it the error is > 50% the dot becomes red
% if the value in exactly one matrix is 0 the dot becomes blue
%
% s1 ~= 0, display entries
% s2 ~= 0,  gives nodelabels
% compa(A1,A2,s);

%@(#)   compa.m 1.1   96/08/21     15:25:43

if nargin==2,s1=0;s2=0;end
if nargin==3,s2=0;end

hold off
spy(A1-A2,0.01)
hold

[inn,jnn] = find(A1);

X=A1;
X(inn,jnn)=1./X(inn,jnn);
X=(A2.*X);

[r k x]=find(X);
[maxxd,maxj]=max(abs(x-1));
maxx=x(maxj);[maxr maxk]=find(X==maxx);

if maxx~=1
  str = sprintf('%1.1d',maxx);
  text(maxk,maxr,str,'FontSize',8,'Color',[1 1 0],...
  'HorizontalAlignment','center','VerticalAlignment','top')
end

j=find(abs(x-1)<0.00001);
r(j)=[];k(j)=[];x(j)=[];
X=sparse(r,k,x);
x=abs(abs(x)-1)+1;
C=sparse(r,k,x);


for i=1.0001:0.1:1.51
  [r k x]=find(C>i);
  spy(sparse(r,k,x),(i-.9)*50)
end

[r k x]=find(abs(C)>1.5);
spy(sparse(r,k,x),'r',30)

xo=xor(A1,A2);
if nnz(xo)>0
  spy(xo,'b',25)
end

xlabel('blue: missing, red: diff > 50%')
title(['nnz: ' num2str(nnz(A1-A2)) ' MaxDiff: ' num2str(maxxd*100) '%']);
zoom on

if s1
  [r,k]=find(X);
  for n=1:length(k),
    str = sprintf('%1.1d',X(r(n),k(n)));
    text(k(n),r(n),str,'FontSize',8,'Color',[1 1 0],...
    'HorizontalAlignment','center','VerticalAlignment','top')
  end 
end

if s2,
  nvt = get_varsize;
  nvn = get_varsize('neut');
  set(gca,'Xtick',0:(nvt+nvn+2)),set(gca,'Ytick',0:(nvt+nvn+2))
  xstr=['    '
      ' mg '
      ' E  '
      ' al '
      ' Wl '
      ' ga '
      ' qw '
      ' tl '
      ' tw '
      ' Wg '
      ' wg '
      ' S  '
      ' jm '
      ' ph '
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
      'dmg/dt '
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
end
