function raa=dub2raa(t2,b,al)
% raa=t_dub2raa(t2,b,al);
%
% Input
%   t2 - doubling time
%    b - delayed neutron fraction beta (can be 1 or six groups),
%        default values are used if none is given
%   al - default eigenvalues, needs to be the same dimension as beta,
%        default values are used if none is given
%
% Example:
%  T2=10:100;raa=dub2raa(T2);plot(raa,T2)
%
% See also: pointkin


% default lambda
defal = [0.01269999984652
       0.03170000016689
       0.11500000208616
       0.31099998950958
       1.39999997615814
       3.86999988555908];

% default beta
defbeta = [0.00022220000392
     0.00124899996445
     0.00110300001688
     0.00238600000739 
     0.00075050001033
     0.00015249999706];

switch nargin
    case 1
    % raa = dub2raa(t2)
    % We define lambda and beta
        al = defal;
        b = defbeta;
   
%     % U-235
%     al2 = [0.0124
%          0.0305
%          0.111
%          0.301
%          1.14
%          3.01   ];
% 
%     b2 = [0.000215
%         0.001424
%         0.001274
%         0.002568
%         0.000748
%         0.000273 ];
    case 2
    % raa = dub2raa(t2,b)
    % We got beta and we use a default lambda
        if (length(b) ==1)
            al = log(2)/8;
        elseif (length(b) == 6)
            al = defal;          
        else
            % Not 1 or 6, we don't really know what to do, so we do this:
            warning('We can just have one or six groups delayed neutrons. We default to six.')
            b = defbeta;
            al = defal;
        end
    
    otherwise
    % raa = dub2raa(t2,b,al)
    % We should be good so we don't do anything.
  
    if (length(b) ~= length(al))
        error('beta and lambda should have the same number of elements.')
        return
    end
end

omega=log(2)./t2;

theta=1e-4;

raa=zeros(size(t2));

for i=1:length(t2),
    raa(i)=omega(i)/(omega(i)*theta+1)*(theta+sum(b./(omega(i)+al)))*1e5;
end