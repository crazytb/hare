%% Effect on coefficient alpha, tput
x = 0:0.25:1;
y_tput = [8.218614	15.185879	16.315333	16.640634	17.557869
8.218614	15.185879	15.185879	15.185879	15.185879
6.397633	8.910605	10.786315	10.701716	8.994654];

figure();
hold on
plot(x, y_tput(1,:),'LineWidth',1,'Marker','o','MarkerSize',10);
plot(x, y_tput(2,:),'LineWidth',1,'Marker','x','MarkerSize',10);
plot(x, y_tput(3,:),'LineWidth',1,'Marker','s','MarkerSize',10);
legend('HARE', 'ARQ-only', 'HARQ-only', 'Location','best');
xlabel("\alpha")
ylabel("Expected throughput (Mbps)")
grid on
xticks(x);

%% Effect on coefficient alpha, buffer
x = 0:0.25:1;
y_buf = [0	0.015622	0.249162	0.331983	0.357697
0	0	0	0	0
0.605084	0.587344	0.618222	0.625103	0.72409];

figure();
hold on
plot(x, y_buf(1,:),'LineWidth',1,'Marker','o','MarkerSize',10);
plot(x, y_buf(2,:),'LineWidth',1,'Marker','x','MarkerSize',10);
plot(x, y_buf(3,:),'LineWidth',1,'Marker','s','MarkerSize',10);
legend('HARE', 'ARQ-only', 'HARQ-only', 'Location','best');
xlabel("\alpha")
ylabel("Average number of occupying buffer per packet")
grid on
xticks(x);

%% Effect on SNR, tput
x = 5:5:25;
y_tput = [8.180017	17.557869	27.333449	39.090753	39.656219
7.082823	15.185879	25.557231	39.434091	40.010386
3.153559	8.994654	26.423993	36.300731	36.587791
];

figure();
hold on
plot(x, y_tput(1,:),'LineWidth',1,'Marker','o','MarkerSize',10);
plot(x, y_tput(2,:),'LineWidth',1,'Marker','x','MarkerSize',10);
plot(x, y_tput(3,:),'LineWidth',1,'Marker','s','MarkerSize',10);
xlabel("Average SNR (dB)")
ylabel("Expected throughput (Mbps)")
legend('HARE', 'ARQ-only', 'HARQ-only', 'Location','best');
grid on
xticks(x);

%% Effect on SNR, buffer
x = 5:5:25;
y_buf = [0.495061	0.357697	0.293339	0.157448	0.140625
0	0	0	0	0
0.805336	0.72409	0.406653	0.321204	0.289407
];

figure();
hold on
plot(x, y_buf(1,:),'LineWidth',1,'Marker','o','MarkerSize',10);
plot(x, y_buf(2,:),'LineWidth',1,'Marker','x','MarkerSize',10);
plot(x, y_buf(3,:),'LineWidth',1,'Marker','s','MarkerSize',10);
xlabel("Average SNR (dB)")
ylabel("Average number of occupying buffer per packet")
legend('HARE', 'ARQ-only', 'HARQ-only', 'Location','best');
grid on
xticks(x);

%% Effect on moving speed, tput
x = 1:1:4;
% speed = {'1.4'; '2'; '3'; '5'};
speed = [1, 2, 3, 4];
y_tput_old = [17.557869	16.651916	16.301331	16.33999
15.185879	15.477317	16.057649	16.296681
8.994654	9.315726	10.031934	13.04071
];
y_tput = flip(y_tput_old, 2);

figure();
hold on
plot(x, y_tput(1,:),'LineWidth',1,'Marker','o','MarkerSize',10);
plot(x, y_tput(2,:),'LineWidth',1,'Marker','x','MarkerSize',10);
plot(x, y_tput(3,:),'LineWidth',1,'Marker','s','MarkerSize',10);
% xlabel("Moving speed (m/s)")
xlabel("The number of coherence slots")
ylabel("Expected throughput (Mbps)")
legend('HARE', 'ARQ-only', 'HARQ-only', 'Location','best');
grid on
xticks(x);
xticklabels(speed);

%% Effect on moving speed, buffer
x = 1:1:4;
y_buf = [0.357697	0.458578	0.499959	0.37755
0	0	0	0
0.72409	0.714242	0.692272	0.599978
];

figure();
hold on
plot(x, y_buf(1,:),'LineWidth',1,'Marker','o','MarkerSize',10);
plot(x, y_buf(2,:),'LineWidth',1,'Marker','x','MarkerSize',10);
plot(x, y_buf(3,:),'LineWidth',1,'Marker','s','MarkerSize',10);
xlabel("Moving speed (m/s)")
ylabel("Average number of occupying buffer per packet")
legend('HARE', 'ARQ-only', 'HARQ-only', 'Location','best');
grid on
xticks(x);
xticklabels(speed);

%% optimal policy

%% Effect on EbNo: Total reward

% EbNo: 5 6 7 8 9 10
% Walking speed: 3 m/s 
% Number of links: 2 
% Number of buffers per STA: 2 
% Number of MCS states: 4 
% Number of channel variations: 4 
% Number of slots per interval: 2  

x = [5 6 7 8 9 10];
y = [ 2.096946e+03 2.274953e+02 1.708570e+03 
 2.686754e+03 7.141175e+02 1.735773e+03 
 2.701853e+03 7.423388e+02 1.874186e+03 
 2.714960e+03 8.377046e+02 1.921974e+03 
 2.874888e+03 9.777201e+02 2.188795e+03 
 2.945088e+03 9.945591e+02 2.221183e+03]';

