function int=stp2integer(stp,xpo)
xpo=xpo(:);
int=stp;
if max(round(stp)-stp)>0,
    for i=1:length(int),
        int(i)=find(abs(int(i)-xpo)<0.001,1,'first');
    end
end
