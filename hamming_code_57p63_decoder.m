function [signal_decoded] = hamming_code_57p63_decoder(received_signal, spm)
    % Init
    parity_check_matrix = [0 0 0 0 1 1; 
                           0 0 0 1 0 1; 
                           0 0 0 1 1 0; 
                           0 0 0 1 1 1; 
                           0 0 1 0 0 1; 
                           0 0 1 0 1 0; 
                           0 0 1 0 1 1; 
                           0 0 1 1 0 0;
                           0 0 1 1 0 1; 
                           0 0 1 1 1 0; 
                           0 0 1 1 1 1; 
                           0 1 0 0 0 1; 
                           0 1 0 0 1 0; 
                           0 1 0 0 1 1; 
                           0 1 0 1 0 0; 
                           0 1 0 1 0 1;
                           0 1 0 1 1 0; 
                           0 1 0 1 1 1; 
                           0 1 1 0 0 0; 
                           0 1 1 0 0 1; 
                           0 1 1 0 1 0; 
                           0 1 1 0 1 1; 
                           0 1 1 1 0 0; 
                           0 1 1 1 0 1;
                           0 1 1 1 1 0;
                           0 1 1 1 1 1; 
                           1 0 0 0 0 1; 
                           1 0 0 0 1 0; 
                           1 0 0 0 1 1; 
                           1 0 0 1 0 0; 
                           1 0 0 1 0 1; 
                           1 0 0 1 1 0;
                           1 0 0 1 1 1; 
                           1 0 1 0 0 0; 
                           1 0 1 0 0 1; 
                           1 0 1 0 1 0; 
                           1 0 1 0 1 1; 
                           1 0 1 1 0 0; 
                           1 0 1 1 0 1; 
                           1 0 1 1 1 0;
                           1 0 1 1 1 1; 
                           1 1 0 0 0 0; 
                           1 1 0 0 0 1; 
                           1 1 0 0 1 0; 
                           1 1 0 0 1 1; 
                           1 1 0 1 0 0; 
                           1 1 0 1 0 1; 
                           1 1 0 1 1 0;
                           1 1 0 1 1 1; 
                           1 1 1 0 0 0; 
                           1 1 1 0 0 1; 
                           1 1 1 0 1 0; 
                           1 1 1 0 1 1; 
                           1 1 1 1 0 0; 
                           1 1 1 1 0 1; 
                           1 1 1 1 1 0; 
                           1 1 1 1 1 1];
    
    mu0 = 1;
    mu1 = 2;

    p0 = 1e-6;
    p1 = 1.02*1e-4;

    % Calculate sigma
    sigma0 = mu0*spm;
    sigma1 = mu1*spm;

    % Calculate q0, q1
    q0 = 1-p0;
    q1 = 1-p1;

    % Calculate r_th
    a = sigma0^2 - sigma1^2;
    b = 2*(mu0*sigma1^2 - mu1*sigma0^2);
    c = mu1^2*sigma0^2 - mu0^2*sigma1^2 + log(((p1-q0)/(p0-q1))*(sigma1/sigma0));

    delta = b^2 - 4*a*c;
    r_th = ((-b+sqrt(delta))/(2*a));
    if r_th <= 0
        r_th = ((-b-sqrt(delta))/(2*a));
    end

    % Calculate the transpose
    parity_check_matrix_T = parity_check_matrix';

    H = [parity_check_matrix_T eye(6)];

    HT = H';

    % received_signal_hard = received_signal > r_th;

    error = mod(received_signal * HT, 2);  % Calculate syndrome

    if isequal(error, [0 0 0 0 0 0])  % If no error is detected
        signal_decoded = received_signal(1:end-6);  % Signal is already correct
    else
        % Find the position of bit error
        [val position] = min(sum(abs(error - HT),2));

        % Correct the bit at the found error position
        if received_signal(1, position) == 0
            received_signal(1, position) = 1;
        else
            received_signal(1, position) = 0;
        end
        
        signal_decoded = received_signal(1:end-6);  % Return the corrected signal
    end
end