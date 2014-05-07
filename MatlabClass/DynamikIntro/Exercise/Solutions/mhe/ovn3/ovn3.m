function ovn3()

h = findplot(0,'Tag','OVN3');
figure(h);
num = 1;
den = [1 1];
sys = tf(num,den);

t = linspace(0,20,10000);
y = zeros(1,length(t));
u = sin(t);

for i = 2:length(t)
    dt = (t(i)-t(i-1));
    y(i) = u(i-1).*dt+ (1-dt).*y(i-1);
end

plot(t,u,t,y);

Y = lsim(sys,u,t);
hold all

plot(t,Y);

h = findplot(0,'Tag','OVN3-2');
figure(h);

plot(t,Y-y');

in = cumsum(ones(1,length(num)));
id = cumsum(ones(1,length(den)));

w = 1;
sjw = sum((1j.^(max(in)-in+1).* w .* num))/sum(1j.^(max(id)-id+1).* w .* den);


disp('Förstärkning')
disp(abs(sjw))
disp('Fasmarginal')
disp(angle(sjw))

end