function [number,lim]=set_lim(number,lim,kmax,hz,zmin,zmax)
% set_lim - Sets the limit for thermohydraulic parameters reda from restart file

if nargin<5,
    zmin=0;
end
if nargin<6,
    zmax= hz*kmax;
end


lim(find(isnan(lim)))=[];

% TODO fix if zmin<0

if lim(1)>zmin,
    lim=[zmin lim];
elseif lim(1)<zmin,
    lim(1)=zmin;
    if zmin==0,
        number(1)=[];
    end
end

imax=find(lim>zmax);
if length(imax)>1,
    lim(imax(2:end))=[];
    lim(imax(1))=zmax;
end


number=number(1:length(lim)-1);

