function flag=zpcan(p,xp,xz)
%
%function flag=zpcan(p,xp,xz)
%
%p	-	pol
%xp	-	polens konfidensintervall
%xz	-	"misstnkt" nollstlles konfidensintervall
%
%flag=1 om konfidensintervallet fr ett reellt nollstlle skr konfidens-
%       intervallet fr en reell pol
%flag=2 om konfidensintervallet fr ett komplext nollstlle skr konfidens-
%       intervallet fr en komplex pol
%flag=0 om inget av ovanstende r uppfyllt	
%
%92-02-11
%Camilla Rotander
%RPA
%ABB Atom
%S-721 63 Vsters
%SWEDEN
%
clear i
[nnz,mmz]=size(xz);
[nnp,mmp]=size(xp);

if (nnz==2)|(nnp==2),
   if (nnz==nnp)		%	reell pol och reellt nollstlle
     xpi=[xp(1)+i*0 xp(2)+i*0];
     xzi=[xz(1)+i*0 xz(2)+i*0];
     if ( (xzi(1)>xpi(1)) & (xzi(1)<xpi(2)) ) | ( (xzi(2)>xpi(1)) & (xzi(2)<xpi(2)) ) 
         flag=1;
      else
         flag=0;
      end
    else
       flag=0;
    end
else
%	
%kollar bara om komplexa poler/nollstllen kancellerar varandra
%
   xzi=[xz(:,1)+i*xz(:,2)];
   xpi=[xp(:,1)+i*xp(:,2)];

   rz=abs(xzi-p);
   j=find(rz==min(rz));
   rzz=abs(xzi(j)-p);
   fi=angle(xzi(j)-p);
   fi1=angle(xpi-p);
   fii=abs(fi1-fi);
   j=find(fii==min(fii));
   fi2=fi1(j);
   rpp=abs(xpi(j)-p);
   flag=2*(rpp>rzz);
end


