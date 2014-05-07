% Thermo-hydraulics for matstab
%
% Files
%   A_th           - 
%   cor_cpl        - x=cor_cpl(tsat)
%   cor_hfg        - x=cor_hfg(P)
%   cor_hg         - cor_rog     remark to 6.4.31
%   cor_hl         - cor_hl
%   cor_kl         - x=cor_kl(tsat)
%   cor_myl        - x=cor_myl(tsat)
%   cor_rof        - r=cor_rof(tsat);
%   cor_rog        - r=cor_rog(tsat);
%   cor_rol        - [r x]=cor_rol(P,tl)
%   cor_tsat       - ts=cor_tsat(P);
%   cor_ug         - y=cor_ug(P,tl,tsat0);        eq. 4.4.75
%   cor_ul         - cor_ul
%   eq_alfa        - 
%   eq_alfa_core   - 
%   eq_dP_core     - 
%   eq_DPDt        - y = eq_DPDt(gammav,tl,P,alfa,Wfw,Wsl,V)
%   eq_E           - eq_E
%   eq_Energy_core - 
%   eq_fl          - eq_fl
%   eq_gamph       - y = eq_gamph(alfa,P,tl)
%   eq_gamv        - y = eq_gamv(gammaw,gammaph)
%   eq_gamw        - y = eq_gamw(qprimw,P,tl,tw,A)
%   eq_Gm          - 
%   eq_haac        - y = eq_haac(P,tw,Wl,A,Iboil,Dh,mod)
%   eq_jm          - y = eq_jm(Wl,Wg,P,tl,A);
%   eq_lrsr        - 
%   eq_Mel         - eq_Mel
%   eq_Mel0        - eq_Mel0
%   eq_Mpump       - eq_Mpump
%   eq_npump       - n=eq_npump(Wl,P,tl,ppump,pump,pk1,pk2)
%   eq_Nre         - eq_Nre
%   eq_pacc        - p=eq_pacc
%   eq_paccD       - p=eq_paccD
%   eq_pelev       - p=eq_pelev
%   eq_pfric       - p=eq_pfric
%   eq_phi2        - eq_phi2
%   eq_ploss       - p=eq_ploss
%   eq_ploss_1     - p=eq_ploss
%   eq_prestr      - p=eq_prestr
%   eq_pspeed      - y = eq_pspeed(x)
%   eq_romum       - y = eq_romum(alfa,P,tl,Tsat0)
%   eq_slip        - y = eq_slip(alfa,P,variabel)
%   eq_tw          - y = eq_tw(tw,tc,tl,P,Wl,A,Iboil,Dh)
%   eq_tw0         - tw = eq_tw0(P,qprimw,htc,pbm,phm,tlb,tl,Wl,Wg,Dh,A)
%   eq_vg          - y = eq_vg(S,jm,alfa)
%   eq_vl          - y = eq_vl(S,jm,alfa)
%   eq_Wg_core     - tw=eq_tw0(p,qprimw,htc,pbm,phm,tlb);
%   eq_Wl          - y = eq_Wl(P,jm,alfa,tl,A)
%   eq_Wl1         - y = eq_Wl(P,jm,alfa,tl,A)
%   eq_Wl_u        - y = eq_Wl(P,jm,alfa,S,tl,A)
%   get_index4AI   - 
%   lin_DnDt       - [Wl_c,P_c,tl_c,n_c]=lin_DnDt(Wl,P,tl,nhcpump)
%   lin_dP_core    - 
%   lin_P          - lin_P
%   ploss_section  - 
%   set_pkoeff     - set_pkoeff
%   syst_f4        - 
%   syst_f4_new    - 
%   syst_f57       - 
%   syst_f_ini     - [alfa,tl,Wg,Wl,chflow,flowb]=syst_f_ini(fue_new,power,chflow,flowb,alfa,tl)
%   void2dens      - dens=void2dens(void,P,tl)
