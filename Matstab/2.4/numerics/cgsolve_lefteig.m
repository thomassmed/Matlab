
x = vq;
b0 = Xvn;

vtq=uaft\(laft\(Aqt'*x));                         
Yvq=Atqf*vtq+AVA*(AAA*vtq);  
Ax=x-Yvq;

r = b0 - Ax;
rtr = r'*r;
p = zeros(size(b0));
bet = 0;

num = 0;
while (norm(r) > tol_lefteig*norm(b0)),
  p = r + bet*p;
  vtq=uaft\(laft\(Aqt'*p));
  Yvq=Atqf*vtq+AVA*(AAA*vtq);
  Ap = p-Yvq;
  alpha = rtr/(p'*Ap);
  x = x + alpha*p;
  r = r - alpha*Ap;
  rtrold = rtr;
  rtr = r'*r;  
  bet = rtr/rtrold;
  num = num + 1;
  if 0,
    disp(['Iter.no q: ' num2str(num) ' Err: ' num2str(norm(r)/norm(b0))])
  end
  if num==maxiter,break,end
end
vq=x;
vtq=uaft\(laft\(Aqt'*vq));
