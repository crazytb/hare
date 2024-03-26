clearvars
clc

% 
tic
% global ebnodB ppduLength;
snrdB = 10;
ppduDuration = 5484;    % usec, defined in 11ax as max PPDU duration.
% ppduLength = 8*(8*(1538+4+2))+6;     % TGax Simulation Scenarios, bits, 8 MPDUs
% dataRate = 2*[8.1 16.3 24.4 32.5 48.8 65.0 73.1 81.3 97.5 108.3 121.9 135.4];     % Mbps, 1.6 μs GI, 20MHz, SS=2
dataRate = [8.1 16.3 24.4 32.5];     % Mbps, 1.6 μs GI, 20MHz, SS=1, BPSK/QPSK/16/64
ebnodB = snrdB - 10*log10(dataRate/20);
% dataDuration = ppduLength./dataRate;        % usec
ppduLength = ppduDuration*dataRate;
channelTransitionProb = 0.1;
numLinks = 2;
ackLevel = 2^numLinks;
alpha = 0.5; % 0: minimizing cost, 1: maximizing tput

%% Calculate channel coherence time
f_c = 5*10^9;
velocity = 5;  % 1.4, 2, 3, 5m/s
c = 300000000;  % m/s
f_m = (velocity/c)*f_c;
T_c = sqrt(9/(16*pi))*(1/f_m); % sec
slotNumber = T_c./min(ppduDuration)*10^6;


%% State definition
% global mcsStateLevel ackLevel stateSize harqActionLevel mcsActionLevel
bufferCounterLevel = 2^numLinks; % Max retx counter is Retxcounter-1
mcsStateLevel = 4;
channelLevel = 4^numLinks;
slotCounterLevel = ceil(slotNumber);
stateSize = bufferCounterLevel*mcsStateLevel*ackLevel*channelLevel*slotCounterLevel;

state = MakeS(bufferCounterLevel, mcsStateLevel, ackLevel, channelLevel, slotCounterLevel);

state_recon = struct('buffer1', cell(1, size(state,2)), 'buffer2', cell(1, size(state,2)), 'mcs', cell(1, size(state,2)), 'ack1', cell(1, size(state,2)), 'ack2', cell(1, size(state,2)), 'channel1', cell(1, size(state,2)), 'channel2', cell(1, size(state,2)), 'leftslot', cell(1, size(state,2)));
for ii = 1:size(state,2)
    state_recon(ii).buffer1 = state(ii).buffer(1);
    state_recon(ii).buffer2 = state(ii).buffer(2);
    state_recon(ii).mcs = state(ii).mcs;
    state_recon(ii).ack1 = state(ii).ack(1);
    state_recon(ii).ack2 = state(ii).ack(2);
    state_recon(ii).channel1 = state(ii).channel(1);
    state_recon(ii).channel2 = state(ii).channel(2);
    state_recon(ii).leftslot = state(ii).leftslot;
end
state_mat_res = reshape(cell2mat(struct2cell(state_recon)), [8, size(state,2)]);
state_mat = state_mat_res.';

%% Action definition
harqActionLevel = 2;
mcsActionLevel = mcsStateLevel;

action = MakeA(harqActionLevel, mcsActionLevel);

%% PER definition
% per = MakePer(bufferCounterLevel, harqActionLevel, mcsActionLevel, ebnodB, ppduLength);

%% Channel model definition
% channelModel = MakeChannelModel(channelTransitionProb);


