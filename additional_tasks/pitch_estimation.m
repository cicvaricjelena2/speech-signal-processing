clear
clc
close all

[x, fs] = audioread('z1.wav');
N = length(x);
t = (0:N-1) / fs;

figure(1)
plot(t, x);
xlabel('Vreme [s]'); ylabel('Amplituda');
title('Govorni signal u vremenu');
grid on;

% 6 povorki impulsa
m1 = zeros(N,1); m2 = zeros(N,1); m3 = zeros(N,1);
m4 = zeros(N,1); m5 = zeros(N,1); m6 = zeros(N,1);

Mn_prev = 0;
mn_prev = 0;

for n = 2:N-1
    if x(n) > x(n-1) && x(n) > x(n+1)
        Mn = x(n);
    else
        Mn = 0;
    end
    if x(n) < x(n-1) && x(n) < x(n+1)
        mn = x(n);
    else
        mn = 0;
    end

    m1(n) = max(0,  Mn);
    m2(n) = max(0,  Mn - mn_prev);
    m3(n) = max(0,  Mn - Mn_prev);
    m4(n) = max(0, -mn);
    m5(n) = max(0, -(mn - Mn_prev));
    m6(n) = max(0, -(mn - mn_prev));

    if Mn ~= 0, Mn_prev = Mn; end
    if mn ~= 0, mn_prev = mn; end
end

% prikaz prvih 1000 odbiraka svih 6 sekvenci
prikaz = 1000;
figure(2)
subplot(7,1,1)
plot(x(1:prikaz)); ylabel('x(t)'); title('Prvih 1000 odbiraka sekvence'); grid on;
subplot(7,1,2)
stem(m1(1:prikaz), 'filled', 'MarkerSize', 3); ylabel('\mu_1(t)'); grid on;
subplot(7,1,3)
stem(m2(1:prikaz), 'filled', 'MarkerSize', 3); ylabel('\mu_2(t)'); grid on;
subplot(7,1,4)
stem(m3(1:prikaz), 'filled', 'MarkerSize', 3); ylabel('\mu_3(t)'); grid on;
subplot(7,1,5)
stem(m4(1:prikaz), 'filled', 'MarkerSize', 3); ylabel('\mu_4(t)'); grid on;
subplot(7,1,6)
stem(m5(1:prikaz), 'filled', 'MarkerSize', 3); ylabel('\mu_5(t)'); grid on;
subplot(7,1,7)
stem(m6(1:prikaz), 'filled', 'MarkerSize', 3); ylabel('\mu_6(t)'); xlabel('t(k)'); grid on;

% paralelno procesiranje
win    = round(fs * 15e-3);
lambda = 120 / fs;
tau    = round(fs * 4e-3);
Tp_min = 1/400;
Tp_max = 1/50;

NN_full = floor(N / (win/2));
pitchFrekv1_vec = zeros(1, NN_full);
k = 1;

for k_win = 1:win/2:N-win+1
    segs = {m1(k_win:k_win+win-1), m2(k_win:k_win+win-1), ...
            m3(k_win:k_win+win-1), m4(k_win:k_win+win-1), ...
            m5(k_win:k_win+win-1), m6(k_win:k_win+win-1)};
    pts_k = NaN(1,6);

    for s = 1:6
        xw = segs{s};
        indx = find(xw > 0, 1);
        if isempty(indx), continue; end
        pocetak = indx + tau;
        if pocetak > win, continue; end

        kraj = 0;
        A = xw(indx);
        for i = pocetak:win
            if xw(i) >= A * exp(-lambda * (i - pocetak))
                kraj = i;
                break;
            end
        end

        if kraj == 0, continue; end

        Tp_est = (kraj - indx) / fs;
        if Tp_est >= Tp_min && Tp_est <= Tp_max
            pts_k(s) = Tp_est;
        end
    end

    validni = pts_k(~isnan(pts_k));
    if ~isempty(validni)
        f = 1 / median(validni);
        if f >= 50 && f <= 400
            pitchFrekv1_vec(k) = f;
        end
    end
    k = k + 1;
end

pts_all_ceo = pitchFrekv1_vec(pitchFrekv1_vec > 50 & pitchFrekv1_vec < 400);
pitchFrekv1 = median(pts_all_ceo);

figure(3)
plot(pitchFrekv1_vec);
hold on;
yline(pitchFrekv1, 'r--', sprintf('Pitch Frek. (medijana) = %.1f Hz', pitchFrekv1));
xlabel('Procena pitch frekvencije'); ylabel('Frekvencija');
title('Procena pitch frekvencije - paralelno procesiranje');
grid on;

fprintf('Metoda 1 (Paralelno procesiranje)\n');
fprintf('Procenjena pitch ucestanost: %.4f Hz\n\n', pitchFrekv1);

% autokorelacija sa centralnim klipovanjem
%zvucni deo signala
frame_e = round(0.02 * fs);
n_fr = floor(N / frame_e);
en = zeros(1, n_fr);
for i = 1:n_fr
    en(i) = sum(x((i-1)*frame_e+1 : i*frame_e).^2);
end
prag_en = 0.05 * max(en);
zvucni_frejm = find(en > prag_en);
z_start = (zvucni_frejm(1)-1)*frame_e + 1;
z_end   = zvucni_frejm(end)*frame_e;
x_zvucni = x(z_start:z_end);
N_z = length(x_zvucni);

% Centralno klipovanje
prag = 0.3 * max(abs(x_zvucni));
x_clip = x_zvucni;
x_clip(abs(x_zvucni) < prag) = 0;

lag_max_acf = min(N_z-1, 40000);
lag_min = round(fs / 400);
lag_max_pitch = round(fs / 50);

R_orig = zeros(1, lag_max_acf);
R_clip = zeros(1, lag_max_acf);
for k2 = 1:lag_max_acf
    R_orig(k2) = sum(x_zvucni(1:N_z-k2) .* x_zvucni(k2+1:N_z));
    R_clip(k2) = sum(x_clip(1:N_z-k2) .* x_clip(k2+1:N_z));
end

figure(4)
subplot(1,2,1)
plot(R_orig);
xlabel('k'); ylabel('R_{xx}(k)');
title('Autokorelaciona f-ja signala');
grid on;

subplot(1,2,2)
plot(R_clip);
xlabel('k'); ylabel('R_{xx}(k)');
title('Autokorelaciona funkcija centralno klipovanog signala');
grid on;

% Procena pitch
R_search = R_clip(lag_min:lag_max_pitch);
[~, idx] = max(R_search);
lag_acf = idx + lag_min - 1;
pitchFrekv3 = fs / lag_acf;

fprintf('Metoda 2 (Autokorelacija sa centralnim klipovanjem)\n');
fprintf('Procenjena pitch ucestanost: %.4f Hz\n\n', pitchFrekv3);
fprintf('Odstupanje: %.2f Hz\n', abs(pitchFrekv1 - pitchFrekv3));