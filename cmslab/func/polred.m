function flag=polred(th,sd)
%
%function flag=polred(th,sd)
%
%th	-	"som vanligt"
%sd	-	standardavvikelse att "reducera pe"
%
%flag	-	=2 om minst ett komplext nollstlle/en komplex 
%		   pol kancellerar varandra ("hgsta" prioritet)
%		=1 om minst ett reellt nollstlle/en reell pol
%		   kancellerar varandra
%		=0 om ingen pol/nollstlleskancellering
%
%92-02-11
%Camilla Rotander
%RPA
%ABB Atom
%S-721 63 Vsters
%SWEDEN
%
zepo=th2zp(th);
[nz,mz]=size(zepo);
z=zepo(2:nz,1:2);
p=zepo(2:nz,3:4);
ip=1:nz-1;
j=find(finite(z(:,1))==0);
iz=1:nz-1-length(j);
flag=zeros(length(ip),length(iz));
[Rz,Xz]=czpsd(z,sd,iz);
[Rp,Xp]=czpsd(p,sd,ip);
cpr=1;cpi=1;
for kp=1:length(ip)
   if (imag(p(kp,1))>=0)
      p1=p(kp,1);
      if (imag(p(kp,1))==0)	
  	 xp=Rp(:,cpr); cpr=cpr+1;
      elseif (imag(p(kp,1))>0)
	 xp=Xp(:,cpi:cpi+1); cpi=cpi+2;
      end
      czr=1; czi=1;
      for kz=1:length(iz)
         if (imag(z(kz,1))>=0)
            z1=z(kz,1);
            if (imag(z(kz,1))==0)
	       xz=Rz(:,czr); czr=czr+1;
 	    elseif (imag(z(kz,1))>0)
	       xz=Xz(:,czi:czi+1); czi=czi+2;
	    end
            flagp(kp,kz)=zpcan(p1,xp,xz);
         end
      end
   end
end

czr=1;czi=1;
for kz=1:length(iz)
   if (imag(z(kz,1))>=0)
      z1=z(kz,1);
      if (imag(z(kz,1))==0)	
  	 xz=Rz(:,czr); czr=czr+1;
      elseif (imag(z(kz,1))>0)
	 xz=Xz(:,czi:czi+1); czi=czi+2;
      end
      cpr=1; cpi=1;
      for kp=1:length(ip)
         if (imag(p(kp,1))>=0)
            p1=p(kp,1);
            if (imag(p(kp,1))==0)
	       xp=Rp(:,cpr); cpr=cpr+1;
 	    elseif (imag(p(kp,1))>0)
	       xp=Xp(:,cpi:cpi+1); cpi=cpi+2;
	    end
            flagz(kz,kp)=zpcan(z1,xz,xp);
         end
      end
   end
end

flag=max(max(max(flagp,flagz')));
