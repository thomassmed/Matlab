function [P,dpcore,dpin,dput]=get_P(ploss,P0)

global geom
if nargin<2, P0=70.0e5; end
KAN=geom.ncc;

P=P0*ones(size(ploss));


risnod=get_risernodes;lrn=length(risnod);
P=P-sum(ploss(risnod));
P(risnod(lrn:-1:1))=P0-cumsum(ploss(risnod(lrn:-1:1)));

for i=1:KAN+1, 
  ik=get_ch(i);
  dpin(i)=ploss(ik(2));
  ik=ik(length(ik):-1:1);
  dput(i)=ploss(ik(1));
  P(ik)=P(ik)-cumsum(ploss(ik));
  dpcore(i)=sum(ploss(ik));
end


lpnodes=[get_lp1nodes,get_lp2nodes];
P(lpnodes)=P(lpnodes)-mean(dpcore);
lpnodes=lpnodes(length(lpnodes):-1:1);
P(lpnodes)=P(lpnodes)-cumsum(ploss(lpnodes));
