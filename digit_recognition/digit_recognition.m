function digit_recognition()
cifre = {'jedan', 'dva', 'tri'}; 
fs_expected = 16000;

X_train = [];
y_train = [];

for c = 1:length(cifre)
    for n = 1:10
        ime = sprintf('train/%s_%d.wav', cifre{c}, n);
        [x, fs] = audioread(ime);
        x = x(:,1);
        x_proc = preprocessing(x, fs);
        feat = feature_extraction(x_proc, fs);
        X_train = [X_train; feat];
        y_train = [y_train; c];
    end
end

X_test = [];
y_test = [];

for c = 1:length(cifre)
    for n = 1:5
        ime = sprintf('test/%s_%d.wav', cifre{c}, n);
        [x, fs] = audioread(ime);
        x = x(:,1);
        x_proc = preprocessing(x, fs);
        feat = feature_extraction(x_proc, fs);
        X_test = [X_test; feat];
        y_test = [y_test; c];
    end
end

% knn
k = 3;
mdl = fitcknn(X_train, y_train, 'NumNeighbors', k);

% predikcija
y_train_pred = predict(mdl, X_train);
y_test_pred  = predict(mdl, X_test);

acc_train = sum(y_train_pred == y_train) / length(y_train) * 100;
acc_test  = sum(y_test_pred  == y_test)  / length(y_test)  * 100;

fprintf('Tacnost na trening skupu: %.1f%%\n', acc_train);
fprintf('Tacnost na test skupu:    %.1f%%\n', acc_test);

figure;
subplot(1,2,1);
confusionchart(y_train, y_train_pred, 'Title', 'Trening skup', ...
    'RowSummary', 'row-normalized', 'ColumnSummary', 'column-normalized');

subplot(1,2,2);
confusionchart(y_test, y_test_pred, 'Title', 'Test skup', ...
    'RowSummary', 'row-normalized', 'ColumnSummary', 'column-normalized');

% prepoznavanje novog snimak iz test skupa
fprintf('\n--- Prepoznavanje jednog snimka ---\n');
[x, fs] = audioread('test/tri_5.wav');
x = x(:,1);
x_proc = preprocessing(x, fs);
feat = feature_extraction(x_proc, fs);
odluka = predict(mdl, feat);
fprintf('Prepoznata cifra: %s\n', cifre{odluka});

end