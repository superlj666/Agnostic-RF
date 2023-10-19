title = 'diabetes';
load(['./results/rf_leverage_', title, '.mat' ]);

legend_str = {'Data-dependent RF', 'Uniform RF'};
xlabel_str = '$log_2(M/d)$';
xstic_str = 0:7;
xticklabels_str = 0:7;

ylabel_str = 'Test accuracy (%)';
Y = {mean(leverage_test_error, 2)', mean(plain_test_error, 2)'};
Z = {std(leverage_test_error, 0, 2)', std(plain_test_error, 0, 2)'};
draw_errorbar_fig(M_rates, Y, Z, ['./results/leverage_accuracy_', title, '.pdf' ], legend_str, xlabel_str, ylabel_str, xstic_str, xticklabels_str)

ylabel_str = 'Log of training time (s)';
Y = {mean(log(leverage_training_time), 2)', mean(log(plain_training_time), 2)'};
Z = {std(log(leverage_training_time), 0, 2)', std(log(plain_training_time), 0, 2)'};
draw_errorbar_fig(M_rates, Y, Z, ['./results/leverage_training_time_', title, '.pdf' ], legend_str, xlabel_str, ylabel_str, xstic_str, xticklabels_str)

ylabel_str = 'Log of generating time (s)';
Y = {mean(log(leverage_generating_time), 2)', mean(log(plain_generating_time), 2)'};
Z = {std(log(leverage_generating_time), 0, 2)', std(log(plain_generating_time), 0, 2)''};
draw_errorbar_fig(M_rates, Y, Z, ['./results/leverage_generating_time_', title, '.pdf' ], legend_str, xlabel_str, ylabel_str, xstic_str, xticklabels_str)