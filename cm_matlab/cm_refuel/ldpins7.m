%@(#)   ldpins7.m 1.2	 06/03/08     08:42:49
%
function ldpins7(refufile,asyid, chkhot)

if exist(refufile,'file')
    bocfile=refu.bocfile;
    sym=refu.symmetry;
    
    khot=readdist7(bocfile,'khot');
    [bocburn,mminj]=readdist7(bocfile,'burnup');
    
    [right,left]=knumhalf(mminj);
    
    [khot,i]=sort(khot);
    
    if sym==3
        khot(left)='';
        j=find(findint(i,left));
        i(j)='';
    end
    
    khot=sort([khot chkhot]);
    khot=khot(2:length(i)+1);
    j=find(khot==chkhot);
    
    if isempty(j),
        khot(1)=chkhot;
        j=1;
    end
    num=j(1);
    
    %figure(hpar)
    %hold on
    for j=num:-1:1
        yx=knum2cpos(i(j),mminj);
        xx(num-j+1)=yx(2);
        yy(num-j+1)=yx(1);
        X=[yx(2) yx(2)+1 yx(2)+.5];
        Y=[yx(1) yx(1) yx(1)+.5];
        %patch(X,Y,[1 1 1]*.8)
        if sym==3
            leftchan=size(bocburn,2)+1-i(j);
            yx=knum2cpos(leftchan,mminj);
            X=[yx(2) yx(2)+1 yx(2)+.5];
            Y=[yx(1) yx(1) yx(1)+.5];
            %patch(X,Y,[1 1 1]*.8)
        end
    end
    %set(h(14),'userdata',[0 xx;0 yy])
    ldchan=i(num);
    yx=knum2cpos(ldchan,mminj);
    xx(1)=yx(2);
    yy(1)=yx(1);
    X=[yx(2) yx(2) yx(2)+1 yx(2)+1];
    Y=[yx(1) yx(1)+1 yx(1)+1 yx(1)];
    %fill(X,Y,[1 1 1]*.8)
    if sym==3
        leftchan=left(find(right==ldchan));
        yx=knum2cpos(leftchan,mminj);
        X=[yx(2) yx(2) yx(2)+1 yx(2)+1];
        Y=[yx(1) yx(1)+1 yx(1)+1 yx(1)];
        %fill(X,Y,[1 1 1]*.8)
    end
    %hold off
    
    
    poolload=refu.poolload;
    n=length(poolload);
    poolload(n+1).ldbuid=asyid;
    poolload(n+1).ldchan=ldchan;
    
    save(refufile,'-append','poolload');
end

