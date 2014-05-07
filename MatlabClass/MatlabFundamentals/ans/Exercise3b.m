%% Exercise 3b
%% Calculate the number of elements that are greater than 0.8
A=rand(1000);
sum(A(:)>.8)/numel(A)