figure();
hold on
plot(x, y(1,:),'LineWidth',1,'Marker','o','MarkerSize',10);
plot(x, y(2,:),'LineWidth',1,'Marker','s','MarkerSize',10);
plot(x, y(3,:),'LineWidth',1,'Marker','*','MarkerSize',10);
% plot(x, y(1,:),'-o', ...
%     x, y(2,:),'-s', ...
%     x, y(3,:),'-*');
legend('Adaptive HARQ', 'ARQ-only', 'HARQ-only', 'Location','best');
xlabel("EbNo (dB)")
ylabel("Expected total reward")
xticks(x);

%% Effect on EbNo: Packet error rate

% EbNo: 5 6 7 8 9 10
% Walking speed: 3 m/s 
% Number of links: 2 
% Number of buffers per STA: 2 
% Number of MCS states: 4 
% Number of channel variations: 4 
% Number of slots per interval: 2  

x = [5 6 7 8 9 10];
y = [ 0.316794 	0.831259 	0.421951 ;
    0.200000 	0.760984 	0.351852 ;
    0.200000 	0.750002 	0.337838;
    0.200000 	0.790576 	0.315385 ;
    0.000000 	0.750011 	0.192308;
    0.000000 	0.729279 	0.180000]';

figure();
hold on
plot(x, y(1,:),'LineWidth',1,'Marker','o','MarkerSize',10);
plot(x, y(2,:),'LineWidth',1,'Marker','s','MarkerSize',10);
plot(x, y(3,:),'LineWidth',1,'Marker','*','MarkerSize',10);
% plot(x, y(1,:),'-o', ...
%     x, y(2,:),'-s', ...
%     x, y(3,:),'-*');
legend('Adaptive HARQ', 'ARQ-only', 'HARQ-only', 'Location','best');
xlabel("EbNo (dB)")
ylabel("Packet error rate")
xticks(x);

%% Effect on Walking speed: Total reward

% EbNo: 7.500000e+00 
% Number of links: 2 
% Number of buffers per STA: 4 
% Number of MCS states: 2 
% Number of channel variations: 2  
% Number of slots per interval: 5 3 2 1

x = [1 2 3 5];
y = [ 1.021481e+03 2.968666e+02 7.406681e+02
 1.762217e+03 4.949220e+02 1.250853e+03 
 2.705832e+03 7.427211e+02 1.893268e+03 
 6.086427e+03 1.522338e+03 3.979539e+03]';

figure();
hold on
plot(x, y(1,:),'LineWidth',1,'Marker','o','MarkerSize',10);
plot(x, y(2,:),'LineWidth',1,'Marker','s','MarkerSize',10);
plot(x, y(3,:),'LineWidth',1,'Marker','*','MarkerSize',10);
% plot(x, y(1,:),'-o', ...
%     x, y(2,:),'-s', ...
%     x, y(3,:),'-*');
legend('Adaptive HARQ', 'ARQ-only', 'HARQ-only', 'Location','best');
xlabel("Walking speed (m/s)")
ylabel("Expected total reward")
xticks(x);

%% Effect on Walking speed: Packet error rate

% EbNo: 7.500000e+00 
% Number of links: 2 
% Number of buffers per STA: 4 
% Number of MCS states: 2 
% Number of channel variations: 2  
% Number of slots per interval: 5 3 2 1

x = [1 2 3 5];
y = [ 1.021481e+03 2.968666e+02 7.406681e+02
 1.762217e+03 4.949220e+02 1.250853e+03 
 2.705832e+03 7.427211e+02 1.893268e+03 
 6.086427e+03 1.522338e+03 3.979539e+03]';

figure();
hold on
plot(x, y(1,:),'LineWidth',1,'Marker','o','MarkerSize',10);
plot(x, y(2,:),'LineWidth',1,'Marker','s','MarkerSize',10);
plot(x, y(3,:),'LineWidth',1,'Marker','*','MarkerSize',10);
% plot(x, y(1,:),'-o', ...
%     x, y(2,:),'-s', ...
%     x, y(3,:),'-*');
legend('Adaptive HARQ', 'ARQ-only', 'HARQ-only', 'Location','best');
xlabel("Walking speed (m/s)")
ylabel("Expected total reward")
xticks(x);

%% MCS distribution

% EbNo: 7.500000e+00 
% Walking speed: 5 m/s 
% Number of links: 2 
% Number of buffers per STA: 2 
% Number of MCS states: 4 
% Number of channel variations: 4 
% Number of slots per interval: 1 

x = [1 2 3 4];
y = [0.0000    0.2093    0.3953    0.3953;
    0.9250    0.0750    0.0000    0.0000;
    0.1200    0.1689    0.3556    0.3556];


figure();
hold on
% plot(x, y(1,:),'LineWidth',1,'Marker','o','MarkerSize',10);
% plot(x, y(2,:),'LineWidth',1,'Marker','s','MarkerSize',10);
% plot(x, y(3,:),'LineWidth',1,'Marker','*','MarkerSize',10);
bar(x, y);
legend('Adaptive HARQ', 'ARQ-only', 'HARQ-only', 'Location','best');
xlabel("MCS index")
ylabel("Probability")
xticks(x);