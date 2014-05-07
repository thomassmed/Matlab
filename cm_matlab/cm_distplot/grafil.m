%@(#)   grafil.m 1.2	 94/01/25     12:42:42
%
hand=get(gcf,'userdata');
prifil=get(hand(2),'string');
delete(gcf);
figure(hand(1));
prieval=['print ',prifil];
eval(prieval);
