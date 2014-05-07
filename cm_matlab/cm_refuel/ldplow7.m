%@(#)   ldplow7.m 1.1	 00/11/23     10:09:04
%
function ldplow7(refufile,asyid)

if exist(refufile,'file')
    refu=load(refufile);
    
    bocfile=refu.bocfile;
    
    khot=readdist7(bocfile,'khot');
    [b,mminj]=readdist7(bocfile);
    
    [right,left]=knumhalf(mminj);
    
    sym=refu.symmetry;
    
    [khot,k]=sort(khot);
    
    ldchan=k(1);
    if isempty(find(right==ldchan))
        ldchan=right(find(left==ldchan));
    end
    
    poolload=refu.poolload;
    n=length(poolload);
    
    poolload(n+1).ldbuid=asyid;
    poolload(n+1).ldchan=ldchan;
    
    save(refufile,'-append','poolload');
end
