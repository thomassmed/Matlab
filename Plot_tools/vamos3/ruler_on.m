function ruler_on(src,eventdata)

[obj,fig] = gcbo;

% Find only children of figure that is an axis-object
ax = get(fig,'Children');
axfind = strmatch('axes',get(ax,'type'));
ax = ax(axfind);
axfind = strmatch('legend',get(ax,'Tag'));
ax(axfind) = 0;
ax = ax(ax ~= 0);

for i=1:size(ax,1)
	axes(ax(i));
	ud = get(ax(i),'UserData');
	xlim = get(ax(i),'XLim');
	ylim = get(ax(i),'YLim');
	if isfield(ud,'ruler')
		type = ud.ruler(1).type;
		oldpos1 = ud.ruler(1).pos;
		oldpos2 = ud.ruler(2).pos;
		switch type
		case 'horizontal'
			ruler1h = line([oldpos1 oldpos1],[ylim(1) ylim(2)]);
			ruler2h = line([oldpos2 oldpos2],[ylim(1) ylim(2)]);
			text1 = 'x1: ';
			text2 = 'x2: ';
			text3 = 'dx: ';
		case 'vertical'
			ruler1h = line([xlim(1) xlim(2)],[oldpos1 oldpos1]);
			ruler2h = line([xlim(1) xlim(2)],[oldpos2 oldpos2]);
			text1 = 'y1: ';
			text2 = 'y2: ';
			text3 = 'dy: ';
		end
	else
		ruler1h = line([xlim(2)/3 xlim(2)/3],[ylim(1) ylim(2)]);
		ruler2h = line([(xlim(2)/3)*2 (xlim(2)/3)*2],[ylim(1) ylim(2)]);
		text1 = 'x1: ';
		text2 = 'x2: ';
		text3 = 'dx: ';
	end
	
	% Set ruler colors and line-styles
	set(ruler1h,'Color',[1 0 1]);
	set(ruler1h,'LineStyle','-');
	set(ruler2h,'Color',[1 0 1]);
	set(ruler2h,'LineStyle','-.');
	set(ruler1h,'HandleVisibility','off');
	set(ruler2h,'HandleVisibility','off');
	
	% Set ruler callbacks
	stru = 'set(gcf,''''WindowButtonMotionFcn'''',[]),set(gcf,''''WindowButtonUpFcn'''',[])';
	str1 = ['set(gcf,''WindowButtonMotionFcn'',''ruler_mov(1)''),set(gcf,''WindowButtonUpFcn'',''' stru ''')'];
	str2 = ['set(gcf,''WindowButtonMotionFcn'',''ruler_mov(2)''),set(gcf,''WindowButtonUpFcn'',''' stru ''')'];
	set(ruler1h,'ButtonDownFcn',str1);
	set(ruler2h,'ButtonDownFcn',str2);
	
	% Set axes ud-rulerdata
	if (~isfield(ud,'ruler'))
		ud.ruler(1).type = 'horizontal';
		ud.ruler(2).type = 'horizontal';
		ud.ruler(1).pos = xlim(2)/3;
		ud.ruler(2).pos = (xlim(2)/3)*2;
	end
	
	ud.ruler(1).handle = ruler1h;
	ud.ruler(2).handle = ruler2h;
	
	dx = ud.ruler(2).pos - ud.ruler(1).pos;
	
	h = legend([ruler1h; ruler2h; ruler1h], ...
				[text1 num2str(ud.ruler(1).pos,'%6.4G')], ...
				[text2 num2str(ud.ruler(2).pos,'%6.4G')], ...
				[text3 num2str(dx,'%6.4G')], ...
				'Location','SouthEastOutside');
	legh = copyobj(h,gcf);
	ha = get(legh,'ButtonDownFcn');
	set(legh,'ButtonDownFcn',{ha{1},handle(legh)})
		
	obj = get(legh,'Children');
	ud.ruler(1).texth = obj(9);
	ud.ruler(2).texth = obj(6);
	ud.rulerlegend = legh;
	
	ud.rulerdiffh = obj(3);
	set(ax(i),'UserData',ud);
	
	updatelegend(ax(i));
end
