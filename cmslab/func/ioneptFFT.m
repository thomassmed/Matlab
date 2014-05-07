function y=ioneptFFT(t,Y,f)

test=exp(1j*2*pi*f*t);
y=real(Y*test);



