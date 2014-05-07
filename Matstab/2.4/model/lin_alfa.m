function mg_c=lin_alfa(alfa,P,V)
%lin_alfa
%
%[P_c,mg_c]=lin_alfa(alfa,P,V)
%Beräknar koefficienterna för variablerna i linjäriserade
%voidekvationen EKV 6.4.27

%@(#)   lin_alfa.m 2.2   01/09/23     16:09:28

global DRog_DP

%Initiering
Tsat=cor_tsat(P);
Rog=cor_rog(Tsat);

mg_c = 1./Rog./V;
j = find(alfa<=0);
mg_c(j) = zeros(length(j),1);
mg_c(1) = 0;

%Reduced:
%P_c = -alfa./Rog*DRog_DP;
%P_c(j) = zeros(length(j),1);
%P_c(1) = 0;
