function ruler_setvertical(src,eventdata)

[obj,fig] = gcbo;

% Find only children of figure that is an axis-object
ax = get(fig,'Children');
axfind = strmatch('axes',get(ax,'type'));
ax = ax(axfind);
axfind = strmatch('legend',get(ax,'Tag'));
ax(axfind) = 0;
ax = ax(ax ~= 0);


rulerind = findobj(fig,'Tag','rulerbtn');
rulerstate = get(rulerind,'State');

if strcmp(rulerstate,'on')
	for i=1:size(ax,1)
		ud = get(ax(i),'UserData');
		if isfield(ud,'ruler')
			type = ud.ruler(1).type;
			switch type
			case 'vertical'
				return;
				
			case 'horizontal'
				xlim = get(ax(i),'XLim');
				ylim = get(ax(i),'YLim');
				ydiff = ylim(2)-ylim(1);
				
				ruler1h = ud.ruler(1).handle;
				ruler2h = ud.ruler(2).handle;
				
				ud.ruler(1).type = 'vertical';
				ud.ruler(2).type = 'vertical';
				ud.ruler(1).pos = ydiff/3+ylim(1);
				ud.ruler(2).pos = (ydiff/3)*2+ylim(1);
				dy = ud.ruler(2).pos - ud.ruler(1).pos;
				
				set(ruler1h,'XData',[xlim(1) xlim(2)]);
				set(ruler1h,'YData',[ydiff/3+ylim(1) ydiff/3+ylim(1)]);
				set(ruler2h,'XData',[xlim(1) xlim(2)]);
				set(ruler2h,'YData',[(ydiff/3)*2+ylim(1) (ydiff/3)*2+ylim(1)]);
				
				set(ud.ruler(1).texth,'String',['y1: ' num2str(ud.ruler(1).pos,'%6.4G')]);
				set(ud.ruler(2).texth,'String',['y2: ' num2str(ud.ruler(2).pos,'%6.4G')]);
				set(ud.rulerdiffh,'String',['dy: ' num2str(abs(dy),'%6.4G')]);
				
				set(ax(i),'UserData',ud);
			end
		end
	end
end
