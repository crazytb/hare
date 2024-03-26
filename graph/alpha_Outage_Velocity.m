PD1 = [0.3375	0.3375	0.337	0.3365	0.3365	0.3409	0.3417	0.3644];
PD2 = [1.9728	1.9684	1.414	1.1631	1.1622	1.1526	1.0009	1.0006];





M = 8;


x_axis= 1:1:M;
yyaxis left
plot(x_axis, PD1(1:M), 'b-*', 'LineWidth', 1)
ylabel('Outage probability', 'fontsize', 15, 'FontName', 'Times');
hold on;
yyaxis right
plot(x_axis, PD2(1:M), 'r-^', 'LineWidth', 1)
ylabel('Average velocity level', 'fontsize', 15, 'FontName', 'Times');
grid on;

xlabel('\alpha','fontsize', 15, 'FontName', 'Times');

legend('Outage Pr.','Avg. velocity LVL', 'FontName', 'Times' );
set(gca,'XTicklabels',x_axis);
xticklabels({'0.95', '0.90', '0.85', '0.80', '0.75', '0.70', '0.65', '0.60'});
