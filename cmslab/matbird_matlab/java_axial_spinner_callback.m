function java_axial_spinner_callback(cn,y,ax)

global cs;
cs.s(cn).axial_zone(y) = ax;

cs.axial(1)=cs.s(1).axial_zone(1);
for k=2:length(cs.s)
    cs.axial(k)=cs.s(k).axial_zone(k)+cs.axial(k-1);
end


end