%% --- (Test Vectors) ---

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

Fs = 48000;          
N_samples = 1000;   
t = (0:N_samples-1) / Fs; 

x1 = 0.4*sin(2*pi*1000*t) + 0.4*sin(2*pi*18000*t);
x1_int = round(x1 * 2^15);
write_hex('stimulus_case1.hex', x1_int);

x2 = 0.4*sin(2*pi*1000*t) + 0.4*sin(2*pi*7000*t);
x2_int = round(x2 * 2^15);
write_hex('stimulus_case2.hex', x2_int);

x3 = 0.4*sin(2*pi*1000*t) + 0.4*sin(2*pi*3000*t);
x3_int = round(x3 * 2^15);
write_hex('stimulus_case3.hex', x3_int);
