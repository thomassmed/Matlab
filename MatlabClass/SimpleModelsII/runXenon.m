%% Calculate the equilibrium Iodine and Xenon
setupXenon
%% Read the result from the detail core monitoring simulation
readXenon
%% Simulate with the simplified model
[t,y]=ode45(@xenon,[0 3600*30],[Ieq;Xeq]);
%% Compare the results 
figure
plot(x(:,end),x(:,6));
hold on
plot(t/3600,y(:,2)/1e12,'r');
xlabel('Time (h)')
ylabel('Xenon concentration T/cm^3')
set(gcf,'InvertHardcopy','off','Color',[1 1 1]);
legend('POLCA','Simplified model')
