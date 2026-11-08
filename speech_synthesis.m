clear
close all
clc

fs = 8000;
f0 = 200;
d  = 3;

% parametri Rozenbergovog modela
t1 = 7.5e-3;
t2 = 1.3e-3;

% pobuda
e = genpulse(f0, d, fs);
g = rosenmodel(t1, t2, fs);
y = conv(e, g);

fA = [800; 1200; 2800; 3600]; 
aA = [0.98; 0.96; 0.88; 0.90];
fE = [500; 1900; 2150; 3300];   
aE = [0.99; 0.96; 0.95; 0.96];
fO = [500; 900;  2300; 3200];   
aO = [0.98; 0.97; 0.89; 0.87];

% sinteza i radijacija
[BA, AA] = makevowel(aA, fA, fs); 
xA = filter([1 -1], 1, filter(BA, AA, y));
[BE, AE] = makevowel(aE, fE, fs); 
xE = filter([1 -1], 1, filter(BE, AE, y));
[BO, AO] = makevowel(aO, fO, fs); 
xO = filter([1 -1], 1, filter(BO, AO, y));

% spektri za A, E, O
Nf = 2^nextpow2(length(xA));
f_osa = (0:Nf/2) * fs/Nf;

XA_spec = abs(fft(xA, Nf)/length(xA));
XA_spec = XA_spec(1:Nf/2+1); XA_spec(2:end-1) = 2*XA_spec(2:end-1);

XE_spec = abs(fft(xE, Nf)/length(xE));
XE_spec = XE_spec(1:Nf/2+1); XE_spec(2:end-1) = 2*XE_spec(2:end-1);

XO_spec = abs(fft(xO, Nf)/length(xO));
XO_spec = XO_spec(1:Nf/2+1); XO_spec(2:end-1) = 2*XO_spec(2:end-1);

figure(1)
subplot(3,2,1); plot(xA); xlim([3900 4200])
title('Sintetisano A (vreme)'); xlabel('n [odb]'); ylabel('Amplituda'); grid on
subplot(3,2,2); plot(f_osa, 20*log10(XA_spec + eps)); xlim([0 fs/2])
title('Sintetisano A (spektar)'); xlabel('f [Hz]'); ylabel('|X(f)| [dB]'); grid on

subplot(3,2,3); plot(xE); xlim([3900 4200])
title('Sintetisano E (vreme)'); xlabel('n [odb]'); ylabel('Amplituda'); grid on
subplot(3,2,4); plot(f_osa, 20*log10(XE_spec + eps)); xlim([0 fs/2])
title('Sintetisano E (spektar)'); xlabel('f [Hz]'); ylabel('|X(f)| [dB]'); grid on

subplot(3,2,5); plot(xO); xlim([3900 4200])
title('Sintetisano O (vreme)'); xlabel('n [odb]'); ylabel('Amplituda'); grid on
subplot(3,2,6); plot(f_osa, 20*log10(XO_spec + eps)); xlim([0 fs/2])
title('Sintetisano O (spektar)'); xlabel('f [Hz]'); ylabel('|X(f)| [dB]'); grid on

sound(xA, fs); pause(4);
sound(xE, fs); pause(4);
sound(xO, fs); pause(4);


figure(2)
f0_vals = [120, 200, 300]; % muski, zenski, dete
for k = 1:length(f0_vals)
    ek  = genpulse(f0_vals(k), d, fs);
    yk  = conv(ek, g);
    xAk = filter([1 -1], 1, filter(BA, AA, yk));
    
    Nf = 2^nextpow2(length(xAk));
    X  = fft(xAk, Nf) / length(xAk);
    Xa = abs(X(1:Nf/2+1));
    Xa(2:end-1) = 2*Xa(2:end-1);
    f  = (0:Nf/2) * fs/Nf;
    
    subplot(3,2,2*k-1)
    plot(xAk); xlim([3900 4200])
    title(sprintf('A, f_0 = %d Hz (vreme)', f0_vals(k)))
    xlabel('n [odb]'); grid on
    
    subplot(3,2,2*k)
    plot(f, Xa); xlim([0 fs/2])
    title(sprintf('A, f_0 = %d Hz (spektar)', f0_vals(k)))
    xlabel('f [Hz]'); grid on
    
    sound(xAk, fs); 
    pause(4);
