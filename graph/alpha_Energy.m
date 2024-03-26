PD1 = [29.2766	29.147	25.337	23.6011	23.5938	23.3739	22.2378	21.2099];
PD2 = [14.84012571	14.80745783	17.91867044	20.29154845	20.3009809	20.27928162	22.21780398	21.19718169];
PD3 = [44.19109434	43.9954717	38.21568627	35.5706104	35.55960814	35.46335913	33.78064712	33.36988672];

M = 8;
x_axis= 1:1:M;


subplot(2,1,1);
plot(x_axis, PD1(1:M), 'k-*', 'LineWidth', 1)
ylabel('Expected energy consumption (mW)', 'fontsize', 10, 'FontName', 'Times');
xlabel('\alpha','fontsize', 10, 'FontName', 'Times');
legend('Expected energy cons. (mW)', 'FontName', 'Times' );
set(gca,'XTicklabels',x_axis);
xticklabels({'0.95', '0.90', '0.85', '0.80', '0.75', '0.70', '0.65', '0.60'});

subplot(2,1,2);
yyaxis left
plot(x_axis, PD2(1:M), 'b-*', 'LineWidth', 1)
ylabel('Energy consumption ratio (mW/v)', 'fontsize', 10, 'FontName', 'Times');
hold on;
yyaxis right
plot(x_axis, PD3(1:M), 'r-^', 'LineWidth', 1)
ylabel('Energy consumption ratio (mW/Pr.)', 'fontsize', 10, 'FontName', 'Times');
grid on;

xlabel('\alpha','fontsize', 10, 'FontName', 'Times');

legend('Energy cons. ratio (mW/v)','Energy cons. ratio (mW/Pr.)', 'FontName', 'Times' );
set(gca,'XTicklabels',x_axis);
xticklabels({'0.95', '0.90', '0.85', '0.80', '0.75', '0.70', '0.65', '0.60'});
