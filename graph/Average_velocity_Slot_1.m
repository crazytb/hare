PD1 = [1	1.2247	1.9728	2.8207	3	3];
PD2 = [1	1.3664	2.0617	2.8207	3	3];
PD3 = [1	1.2247	1.9007	2.6731	2.9364	2.9852];
PD4 = [1	1.0048	1.1022	2.7455	3	3];
PD5 = [1	1.0001	1.0002	1.0003	1.3291	1.338];



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
ylabel('Average velocity level', 'fontsize', 15, 'FontName', 'Times');
legend('MP','2H','1H','DV','EMDS', 'FontName', 'Times');
set(gca,'XTick',mid+1:1:plot_node);