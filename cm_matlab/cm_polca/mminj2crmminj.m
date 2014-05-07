%@(#)   mminj2crmminj.m 1.1   04/07/23     10:30:08
%
%function crmminj = mminj2crmminj(mminj)
function crmminj = mminj2crmminj(mminj)
j = 1;
smminj = size(mminj);
crmminj = zeros(smminj(1)/2, 1);
for i = 1:2:(smminj(1)/2 -1)
  crmminj(j) = floor(mminj(i)/2 + 1);
  j = j + 1;
end
for i = (smminj/2 + 1):2:smminj
  crmminj(j) = floor(mminj(i)/2 + 1);
  j = j + 1;
end
