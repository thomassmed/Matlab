%%
for i = 1:7
    h = 10^-i;
    try
        [t,N1,N2,N3] = ovn1(h);
        h
        exp(2.*h)
    catch me
        break
    end
end
%%
h = 0.1;
[t,N1,N2,N3] = ovn1(h);

R = zeros(size(t));

R = N2 .* (h.^2./2-h.^3./6+h^4./factorial(4)-h.^5./factorial(5));

plot(t,R,t,diff([N1;N2]))
