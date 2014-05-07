function yp=f(t,y,T,K,u,t0)

u0=interp1(t0,u,t);

yp=-y/T+K/T*u0;