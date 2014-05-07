function [ret,x0,str]=simupak(t,x,u,flag);
%SIMUPAK	is the M-file description of the SIMULINK system named SIMUPAK.
%	The block-diagram can be displayed by typing: SIMUPAK.
%
%	SYS=SIMUPAK(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%	Setting FLAG=1 causes SIMUPAK to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%	Calling SIMUPAK with a FLAG of zero:
%	[SIZES]=SIMUPAK([],[],[],0),  returns a vector, SIZES, which
%	contains the sizes of the state vector and other parameters.
%		SIZES(1) number of states
%		SIZES(2) number of discrete states
%		SIZES(3) number of outputs
%		SIZES(4) number of inputs.
%	For the definition of other parameters in SIZES, see SFUNC.
%	See also, TRIM, LINMOD, LINSIM, EULER, RK23, RK45, ADAMS, GEAR.

% Note: This M-file is only used for saving graphical information;
%       after the model is loaded into memory an internal model
%       representation is used.

% the system will take on the name of this mfile:
sys = mfilename;
new_system(sys)
simver(1.2)
if(0 == (nargin + nargout))
     set_param(sys,'Location',[81,264,483,387])
     open_system(sys)
end;
set_param(sys,'algorithm',     'RK-45')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     '999999')
set_param(sys,'Min step size', '0.0001')
set_param(sys,'Max step size', '10')
set_param(sys,'Relative error','1e-3')
set_param(sys,'Return vars',   '')


%     Subsystem  'In//Ut'.

new_system([sys,'/','In//Ut'])
set_param([sys,'/','In//Ut'],'Location',[0,59,228,541])

add_block('built-in/Step Fcn',[sys,'/','In//Ut/Step Fcn'])
set_param([sys,'/','In//Ut/Step Fcn'],...
		'position',[55,35,75,55])

add_block('built-in/Sine Wave',[sys,'/','In//Ut/Sine Wave'])
set_param([sys,'/','In//Ut/Sine Wave'],...
		'position',[55,75,75,95])

add_block('built-in/White Noise',[sys,'/','In//Ut/White Noise'])
set_param([sys,'/','In//Ut/White Noise'],...
		'position',[55,120,75,140])

add_block('built-in/From Workspace',[sys,'/','In//Ut/From Workspace'])
set_param([sys,'/','In//Ut/From Workspace'],...
		'position',[45,242,85,268])

add_block('built-in/From File',[sys,'/','In//Ut/From File'])
set_param([sys,'/','In//Ut/From File'],...
		'position',[50,290,80,320])

add_block('built-in/Signal Generator',[sys,'/','In//Ut/Signal Gen.'])
set_param([sys,'/','In//Ut/Signal Gen.'],...
		'Peak','1.000000',...
		'Peak Range','5.000000',...
		'Freq','1.000000',...
		'Freq Range','5.000000',...
		'Wave','Sin',...
		'Units','Rads',...
		'position',[45,338,90,372])

add_block('built-in/Clock',[sys,'/','In//Ut/Clock'])
set_param([sys,'/','In//Ut/Clock'],...
		'position',[55,160,75,180])

add_block('built-in/Constant',[sys,'/','In//Ut/Constant'])
set_param([sys,'/','In//Ut/Constant'],...
		'position',[55,200,75,220])

add_block('built-in/Note',[sys,'/','In//Ut/Library'])
set_param([sys,'/','In//Ut/Library'],...
		'position',[65,15,70,20])

add_block('built-in/Note',[sys,'/','In//Ut/Signal Source'])
set_param([sys,'/','In//Ut/Signal Source'],...
		'position',[65,0,70,5])

add_block('built-in/To File',[sys,'/','In//Ut/To File'])
set_param([sys,'/','In//Ut/To File'],...
		'position',[125,125,220,155])

add_block('built-in/To Workspace',[sys,'/','In//Ut/To Workspace'])
set_param([sys,'/','In//Ut/To Workspace'],...
		'mat-name','yout',...
		'position',[145,87,195,103])

