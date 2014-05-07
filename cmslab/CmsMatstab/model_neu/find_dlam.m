function [et_efix,et,ej,en,ef,eq]=find_dlam(lam,dlam,Bt,Btj,At,Atj,Atf,l1,u1,Atq,Bj,Aj,Ajttj,Ajf,Ajt,Ant,AntIm,An,AnIm,Anf,Aqt,Aqn,Aqf,Aft,Afq,Af,Afj,Bf,...
    l,u,lf,uf,et,ej,en,eq,ef,efix,CoreOnly,matr)

global msopt geom

Midpoint=get_bool(msopt.Midpoint);

for ii0=1:1,
    for ii=1:1,
        rhs1=-Bt*et*(lam+dlam)+At*et+Atj*ej+Atf*ef+Atq*eq-Btj*ej*(lam+dlam);
        if CoreOnly
            ej=0*ej;
        else
            dej=(lam*Bj-Aj-Ajttj)\(-Bj*(lam+dlam)*ej+Ajf*ef+Aj*ej+Ajt*et+Ajt*(u1\(l1\rhs1)));
            ej=ej+dej;
        end
        et=u1\(l1\(Atf*ef+Atq*eq+Atj*ej-dlam*Bt*et-Btj*ej*(lam+dlam)));
    end
    enorm=et(efix);
    et=et/enorm;ej=ej/enorm;en=en/enorm;eq=eq/enorm;ef=ef/enorm;
    for i3=1:1,
        etn=et;
        if Midpoint, %Midpoint
            ev=et(matr.ibas_t);
            ev=reshape(ev,geom.kmax,geom.ncc);
            ev=bound2mid(ev);
            etn(matr.ibas_t)=ev(:);
        end
        hl=Ant*etn+AntIm*(et*1j)+AnIm*(en*1j)+Anf*ef;
        en = pcgsolve(An,-hl,en,1e-5,30,0,l,u);
    end
    for i3=1:2,
        eq=Aqn*en+Aqt*etn+Aqf*ef;
        if ismatlab
            ef = uf\(lf\(-Bf*dlam*ef+Aft*et+Afq*eq+Afj*ej));
        else
            ef = ((lam+dlam)*Bf-Af)\(Aft*et+Afq*eq+Afj*ej);
        end
    end
end
for ii=1:1,
    rhs1=-Bt*et*(lam+dlam)+At*et+Atj*ej+Atf*ef+Atq*eq-Btj*ej*(lam+dlam);
    if CoreOnly
        ej=0*ej;
    else
        dej=(lam*Bj-Aj-Ajttj)\(-Bj*(lam+dlam)*ej+Ajf*ef+Aj*ej+Ajt*et+Ajt*(u1\(l1\rhs1)));
        ej=ej+dej;
    end
    et=u1\(l1\(Atf*ef+Atq*eq+Atj*ej-dlam*Bt*et-Btj*ej*(lam+dlam)));
end
et_efix=et(efix);