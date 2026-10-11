clc;
clearvars -except Num;

if exist('Num', 'var')
    h = Num;
end

h_int = round(h * 2^15);

h_q = h_int / 2^15;

fvtool(h, 1, h_q, 1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function write_hex(filename, q_int)
    % Write a vector of Q1.15 integers as one 4-digit hex value per line,
    % two's-complement, ready for $readmemh in Verilog.
    fid = fopen(filename, 'w');
    for k = 1:length(q_int)
        fprintf(fid, '%s\n', dec2hex(typecast(int16(q_int(k)), 'uint16'), 4));
    end
    fclose(fid);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

write_hex('fir_coeffs.hex', h_int);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

