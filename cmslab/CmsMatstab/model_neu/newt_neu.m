function [en,eq,ef]=newt_neu(lam,et,ej,en,ef,An,Ant,AntIm,AnIm,Anf,l,u,lf,uf,Aqn,Aqt,Aqf,Aft,Afq,Afj,enupd)
if ~exist('enupd','var'),
    enupd=1;
end
for i3=1:3,
  hl=Ant*et+AntIm*(et*1j)+AnIm*(en*1j)+Anf*ef;
  if enupd,
      en = pcgsolve(An,-hl,en,1e-5,30,0,l,u);
  end
end
for i3=1:3,
  eq=Aqn*en+Aqt*et+Aqf*ef;
  ef = uf\(lf\(Aft*et+Afq*eq+Afj*ej));
end