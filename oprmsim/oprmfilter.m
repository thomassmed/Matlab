% Filter (2nd order Butterworth using bilinear transformation)
% Input:
%	t		Time vector
%	x		Unfiltered signal
%	fc		Corner frequency
%	T 		Sampling intervall
%
% Output:
%	y		Filtered signal

function y=oprmfilter(t,x,fc,T)

tlength = size(t,1);	% Length of data
nsignal = size(x,2);	% Number of signals

y = zeros(tlength+2,nsignal);

F0 = (2/T)*(atan(2.0*pi()*fc*T/2));
DEN = (4/T^2) + 2.828*F0/T + F0^2;

a = F0^2/DEN;
b = (-8/T^2 + 2*F0^2)/DEN;
c = ((4/T^2) - 2.828*F0/T + F0^2)/DEN;

t = [ t(1,1); t(1,1); t(:,1)];
x = [x(1,:); x(1,:); x(1:end,:)];


for n=1:nsignal

	y(1:2,n) = x(1,n);

	for i=3:tlength + 2
		y(i,n) = a*(x(i-2,n) + 2*x(i-1,n) + x(i,n)) - (b*y(i-1,n) + c*y(i-2,n));
	end
	
end

y = y(3:end,:);
