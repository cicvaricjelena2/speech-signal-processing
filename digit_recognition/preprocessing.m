function signal_out = preprocessing(signal_in, fs)

signal = signal_in / max(abs(signal_in));

% uklanjanje tisine sa pocetka i kraja
frame_len  = round(0.02 * fs);
frame_step = round(0.01 * fs);
threshold  = 0.02;

num_frames = floor((length(signal) - frame_len) / frame_step) + 1;
energy = zeros(1, num_frames);

for i = 1:num_frames
    start_idx = (i-1)*frame_step + 1;
    frame = signal(start_idx : start_idx + frame_len - 1);
    energy(i) = sum(frame.^2) / frame_len;
end

energy = energy / max(energy);

active = find(energy > threshold);

if isempty(active)
    signal_out = signal;
    return;
end

start_sample = (active(1) - 1) * frame_step + 1;
end_sample   = min((active(end) - 1) * frame_step + frame_len, length(signal));

signal_out = signal(start_sample:end_sample);
end