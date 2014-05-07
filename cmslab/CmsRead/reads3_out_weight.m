function [W] = reads3_out_weight(blob, cr)
% Input:
% outfile  - name of out file that ran the adaption case
% Output:
% W - num_cases x 5 x 5 matrix of assembly weighting factors

if nargin<2,
    cr=find(blob==10);
    if length(cr)<1,
        blob=read_simfile(blob);
        cr=find(blob==10);
    end
end

if (strfind(blob, 'Power Spatial Weighting Factors Are:'))
    iE = strfind(blob, 'Power Spatial Weighting Factors Are:'); % find the data
else
    W = [1.000  0.667  0.333  0.0001 0.0001;
         0.667  0.667  0.333  0.0001 0.0001;
         0.333  0.333  0.333  0.0001 0.0001;
         0.0001 0.0001 0.0001 0.0001 0.0001;
         0.0001 0.0001 0.0001 0.0001 0.0001;
        ];
    return;
end

icr = find(cr > iE(1), 1 );                               % find the carriage return right after the 'Power Spatial' statement

% read the weighting values from the output file
counter = 1;
for i = 1 : 5
    read_line = blob( (cr(icr-1) + 1):(cr(icr) - 1) );    % read the line following the 'DET.DIS' statement
    icr = icr + 1;
    % read the first line
    if (i == 1)
        read_line(1 :  strfind(read_line, ':')) = [];
    end
    w = sscanf(read_line, '%g')';
    for j = 1 : length(w)
        weights(counter) = w(j);
        counter = counter + 1;
    end
end

% put the weighting values into the matrix
W(1, 1) = weights(1);
W(1, 2) = weights(2);
W(1, 3) = weights(3);
W(1, 4) = weights(4);
W(1, 5) = weights(5);
W(2, 1) = weights(2);
W(2, 2) = weights(6);
W(2, 3) = weights(7);
W(2, 4) = weights(8);
W(2, 5) = weights(9);
W(3, 1) = weights(3);
W(3, 2) = weights(7);
W(3, 3) = weights(10);
W(3, 4) = weights(11);
W(3, 5) = weights(12);
W(4, 1) = weights(4);
W(4, 2) = weights(8);
W(4, 3) = weights(11);
W(4, 4) = weights(13);
W(4, 5) = weights(14);
W(5, 1) = weights(5);
W(5, 2) = weights(9);
W(5, 3) = weights(12);
W(5, 4) = weights(14);
W(5, 5) = weights(15);    