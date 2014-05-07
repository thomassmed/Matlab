function ruler_mov(rulerno)

ax = gca;
ud = get(ax,'UserData');

pos = get(ax,'CurrentPoint');



lineh = ud.ruler(rulerno).handle;
set(lineh,'EraseMode','xor');

type = ud.ruler(rulerno).type;
switch type
case 'horizontal'
	set(lineh,'XData',[pos(1,1) pos(1,1)]);
	ud.ruler(rulerno).pos = pos(1,1);
	set(ud.ruler(rulerno).texth,'String',['x' num2str(rulerno) ': ' num2str(ud.ruler(rulerno).pos,'%6.4G')]);
	set(ud.rulerdiffh,'String',['dx: ' num2str(abs(ud.ruler(2).pos - ud.ruler(1).pos),'%6.4G')]);
case 'vertical'
	set(lineh,'YData',[pos(1,2) pos(1,2)]);
	ud.ruler(rulerno).pos = pos(1,2);
	set(ud.ruler(rulerno).texth,'String',['y' num2str(rulerno) ': ' num2str(ud.ruler(rulerno).pos,'%6.4G')]);
	set(ud.rulerdiffh,'String',['dy: ' num2str(abs(ud.ruler(2).pos - ud.ruler(1).pos),'%6.4G')]);
end



set(ax,'UserData',ud);
drawnow();