add_block('built-in/Scope',[sys,'/','In//Ut/Scope'])
set_param([sys,'/','In//Ut/Scope'],...
		'Vgain','1.000000',...
		'Hgain','1.000000',...
		'Vmax','2.000000',...
		'Hmax','2.000000',...
		'Window',[100,100,380,320],...
		'position',[165,32,185,58])


%     Subsystem  ['In//Ut/Auto-scale storage',13,'graph scope'].

new_system([sys,'/',['In//Ut/Auto-scale storage',13,'graph scope']])
set_param([sys,'/',['In//Ut/Auto-scale storage',13,'graph scope']],'Location',[0,0,274,193])

add_block('built-in/S-function',[sys,'/',['In//Ut/Auto-scale storage',13,'graph scope/S-function',13,'M-file which plots',13,'lines',13,'']])
set_param([sys,'/',['In//Ut/Auto-scale storage',13,'graph scope/S-function',13,'M-file which plots',13,'lines',13,'']],...
		'function name','sfunyst',...
		'parameters','ax, color, npts',...
		'position',[130,55,180,75])

add_block('built-in/Inport',[sys,'/',['In//Ut/Auto-scale storage',13,'graph scope/x']])
set_param([sys,'/',['In//Ut/Auto-scale storage',13,'graph scope/x']],...
		'position',[65,55,85,75])
add_line([sys,'/',['In//Ut/Auto-scale storage',13,'graph scope']],[90,65;120,65])
set_param([sys,'/',['In//Ut/Auto-scale storage',13,'graph scope']],...
		'Mask Display','plot(0,0,100,100,[83,76,63,52,42,38,28,16,11,84,11,11,11,90,90,11],[75,58,47,54,72,80,84,74,65,65,65,90,40,40,90,90])',...
		'Mask Type','Storage scope.')
set_param([sys,'/',['In//Ut/Auto-scale storage',13,'graph scope']],...
		'Mask Dialogue','Storage scope using MATLAB graph window.\nEnter plotting ranges and line type.|Initial Time Range:|Initial y-min:|Initial y-max:|Storage pts.:|Line type (rgbw-.:xo):')
set_param([sys,'/',['In//Ut/Auto-scale storage',13,'graph scope']],...
		'Mask Translate','npts = @4; color = @5; ax = [0, @1, @2, @3];')
set_param([sys,'/',['In//Ut/Auto-scale storage',13,'graph scope']],...
		'Mask Help','Uses MATLAB''s graph window.\nUse only one block per system.\nLine type must be in quotes.\nSee the M-file sfunyst.m.')
set_param([sys,'/',['In//Ut/Auto-scale storage',13,'graph scope']],...
		'Mask Entries','5\/-10\/10\/500\/''r-''\/')


%     Finished composite block ['In//Ut/Auto-scale storage',13,'graph scope'].

set_param([sys,'/',['In//Ut/Auto-scale storage',13,'graph scope']],...
		'Drop Shadow',4,...
		'position',[155,320,185,360])


%     Subsystem  'In//Ut/XY Graph'.

new_system([sys,'/','In//Ut/XY Graph'])
set_param([sys,'/','In//Ut/XY Graph'],'Location',[0,0,274,193])

add_block('built-in/S-function',[sys,'/',['In//Ut/XY Graph/S-function',13,'M-file which plots',13,'lines',13,'']])
set_param([sys,'/',['In//Ut/XY Graph/S-function',13,'M-file which plots',13,'lines',13,'']],...
		'function name','sfunxy',...
		'parameters','ax',...
		'position',[185,70,235,90])

add_block('built-in/Mux',[sys,'/','In//Ut/XY Graph/Mux'])
set_param([sys,'/','In//Ut/XY Graph/Mux'],...
		'inputs','2',...
		'position',[100,61,130,94])

add_block('built-in/Inport',[sys,'/','In//Ut/XY Graph/x'])
set_param([sys,'/','In//Ut/XY Graph/x'],...
		'position',[10,30,30,50])

add_block('built-in/Inport',[sys,'/','In//Ut/XY Graph/y'])
set_param([sys,'/','In//Ut/XY Graph/y'],...
		'Port','2',...
		'position',[10,100,30,120])
