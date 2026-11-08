clear 
close all 
clc

% Samoglasnik A
[y_a, fs_a] = audioread('a.wav');
y_a = y_a - mean(y_a);
y_a = y_a / max(abs(y_a));

N_a = length(y_a);
t_a = (0:N_a-1)/fs_a;

Nf_a = 2^nextpow2(N_a);
Y_a  = fft(y_a, Nf_a) / N_a;
Ya   = abs(Y_a(1:Nf_a/2+1));
Ya(2:end-1) = 2*Ya(2:end-1);
f_a  = (0:Nf_a/2) * fs_a/Nf_a;

figure(1)
subplot(2,1,1)
plot(t_a, y_a)
xlabel('t [s]'); ylabel('Amplituda')
title('Samoglasnik A (vremenski domen)')
grid on

subplot(2,1,2)
plot(f_a, Ya)
xlabel('f [Hz]'); ylabel('|Y(f)|')
title('Amplitudski spektar')
xlim([0 fs_a/2])
grid on

figure(2)
plot(t_a, y_a)
xlabel('t [s]'); ylabel('Amplituda')
title('Samoglasnik A ograničen u vremenskom domenu')
xlim([0.2 0.25])
grid on

% Frikativ S
[y_s, fs_s] = audioread('s.wav');
y_s = y_s - mean(y_s);
y_s = y_s / max(abs(y_s));

N_s = length(y_s);
t_s = (0:N_s-1)/fs_s;

Nf_s = 2^nextpow2(N_s);
Y_s  = fft(y_s, Nf_s) / N_s;
Ys   = abs(Y_s(1:Nf_s/2+1));
Ys(2:end-1) = 2*Ys(2:end-1);
f_s  = (0:Nf_s/2) * fs_s/Nf_s;

figure(3)
subplot(2,1,1)
plot(t_s, y_s)
xlabel('t [s]'); ylabel('Amplituda')
title('Frikativ S (vremenski domen)')
grid on

subplot(2,1,2)
plot(f_s, Ys)
xlabel('f [Hz]'); ylabel('|Y(f)|')
title('Amplitudski spektar')
xlim([0 fs_s/2])
grid on

% Afrikat C
[y_c, fs_c] = audioread('c.wav');
y_c = y_c - mean(y_c);
y_c = y_c / max(abs(y_c));

N_c = length(y_c);
t_c = (0:N_c-1)/fs_c;

Nf_c = 2^nextpow2(N_c);
Y_c  = fft(y_c, Nf_c) / N_c;
Yc   = abs(Y_c(1:Nf_c/2+1));
Yc(2:end-1) = 2*Yc(2:end-1);
f_c  = (0:Nf_c/2) * fs_c/Nf_c;

figure(4)
subplot(2,1,1)
plot(t_c, y_c)
xlabel('t [s]'); ylabel('Amplituda')
title('Afrikat C (vremenski domen)')
grid on

subplot(2,1,2)
plot(f_c, Yc)
xlabel('f [Hz]'); ylabel('|Y(f)|')
title('Amplitudski spektar')
xlim([0 fs_c/2])
grid on

figure(5)
plot(t_c, y_c)
xlabel('t [s]'); ylabel('Amplituda')
title('Afrikat C (uvećan na jedno izgovaranje)')
xlim([0.34 0.47])  
grid on