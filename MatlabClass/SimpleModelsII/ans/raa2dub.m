function t2=raa2dub(raa)

t2=5000./raa; % Rough approximation to get starting guess

for i=1:length(raa(:))
    f=@(x) dub2raa(x)-raa(i); 
    t2(i)=fzero(f,t2(i));
end