add_line([sys,'/','In//Ut/XY Graph'],[135,80;175,80])
add_line([sys,'/','In//Ut/XY Graph'],[35,40;70,40;70,70;90,70])
add_line([sys,'/','In//Ut/XY Graph'],[35,110;70,110;70,85;90,85])
set_param([sys,'/','In//Ut/XY Graph'],...
		'Mask Display','plot(0,0,100,100,[12,91,91,12,12],[90,90,45,45,90],[51,57,65,75,80,79,75,67,60,54,51,48,42,34,28,27,31,42,51],[71,68,66,66,72,79,83,84,81,77,71,60,54,54,58,65,71,74,71])')
set_param([sys,'/','In//Ut/XY Graph'],...
		'Mask Type','XY scope.',...
		'Mask Dialogue','XY scope using MATLAB graph window.\nFirst input is used as time base.\nEnter plotting ranges.|x-min|x-max|y-min|y-max')
set_param([sys,'/','In//Ut/XY Graph'],...
		'Mask Translate','ax = [@1, @2, @3, @4];',...
		'Mask Help','This block can be used to explore limit cycles. Look at the m-file sfunxy.m to see how it works.',...
		'Mask Entries','-10\/10\/-10\/10\/')


%     Finished composite block 'In//Ut/XY Graph'.

set_param([sys,'/','In//Ut/XY Graph'],...
		'Drop Shadow',4,...
		'position',[155,246,185,284])


%     Subsystem  'In//Ut/Graph Scope'.

new_system([sys,'/','In//Ut/Graph Scope'])
set_param([sys,'/','In//Ut/Graph Scope'],'Location',[0,0,274,193])

add_block('built-in/S-function',[sys,'/',['In//Ut/Graph Scope/S-function',13,'M-file which plots',13,'lines',13,'']])
set_param([sys,'/',['In//Ut/Graph Scope/S-function',13,'M-file which plots',13,'lines',13,'']],...
		'function name','sfuny',...
		'parameters','ax, color',...
		'position',[130,55,180,75])

add_block('built-in/Inport',[sys,'/','In//Ut/Graph Scope/x'])
set_param([sys,'/','In//Ut/Graph Scope/x'],...
		'position',[65,55,85,75])
add_line([sys,'/','In//Ut/Graph Scope'],[90,65;120,65])
set_param([sys,'/','In//Ut/Graph Scope'],...
		'Mask Display','plot(0,0,100,100,[90,10,10,10,90,90,10],[65,65,90,40,40,90,90],[90,78,69,54,40,31,25,10],[77,60,48,46,56,75,81,84])',...
		'Mask Type','Graph scope.')
set_param([sys,'/','In//Ut/Graph Scope'],...
		'Mask Dialogue','Graph scope using MATLAB graph window.\nEnter plotting ranges and line type.|Time range:|y-min:|y-max:|Line type (rgbw-:*):',...
		'Mask Translate','color = @4; ax = [0, @1, @2, @3];')
set_param([sys,'/','In//Ut/Graph Scope'],...
		'Mask Help','This block plots to the MATLAB graph window and can be used as an improved version of the Scope block. Look at the m-file sfuny.m to see how it works.')
set_param([sys,'/','In//Ut/Graph Scope'],...
		'Mask Entries','20\/-20\/20\/''y-''\/')


%     Finished composite block 'In//Ut/Graph Scope'.

set_param([sys,'/','In//Ut/Graph Scope'],...
		'Drop Shadow',4,...
		'position',[155,181,185,219])


%     Finished composite block 'In//Ut'.

set_param([sys,'/','In//Ut'],...
		'position',[30,20,60,70])


%     Subsystem  'Discrete'.

new_system([sys,'/','Discrete'])
set_param([sys,'/','Discrete'],'Location',[0,83,144,381])

add_block('built-in/Note',[sys,'/','Discrete/Discrete'])
set_param([sys,'/','Discrete/Discrete'],...
		'position',[65,0,70,5])

add_block('built-in/Note',[sys,'/','Discrete/Library'])
set_param([sys,'/','Discrete/Library'],...
		'position',[65,15,70,20])

add_block('built-in/Unit Delay',[sys,'/','Discrete/Unit Delay'])
set_param([sys,'/','Discrete/Unit Delay'],...
		'position',[40,32,90,48])

