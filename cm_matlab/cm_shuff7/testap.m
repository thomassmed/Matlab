%@(#)   testap.m 1.1	 05/07/13     10:29:43
%
%
      hand=get(gcf,'userdata');
      hand(3)
      plmat=get(hand(3),'cdata');
      plmat(18,18)=9.5;
      set(hand(3),'cdata',plmat);
set(Hring(find(gonu==1)),'visible','off');
set(Hpil(find(gonu==1)),'visible','off');
set(Hring(find(gonu==3)),'visible','off');
set(Hpil(find(gonu==3)),'visible','off');
set(Hring(find(gonu==2)),'visible','on');
set(Hpil(find(gonu==2)),'visible','on');
      set(gcf,'userdata',hand);
