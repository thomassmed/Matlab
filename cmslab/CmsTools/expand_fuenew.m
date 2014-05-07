function fue_new=expand_fuenew(fue_in)
fue_new=fue_in;
knum=fue_new.knum;
if ~strcmp(fue_new.sym,'FULL')
    fue_new.burnup=sym_full(fue_in.burnup,knum);
    fue_new.nfta=sym_full(fue_in.nfta,knum);
    fue_new.nload=sym_full(fue_in.nload',knum)';
    fue_new.nfra=sym_full(fue_in.nfra,knum);
    fue_new.nhyd=sym_full(fue_in.nhyd,knum);
    fue_new.xenon=sym_full(fue_in.xenon,knum);
    fue_new.ibat=sym_full(fue_in.ibat,knum);
    fue_new.iodine=sym_full(fue_in.iodine,knum);
    fue_new.promethium=sym_full(fue_in.promethium,knum);
    fue_new.samarium=sym_full(fue_in.samarium,knum);
    fue_new.lab=sym_full(fue_in.lab',knum)';
    fue_new.ser=sym_full(fue_in.ser',knum)';
    fue_new.vhist=sym_full(fue_in.vhist,knum);
    fue_new.crdhist=sym_full(fue_in.crdhist,knum);
    fue_new.tfuhist=sym_full(fue_in.tfuhist,knum);
    if strcmpi(fue_new.lwr,'BWR')
        fue_new.orityp=sym_full(fue_in.orityp,knum);
        fue_new.afuel=sym_full(fue_in.afuel,knum);
        fue_new.dhfuel=sym_full(fue_in.dhfuel,knum);
        fue_new.phfuel=sym_full(fue_in.phfuel,knum);
        fue_new.vhifuel=sym_full(fue_in.vhifuel,knum);
        fue_new.vhofuel=sym_full(fue_in.vhofuel,knum);
        fue_new.Xcin=sym_full(fue_in.Xcin,knum);
        fue_new.amdt=sym_full(fue_in.amdt,knum);
        fue_new.bmdt=sym_full(fue_in.bmdt,knum);
        for i=1:length(fue_in.A_wr),
            fue_new.A_wr{i}=sym_full(fue_in.A_wr{i},knum);
            fue_new.Ph_wr{i}=sym_full(fue_in.Ph_wr{i},knum);
            fue_new.Dhy_wr{i}=sym_full(fue_in.Dhy_wr{i},knum);
            fue_new.Kin_wr{i}=sym_full(fue_in.Kin_wr{i},knum);
            fue_new.Kex_wr{i}=sym_full(fue_in.Kex_wr{i},knum);
        end
    end
    fue_new.knum=(1:fue_in.kan)';
    ij=knum2cpos(fue_new.knum,fue_new.mminj);
    fue_new.iaf=ij(:,1);
    fue_new.jaf=ij(:,2);
    for i=1:3,
        fue_new.Core_Seg{i}=sym_full(fue_in.Core_Seg{i},knum);
        fue_new.Seg_w{i}=sym_full(fue_in.Seg_w{i},knum);
    end
end