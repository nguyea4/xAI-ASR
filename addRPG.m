% Add Random phase to the output signal by calculating fft and changing the
% magnitude
function [out_sig, fs] = addRPG(in_sig, fs, win_size)
N = length(in_sig);
start_ind = 1;
end_ind = 0;
out_sig = in_sig; % as place holder

for i = 1: ceil(N/win_size)
    % Update start index and end index
    start_ind = end_ind +1;
    end_ind = start_ind+win_size -1;
    if end_ind > N
        end_ind = N;
    end
    % Get signal within window
    win_sig = in_sig(start_ind:end_ind);
    % Compute magnitude fft of window
    win_absfft = abs(fft(win_sig)); % magnitude we call Y
    % Declare new FFT
    new_fft = win_absfft;
    % Get random real and imaginary party with same magnitude 
    for k = 1:(end_ind-start_ind)
        % Normalized magnitude to one and calculate random numbers
        ak = unifrnd(-1,1); % uniform random distribution from -1 to 1 for real component
        bk = sqrt(1 - ak^2); % mag of bk solves 1 = ak^2 + bk^2. 
            % bk could be negative or positive, flip a coin
        r = unifrnd(0,1);
        bk = -1*(r > 0.5)*bk; % (r>0.5) has 50% chance of being 0 or 1 meaning bk can either be -bk or +bk
        % Scale to new magnitude and combine into complex number
        bin = win_absfft(k)*(ak+1j*bk);  % Magnitude of bin is sqrt(Y^2(ak^2+bk^2))
            % Verify magnitude
        assert(abs(bin) - win_absfft(k) < 1e-6) % verify magnitude is similar within 1e-6 precision
        % Set new fft as this, use fft properties of real signals to fill the rest   
        if mod(win_size,2) == 0 % even length, first and N/2 +1 is unique,  rest are conjugate pairs ( like index 2 and end)
            if k ==1 || k== win_size/2+1
                new_fft(k) = bin;
            else
                new_fft(k) = bin;
                new_fft(end-k+2) = conj(bin);
            end
        else % odd length, first element is unique, the next N/2 are conjugate pairs (index 2 with end, 
            if k ==1 
                new_fft(k) = bin;
            else
                new_fft(k) = bin;
                new_fft(end-k+2) = conj(bin);
            end    
        end
        % convert back to original signal
        new_sig = ifft(new_fft);
        out_sig(start_ind:end_ind) = new_sig;
    end
end

out_sig = real(out_sig); % make sure its real signal
end