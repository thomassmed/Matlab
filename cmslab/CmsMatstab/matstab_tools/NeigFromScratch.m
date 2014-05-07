function neig=NeigFromScratch(mminj,kmax,knum)
% NeigFromScratch - Generates the neighbour nodes numbering
% 
% neig=NeigFromScratch(knum,mminj,kmax)

%%
iafull=length(mminj);
kan=sum(iafull-2*(mminj-1));
if nargin<3,
    knum=(1:kan)';
end

if nargin<2,
    kmax=25;
end


ntot=kan*kmax;

[x,i]=sort(knum(:,1));
temp(x)=i;

switch size(knum,2)
    case 1
        isym=1;
    case 2
        isym=2;
    case 4
        isym=7;
end
    
corec=vec2cor(temp,mminj);
core=zeros(length(mminj)+2);

if isym==1
  core(2:length(mminj)+1,2:length(mminj)+1)=corec;
  [i,j]=find(core~=0);
  for k=1:length(i),
    neig(core(i(k),j(k)),:)=[core(i(k)-1,j(k)) core(i(k),j(k)+1) core(i(k)+1,j(k)) core(i(k),j(k)-1)];
  end
elseif isym==2
  core(2:length(mminj)+1,2:length(mminj)+1)=rot90(corec,3);
  core(2:length(mminj)+1,2:length(mminj)+1)=core(2:length(mminj)+1,2:length(mminj)+1)+rot90(corec);
  [i,j]=find(core~=0);
  for k=1:length(i)
    if i(k)> length(mminj)/2+1
      neig(core(i(k),j(k)),:)=[core(i(k),j(k)+1) core(i(k)+1,j(k)) core(i(k),j(k)-1) core(i(k)-1,j(k))];
    end
  end
elseif isym==7
  corec=corec+rot90(corec);
  corec=corec+rot90(rot90(corec));
  core(2:length(mminj)+1,2:length(mminj)+1)=corec;
  [i,j]=find(core~=0);
  for k=1:length(i)
    if i(k)> length(mminj)/2+1 && j(k)>length(mminj)/2+1
      neig(core(i(k),j(k)),:)=[core(i(k)-1,j(k)) core(i(k),j(k)+1) core(i(k)+1,j(k)) core(i(k),j(k)-1)];
    end
  end
end

neig=(neig-1)*kmax;
i=find(neig<0);
neig(i)=(ntot+1)*ones(length(i),1);

neig=neig';
neig=neig(:);

neig=neighbour(neig,kmax);