function stat=get_bool(inarg)

stat=inarg;

if ischar(inarg)
    if strcmpi(inarg,'on')||strcmpi(inarg,'1')||strcmpi(inarg,'true')||strcmpi(inarg,'yes')
        stat=true;
    elseif strcmpi(inarg,'off')||strcmpi(inarg,'0')||strcmpi(inarg,'false')||strcmpi(inarg,'no')
        stat=false;
    end
elseif isnan(inarg)
    stat=false;
end
    