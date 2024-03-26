PD1 = [7.98E-07	1.91E-05	2.90E-01	0.3375	0.3402	0.372];
PD2 = [2.61E-15	3.86E-08	0.2897	0.3411	0.3444	0.3698];
PD3 = [0.0549	0.1377	0.2687	0.3386	0.3401	0.3895];
PD4 = [7.98E-07	1.91E-05	0.2908	0.3728	0.8506	0.9999];
PD5 = [7.98E-07	0.1377	0.2687	0.3388	0.3416	0.7346];



mid=2;
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

xlabel('Number of vehicles in the platoon','fontsize', 15, 'FontName', 'Times');
ylabel('Outage probability', 'fontsize', 15, 'FontName', 'Times');
legend('MP','2H','1H','DV','EMDS', 'FontName', 'Times' );
set(gca,'XTick',mid+1:1:plot_node);