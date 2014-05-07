function t2=raa2dub(raa)

t2=5000./raa; % Rough approximation to get starting guess

for i=1:length(raa(:))
    f=@(x) (dub2raa(x)-raa(i))^2; 
    t2(i)=fminbnd(f,1e-10,1000);
end