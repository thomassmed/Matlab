function fl=eq_fl(Wl,Wg,dh,P,A,amdt,bmdt)
%eq_fl
%
%fl=eq_fl(Wl,Wg,dh,P,A)
%Single phase pressure drop
%Ekv. 4.4.44

%@(#)   eq_fl.m 1.2   02/03/04     14:06:37

Nre = eq_Nre(Wl,Wg,dh,P,A);

amdtflag=true;
if nargin<6, 
    amdtflag=false;
elseif isempty(amdt)
    amdtflag=false;
end

if amdtflag,
    kmax=size(Nre,1);
    if max(size(amdt))>1,
        amdt=repmat(amdt,kmax,1);
    end
    if max(size(bmdt))>1,
        bmdt=repmat(bmdt,kmax,1);
    end
    fl=amdt.*Nre.^bmdt;
else
   fl = 0.23./(Nre.^0.2); %New koefficient according to L.Moberg/SSP-01/210
   % fl=0.0916./Nre.^.1730;
end
