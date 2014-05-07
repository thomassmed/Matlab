function alfa_mid=bound2mid(alfa)
[kmax,ncc]=size(alfa);
alfa_mid=0.5*alfa;
alfa_mid(2:kmax,:)=alfa_mid(2:kmax,:)+0.5*alfa(1:kmax-1,:);
%alfa_mid=alfa;