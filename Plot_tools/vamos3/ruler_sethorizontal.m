function ruler_sethorizontal(src,eventdata)

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
			case 'horizontal'
				return;
				
			case 'vertical'
				xlim = get(ax(i),'XLim');
				ylim = get(ax(i),'YLim');
				
				ruler1h = ud.ruler(1).handle;
				ruler2h = ud.ruler(2).handle;
				
				ud.ruler(1).type = 'horizontal';
				ud.ruler(2).type = 'horizontal';
				ud.ruler(1).pos = xlim(2)/3;
				ud.ruler(2).pos = (xlim(2)/3)*2;
				dx = ud.ruler(2).pos - ud.ruler(1).pos;
				
				set(ruler1h,'XData',[xlim(2)/3 xlim(2)/3]);
				set(ruler1h,'YData',[ylim(1) ylim(2)]);
				set(ruler2h,'XData',[(xlim(2)/3)*2 (xlim(2)/3)*2]);
				set(ruler2h,'YData',[ylim(1) ylim(2)]);
				
				set(ud.ruler(1).texth,'String',['x1: ' num2str(ud.ruler(1).pos,'%6.4G')]);
				set(ud.ruler(2).texth,'String',['x2: ' num2str(ud.ruler(2).pos,'%6.4G')]);
				set(ud.rulerdiffh,'String',['dx: ' num2str(abs(dx),'%6.4G')]);
				
				set(ax(i),'UserData',ud);
			end
		end
	end
end



