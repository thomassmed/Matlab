function exchange(~,~,hfig)

CmsCoreProp=get(hfig,'userdata');

left=cpos2knum(CmsCoreProp.i(1),CmsCoreProp.j(1),CmsCoreProp.core.mminj);
middle=cpos2knum(CmsCoreProp.x,CmsCoreProp.y,CmsCoreProp.core.mminj);


power_left=CmsCoreProp.core.s(left).power;
power_middle=CmsCoreProp.core.s(middle).power;
CmsCoreProp.core.s(middle).power=power_left;
CmsCoreProp.core.s(left).power=power_middle;

burnup_left=CmsCoreProp.core.s(left).burnup;
burnup_middle=CmsCoreProp.core.s(middle).burnup;
CmsCoreProp.core.s(middle).burnup=burnup_left;
CmsCoreProp.core.s(left).burnup=burnup_middle;

dens_left=CmsCoreProp.core.s(left).dens;
dens_middle=CmsCoreProp.core.s(middle).dens;
CmsCoreProp.core.s(middle).dens=dens_left;
CmsCoreProp.core.s(left).dens=dens_middle;

void_left=CmsCoreProp.core.s(left).void;
void_middle=CmsCoreProp.core.s(middle).void;
CmsCoreProp.core.s(middle).void=void_left;
CmsCoreProp.core.s(left).void=void_middle;

evoid_left=CmsCoreProp.core.s(left).evoid;
evoid_middle=CmsCoreProp.core.s(middle).evoid;
CmsCoreProp.core.s(middle).evoid=evoid_left;
CmsCoreProp.core.s(left).evoid=evoid_middle;

kinf_left=CmsCoreProp.core.s(left).kinf;
kinf_middle=CmsCoreProp.core.s(middle).kinf;
CmsCoreProp.core.s(middle).kinf=kinf_left;
CmsCoreProp.core.s(left).kinf=kinf_middle;



set(hfig,'userdata',CmsCoreProp);
paint_core([],[],hfig);

end

