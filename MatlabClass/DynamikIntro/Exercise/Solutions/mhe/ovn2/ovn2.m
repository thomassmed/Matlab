function ovn2(k,c)


% Find plot and reuse, delete all but last
h = findplot(0,'Tag','OVN2');
figure(h);
% Create state-space matrices
A = [0 1; -k -c];
B = zeros(size(A));
C = eye(2);
D = [];
sys = ss(A,B,C,D);


eig(A)
dt=0.001;
t = 0:dt:10;
x = zeros(2,length(t));
x(:,1) = [1 -0.1];
for i = 2:length(t)
    x(:,i) = x(:,i-1)+dt*A*x(:,i-1);
end

Y = lsim(sys,zeros(2,length(t)),t,[1 -0.1]);
plot(t,x)
hold all
plot(t,Y);
hold off

dts = [1 10 50 100];
% 
% for i = 1:length(dts)
%     pause;
%     Eulerex(dts(i)./1000)
% end

[v,e] = eig(A);

hold off
plot(t,x);
hold all
plot(t,exp(real(e(1,1)).*t)); % Damping
h = findplot(0,'Tag','OVN2-2');
figure(h);
compass(v);

end

