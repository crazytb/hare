PD1 = [0.9999	0.3897	0.3375	0.216	2.18E-05	7.29E-06];
PD2 = [0.9999	0.4046	0.3411	0.216	4.83E-08	1.38E-08];
PD3 = [0.9999	0.3897	0.3386	0.2741	0.1491	0.0723];
PD4 = [0.9999	0.8502	0.3728	0.2908	1.91E-05	7.98E-07];
PD5 = [0.9999	0.3983	0.3388	0.3339	0.3604	0.357];



mid=0;
M = 6;
plot_node = M+mid; 


x_axis = mid+1:1:plot_node;
plot(x_axis, PD2(1:M), 'r-', 'LineWidth', 1)
hold on;
plot(x_axis, PD3(1:M), 'g-X', 'LineWidth', 1)
plot(x_axis, PD4(1:M), 'm-^', 'LineWidth', 1)
plot(x_axis, PD5(1:M), 'k-v', 'LineWidth', 1)
plot(x_axis, PD1(1:M), 'b-*', 'LineWidth', 1)
grid on;

xlabel('Number of slots in a Section time','fontsize', 15, 'FontName', 'Times');
ylabel('Outage probability', 'fontsize', 15, 'FontName', 'Times');
legend('MP','2H','1H','DV','EMDS', 'FontName', 'Times' );
set(gca,'XTick',mid+1:1:plot_node);