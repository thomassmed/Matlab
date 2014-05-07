function [N,T] = loanPayments(r,A,P)
% LOANPAYMENTS  Solution to "Loan Function" exercise.
%    Inputs are, in order, the rate of the loan (per period), the initial
%    amount of the loan, and the payment per period.  The outputs are the 
%    number of payments it will take to pay off the loan and the total
%    interest paid on the loan.
%
%    Example: 
%    If you have a loan of $10000 at 5% annually and 
%    are paying $250 per month:
%
%    [N,T] = loanPayments(0.05/12,10000,250)
%    N =
%       43.8483
%    T =
%      962.0678
%
%    It will take 44 payments to pay off the loan and 
%    the total interest paid will be $962.07.

% 1.  Declare the function.  See line 1.
% 2.  Calculate N and T. No "loop" is needed due to vectorized operations, but we should use one to practice.

% Non-vectorized
T = zeros(1,length(P));
for j = 1:length(P)
    N = -log(1-r*A/P(j))/log(1+r);
    T(j) = N*P(j)-A;
end

% Vectorized
N = -log(1-r*A./P)./log(1+r);
T = N.*P-A;
