function dist = matstab2polca(dat)
%dist=matstab2polca(dat)
%
%Gives a POLCA-distribution whith the data i dat
%dat kan be steady state for fuel or thermo hydraulics
%or an eigen vector

global fuel steady termo polcadata msopt geom

isfuel=0;isthermo=0;iseigenvector=0;

switch length(dat),
  case geom.ntot
    isfuel=1;
  case length(geom.A)
    isthermo=1;
  case max(geom.k+11)
    iseigenvector=1;
  otherwise
    error('Vector length is wrong')
end

knum=geom.knum;
kan=geom.kan; 
kmax=geom.kmax;
kanram = length(geom.r)/kmax;

if isthermo,
num=1:kan;
  j=zeros(kmax+1,kan);
  for i=1:kan
    j(:,i)=(geom.nin(4+num(i)):(geom.ncc+1):geom.nout(4+num(i)))';
  end
  j(1,:)=[];
  j=j(:)';
  dist=zeros(kmax,kan);
  dist(:,knum(:,1))=reshape(dat(j),kmax,kanram);
  if msopt.CoreSym==2,
    dist(:,knum(:,2))=dist(:,knum(:,1));
  end
end

if isfuel,
  dist=zeros(kmax,kan);
  dist(:,knum(:,1))=reshape(dat,kmax,kanram);
  if msopt.CoreSym==2,
    dist(:,knum(:,2))=dist(:,knum(:,1));
  end
end

if iseigenvector,
  dist.void=zeros(kmax,kan);
  dist.void(:,knum(:,1))=reshape(dat(geom.r),kmax,kanram);
  if msopt.CoreSym==2,
    dist.void(:,knum(:,2))=dist.void(:,knum(:,1));
  end
  dist.fa1=zeros(kmax,kan);
  dist.fa1(:,knum(:,1))=reshape(dat(geom.k),kmax,kanram);
  if msopt.CoreSym==2,
    dist.fa1(:,knum(:,2))=dist.fa1(:,knum(:,1));
  end
end
