function ruler_off_save(fig)

%[obj,fig] = gcbo;

% Find only children of figure that is an axis-object
ax = get(fig,'Children');
axfind = strmatch('axes',get(ax,'type'));
ax = ax(axfind);
axfind = strmatch('legend',get(ax,'Tag'));
ax(axfind) = 0;
ax = ax(ax ~= 0);

for i=1:size(ax,1)
	ud = get(ax(i),'UserData');
	if isfield(ud,'ruler')
		delete(ud.ruler(1).handle);
		delete(ud.ruler(2).handle);
		ud.ruler(1).handle = [];
		ud.ruler(2).handle = [];
		delete(ud.rulerlegend);
		ud.rulerlegend=[];
		set(ax(i),'UserData',ud);
	end
end
