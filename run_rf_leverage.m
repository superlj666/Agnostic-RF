close all
clear all

typeRF = 'sle-rff'; % rff qmc le-rff sle-rff(Ours)
flagCV = 0;
repeate = 10;

M_rates = 0:7;%linspace(1e2, 1e3, 10);

title = 'diabetes';
sigma = 2^(4);
lambda = 1e-1;

load(['./data/', title '.mat']);
d = size(X,2);
X = mapstd(X); 

plain_approximate_error = zeros(length(M_rates), repeate);
plain_test_error = zeros(length(M_rates), repeate);
plain_training_time = zeros(length(M_rates), repeate);
plain_generating_time = zeros(length(M_rates), repeate);

leverage_approximate_error = zeros(length(M_rates), repeate);
leverage_test_error = zeros(length(M_rates), repeate);
leverage_training_time = zeros(length(M_rates), repeate);
leverage_generating_time = zeros(length(M_rates), repeate);


for i=1:length(M_rates)
    D = d * 2^M_rates(i);
    
    for j = 1:repeate
        rate = 1/2;
        Training_num = round(length(y)*rate);
        [~, index] = sort(rand( length(y), 1));
        X_train = X(index( end - Training_num+1 : end), : );    
        Y_train = y(index( end - Training_num+1: end));
        X_test = X(index( 1 : end - Training_num), : );
        Y_test = y(index( 1 : end - Training_num));
        
        n=size(X_train,1);

        b = rand(1,D)*2*pi;
        W = RandomFeatures(D, d,sigma,typeRF);
        tic;
        [Z_train_leverage,Z_test_leverage]= SERLSRFF(D, W, b, X_train',X_test',Y_train);       
        leverage_generating_time(i, j)=toc;
        tic;
        Z_train = createRandomFourierFeatures(D, W, b, X_train',typeRF);
        plain_generating_time(i, j)=toc;
        Z_test = createRandomFourierFeatures(D, W, b, X_test',typeRF);
               
        [plain_training_time(i, j), plain_test_error(i, j)] = RFclassification(Z_train,Z_test,Y_train,Y_test,flagCV, lambda);
        [leverage_training_time(i, j), leverage_test_error(i, j)] = RFclassification(Z_train_leverage,Z_test_leverage,Y_train,Y_test,flagCV, lambda);
     end
    
    fprintf('Plain RF: M=%5d  ACC=%.2f, lambda= %f, sigma= %f, Time=%.6f\n', D, mean(plain_test_error(i,:)), lambda, sigma, mean(plain_training_time(i,:)));
    fprintf('Leverage RF: M=%5d  ACC=%.2f, lambda= %f, sigma= %f, Time=%.6f\n', D, mean(leverage_test_error(i,:)), lambda, sigma, mean(leverage_training_time(i,:)));
end
save(['./results/rf_leverage_', title, '.mat' ]);