%@(#)   ldfresh7.m 1.1	 00/11/23     10:09:03
%
function ldfresh7(refufile,asytyp,num)

if exist(refufile,'file')
    refu=load(refufile);
    
    bocfile=refu.bocfile;
    khot=readdist7(bocfile,'khot');
    [bocburn,mminj]=readdist7(bocfile,'asyid');
    
    sym=refu.symmetry;
    
    if sym==3
        num=num/2;
    end
    
    [right,left]=knumhalf(mminj);
    
    
    ikan=[];
    freshload=refu.freshload;
    for i=1:length(freshload)
        ikan=[ikan freshload(i).ikan];
    end
    
    if isempty(ikan)
        fr=0;
    else
        fr=length(ikan);
    end
    
    [khot,k]=sort(khot);
    
    if sym==3
        i=find(findint(k,left));
        k(i)='';
    end
    
    n=length(freshload);
    freshload(n+1).ikan=k(fr+1:fr+num);
    freshload(n+1).newbun=asytyp;
    
    save(refufile,'-append','freshload');
    
    ikan=[ikan k(fr+1:fr+num)];
    
   
    
end