add_block('built-in/Discrete Zero-Pole',[sys,'/','Discrete/Dis. Zero-Pole'])
set_param([sys,'/','Discrete/Dis. Zero-Pole'],...
		'Poles','[0; 0.5]',...
		'position',[35,68,95,102])

add_block('built-in/Filter',[sys,'/','Discrete/Filter'])
set_param([sys,'/','Discrete/Filter'],...
		'Denominator','[1 2]',...
		'position',[40,121,85,159])

add_block('built-in/Discrete Transfer Fcn',[sys,'/','Discrete/Dis. Transfer Fcn'])
set_param([sys,'/','Discrete/Dis. Transfer Fcn'],...
		'Denominator','[1 0.5]',...
		'position',[40,182,85,218])

add_block('built-in/Discrete State-space',[sys,'/','Discrete/Dis. State-space'])
set_param([sys,'/','Discrete/Dis. State-space'],...
		'position',[15,250,115,280])


%     Finished composite block 'Discrete'.

set_param([sys,'/','Discrete'],...
		'position',[90,20,120,70])


%     Subsystem  'Linear'.

new_system([sys,'/','Linear'])
set_param([sys,'/','Linear'],'Location',[0,83,142,474])

add_block('built-in/Note',[sys,'/','Linear/Linear'])
set_param([sys,'/','Linear/Linear'],...
		'position',[70,0,75,5])

add_block('built-in/Note',[sys,'/','Linear/Library'])
set_param([sys,'/','Linear/Library'],...
		'position',[70,15,75,20])

add_block('built-in/State-space',[sys,'/','Linear/State-space'])
set_param([sys,'/','Linear/State-space'],...
		'position',[50,325,110,355])

add_block('built-in/Zero-Pole',[sys,'/','Linear/Zero-Pole'])
set_param([sys,'/','Linear/Zero-Pole'],...
		'Poles','[0; -1]',...
		'position',[50,262,95,298])

add_block('built-in/Transfer Fcn',[sys,'/','Linear/Transfer Fcn'])
set_param([sys,'/','Linear/Transfer Fcn'],...
		'Denominator','[1 1]',...
		'position',[55,202,90,238])

add_block('built-in/Derivative',[sys,'/','Linear/Derivative'])
set_param([sys,'/','Linear/Derivative'],...
		'position',[55,160,85,180])

add_block('built-in/Integrator',[sys,'/','Linear/Integrator'])
set_param([sys,'/','Linear/Integrator'],...
		'ForeGround',4,...
		'position',[60,120,80,140])

add_block('built-in/Gain',[sys,'/','Linear/Gain'])
set_param([sys,'/','Linear/Gain'],...
		'position',[60,80,80,100])

add_block('built-in/Sum',[sys,'/','Linear/Sum'])
set_param([sys,'/','Linear/Sum'],...
		'position',[60,40,80,60])


%     Finished composite block 'Linear'.

set_param([sys,'/','Linear'],...
		'position',[150,20,180,70])


%     Subsystem  'Nonlinear'.

new_system([sys,'/','Nonlinear'])
set_param([sys,'/','Nonlinear'],'Location',[0,83,148,689])

add_block('built-in/Transport Delay',[sys,'/','Nonlinear/Transport Delay'])
set_param([sys,'/','Nonlinear/Transport Delay'],...
		'Delay Time','1',...
		'position',[45,450,90,480])

add_block('built-in/Switch',[sys,'/','Nonlinear/Switch'])
set_param([sys,'/','Nonlinear/Switch'],...
		'position',[55,399,80,431])

add_block('built-in/S-function',[sys,'/','Nonlinear/S-function'])
set_param([sys,'/','Nonlinear/S-function'],...
		'position',[40,560,90,580])

add_block('built-in/MATLAB Fcn',[sys,'/','Nonlinear/MATLAB Fcn'])
set_param([sys,'/','Nonlinear/MATLAB Fcn'],...
		'position',[40,505,90,535])

add_block('built-in/Saturation',[sys,'/','Nonlinear/Saturation'])
set_param([sys,'/','Nonlinear/Saturation'],...
		'position',[55,360,80,380])

