function [y,tw,Iboil,gammav]=eq_Wg_core(alfa,tl,Wl,Wg,qprimw,p,A,hz,tlb,htc,pbm,phm,Dh)
%tw=eq_tw0(p,qprimw,htc,pbm,phm,tlb);
%TODO: change this to:
[tw,Iboil]=eq_tw0(p,qprimw,htc,pbm,phm,tlb,tl,Wl,Wg,Dh,A);
gammav=eq_gamv(eq_gamw(qprimw,p,tl,tw,A),eq_gamph(alfa,p,tl));
gammav=gammav.*(gammav>0);
kmax=size(alfa,1);
k=2:kmax;
y(k,:)=Wg(k,:)-Wg(k-1,:)-(gammav(k,:)).*A(k,:)*hz/100;
