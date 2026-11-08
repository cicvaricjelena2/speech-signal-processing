clear
clc
close all

[x, fs] = audioread('z2.wav');
x = x / max(abs(x));
t = (0:length(x)-1) / fs;

% delta kvantizator
function [xq, e] = delta_kvantizator(x, delta)
    N = length(x);
    xq = zeros(1, N);
    xq(1) = 0;
    for n = 2:N
        if x(n) >= xq(n-1)
            xq(n) = xq(n-1) + delta;
        else
            xq(n) = xq(n-1) - delta;
        end
        xq(n) = max(-1, min(1, xq(n)));
    end
    e = x - xq;
end

snr_db = @(orig, e) 10*log10(sum(orig.^2) / sum(e.^2 + eps));

% Histogram razlika susednih odbiraka
diff_x = diff(x);
figure(1);
histogram(diff_x, 100);
xlabel('Razlika susednih odbiraka');
ylabel('Broj pojavljivanja');
title('Histogram razlika susednih odbiraka');
grid on;

max_diff = prctile(abs(diff_x), 95);
fprintf('Izabrana optimalna delta: %.4f\n', max_diff);

delta_malo   = max_diff * 0.2;
delta_dobro  = max_diff;
delta_veliko = max_diff * 3;

deltas = [delta_malo, delta_dobro, delta_veliko];
nazivi = {'Delta premalo (slope overload)', ...
          'Delta optimalno', ...
          'Delta preveliko (granular noise)'};

N_prikaz    = 500;
start_prikaz = round(length(x) / 4);
idx = start_prikaz : start_prikaz + N_prikaz - 1;

for i = 1:3
    [xq, e] = delta_kvantizator(x', deltas(i));
    xq = xq'; e = e';
    snr = snr_db(x, e);

    fprintf('\n%s\n', nazivi{i});
    fprintf('delta = %.4f, SNR = %.2f dB\n', deltas(i), snr);

    figure(i+1);
    subplot(2,1,1);
    plot(t(idx), x(idx), 'b', t(idx), xq(idx), 'r');
    xlabel('Vreme [s]'); ylabel('Amplituda');
    title(sprintf('%s\ndelta=%.4f, SNR=%.1f dB', nazivi{i}, deltas(i), snr));
    legend('Original', 'Rekonstruisan');
    grid on;

    subplot(2,1,2);
    plot(t(idx), e(idx));
    xlabel('Vreme [s]'); ylabel('Greska');
    title('Greska rekonstrukcije');
    grid on;
end

% Optimalno delta
[xq_opt, e_opt] = delta_kvantizator(x', delta_dobro);
xq_opt = xq_opt'; e_opt = e_opt';

figure(5);
subplot(3,1,1);
plot(t, x);
xlabel('Vreme [s]'); ylabel('Amplituda');
title('Originalni signal');
grid on;

subplot(3,1,2);
plot(t, xq_opt);
xlabel('Vreme [s]'); ylabel('Amplituda');
title(sprintf('Rekonstruisani signal (delta=%.4f)', delta_dobro));
grid on;

subplot(3,1,3);
plot(t, e_opt);
xlabel('Vreme [s]'); ylabel('Greska');
title('Greska rekonstrukcije');
grid on;

fprintf('\n Optimalna delta = %.4f \n', delta_dobro);
fprintf('SNR (optimalna delta): %.2f dB\n', snr_db(x, e_opt));