function [i_a,j_a,x_a]=get_index4AI(varargin)
nvar=nargin-1;
ncc=varargin{1};
l_vec=length(varargin{2});
i_i=zeros(1,l_vec*ncc);
j_i=zeros(ncc,l_vec);
for i=1:nvar,
  C{i}=j_i;
end
for i=1:l_vec,
    istart=(i-1)*ncc+1;
    istop=i*ncc;
    i_i(istart:istop)=1:ncc;
    j_i(:,i)=ones(ncc,1)*(i-1)*nvar;
    for j=1:nvar
      C{j}(:,i)=ones(ncc,1)*varargin{j+1}(i);
    end
end
j_i=j_i(:)';
i_a=zeros(1,ncc*l_vec*nvar);
j_a=i_a;
x_a=i_a;
for j=1:nvar
    istart=(j-1)*l_vec*ncc+1;
    istop=j*l_vec*ncc;
    i_a(istart:istop)=i_i;
    j_a(istart:istop)=j_i+j;
    x_a(istart:istop)=C{j}(:)';
end
