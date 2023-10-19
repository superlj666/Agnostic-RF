close all
clear all

typeRF = 'sle-rff'; % rff qmc le-rff sle-rff(Ours)
flagCV = 0;

repeate = 5;
lambda_list = -20:10;

title = 'a6a';
sigma = 2^10;

load(['./data/', title '.mat']);
d = size(X,2);
X = mapstd(X); 
% D = d * 2^7;
D = 1000;

leverage_test_error = zeros(length(lambda_list), repeate);
plain_test_error = zeros(length(lambda_list), repeate);


for i=1:length(lambda_list)
    lambda = 10^lambda_list(i);
    
    for j = 1:repeate
        rate = 1/2;
        Training_num = round(length(y)*rate);
        [~, index] = sort(rand( length(y), 1));
        X_train = X( index( end - Training_num+1 : end), : );
        Y_train = y( index( end - Training_num+1: end));
        X_test = X( index( 1 : end - Training_num), : );
        Y_test = y( index( 1 : end - Training_num));
        
        n=size(X_train,1);

        b = rand(1,D)*2*pi;
        W = RandomFeatures(D, d,sigma,typeRF);
        [Z_train_leverage,Z_test_leverage]= SERLSRFF(D, W, b, X_train',X_test',Y_train);       
        Z_train = createRandomFourierFeatures(D, W, b, X_train',typeRF);
        Z_test = createRandomFourierFeatures(D, W, b, X_test',typeRF);
               
        % [~, plain_test_error(i, j)] = RFclassification(Z_train,Z_test,Y_train,Y_test,flagCV, lambda);
        [~, leverage_test_error(i, j)] = RFclassification(Z_train_leverage,Z_test_leverage,Y_train,Y_test,flagCV, lambda);
     end
    
    fprintf('Leverage RF: M=%d  Acc=%.2f±%.2f, lambda= %f, sigma= %f \n', D, mean(leverage_test_error(i,:)),std(leverage_test_error(i,:)), lambda, sigma);
end
[m, indx] = max(mean(leverage_test_error, 2));
fprintf('best lambda is 10^%d\n', lambda_list(indx))
save(['./results/lambda_', title, '.mat' ]);

legend_str = {'The exact KRR'};
xlabel_str = 'Regularity parameter $\lambda$';
ylabel_str = 'Test accuracy (%)';
xstic_str = -20:10:10;
xticklabels_str = repmat("10^{", 1, length(xstic_str)) + string(xstic_str) + "}";
Y = {mean(leverage_test_error, 2)'};
draw_plot_fig(lambda_list, Y, ['./results/lambda_', title, '.pdf' ], legend_str, xlabel_str, ylabel_str, xstic_str, xticklabels_str)