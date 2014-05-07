function [sys,x0,str,ts] = punktkin(t,x,u,flag)
%Punktkinetikmodell för modellering i simulink
%[sys,x0,str,ts] = punktkin(t,x,u,flag)
%
% Öppna modellen med simulinks funktionsblock s-function
%
% u = R, öveskottsreaktivivtet 
%
% [sys,x0] = punktkin(t,x,R,0); ger systembeskrivning och initialgissning
% dx = punktkin(t,x,R,1); ger dy/dt
% dy = punktkin(t,x,R,3);


%Påk 2004-08-04

al =[0.01269999984652
     0.03170000016689
     0.11500000208616
     0.31099998950958
     1.39999997615814
     3.86999988555908];

b=[0.00022220000392
   0.00124899996445
   0.00110300001688
   0.00238600000739
   0.00075050001033
   0.00015249999706];


switch flag,

  %%%%%%%%%%%%%%%%%%
  % Initialization %
  %%%%%%%%%%%%%%%%%%
  case 0,
    [sys,x0,str,ts]=mdlInitializeSizes(b,al);

  %%%%%%%%%%%%%%%
  % Derivatives %
  %%%%%%%%%%%%%%%
  case 1,
    sys=mdlDerivatives(t,x,u,b,al);

  %%%%%%%%%%%
  % Outputs %
  %%%%%%%%%%%
  case 3,
    sys=mdlOutputs(t,x);

  %%%%%%%%%%%%%%%%%%%
  % Unhandled flags %
  %%%%%%%%%%%%%%%%%%%
  case { 2, 4, 9 },
    sys = [];

  %%%%%%%%%%%%%%%%%%%%
  % Unexpected flags %
  %%%%%%%%%%%%%%%%%%%%
  otherwise
    error(['Unhandled flag = ',num2str(flag)]);

end
% end punktkin

%
%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================
%
  function [sys,x0,str,ts]=mdlInitializeSizes(b,al)

sizes = simsizes;
sizes.NumContStates  = 7;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 1;
sizes.NumInputs      = 1;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;

sys = simsizes(sizes);
x0  = [1;b./al];
str = [];
ts  = [0 0];

% end mdlInitializeSizes
%
%=============================================================================
% mdlDerivatives
% Return the derivatives for the continuous states.
%=============================================================================
%
function sys=mdlDerivatives(t,x,u,b,al)

LAM=1e-4;
sys=[(u-sum(b))/LAM*x(1)+al'*x(2:7)/LAM;b*x(1)-al.*x(2:7)];

% end mdlDerivatives
%
%=============================================================================
% mdlOutputs
% Return the block outputs.
%=============================================================================
%
function sys=mdlOutputs(t,x)

sys = x(1);

% end mdlOutputs
