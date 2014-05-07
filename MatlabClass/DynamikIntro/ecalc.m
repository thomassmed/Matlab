%% Beräkning av e
h=1;
format dcompact
format compact
while h>2*eps,
    h=h/2;
    e=(1+h)^(1/h);
    disp([h e]);
end