end

% utical poluprecnika polova a na samoglasnik A
aA1 = [0.98; 0.96; 0.88; 0.90];   
aA2 = [0.90; 0.88; 0.80; 0.82];   

[BA1, AA1] = makevowel(aA1, fA, fs);
[BA2, AA2] = makevowel(aA2, fA, fs);

xA1 = filter([1 -1], 1, filter(BA1, AA1, y));
xA2 = filter([1 -1], 1, filter(BA2, AA2, y));

% spektri
Nf = 2^nextpow2(length(xA1));
X1 = abs(fft(xA1, Nf)/length(xA1));
X1 = X1(1:Nf/2+1); X1(2:end-1) = 2*X1(2:end-1);
X2 = abs(fft(xA2, Nf)/length(xA2));
X2 = X2(1:Nf/2+1); X2(2:end-1) = 2*X2(2:end-1);
f  = (0:Nf/2) * fs/Nf;

figure(3)
subplot(2,2,1); plot(xA1); xlim([3900 4200])
title('A, a = [0.98 0.96 0.88 0.90] (vreme)')
xlabel('n [odb]'); ylabel('Amplituda'); grid on
subplot(2,2,2); plot(f, 20*log10(X1 + eps)); xlim([0 fs/2])
title('A, ostri formanti (spektar)')
xlabel('f [Hz]'); ylabel('|X(f)| [dB]'); grid on

subplot(2,2,3); plot(xA2); xlim([3900 4200])
title('A, a = [0.90 0.88 0.80 0.82] (vreme)')
xlabel('n [odb]'); ylabel('Amplituda'); grid on
subplot(2,2,4); plot(f, 20*log10(X2 + eps)); xlim([0 fs/2])
title('A, prigusniji formanti (spektar)')
xlabel('f [Hz]'); ylabel('|X(f)| [dB]'); grid on

sound(xA1, fs); pause(4);
sound(xA2, fs); pause(4);

% uticaj filtra radijacije na usnama
yA_bez = filter(BA, AA, y);          
xA_sa  = filter([1 -1], 1, yA_bez); 

Nf = 2^nextpow2(length(xA_sa));
Yb = fft(yA_bez, Nf) / length(yA_bez); 
Yba = abs(Yb(1:Nf/2+1)); 
Yba(2:end-1) = 2*Yba(2:end-1);
Xs = fft(xA_sa,  Nf) / length(xA_sa);  
Xsa = abs(Xs(1:Nf/2+1)); 
Xsa(2:end-1) = 2*Xsa(2:end-1);
f  = (0:Nf/2) * fs/Nf;

figure(4)
subplot(2,2,1); plot(yA_bez); xlim([3900 4200])
title('A bez radijacije (vreme)'); xlabel('n [odb]'); ylabel('Amplituda'); grid on
subplot(2,2,2); plot(f, 20*log10(Yba + eps)); xlim([0 fs/2])
title('A bez radijacije (spektar)'); xlabel('f [Hz]'); ylabel('|Y(f)| [dB]'); grid on
subplot(2,2,3); plot(xA_sa); xlim([3900 4200])
title('A sa radijacijom (vreme)'); xlabel('n [odb]'); ylabel('Amplituda'); grid on
subplot(2,2,4); plot(f, 20*log10(Xsa + eps)); xlim([0 fs/2])
title('A sa radijacijom (spektar)'); xlabel('f [Hz]'); ylabel('|X(f)| [dB]'); grid on

figure(5)
plot(f, 20*log10(Yba + eps), 'b', 'LineWidth', 1.2); hold on
plot(f, 20*log10(Xsa + eps), 'r', 'LineWidth', 1.2);
xlim([0 fs/2]); grid on
xlabel('f [Hz]'); ylabel('Amplituda [dB]')
title('Poredjenje spektra A sa i bez radijacije')
legend('bez radijacije', 'sa radijacijom', 'Location', 'best')

sound(yA_bez, fs); pause(4);
sound(xA_sa,  fs); pause(4);

