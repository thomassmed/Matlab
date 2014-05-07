function [e1 e2 e3] = coordconv(x,y,z,option)

%% answer to exercise scripts and functions
% 1. and 2. see case 'polar'
% 3. case 'cylindrical' and 'polar' same structure as in if case below
% 4. everyting exept elseif nargin <4


%% Take care of different amount of input parameters
if nargin ==2
    option = 'polar';
elseif nargin <4
    option = 'cylindrical';
end

%% switch case for different options
switch option
    case 'spherical'
        e1 = sqrt(x.^2 + y.^2 + z.^2);
        e2 = atan2(y,x);
        e3 = atan2(sqrt(x.^2 + y.^2),z);
        
    case 'cylindrical'
        e1 = sqrt(x.^2 + y.^2);
        e2 = atan2(y,x);
        e3 = z;
    case'polar'
        e1 = sqrt(x.^2 + y.^2);
        e2 = atan2(y,x);
end
    
