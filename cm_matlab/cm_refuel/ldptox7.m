%@(#)   ldptox7.m 1.1	 00/11/23     10:09:04
%
function ldptox7(refufile, asyid, x, y)

if exist(refufile,'file')
    refu=load(refufile);
    
    pool=refu.poolfile;
    bocfile=refu.bocfile;
    
    [bocbuid,mminj]=readdist7(bocfile,'asyid');
    
    [right,left]=knumhalf(mminj);
    
    sym=refu.symmetry;
    
    x=fix(x);
    y=fix(y);
    
    ldchan=cpos2knum(y,x,mminj);
    
    if ~isempty(find(left==ldchan)) & sym==3
        ldchan=right(find(left==ldchan));
    end
    
    poolload=refu.poolload;
    n=length(poolload);
    poolload(n+1).ldbuid=asyid;
    poolload(n+1).ldchan=ldchan;
    
    save(refufile,'-append','poolload');
end
