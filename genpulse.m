function e = genpulse(f0, d, fs)
% прави дискретну поворку импулса

N = round(d*fs); % дужина секвенце у одбирцима
e = zeros(1,N);

period = round(fs/f0); % број узорака у једном периоду импулса
e(1:period:end) = 1; 

end
