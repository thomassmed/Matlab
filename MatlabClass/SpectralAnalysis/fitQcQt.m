function fel=fitQcQt(p)
gamma=p(1);
T=p(2);
%K=p(3);
K=1;
lam=0.0127+3.3552i;
qc=0.0585 - 0.1038i;
qt=1;
Hs=K*(1-gamma)/(1+lam*T);
y=Hs*qt+gamma*qt;
fel=norm(y-qc);