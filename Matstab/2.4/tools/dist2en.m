function [e0,xi]=dist2en(distfile);
%[e0,xi] = dist2en(distfile);
%
%en is the starting guess on neutronic eigenvector
%xi is the number of the channel that has the highest mean power

%@(#)   dist2en.m 1.8   02/02/27     21:38:24

global msopt geom vec steady

isym=msopt.CoreSym;
kan=geom.kan;
kmax=geom.kmax;
knum=geom.knum;
r=geom.r;
jt=vec.t;

if nargin==1,
  e0=readdist(distfile,'power');
else
  e0=steady.Ppower;
end

startvinkel=-[0 0 0 0 1 2 5 8 11 15 19 23 27 31 35 39 42 45 48 50 52 54 55 56 56]';

[x,xi] = max(mean(e0));
e0=e0(:,knum(:,1));
for i=1:25
  e0(i,:)=-e0(i,:)*exp(pi*1j*startvinkel(i)/180);
end
e0=e0(:);

%Fix node in the system

e0tmp = reshape(e0,kmax,kan);

[enmax,enmaxi]=max(mean(e0tmp));
node=(enmaxi-1)*kmax+22;
efix=find(jt==r(node));

let=length(jt);
ett=zeros(1,let);
ett(efix)=1;

vec.e0=e0;
vec.efix=efix;
vec.let=let;
vec.ett=ett;
