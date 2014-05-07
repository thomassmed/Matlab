function [rps,XS]=czpsd(zepo,sd,iz)
%CZPSD berknar standardavvikelse-ellipser fr poler och nollstllen
%
%  [rps,XS]=czpsd(zepo,sd,iz)
%
%  modifierad zpsdpl.m (/ident) 
%  92-02-11, C. Rotander, RPA, ABB Atom, 721 63 Vsters
%
%  Modifierad av Pär Lansåker 940104
if nargin==3
  om=2.1*pi*(1:100)/100;
  w=exp(om*sqrt(-1));
end
rps=[];XS=[];
for k=iz
  if imag(zepo(k,1))==0;
    rp=real(zepo(k,1)+sd*zepo(k,2)*[-1 1]);
    rps=[rps rp'];
  else 
    if imag(zepo(k,1))>0
      r1=real(zepo(k,2));r2=imag(zepo(k,2));r3=zepo(k+1,2);
      p1=r1*r1;p2=r2*r2;p3=r3*r1*r2;
      SM=[p1 p3;p3 p2]; [V,D]=eig(SM); z1=real(w)*sd*sqrt(D(1,1));
      z2=imag(w)*sd*sqrt(D(2,2)); X=V*[z1;z2];
      X=[X(1,:)+real(zepo(k,1));X(2,:)+imag(zepo(k,1))];
      if isempty(XS)
         XS=X';
      else
         XS=[XS X'];
      end
    end
  end
end




