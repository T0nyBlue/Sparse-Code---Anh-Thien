function [converted_data] = my_sparse_code_decoder(received_data)
    % Convert received data to user data
    last_three_bits = received_data(end-2:end);

    if isequal(last_three_bits, [1 1 1]) || ...
       isequal(last_three_bits, [1 1 0]) || ...
       isequal(last_three_bits, [1 0 1]) || ...
       isequal(last_three_bits, [0 1 1])

        converted_data = 1 - received_data(1:end-3);
    else
        converted_data = received_data(1:end-3);
    end
end