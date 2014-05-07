function [k,k0]=get_thneig(ki)
%get_thneig
%
%[k,k0]=get_thneig(ki)
%Hämtar de termohydrauliska grannarna k
%till en termohydraulisk vektor k0. Om
%ki anges fås grannarna till dessa noder.

%@(#)   get_thneig.m 2.2   02/02/27     12:04:13

global geom
nin=geom.nin;
nout=geom.nout;
ncc=geom.ncc;

if nargin==0, 
  k0 = 1:get_thsize;
  k0([1;nin]) = [];
  k = [0 1:(nout(4))];
  k = [k (nin(5)-ncc):nout(5)];
  k = [k nin(6+ncc):(nout(6+ncc)-1)];
  k([1;nin]) = [];
else
  k0 = zeros(1,get_thsize);
  k0(ki) = ki;
  j = find(k0==0);
  k0([1;nin;j'])=[];
  k = [0 1:(nout(4))];
  k = [k (nin(5)-ncc):nout(5)];
  k = [k nin(6+ncc):(nout(6+ncc)-1)];
  k([1;nin;j'])=[];
end
