function [ok] = java_get_radial_opt()

global cs;

if(max(max(cs.fintp_bundle))==0 && max(max(cs.btfp_btf))==0 && max(max(cs.powp))==0)
    ok=1;
else
    ok=0;
end



end
