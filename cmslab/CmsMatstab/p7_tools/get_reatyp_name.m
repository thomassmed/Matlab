function reatyp_name = get_reatyp_name(reatyp_nr)

switch reatyp_nr
    case 1
        reatyp_name = 'BWR';
    case 2
        reatyp_name = 'PWR';
    otherwise
        warning('Unknown reatyp number!');
end

end