close all
clear all

typeRF = 'sle-rff'; % rff qmc le-rff sle-rff(Ours)
flagCV = 0;

repeate = 5;
sigma_list = -10:20;

title = 'a6a';
load(['./data/', title '.mat']);
d = size(X,2);
X = mapstd(X); 
lambda = 1/size(X, 1);
% D = d * 2^7;
D = 1000;

leverage_test_error = zeros(length(sigma_list), repeate);
plain_test_error = zeros(length(sigma_list), repeate);

for i=1:length(sigma_list)
    sigma = 2^sigma_list(i);
    
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
        [~, leverage_test_error(i, j)] = RFclassification(Z_train_leverage,Z_test_leverage,Y_train,Y_test,flagCV, lambda);

        % Z_train = createRandomFourierFeatures(D, W, b, X_train',typeRF);
        % Z_test = createRandomFourierFeatures(D, W, b, X_test',typeRF);
        % [~, plain_test_error(i, j)] = RFclassification(Z_train,Z_test,Y_train,Y_test,flagCV, lambda);
     end
    
    fprintf('Leverage RF: M=%d  Acc=%.2f±%.2f, lambda= %f, sigma= %f \n', D, mean(leverage_test_error(i,:)),std(leverage_test_error(i,:)), lambda, sigma);
end
[m, indx] = max(mean(leverage_test_error, 2));
fprintf('best sigma is 2^%d\n', sigma_list(indx));
save(['./results/sigma_', title, '.mat' ]);

legend_str = {'The exact KRR'};
xlabel_str = 'Kernel parameter $\sigma^2$';
ylabel_str = 'Test accuracy (%)';
xstic_str = -10:10:20;
xticklabels_str = repmat("2^{", 1, length(xstic_str)) + string(xstic_str) + "}";
Y = {mean(leverage_test_error, 2)'};
draw_plot_fig(sigma_list, Y, ['./results/sigma_', title, '.pdf' ], legend_str, xlabel_str, ylabel_str, xstic_str, xticklabels_str)