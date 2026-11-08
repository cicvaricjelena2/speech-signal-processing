function features = feature_extraction(signal, fs)

num_coeffs = 13;  

coeffs = mfcc(signal, fs, 'NumCoeffs', num_coeffs);

features = mean(coeffs, 1);

end