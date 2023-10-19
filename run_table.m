title = 'HIGGS';
load(['./results/rf_leverage_', title, '.mat' ], "n", "Y_train", "Y_test", "d", "leverage_training_time", "leverage_generating_time", ...
    "leverage_test_error", "plain_training_time", "plain_generating_time", "plain_test_error");

leverage_total_time = leverage_training_time(5, :) + leverage_generating_time(5, :);
leverage_accuracy = leverage_test_error(5, :);

uniform_total_time = plain_training_time(5, :) + plain_generating_time(5, :);
uniform_accuray = plain_test_error(5, :);

fprintf('& $%d$  & $%d$ \n', length(Y_train), length(Y_test))

fprintf('%s & %d & %.2f$\\pm$ %.2f  & {\\bf %.2f$\\pm$%.2f} & {\\bf %.5f} &%.5f \\\\ \n', ...
    title, d*16, mean(uniform_accuray), std(uniform_accuray), mean(leverage_accuracy), std(leverage_accuracy), ...
    mean(uniform_total_time), mean(leverage_total_time))

d = leverage_accuracy - uniform_accuray;
if mean(uniform_accuray) < mean(leverage_accuracy) && mean(d)/(std(d)/sqrt(10)) > 1.812
    fprintf("significant \n");
else
    fprintf("non-significant \n");
end