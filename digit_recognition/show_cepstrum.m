clear
close all
clc

[x, fs] = audioread('train/jedan_1.wav');
x = x(:,1);
x_proc = preprocessing(x, fs);

%  zvucni segment iz sredine signala
segment_len = round(0.03 * fs);  
start_idx = round(length(x_proc)/2);
segment = x_proc(start_idx : start_idx + segment_len - 1);

% realni kepstrum
X = fft(segment);
cepstrum = real(ifft(log(abs(X) + 1e-10)));
quefrency = (0:length(cepstrum)-1) / fs * 1000;  

% pronadji pitch iz kepstruma
min_q = round(fs/400);
max_q = round(fs/50);
cep_range = cepstrum(min_q:max_q);
[~, idx] = max(cep_range);
pitch_period_ms = (idx + min_q - 1) / fs * 1000;
pitch_freq = 1000 / pitch_period_ms;

fprintf('Procenjena pitch perioda: %.2f ms\n', pitch_period_ms);
fprintf('Procenjena pitch ucestanost: %.1f Hz\n', pitch_freq);

figure;
subplot(2,1,1);
t_seg = (0:length(segment)-1) / fs * 1000;
plot(t_seg, segment);
title('Odabrani zvucni segment');
xlabel('Vreme [ms]'); ylabel('Amplituda');

subplot(2,1,2);
plot(quefrency, cepstrum);
title(sprintf('Realni kepstrum- pitch perioda = %.2f ms (%.1f Hz)', ...
    pitch_period_ms, pitch_freq));
xlabel('Kašnjenje [ms]'); ylabel('Kepstrum');
xlim([0 25]);  
xline(pitch_period_ms, 'r--', sprintf('%.2f ms', pitch_period_ms));