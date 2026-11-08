clc
clear
close all

[x, fs] = audioread('train/jedan_1.wav');
x = x(:,1);
x_proc = preprocessing(x, fs);

p = 14;
win = round(20e-3 * fs);
hop = round(10e-3 * fs);
num_frames = floor((length(x_proc) - win) / hop) + 1;

% racunanje LPC koeficijenata po prozorima korisnickim funkcijama
LPCs = zeros(p + 1, num_frames);
for i = 1:num_frames
    start_idx = (i - 1) * hop + 1;
    frame = x_proc(start_idx : start_idx + win - 1);
    rxx = autocorrelation(frame, p);
    [a, ~] = estimate_LPC(rxx, p);
    LPCs(:, i) = a(:);
end

frame_time = ((0:num_frames-1) * hop + win/2) / fs;

figure;
plot(frame_time, LPCs(2:end, :).');
title('Promena LPC koeficijenata kroz vreme');
xlabel('Vreme [s]');
ylabel('Vrednost koeficijenta');
grid on;

% AR/LPC spektralna procena za jedan segment iz sredine signala
start_seg = round(length(x_proc) / 2);
segment = x_proc(start_seg : start_seg + win - 1);

rxx_seg = autocorrelation(segment, p);
[a, s] = estimate_LPC(rxx_seg, p);

f = linspace(0, fs/2, 512);
omega = 2 * pi * f / fs;

A_eval = zeros(1, length(f));
for k = 0:p
    A_eval = A_eval + a(k+1) * exp(-1j * omega * k);
end
P_AR = s ./ abs(A_eval).^2;

[P_per, W_per] = periodogram(segment, [], [], fs);

figure;
plot(W_per, 10*log10(P_per + eps), 'Color', [0.7 0.7 0.7]);
hold on;
plot(f, 10*log10(P_AR + eps), 'b', 'LineWidth', 2);
title('AR/LPC spektralna procena zvucnog segmenta');
xlabel('Frekvencija [Hz]');
ylabel('Snaga [dB]');
legend('Periodogram', 'AR spektar (LPC)');
grid on;
