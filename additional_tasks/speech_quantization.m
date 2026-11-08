clear
clc
close all

[x, fs] = audioread('z2.wav');
x = x / max(abs(x));
t = (0:length(x)-1) / fs;

figure(1);
plot(t, x);
xlabel('Vreme [s]'); ylabel('Amplituda');
title('Govorni signal u vremenskom domenu');
grid on;

snr_db = @(orig, rec) 10*log10(sum(orig.^2) / sum((orig - rec).^2 + eps));

mu_compress = @(x, mu) sign(x) .* log(1 + mu*abs(x)) / log(1 + mu);
mu_expand   = @(y, mu) sign(y) .* (1/mu) .* ((1 + mu).^abs(y) - 1);

% Mid-tread kvantizator
function xq = mid_tread(x, B)
    delta = 2 / 2^B;
    xq = delta * floor(x/delta + 0.5);
    xq = max(-1 + delta/2, min(1 - delta/2, xq));
end

% Mid-rise kvantizator
function xq = mid_rise(x, B)
    delta = 2 / 2^B;
    xq = delta * (floor(x/delta) + 0.5);
    xq = max(-1 + delta/2, min(1 - delta/2, xq));
end

B = 8;

xq_tread = mid_tread(x, B);
xq_rise  = mid_rise(x, B);

snr_tread = snr_db(x, xq_tread);
snr_rise  = snr_db(x, xq_rise);

fprintf('Uniformni kvantizatori (B=%d)\n', B);
fprintf('Mid-Tread SNR = %.2f dB\n', snr_tread);
fprintf('Mid-Rise  SNR = %.2f dB\n', snr_rise);


xin = linspace(-1, 1, 10000);
B1 = 3;
figure(2);
subplot(1,2,1);
plot(xin, mid_tread(xin, B1), 'b', 'LineWidth', 1.2);
hold on; plot(xin, xin, 'k--');
xlabel('Ulaz'); ylabel('Izlaz');
title(sprintf('Mid-Tread, B=%d bit, SNR=%.1f dB', B1, snr_tread));
grid on; axis square;

subplot(1,2,2);
plot(xin, mid_rise(xin, B1), 'r', 'LineWidth', 1.2);
hold on; plot(xin, xin, 'k--');
xlabel('Ulaz'); ylabel('Izlaz');
title(sprintf('Mid-Rise, B=%d bit, SNR=%.1f dB', B1, snr_rise));
grid on; axis square;

% Mu kompanding
mu_values = [100, 255];
B_values  = [4, 8, 12];

fprintf('\n Mu-kompanding kvantizator \n');
fprintf('%8s %8s %10s\n', 'mu', 'B [bit]', 'SNR [dB]');
fprintf('%s\n', repmat('-', 1, 30));

snr_mu = zeros(length(mu_values), length(B_values));

for i = 1:length(mu_values)
    mu = mu_values(i);
    xc = mu_compress(x, mu);
    for j = 1:length(B_values)
        Bj = B_values(j);
        xc_q = mid_rise(xc, Bj);
        xr   = mu_expand(xc_q, mu);
        snr_mu(i,j) = snr_db(x, xr);
        fprintf('%8d %8d %10.2f\n', mu, Bj, snr_mu(i,j));
    end
end

figure(3);
xin2 = linspace(-1, 1, 1000);
colors = {'b', 'r'};
for i = 1:length(mu_values)
    mu = mu_values(i);
    subplot(1,2,i);
    plot(xin2, mu_compress(xin2, mu), colors{i}, 'LineWidth', 1.5);
    hold on; plot(xin2, xin2, 'k--');
    xlabel('Ulaz x'); ylabel('Kompresovani y');
    title(sprintf('Mu-kompresija, mu=%d', mu_values(i)));
    legend('mu-law', 'Linearno', 'Location', 'NW');
    grid on;
end

%SNR vs Xmax/sigma (promena atenuacije)
att_dB  = 0:-3:-42;
att_lin = 10.^(att_dB/20);

sigma_x = std(x);
Xmax    = max(abs(x));

snr_tread_att = zeros(size(att_dB));
snr_rise_att  = zeros(size(att_dB));
snr_mu1_att   = zeros(size(att_dB));
snr_mu2_att   = zeros(size(att_dB));

for k = 1:length(att_lin)
    xs = x * att_lin(k);

    snr_tread_att(k) = snr_db(xs, mid_tread(xs, B));
    snr_rise_att(k)  = snr_db(xs, mid_rise(xs, B));

    for idx = 1:length(mu_values)
        mu   = mu_values(idx);
        xc   = mu_compress(xs, mu);
        xc_q = mid_rise(xc, B);
        xr   = mu_expand(xc_q, mu);
        if idx == 1
            snr_mu1_att(k) = snr_db(xs, xr);
        else
            snr_mu2_att(k) = snr_db(xs, xr);
        end
    end
end

ratio_dB = 20*log10(Xmax ./ (sigma_x * att_lin));

figure(4);
plot(ratio_dB, snr_tread_att, 'b-o', 'DisplayName', sprintf('Mid-Tread, B=%d', B));
hold on;
plot(ratio_dB, snr_rise_att,  'r-s', 'DisplayName', sprintf('Mid-Rise, B=%d', B));
plot(ratio_dB, snr_mu1_att,   'g-^', 'DisplayName', sprintf('mu=%d, B=%d', mu_values(1), B));
plot(ratio_dB, snr_mu2_att,   'm-d', 'DisplayName', sprintf('mu=%d, B=%d', mu_values(2), B));
xlabel('X_{max}/\sigma_x [dB]'); ylabel('SNR [dB]');
title('SNR vs X_{max}/\sigma_x');
legend('Location', 'SouthWest'); grid on;


mu_range = [1, 5, 10, 50, 100, 200, 255, 500, 1000];

figure(5);
hold on;
ls = {'-o', '-s', '-^'};
for j = 1:length(B_values)
    Bj = B_values(j);
    snr_vs_mu = zeros(size(mu_range));
    for i = 1:length(mu_range)
        mu   = mu_range(i);
        xc   = mu_compress(x, mu);
        xc_q = mid_rise(xc, Bj);
        xr   = mu_expand(xc_q, mu);
        snr_vs_mu(i) = snr_db(x, xr);
    end
    plot(mu_range, snr_vs_mu, ls{j}, 'DisplayName', sprintf('B=%d', Bj), 'LineWidth', 1.3);
end
xlabel('mu'); ylabel('SNR [dB]');
title('SNR vs mu za razlicite vrednosti B');
legend; grid on;
set(gca, 'XScale', 'log');

% Rekonstruisani signal 
mu_prikaz = 255;
B_prikaz  = 8;
xc_prikaz = mu_compress(x, mu_prikaz);
xc_q_prikaz = mid_rise(xc_prikaz, B_prikaz);
xr_prikaz = mu_expand(xc_q_prikaz, mu_prikaz);

figure(6);
subplot(2,1,1);
plot(t, x); xlabel('Vreme [s]'); ylabel('Amplituda');
title('Originalni signal'); grid on;

subplot(2,1,2);
plot(t, xr_prikaz); xlabel('Vreme [s]'); ylabel('Amplituda');
title(sprintf('Rekonstruisani signal (mu=%d, B=%d)', mu_prikaz, B_prikaz));
grid on;