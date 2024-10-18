clear all
clc

% Init
sigma_mu = [8 9.5 11 12 13 14 15 16];

P = 1/2;
% P = [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9];
% P = 0.5;
% P1 = 2.2e-4;
P1 = 2.1e-4;

N = 56;
packet = 10000000;

diff_bits_no_coding = zeros(1,length(sigma_mu));
diff_bits = zeros(1,length(sigma_mu));

% Create a waitbar
% hWaitbar = waitbar(0, 'Processing...');

% Testing MRAM with Sparse Code and Hamming Code
tic;
parfor ct = 1:length(sigma_mu)
    % Initialize local counter for each parallel worker
    local_diff_bits = 0;

    for page = 1:packet
        disp(['Processing of calculating BER at ' num2str(sigma_mu(ct)) '% : ' num2str((page/packet)*100) '%'])
        % Generate user data
        user_data = double(rand(1,N) >= 0.5);

        % Modulate user data using sparse code
        user_data_sparsecode_modulation = sparse_code_encoder(user_data);
        
        % Encode using hamming code
        code_word = hamming_code_57p63_encoder(user_data_sparsecode_modulation);

        % Passing code word through cascased channel
        received_data = cascased_channel(code_word, sigma_mu(ct)/100);
        % received_data = cascased_channel_with_P1(code_word, sigma_mu(ct)/100, P1);

        % Calculate rth
        % r_th = calc_rth(sigma_mu(ct)/100);
        r_th = optimizing_rth(sigma_mu(ct)/100, P1, P);
        
        % Decode using hamming code
        data_decoded = hamming_code_57p63_decoder(received_data >= r_th, sigma_mu(ct)/100);

        % Demodulation using sparse code
        user_data_sparsecode_demodulation = sparse_code_decoder(data_decoded);

        % output_decoding = (output >= threshold);
        % decoding = my_sparse_code_decoder(output_decoding);

        % Calculate local difference bits
        local_diff_bits = local_diff_bits + sum(abs(user_data - user_data_sparsecode_demodulation));
    end

    % Calculate difference bits
    diff_bits(ct) = local_diff_bits;

    % Update waitbar
    % waitbar(ct / length(sigma_mu), hWaitbar, sprintf('Processing sigma_mu = %.1f', sigma_mu(ct)));
end

% close(hWaitbar); % Close waitbar after completion
toc;


% Draw BER
figure
BER_no_coding = diff_bits_no_coding/(N*packet);
% BER_sc_hm_MRAM_with_P1 = diff_bits/(N*packet);
BER_sc_hm_MRAM = diff_bits/(N*packet);

% file_name = ['BER_my_sparse_code_P_' num2str(P) '_' datetime];
% save(file_name,BER_sc_hm_MRAM);

semilogy(sigma_mu,BER_no_coding,'r');
hold on
semilogy(sigma_mu,BER_sc_hm_MRAM,'--b');
xlabel('\sigma_0/\mu_0')
ylabel('BER')
grid on
legend('No coding','56/63 Sparse code')
axis([8 16 1e-7 1e-1])