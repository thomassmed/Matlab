function [k,b]=profil(x);
%
%[k,b]=profil(x) : k=kamelfaktorn, b=bottenfaktorn
%
%Beraknar graden av "kamel"-formighet och bottenforskjutning
%for en given effektprofil x(1)=botten, x(25)=toppen av harden

k=sum(x(2:8))*sum(x(18:24))/49/10000;
b=sum(x(2:8))/7/100;