add_block('built-in/Relay',[sys,'/','Nonlinear/Relay'])
set_param([sys,'/','Nonlinear/Relay'],...
		'position',[55,320,80,340])

add_block('built-in/Look Up Table',[sys,'/','Nonlinear/Look Up Table'])
set_param([sys,'/','Nonlinear/Look Up Table'],...
		'Input_Values','[-10 0 10]',...
		'Output_Values','[-5 0 10]',...
		'position',[55,285,80,305])

add_block('built-in/Note',[sys,'/','Nonlinear/Nonlinear'])
set_param([sys,'/','Nonlinear/Nonlinear'],...
		'position',[65,0,70,5])

add_block('built-in/Note',[sys,'/','Nonlinear/Library'])
set_param([sys,'/','Nonlinear/Library'],...
		'position',[65,15,70,20])

add_block('built-in/Rate Limiter',[sys,'/','Nonlinear/Rate Limiter'])
set_param([sys,'/','Nonlinear/Rate Limiter'],...
		'position',[55,245,80,265])

add_block('built-in/Dead Zone',[sys,'/','Nonlinear/Dead Zone'])
set_param([sys,'/','Nonlinear/Dead Zone'],...
		'position',[55,205,80,225])

add_block('built-in/Backlash',[sys,'/','Nonlinear/Backlash'])
set_param([sys,'/','Nonlinear/Backlash'],...
		'position',[55,165,80,185])

add_block('built-in/Fcn',[sys,'/','Nonlinear/Fcn'])
set_param([sys,'/','Nonlinear/Fcn'],...
		'position',[45,125,85,145])

add_block('built-in/Product',[sys,'/','Nonlinear/Product'])
set_param([sys,'/','Nonlinear/Product'],...
		'position',[55,80,80,100])

add_block('built-in/Abs',[sys,'/','Nonlinear/Abs'])
set_param([sys,'/','Nonlinear/Abs'],...
		'position',[55,40,80,60])


%     Finished composite block 'Nonlinear'.

set_param([sys,'/','Nonlinear'],...
		'position',[210,20,240,70])


%     Subsystem  'Connections'.

new_system([sys,'/','Connections'])
set_param([sys,'/','Connections'],'Location',[128,364,251,599])

add_block('built-in/Note',[sys,'/','Connections/Connections'])
set_param([sys,'/','Connections/Connections'],...
		'position',[65,0,70,5])

add_block('built-in/Note',[sys,'/','Connections/Library'])
set_param([sys,'/','Connections/Library'],...
		'position',[65,15,70,20])

add_block('built-in/Inport',[sys,'/','Connections/Inport'])
set_param([sys,'/','Connections/Inport'],...
		'ForeGround',2,...
		'position',[55,40,75,60])

add_block('built-in/Outport',[sys,'/','Connections/Outport'])
set_param([sys,'/','Connections/Outport'],...
		'ForeGround',2,...
		'position',[55,80,75,100])

add_block('built-in/Demux',[sys,'/','Connections/Demux'])
set_param([sys,'/','Connections/Demux'],...
		'outputs','3',...
		'position',[45,174,85,206])

add_block('built-in/Mux',[sys,'/','Connections/Mux'])
set_param([sys,'/','Connections/Mux'],...
		'inputs','3',...
		'position',[50,124,80,156])


%     Finished composite block 'Connections'.

set_param([sys,'/','Connections'],...
		'position',[280,20,310,70])


%     Subsystem  'Extras'.

new_system([sys,'/','Extras'])
set_param([sys,'/','Extras'],'Location',[0,0,123,235])
set_param([sys,'/','Extras'],...
		'Mask Display','',...
		'Mask Dialogue','eval(''extras'')')


%     Finished composite block 'Extras'.

set_param([sys,'/','Extras'],...
		'position',[350,20,380,70])

% Return any arguments.
if (nargin | nargout)
	% Must use feval here to access system in memory
	if (nargin > 3)
		if (flag == 0)
			eval(['[ret,x0,str]=',sys,'(t,x,u,flag);'])
		else
			eval(['ret =', sys,'(t,x,u,flag);'])
		end
	else
		[ret,x0,str] = feval(sys);
	end
end
