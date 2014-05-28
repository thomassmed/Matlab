function sym_name = get_sym_name(sym_nr)

switch sym_nr
    case 1
        sym_name = 'FULL';
    case 2
        sym_name = 'HMIR';
    case 3
        sym_name = 'HROT';
    case 4
        sym_name = 'QMIR';
    case 5
        sym_name = 'QROT';
    case 6
        sym_name = 'PERIODIC'
    otherwise
        disp('Unknown core symmetry option!');
end

end