function [converted_data] = my_sparse_code_decoder(received_data)
    % Convert received data to user data
    last_bit = received_data(end);

    if isequal(last_bit, [1])
        converted_data = 1 - received_data(1:end-1);
    else
        converted_data = received_data(1:end-1);
    end
end