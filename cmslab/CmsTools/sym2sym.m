function dis2=sym2sym(dis1,sym1,sym2,knum1,knum2)
% dis2=sym2sym(dis1,sym1,sym2,knum1,knum2)
if sym1==sym2,
    dis2=dis1;
elseif sym1==1&&sym2==2
    dis2=dis1(:,knum2(:,1));
elseif sym1==2&&sym2==1
    dis2=sym_full(dis1,knum1);
end
