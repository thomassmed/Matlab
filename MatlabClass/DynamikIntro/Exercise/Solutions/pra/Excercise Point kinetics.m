h=0.0001;
t1=0:h:60;
y1=zeros(2,length(t1));
y1(:,1)=y0;
for i=2:length(t1)
    y1(:,i)=y1(:,i-1)+h*pointk(0,y1(:,i-1));
end

