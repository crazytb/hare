%% Statistics

% 1: buffer1, bufferCounterLevel/2
% 2: buffer2, bufferCounterLevel/2
% 3: mcs, mcsStateLevel
% 4: ack1, ackLevel/2
% 5: ack2, ackLevel/2
% 6: channel1, channelLevel/2
% 7: channel2, channelLevel/2
% 8: leftslot, slotCounterLevel

res_proposed = zeros(slotCounterLevel, size(action, 2));
res_arq = zeros(slotCounterLevel, size(action, 2));
res_harq = zeros(slotCounterLevel, size(action, 2));
focus = 8;
state_stat_proposed = [state_mat'; policy_proposed']';
state_stat_arq= [state_mat'; policy_arq']';
state_stat_harq= [state_mat'; policy_harq']';

for ind = 1:size(state_stat_proposed,1)
    val = state_stat_proposed(ind, focus);
    res_proposed(val+1, state_stat_proposed(ind, 9)) = res_proposed(val+1, state_stat_proposed(ind, 9)) + 1;
    res_arq(val+1, state_stat_arq(ind, 9)) = res_arq(val+1, state_stat_arq(ind, 9)) + 1;
    res_harq(val+1, state_stat_harq(ind, 9)) = res_harq(val+1, state_stat_harq(ind, 9)) + 1;
end

for ii = 1:size(res_proposed,1)
    res_proposed(ii,:) = res_proposed(ii,:)/sum(res_proposed(ii,:));
    res_arq(ii,:) = res_arq(ii,:)/sum(res_arq(ii,:));
    res_harq(ii,:) = res_harq(ii,:)/sum(res_harq(ii,:));
end

%% Plot
x = 1:1:4;
names = {'(0,1)'; '(0,2)'; '(0,3)'; '(0,4)'; '(1,1)'; '(1,2)'; '(1,3)'; '(1,4)'};
figure();
bar3(res_proposed)
set(gca,'ytick',[1:1:8],'xticklabel',names, 'yticklabel', 0:1:3)
xlabel("(h, m_A)")
ylabel("f")
zlabel("Probability")
view(-10, 30)
figure();
bar3(res_arq)
set(gca,'ytick',[1:1:8],'xticklabel',names, 'yticklabel', 0:1:3)
xlabel("(h, m_A)")
ylabel("f")
zlabel("Probability")
view(-10, 30)
figure();
bar3(res_harq)
set(gca,'ytick',[1:1:8],'xticklabel',names, 'yticklabel', 0:1:3)
xlabel("(h, m_A)")
ylabel("f")
zlabel("Probability")
view(-10, 30)

%%
% figure();
% hold on
% plot(x, y_tput(1,:),'LineWidth',1,'Marker','o','MarkerSize',10);
% plot(x, y_tput(2,:),'LineWidth',1,'Marker','x','MarkerSize',10);
% plot(x, y_tput(3,:),'LineWidth',1,'Marker','s','MarkerSize',10);
% legend('HARE', 'ARQ-only', 'HARQ-only', 'Location','best');
% xlabel("\alpha")
% ylabel("Expected throughput (Mbps)")
% grid on
% xticks(x);