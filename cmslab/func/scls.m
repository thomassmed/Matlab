function scls
% scls
% sets the linestyles for the lines in
% the current axis according to
% their colors
colrs=[1 1 0;1 0 1;0 1 1;1 0 0;0 1 0;0 0 1;1 1 1;0 0 0];
lnst=['- ';'--';': ';'-.';'- ';'--';': ';'-.'];
l=gcls;
for n=1:length(l),
  col=get(l(n),'Color'); 
  for m=1:8,
    if all(colrs(m,:)==col)
      set(l(n),'LineStyle',lnst(m,:))
      break
    end
  end
end 
