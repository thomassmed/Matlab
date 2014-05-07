%
function ldfreshtox(refufile, asytyp, pos)

if exist(refufile,'file')
    refu=load(refufile);
    
    bocfile=refu.bocfile;
    [~,mminj]=readdist7(bocfile);
    [right,left]=knumhalf(mminj);
    
    sym=refu.symmetry;
    
    freshload=refu.freshload;
    n=length(freshload);
    
    for i=1:size(pos,1)

        x=fix(pos(i,1));
        y=fix(pos(i,2));
        
        ldchan=cpos2knum(y,x,mminj);
        
        if ~isempty(find(left==ldchan)) & sym==3
            ldchan=right(find(left==ldchan));
        end
        
        
        
        freshload(n+i).ikan=ldchan
        freshload(n+i).newbun=asytyp;
    end
    
    save(refufile,'-append','freshload');
end
