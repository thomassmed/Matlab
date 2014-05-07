function java_writecaifile(cn,option)

global cs;


if(isempty(cs.s(cn).caifile))
    cs.s(cn).caifile=strrep(cs.s(cn).caxfile,'cax','inp');
end

% cs.s(cn).writecaifile(HotBirdProp.cs.s(cn).caifile,option)
cs.s(cn).writecaifile(cs.s(cn).caifile,option)



end





