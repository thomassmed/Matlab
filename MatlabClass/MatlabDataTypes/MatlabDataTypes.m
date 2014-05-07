%% Cell Arrays
x = {'hello';'ciao';'guten tag'};
y = {pi,[];'foo',42;ones(2),eye(3)};
z1 = {x,y};
z2 = {x;y};
z3=[x;y(:,1)];
%% Working with dates
x = datenum('1/2/03');
datestr(x)
datestr(x,'dd-mmm-yyyy');

%% Structures
S.apples = 42;
S.oranges = magic(3);
S.bananas = 'green';
%
%x = sin(S.cheese);
x = sin(S.apples);
%
S(1).a = 42;
S(2).a = pi;
S
%
S(1).b = 42;
S(2)
%
S(3).a = magic(3);
S(4).b = 'hello';
%
S(3)
S.a
S([1,3])
S(1:3).a
%
[S(1:2).a]
{S(1:3).a}