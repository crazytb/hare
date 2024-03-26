PD1 = [3	3	2.76E+00	1.9728	1.4608	1.3095];
PD2 = [3	3	2.7596	2.0617	1.5202	1.3066];
PD3 = [2.9913	2.9475	2.7355	1.9007	1.2902	1.0589];
PD4 = [3	3	2.7455	1.1022	1.0049	1];
PD5 = [3	2.9475	2.7355	1.0002	1.0007	1];



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

xlabel('Number of vehicles in the platoon','fontsize', 15,  'FontName', 'Times');
ylabel('Average velocity level', 'fontsize', 15,  'FontName', 'Times');
legend('MP','2H','1H','DV','EMDS',  'FontName', 'Times');
set(gca,'XTick',mid+1:1:plot_node);