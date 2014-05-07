%%
AA=[ett q];
p11=AA\kef
AA3=[ett w w.^2 w.^3];
p23=AA3\(kef-AA*p11)
ptot3=[p11(1)+p23(1);p11(2);p23(2:4)]
Atot3=[ett q w w.^2 w.^3];
keftot3=Atot3*ptot3;
%%
[QQ,WW]=meshgrid(0.4:.01:1.1,0.4:.01:1.1);
ATOT3=[ones(size(QQ(:))) QQ(:) WW(:) WW(:).^2 WW(:).^3];
KEFFTOT3=ATOT3*ptot3;
figure
[iq,jq]=size(QQ);
KEFFTOT3=reshape(KEFFTOT3,iq,jq);
surfc(QQ,WW,KEFFTOT3)
xlabel('Power')
ylabel('flow')
zlabel('K-effective')
title('3rd order in flow');
%%
AA2=[ett w w.^2];
p22=AA2\(kef-AA*p11)
ptot2=[p11(1)+p22(1);p11(2);p22(2:3)]
Atot2=[ett q w w.^2];
keftot2=Atot2*ptot2;
%%
ATOT2=[ones(size(QQ(:))) QQ(:) WW(:) WW(:).^2];
KEFFTOT2=ATOT2*ptot2;
figure
KEFFTOT2=reshape(KEFFTOT2,iq,jq);
surf(QQ,WW,KEFFTOT2)
xlabel('Power')
ylabel('flow')
zlabel('K-effective')
title('2nd order in flow');