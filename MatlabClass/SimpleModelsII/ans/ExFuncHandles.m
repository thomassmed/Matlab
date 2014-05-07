%% Exercise Function handles 1
% Use the function h_v to plot the enthalpy as a function of temperature in the interval 250 to
% 286 C for 70 Bars (7e6 Pa). Note that h_v require Pascal and K as input, 0 C = 273.15 K!
p=7e6;
T=250:.01:285;
plot(T,h_v(T+273.15,p));
xlabel('Temp (^oC)')
ylabel('Entalpi (kJ/kg)')
title('Entalpi som funktion av temperatur vid 70 Bar');
grid
%% Write a Newton-Raphson to solve for temperature if the enthalpy is 1200 kJ/kg.
f=@(T) h_v(T,7e6)-1200;
p=7e6;h=0.01;
x=250+273.13;
for i=1:10,
    f0=f(x)
    if abs(f0)<1e-6, break;end
    dfdx=(f(x+h)-f0)/h;
    %dfdx=5;
    dx=-f0/dfdx;
    x=x+dx;
end
fprintf(1,'Temperatur vid 1200 kj/kg: %6.2f \n',x-273.15);
%% Use fzero to solve for the Temperature
y=fzero(f,250+273.15)-273.15
%% Play around with options to explore what is going on inside:
opt=optimset(@fzero);
opt.Display='iter';
fzero(f,250+273.15,opt);