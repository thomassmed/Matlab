function hf=entT(T)
%function hf=entT(T)
% Mavaentalpi ur mavatemp
Th=T/100.0;
TT=[1 Th Th^2 Th^3 Th^4 Th^5];
bb=[-41.88919 
    571.00460
   -191.80500 
    116.76980
    -34.08195
      4.153846];
hf=TT*bb;
end
