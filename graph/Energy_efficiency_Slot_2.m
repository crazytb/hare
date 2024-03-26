PD1 = [6.9498	10.089	12.53348311	14.84012571	21.0546276	24.83589156];
PD2 = [10.0898	11.9643	13.79989854	18.08536645	24.16214972	28.7800398];
PD3 = [8.054558219	9.187311281	11.5771157	15.70221497	26.06983413	29.25375338];
PD4 = [6.9498	10.089	13.15756693	29.59154418	35.4521843	35.6432];
PD5 = [6.9498	9.187311281	11.5771157	28.20975805	27.77315879	35.3317];



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
ylabel('Energy consumption ratio (mW/v)', 'fontsize', 15, 'FontName', 'Times');
legend('MP','2H','1H','DV','EMDS','FontName', 'Times');
set(gca,'XTick',mid+1:1:plot_node);
%ylim([20 30]);