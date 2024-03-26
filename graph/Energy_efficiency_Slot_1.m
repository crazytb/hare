PD1 = [28.125	26.61296644	14.84012571	11.40305598	10.391	9.7501];
PD2 = [33.75	27.2871048	18.08536645	13.64196831	12.97576667	11.9391];
PD3 = [28.125	26.61296644	15.70221497	11.61539037	10.29086637	9.769395685];
PD4 = [28.125	33.53622611	29.59154418	13.75858678	11.72546667	10.39893333];
PD5 = [28.125	29.53184682	28.20975805	26.25482355	18.90760665	18.04521674];



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

xlabel('Number of slots in a Section time','fontsize', 15,  'FontName', 'Times');
ylabel('Energy consumption ratio (mW/v)', 'fontsize', 15,  'FontName', 'Times');
legend('MP','2H','1H','DV','EMDS',  'FontName', 'Times');
set(gca,'XTick',mid+1:1:plot_node);
%ylim([20 30]);