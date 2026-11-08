clc
clear
close all

[x, fs] = audioread('train/jedan_1.wav');
x = x(:,1); % mono ako j e stereo

x_proc = preprocessing(x, fs);

coeffs = mfcc(x_proc, fs, 'NumCoeffs', 13);

t = (0:length(x_proc)-1) / fs;

figure;
subplot(2,1,1);
plot(t, x_proc);
title('Vremenski oblik signala');
xlabel('Vreme [s]'); ylabel('Amplituda');

subplot(2,1,2);
imagesc(coeffs');
colorbar;
title('MFCC koeficijenti kroz vreme');
xlabel('Prozor'); ylabel('MFCC koeficijent');