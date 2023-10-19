function draw_plot_fig(X, Y, filepath, legend_str, xlabel_str, ylabel_str, xtick_str, xticklabels_str)
    h = figure;
    item_size = length(Y);
    
    for i = 1 : item_size
        plot(X, Y{i}, 'linewidth', 2);
        hold on
    end
    
    grid on
    legend(legend_str, 'Interpreter','latex', 'FontSize', 10);
    ylabel(ylabel_str);
    xlabel(xlabel_str, 'Interpreter','latex');
    xticks(xtick_str)
    xticklabels(xticklabels_str)
    set(gca,'Fontname', 'Times New Roman', 'FontSize', 15);
    %title(['f_*(x)=\Lambda_{',  num2str(r/gamma + 0.5), '}(x, 0)']);

    hold off;

    set(h,'Units','Inches');
    pos = get(h,'Position');
    set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
    print(h,filepath, '-dpdf','-r600')