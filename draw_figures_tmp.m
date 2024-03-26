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