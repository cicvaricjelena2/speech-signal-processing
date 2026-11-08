[x, fs] = audioread('train/jedan_2.wav');
x = x(:,1);  

x_proc = preprocessing(x, fs);

t_orig = (0:length(x)-1) / fs;
t_proc = (0:length(x_proc)-1) / fs;

figure;
subplot(2,1,1);
plot(t_orig, x);
title('Originalni signal');
xlabel('Vreme [s]'); ylabel('Amplituda');

subplot(2,1,2);
plot(t_proc, x_proc);
title('Signal nakon predobre');
xlabel('Vreme [s]'); ylabel('Amplituda');