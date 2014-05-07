%@(#)   siminput.m 1.2	 97/11/25     08:00:48
%
function siminput
blist=[0 500 1000 1500 2000 2500 3000 3500 4000 4500 5000 5500 6000 6500 6938 6939]';
% Observera sista steget i blist, skall vara 1 EFPH mer sista riktiga steget
bocfile='/cm/f2/c14/bbyt/short/boc.dat';
conrod=['73=8,41=10,57=65'
        '73=8,41=17,57=80'
        '73=8,41=18      '
        '73=8,41=17      '
        '73=8,41=16      '
        '73=8,41=15      '
        '73=8,41=16      '
        '73=8,41=19      '
        '73=8,41=21      '
        '73=8,41=25      '
        '73=8,41=29      '
        '73=8,41=37      '
        '73=21,41=45     '
        '73=45,41=65     '
        '73=45,41=85     '];
filenames=['/cm/f2/c14/bbyt/short/distr-1.dat '
           '/cm/f2/c14/bbyt/short/distr-2.dat '
           '/cm/f2/c14/bbyt/short/distr-3.dat '
           '/cm/f2/c14/bbyt/short/distr-4.dat '
           '/cm/f2/c14/bbyt/short/distr-5.dat '
           '/cm/f2/c14/bbyt/short/distr-6.dat '
           '/cm/f2/c14/bbyt/short/distr-7.dat '
           '/cm/f2/c14/bbyt/short/distr-8.dat '
           '/cm/f2/c14/bbyt/short/distr-9.dat '
           '/cm/f2/c14/bbyt/short/distr-10.dat'
           '/cm/f2/c14/bbyt/short/distr-11.dat'
           '/cm/f2/c14/bbyt/short/distr-12.dat'
           '/cm/f2/c14/bbyt/short/distr-13.dat'
           '/cm/f2/c14/bbyt/short/distr-14.dat'
           '/cm/f2/c14/bbyt/short/distr-15.dat'];
hcf=9900*ones(14,1); hcf(15)=11000;
p=108*ones(15,1);
tlow=274*ones(14,1); tlow(15)=275.1;

% Nedanstående behöver ej ändras

for i=1:size(filenames,1)
  hc(i,1:7)=sprintf('%7.1f',hcf(i));
  pow(i,1:5)=sprintf('%5.1f',p(i));
  tlowp(i,1:5)=sprintf('%5.1f',tlow(i));
  bustep(i,1:4)=sprintf('%4.0f',blist(i+1)-blist(i));
end
!rm simfile.mat
save simfile blist bocfile bustep conrod filenames hc pow tlowp
