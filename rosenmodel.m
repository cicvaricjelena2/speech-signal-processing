function g = rosenmodel(t1,t2,fs)

N1 = round(t1*fs); % одбирци
N2 = round(t2*fs); % oдбирци
n = 0:(N1+N2); % трајање
g = 0.5*(1-cos(pi*n/N1)).*(n<=N1)+cos(pi*(n-N1)/2/N2).*(n>N1);

end


