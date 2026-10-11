%% --- (Golden Model) ---

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


% (Case 1)
y1 = filter(h_q, 1, x1);
y1_int = round(y1 * 2^15);
write_hex('golden_case1.hex', y1_int);

% (Case 2)
y2 = filter(h_q, 1, x2);
y2_int = round(y2 * 2^15);
write_hex('golden_case2.hex', y2_int);

% (Case 3)
y3 = filter(h_q, 1, x3);
y3_int = round(y3 * 2^15);
write_hex('golden_case3.hex', y3_int);

