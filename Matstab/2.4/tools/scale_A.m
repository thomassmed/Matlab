function A = scale_A(A)
%scale_A
%
%A = scale_A(A)
%Scales A to make it well conditioned

%@(#)   scale_A.m 1.3   02/02/27     12:13:50

global geom neu

ncc=geom.ncc;
kan=geom.kan;
kmax=geom.kmax;
n_neu_tfuel=neu.n_neu_tfuel;

hydsize = get_hydsize;
kv = zeros(hydsize,1);
ke = zeros(hydsize,1);

kv(1) = 1e6;
ke(1) = 1e-6;
if kan>10,Wl_sc=1;else,Wl_sc=1e3;end

%Variabler
k1 = [1            %mg
      1e8          %E
      1            %alfa
      Wl_sc        %Wl
      1            %Gammav
      1e8          %qprimw
      1            %tl
      1            %tw
      1            %Wg
      1            %wg
      1            %S
      1            %jm
      1];          %phi
%Ekvationer

k2 = [1            
      1e-8        
      1        
      1/Wl_sc
      1      
      1e-8     
      1       
      1    
      1  
      1
      1     
      1    
      1]; 

for n = 1:get_varsize,
  j = ind_tnk(n,get_varsize);
  kv(j) = ones(length(j),1)*k1(n);
  ke(j) = ones(length(j),1)*k2(n);
end

j = get_thsize*get_varsize+2;
kv(j:(j+ncc)) = ones(ncc+1,1)*1e3;     %I
ke(j:(j+ncc)) = ones(ncc+1,1)*1e-3;     %I

j = get_thsize*get_varsize+3+ncc;
kv(j) = 1;                          %n hcpump
ke(j) = 1;                          %n hcpump
kv(j+1) = 1e4;                      %p hcpump
ke(j+1) = 1e-4;                     %p hcpump

ibas = get_hydsize + (0:kan*kmax-1)'*n_neu_tfuel;

k1 = [1e14
      1e14
      1e14
      1e14
      1
      1e6
      1
      1
      1
      1
      1
      1];

k2 = [1e-14
      1e-14
      1e-14
      1e-14
      1
      1e-6
      1
      1
      1
      1
      1
      1];

for n=1:n_neu_tfuel,
  kv(ibas+n) = ones(length(ibas),1)*k1(n);
  ke(ibas+n) = ones(length(ibas),1)*k2(n);
end

nmax = get_hydsize + n_neu_tfuel*kan*kmax;  
se = spdiags(ke,0,nmax,nmax);
sv = spdiags(kv,0,nmax,nmax);

A = se*A*sv;
