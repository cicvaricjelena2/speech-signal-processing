clear
close all
clc

[x, fs_orig] = audioread('recenica.wav');
if size(x,2) > 1
    x = mean(x, 2);  % mono ako je stereo
end

fs = 10000;
if fs_orig ~= fs
    x = resample(x, fs, fs_orig);
end

% normalizacija
x = x / max(abs(x));
N = length(x);
t = (0:N-1) / fs;

figure(1)
plot(t, x)
title('Prikaz signala u vremenskom domenu')
xlabel('vreme [s]'); ylabel('amplituda')
grid on

% kve
T_win = 0.02;            
T_pomeraj = 0.010;            
N_win = round(T_win * fs);
N_pomeraj = round(T_pomeraj * fs); 

n_frames = floor((N - N_win) / N_pomeraj) + 1;

E   = zeros(n_frames, 1);  
ZCR = zeros(n_frames, 1);  
tF  = zeros(n_frames, 1);  

w = hamming(N_win); 

for k = 1:n_frames
    idx = (k-1)*N_pomeraj + (1:N_win);
    seg = x(idx) .* w;

    E(k) = sum(seg.^2);

    ZCR(k) = sum(abs(diff(sign(seg)))) / (2*N_win);

    tF(k) = ((k-1)*N_pomeraj + N_win/2) / fs;     
end

En = E / max(E); 
ZCRn = ZCR / max(ZCR);


Nsil = round(0.2 * fs);             % prvih 200ms je tisina
Esil = zeros(floor(Nsil/N_pomeraj), 1);
for k = 1:length(Esil)
    idx = (k-1)*N_pomeraj + (1:N_win);
    if idx(end) <= N
        Esil(k) = sum((x(idx).*w).^2);
    end
end
E_noise = mean(Esil);
prag_E = E_noise + 0.05 * max(E);   % prag iznad nivoa suma


active = E > prag_E;

d = diff([0; active; 0]);
start_KVE = find(d == 1);
end_KVE   = find(d == -1) - 1;

% krace pauze < 50 ms se ne racunaju 
min_gap = round(0.05 / T_pomeraj);   
i = 1;
while i < length(start_KVE)
    if start_KVE(i+1) - end_KVE(i) < min_gap
        end_KVE(i) = end_KVE(i+1);
        start_KVE(i+1) = [];
        end_KVE(i+1) = [];
    else
        i = i + 1;
    end
end

% Uklanjanje prekratkih segmenata manje od 50 ms
min_dur = round(0.05 / T_pomeraj);
keep = (end_KVE - start_KVE) >= min_dur;
start_KVE = start_KVE(keep);
end_KVE   = end_KVE(keep);

t_start_KVE = tF(start_KVE);
t_end_KVE   = tF(end_KVE);

figure(2)
subplot(2,1,1)
plot(t, x); hold on
for k = 1:length(t_start_KVE)
    xline(t_start_KVE(k), 'g', 'LineWidth', 1.2)
    xline(t_end_KVE(k),   'r', 'LineWidth', 1.2)
end
title(['Segmentacija samo na osnovu KVE (' num2str(length(t_start_KVE)) ' segmenata)'])
xlabel('vreme [s]'); ylabel('amplituda'); grid on

subplot(2,1,2)
plot(tF, En, 'b'); hold on
yline(prag_E/max(E), 'k--', 'prag')
for k = 1:length(t_start_KVE)
    xline(t_start_KVE(k), 'g', 'LineWidth', 1.2)
    xline(t_end_KVE(k),   'r', 'LineWidth', 1.2)
end
title('Normalizovana kratkovremena energija')
xlabel('vreme [s]'); ylabel('E_n'); grid on

% ZCR
ZCRsil = ZCR(1:length(Esil));
prag_ZCR = mean(ZCRsil) + 2*std(ZCRsil);

start_ZCR = start_KVE;
end_ZCR   = end_KVE;

max_ext = 25;

for k = 1:length(start_ZCR)

    i = start_ZCR(k);
    cnt = 0;
    while i > 1 && ZCR(i-1) > prag_ZCR && cnt < max_ext
        i = i - 1;
        cnt = cnt + 1;
    end
    start_ZCR(k) = i;

    i = end_ZCR(k);
    cnt = 0;
    while i < n_frames && ZCR(i+1) > prag_ZCR && cnt < max_ext
        i = i + 1;
        cnt = cnt + 1;
    end
    end_ZCR(k) = i;
end

t_start_ZCR = tF(start_ZCR);
t_end_ZCR   = tF(end_ZCR);


figure(3)
subplot(3,1,1)
plot(t, x); hold on
for k = 1:length(t_start_ZCR)
    xline(t_start_ZCR(k), 'g', 'LineWidth', 1.2)
    xline(t_end_ZCR(k),   'r', 'LineWidth', 1.2)
end
title(['Konačna segmentacija (KVE i ZCR) ' num2str(length(t_start_ZCR)), ' reči'])
xlabel('vreme [s]'); ylabel('amplituda'); grid on

subplot(3,1,2)
plot(tF, En, 'b'); hold on
yline(prag_E/max(E), 'k--')
title('Kratkovremena energija (normalizovana)')
xlabel('vreme [s]'); ylabel('E_n'); grid on

subplot(3,1,3)
plot(tF, ZCRn, 'm'); hold on
yline(prag_ZCR/max(ZCR), 'k--')
title('Učestanost prolazaka kroz nulu (normalizovana)')
xlabel('vreme [s]'); ylabel('ZCR_n'); grid on

fprintf('\nPronađeno %d reči:\n', length(t_start_ZCR));
fprintf(' br |  pocetak [s] |  kraj [s]  | trajanje [s]\n');
for k = 1:length(t_start_ZCR)
    fprintf(' %2d |    %6.3f    |   %6.3f   |    %.3f\n', ...
        k, t_start_ZCR(k), t_end_ZCR(k), t_end_ZCR(k)-t_start_ZCR(k));
end


