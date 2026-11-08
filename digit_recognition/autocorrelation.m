function rxx = autocorrelation(x,p)
% autocorrelation рачуна АКФ за кашњења oд -p дo p
% x је један прозор говорног сигнала
% p је ред AR/LPC модела

N = length(x);
r_pos = zeros(p+1,1);

% рачунамо rxx[0], rxx[1], ..., rxx[p]
for lag = 0:p
    r_pos(lag+1) = sum(conj(x(1:N-lag)).*x(1+lag:N))/N;
end

% користимо особину rxx[-k] = conj(rxx[k])
rxx = [conj(r_pos(end:-1:2)); r_pos];
end
