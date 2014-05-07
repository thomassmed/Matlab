%% Exercise Regression
%% 1) confirm that s1=u'Av
A=[1 3;4 2];
[u,s,v]=svd(A)
u(:,1)'*A*v(:,1)
s(1)
%% 1), s(2)
u(:,2)'*A*v(:,2)
s(2,2)
%% Indeed, it is easier to just conclude that
u'*A*v
%% is equal to
s
%% 2) Confirm that A*v1=s1*u1
A*v(:,1)
s(1)*u(:,1)
%% A*v2=s2*v2
A*v(:,2)
s(2,2)*u(:,2)
%% Of course, this is a special case of u*s = A*v:
u*s
A*v
%% 3) Compare your fit for Mueleberg with the one in the word document
%% Import data
filename='../KKM_kregr.xls';
[num,txt]=xlsread(filename);
%% Put the data into variables
t=datenum(txt(3:end,2))+num(:,3);
keff=num(:,7);
Q=num(:,5);
W=num(:,6);
E=num(:,4);
Case=num(:,1);
%% prepare variables for ls-fit
i0=352;
i1=381;
w=W(i0:i1)/100;
q=Q(i0:i1)/100;
kef=keff(i0:i1);
%% 1st order in flow
ett=ones(size(q));
A1=[ett q w];
p1=A1\kef;
fprintf('%9.5f%11.7f%12.8f\n',p1);
%% These are different from 0.99423 0.0091582 0.00068218
A11=[ett q];
p11=A11\kef;
fprintf('%9.5f%11.7f\n',p11);
% Now we seem to get the q-cofficient to be the same as in the document
%% To get the other coefficients:
A12=[ett w];
p12=A12\(kef-A11*p11); % Take the remains that are not explained by the variation in q
ptot1=[p11(1)+p12(1);p11(2);p12(2)];
fprintf('%9.5f%11.7f%12.8f\n',ptot1);
% Now we are spot on
%% Second order:
A22=[ett w w.^2];
p22=A22\(kef-A11*p11); % Take the remains that are not explained by the variation in q
ptot2=[p11(1)+p22(1);p11(2);p22(2);p22(3)];
fprintf('%9.5f%11.7f%11.6f%10.6f\n',ptot2);
%% Third order:
A32=[ett w w.^2 w.^3];
p32=A32\(kef-A11*p11); % Take the remains that are not explained by the variation in q
ptot3=[p11(1)+p32(1);p11(2);p32(2);p32(3);p32(4)];
fprintf('%9.5f%11.7f%10.5f%8.4f%10.5f\n',ptot3);
%% 4) Can we make a better fit?
isel=E>300;
e=(E(isel)-3000)/10000;
ett=ones(size(e));
q=(Q(isel)-100)/100;
w=(W(isel)-95)/100;
A=[ett e e.^2 q w];
pe=A\keff(isel);
fprintf('%9.5f%11.6f%11.6f%11.6f%11.6f\n',pe);
%% It is encouraging that the coefficients for q and w appear to be stable
%% Look at the svd
[u,s,v]=svd(A,0);
s,v
%% Compare
v(4:5,3)
s(3,3)
%% with
v(4:5,5)
s(5,5)
%% Clearly the information in the A-A direction is better, but the info in B-B is not that bad.
%% A reasonable approach would be to use the coefficients for q and w and apply it as a 
%% deviation from the established present k-effective at the nominal point. A filter 
%% could be installed that keeps track of the present 'base level' for k-effective in 
%% order to deal with the dependence of burnup and other long term dependicies.
%% As an indication of increased degree of robustness, compare the size of A with the size of A1:
size(A)
size(A1)