%% Transition prob. definition
% P(s, s', a)
% R(s', a)
% [P_proposed, R_proposed] = MakeP_revised(state, action, dataRate, ebnodB, ppduLength, bufferCounterLevel, channelLevel, mcsStateLevel, numLinks, slotCounterLevel, 'proposed');
% [P_arq, R_arq] = MakeP_revised(state, action, dataRate, ebnodB, ppduLength, bufferCounterLevel, channelLevel, mcsStateLevel, numLinks, slotCounterLevel, 'arq');
% [P_harq, R_harq] = MakeP_revised(state, action, dataRate, ebnodB, ppduLength, bufferCounterLevel, channelLevel, mcsStateLevel, numLinks, slotCounterLevel, 'harq');
[P_proposed, R_proposed] = MakeP_revised_1(state, state_mat, action, dataRate, ebnodB, ppduLength, bufferCounterLevel, channelLevel, mcsStateLevel, numLinks, slotCounterLevel, 'proposed', alpha);
[P_arq, R_arq] = MakeP_revised_1(state, state_mat, action, dataRate, ebnodB, ppduLength, bufferCounterLevel, channelLevel, mcsStateLevel, numLinks, slotCounterLevel, 'arq', alpha);
[P_harq, R_harq] = MakeP_revised_1(state, state_mat, action, dataRate, ebnodB, ppduLength, bufferCounterLevel, channelLevel, mcsStateLevel, numLinks, slotCounterLevel, 'harq', alpha);
% [P_proposed, R_proposed] = MakeP_proposed(state, action, dataRate);
% [P_arq, R_arq] = MakeP_onlyARQ(state, action, dataRate);
% [P_harq, R_harq] = MakeP_onlyHARQ(state, action, dataRate);
%% Using GPU
% P_proposed = gpuArray(P_proposed);
% P_arq = gpuArray(P_arq);
% P_harq = gpuArray(P_harq);
% R_proposed = gpuArray(R_proposed);
% R_arq = gpuArray(R_arq);
% R_harq = gpuArray(R_harq);

%% Policy iteration
discountFactor = 0.95;
[V_proposed, policy_proposed] = mdp_policy_iteration(P_proposed, R_proposed, discountFactor);
[V_arq, policy_arq] = mdp_policy_iteration(P_arq, R_arq, discountFactor);
[V_harq, policy_harq] = mdp_policy_iteration(P_harq, R_harq, discountFactor);
meanValues = mean([V_proposed, V_arq, V_harq]);

%% Get stationary distribution
[P_policy_proposed, ~] = mdp_computePpolicyPRpolicy(P_proposed, R_proposed, policy_proposed);
[P_policy_arq, ~] = mdp_computePpolicyPRpolicy(P_arq, R_arq, policy_arq);
[P_policy_harq, ~] = mdp_computePpolicyPRpolicy(P_harq, R_harq, policy_harq);

mu_proposed = get_stationary_distribution(mdp_computePpolicyPRpolicy(P_proposed, R_proposed, policy_proposed));
mu_arq = get_stationary_distribution(mdp_computePpolicyPRpolicy(P_arq, R_arq, policy_arq));
mu_harq = get_stationary_distribution(mdp_computePpolicyPRpolicy(P_harq, R_harq, policy_harq));
mu_proposed(mu_proposed<0) = 0; mu_arq(mu_arq<0) = 0; mu_harq(mu_harq<0) = 0;

%% Get average delay
P_policy_proposed_ack_wise = zeros(4,4); P_policy_arq_ack_wise = zeros(4,4); P_policy_harq_ack_wise = zeros(4,4);
mu_proposed_ack_wise = zeros(4,1); mu_arq_ack_wise = zeros(4,1); mu_harq_ack_wise = zeros(4,1);
mu_proposed_rep = repmat(mu_proposed,1,size(state,2)); mu_arq_rep = repmat(mu_arq,1,size(state,2)); mu_harq_rep = repmat(mu_harq,1,size(state,2));
P_policy_proposed_mu = mu_proposed_rep.*P_policy_proposed; P_policy_arq_mu = mu_arq_rep.*P_policy_arq; P_policy_harq_mu = mu_harq_rep.*P_policy_harq;

for ia = 1:size(state,2)
    ack_ia = state(ia).ack;
%     index_ack_ia = bi2de(ack_ia, 'left-msb')+1;
    index_ack_ia = b2d(ack_ia)+1;
    mu_proposed_ack_wise(index_ack_ia) = mu_proposed_ack_wise(index_ack_ia) + mu_proposed(ia);
    mu_arq_ack_wise(index_ack_ia) = mu_arq_ack_wise(index_ack_ia) + mu_arq(ia);
    mu_harq_ack_wise(index_ack_ia) = mu_harq_ack_wise(index_ack_ia) + mu_harq(ia);
end

for ja = 1:size(state,2)
    for jb = 1:size(state,2)
        ack_ja = state(ja).ack;
        ack_jb = state(jb).ack;
%         index_ack_ja = bi2de(ack_ja, 'left-msb')+1;
%         index_ack_jb = bi2de(ack_jb, 'left-msb')+1;
        index_ack_ja = b2d(ack_ja)+1;
        index_ack_jb = b2d(ack_jb)+1;
        P_policy_proposed_ack_wise(index_ack_ja, index_ack_jb) = P_policy_proposed_ack_wise(index_ack_ja, index_ack_jb) + P_policy_proposed_mu(ja, jb);
        P_policy_arq_ack_wise(index_ack_ja, index_ack_jb) = P_policy_arq_ack_wise(index_ack_ja, index_ack_jb) + P_policy_arq_mu(ja, jb);
        P_policy_harq_ack_wise(index_ack_ja, index_ack_jb) = P_policy_harq_ack_wise(index_ack_ja, index_ack_jb) + P_policy_harq_mu(ja, jb);
    end
end

P_policy_proposed_ack_wise = P_policy_proposed_ack_wise./mu_proposed_ack_wise;
P_policy_arq_ack_wise = P_policy_arq_ack_wise./mu_arq_ack_wise;
P_policy_harq_ack_wise = P_policy_harq_ack_wise./mu_harq_ack_wise;

%% Environments
fprintf("EbNo: %d \n",ebnodB);
fprintf("SNR: %d \n",snrdB);
fprintf("Walking speed: %d m/s \n",velocity);
fprintf("Number of links: %d \n", numLinks);
fprintf("Number of buffers per STA: %d \n", bufferCounterLevel^(1/numLinks));
fprintf("Number of MCS states: %d \n", mcsStateLevel);
fprintf("Number of channel variations: %d \n", channelLevel^(1/numLinks));
fprintf("Number of slots per interval: %d \n", slotCounterLevel);
fprintf("Coefficient (alpha): %d \n", alpha);
fprintf("Discount factor: %d \n", discountFactor);
% fprintf('Proposed, ARQ, HARQ \n')

fprintf("Total reward, Proposed, ARQ, HARQ \n %d \n %d \n %d \n", meanValues(1), meanValues(2), meanValues(3));
% disp(meanValues)

%% Get average MCS level
aveMcs_proposed = zeros(1,mcsStateLevel);
aveMcs_arq = zeros(1,mcsStateLevel);
aveMcs_harq = zeros(1,mcsStateLevel);

for iMcs = 1:1:mcsStateLevel
    aveMcs_proposed(iMcs) = sum(mu_proposed([state.mcs]==(iMcs-1)));
    aveMcs_arq(iMcs) = sum(mu_arq([state.mcs]==(iMcs-1)));
    aveMcs_harq(iMcs) = sum(mu_harq([state.mcs]==(iMcs-1)));
end
fprintf("Average MCS Prob. (proposed): \n");
fprintf("%f \t", aveMcs_proposed); fprintf("\n");
fprintf("Average MCS Prob. (ARQ): \n");
fprintf("%f \t", aveMcs_arq); fprintf("\n");
fprintf("Average MCS Prob. (HARQ): \n");
fprintf("%f \t", aveMcs_harq); fprintf("\n");

%% Get average fail probability and tputs
failProb_proposed_tmp = zeros(size(state,2),1);
failProb_arq_tmp = zeros(size(state,2),1);
failProb_harq_tmp = zeros(size(state,2),1);
tput_proposed_tmp = zeros(size(state,2),1);
tput_arq_tmp = zeros(size(state,2),1);
tput_harq_tmp = zeros(size(state,2),1);

for iAck = 1:1:size(state,2)
    if isequal(state(iAck).ack, [0, 0])
        failProb_proposed_tmp(iAck) = mu_proposed(iAck);
        failProb_arq_tmp(iAck) = mu_arq(iAck);
        failProb_harq_tmp(iAck) = mu_harq(iAck);
    elseif isequal(state(iAck).ack, [0, 1]) || isequal(state(iAck).ack, [1, 0])
        failProb_proposed_tmp(iAck) = 0.5*mu_proposed(iAck);
        failProb_arq_tmp(iAck) = 0.5*mu_arq(iAck);
        failProb_harq_tmp(iAck) = 0.5*mu_harq(iAck);
    end
end

for iMcs = 1:1:size(state,2)
    tput_proposed_tmp(iMcs) = mu_proposed(iMcs)*dataRate(state(iMcs).mcs+1)*sum(state(iMcs).ack);
    tput_arq_tmp(iMcs) = mu_arq(iMcs)*dataRate(state(iMcs).mcs+1)*sum(state(iMcs).ack);
    tput_harq_tmp(iMcs) = mu_harq(iMcs)*dataRate(state(iMcs).mcs+1)*sum(state(iMcs).ack);
end

failProb_proposed = sum(failProb_proposed_tmp);
failProb_arq = sum(failProb_arq_tmp);
failProb_harq = sum(failProb_harq_tmp);

tput_proposed = sum(tput_proposed_tmp);
tput_arq = sum(tput_arq_tmp);
tput_harq = sum(tput_harq_tmp);

fprintf("Failure prob., proposed, ARQ, HARQ \n %f \n %f \n %f \n", failProb_proposed, failProb_arq, failProb_harq);
fprintf("Mean Tput (Mbps), proposed, ARQ, HARQ \n %f \n %f \n %f \n", tput_proposed, tput_arq, tput_harq);

%% Get average buffer size

aveBuf_proposed = zeros(1,bufferCounterLevel^(1/numLinks));
aveBuf_arq = zeros(1,bufferCounterLevel^(1/numLinks));
aveBuf_harq = zeros(1,bufferCounterLevel^(1/numLinks));

for iBuf = 1:1:bufferCounterLevel^(1/numLinks)
    aveBuf_proposed(iBuf) = sum(mu_proposed([state_mat(:,1)]==(iBuf-1)));
    aveBuf_arq(iBuf) = sum(mu_arq([state_mat(:,1)]==(iBuf-1)));
    aveBuf_harq(iBuf) = sum(mu_harq([state_mat(:,1)]==(iBuf-1)));
end
fprintf("Average buffer size, proposed, ARQ, HARQ \n %f \n %f \n %f \n", [0:1:bufferCounterLevel^(1/numLinks)-1]*aveBuf_proposed', [0:1:bufferCounterLevel^(1/numLinks)-1]*aveBuf_arq', [0:1:bufferCounterLevel^(1/numLinks)-1]*aveBuf_harq');
% fprintf("%f \t", [0:1:bufferCounterLevel^(1/numLinks)-1]*aveBuf_proposed'); fprintf("\n");
% fprintf("Average buffer size (ARQ): \n");
% fprintf("%f \t", [0:1:bufferCounterLevel^(1/numLinks)-1]*aveBuf_arq'); fprintf("\n");
% fprintf("Average buffer size (HARQ): \n");
% fprintf("%f \t", [0:1:bufferCounterLevel^(1/numLinks)-1]*aveBuf_harq'); fprintf("\n");
toc
