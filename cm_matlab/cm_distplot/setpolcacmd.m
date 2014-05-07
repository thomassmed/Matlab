function hfig=setpolcacmd()

hand=get(gcf,'userdata');
polcacmd=get(hand(2),'string');

save -append sim/simfile polcacmd;