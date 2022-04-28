% assume in_sig is N x 1
% Invert each time-domain window size in each audio sample
function [out_sig, fs] = addTDI(in_sig, fs, win_size)
N = length(in_sig);
start_ind = 1;
end_ind = 0;
out_sig = in_sig;
% For each window frame, invert the signal
for i = 1: ceil(N/win_size)
    start_ind = end_ind +1;
    end_ind = start_ind+win_size -1;
    if end_ind > N
        end_ind = N;
    end
    temp = in_sig(end_ind: -1: start_ind); % inverse of window
    out_sig(start_ind:end_ind) = temp;
end