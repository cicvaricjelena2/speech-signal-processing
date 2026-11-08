clc
clear
close all

cifre = {'jedan', 'dva', 'tri'};  
fs = 16000;      
trajanje = 2;    

if ~exist('train', 'dir'), mkdir('train'); end
if ~exist('test', 'dir'),  mkdir('test');  end

% trening
for c = 1:length(cifre)
    for n = 1:10
        fprintf('\n %s (snimak %d/10)\n', cifre{c}, n);
        input('Pritisni Enter');
        
        fprintf('Snimi\n');
        rec = audiorecorder(fs, 16, 1);
        recordblocking(rec, trajanje);
        signal = getaudiodata(rec);
        
        ime = sprintf('train/%s_%d.wav', cifre{c}, n);
        audiowrite(ime, signal, fs);
        fprintf('Sacuvano: %s\n', ime);
    end
end

% test
for c = 1:length(cifre)
    for n = 1:5
        fprintf('\n %s (test snimak %d/5)\n', cifre{c}, n);
        input('Pritisni Enter');
        
        fprintf('Snimi\n');
        rec = audiorecorder(fs, 16, 1);
        recordblocking(rec, trajanje);
        signal = getaudiodata(rec);
        
        ime = sprintf('test/%s_%d.wav', cifre{c}, n);
        audiowrite(ime, signal, fs);
        fprintf('Sacuvano: %s\n', ime);
    end
end

fprintf('\nGotovo! Snimljena je cela baza.\n');