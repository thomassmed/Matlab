%@(#)   getmatvec.m 1.2	 94/01/25     12:42:38
%
function evalfiltvec=getmatvec;
hand=get(gcf,'userdata');
matvecstr=get(hand(2),'string');
delete(gcf);
figure(hand(1));
evalfiltvec=['fvecdumm=',matvecstr,';if size(fvecdumm,1)>1, fvecdumm=fvecdumm'';end;',...
'handles=get(gcf,''userdata'');set(handles(24),''userdata'',fvecdumm);goplot'];
