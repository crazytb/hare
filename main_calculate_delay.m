slotTrials = 10000;
currentpos_proposed = 1;
currentpos_arq = 1;
currentpos_harq = 1;
delay_proposed = zeros(2,slotTrials);
delay_arq = zeros(2,slotTrials);
delay_harq = zeros(2,slotTrials);
delay_proposed_now = [0; 0];
delay_arq_now = [0; 0];
delay_harq_now = [0; 0];
counter_proposed = 1;
counter_arq = 1;
counter_harq = 1;


for ind = 1:slotTrials
    currentpos_proposed = randsample(1:1:size(P_policy_proposed_ack_wise,2), 1, true, P_policy_proposed_ack_wise(currentpos_proposed,:));
    currentpos_arq = randsample(1:1:size(P_policy_arq_ack_wise,2), 1, true, P_policy_arq_ack_wise(currentpos_arq,:));
    currentpos_harq = randsample(1:1:size(P_policy_harq_ack_wise,2), 1, true, P_policy_harq_ack_wise(currentpos_harq,:));
    
    delay_proposed_now = delay_proposed_now + 1;
    delay_arq_now = delay_arq_now + 1;
    delay_harq_now = delay_harq_now + 1;
    
    if currentpos_proposed == 2
        delay_proposed(counter_proposed) = delay_proposed_now(2);
        delay_proposed_now(2) = 0;
        counter_proposed = counter_proposed + 1;
    elseif currentpos_proposed == 3
        delay_proposed(counter_proposed) = delay_proposed_now(1);
        delay_proposed_now(1) = 0;
        counter_proposed = counter_proposed + 1;
    elseif currentpos_proposed == 4
        delay_proposed(counter_proposed) = delay_proposed_now(1);
        delay_proposed_now(1) = 0;
        counter_proposed = counter_proposed + 1;
        delay_proposed(counter_proposed) = delay_proposed_now(2);
        delay_proposed_now(2) = 0;
        counter_proposed = counter_proposed + 1;
    end
       
    if currentpos_arq == 2
        delay_arq(counter_arq) = delay_arq_now(2);
        delay_arq_now(2) = 0;
        counter_arq = counter_arq + 1;
    elseif currentpos_arq == 3
        delay_arq(counter_arq) = delay_arq_now(1);
        delay_arq_now(1) = 0;
        counter_arq = counter_arq + 1;
    elseif currentpos_arq == 4
        delay_arq(counter_arq) = delay_arq_now(1);
        delay_arq_now(1) = 0;
        counter_arq = counter_arq + 1;
        delay_arq(counter_arq) = delay_arq_now(2);
        delay_arq_now(2) = 0;
        counter_arq = counter_arq + 1;
    end
    
    if currentpos_harq == 2
        delay_harq(counter_harq) = delay_harq_now(2);
        delay_harq_now(2) = 0;
        counter_harq = counter_harq + 1;
    elseif currentpos_harq == 3
        delay_harq(counter_harq) = delay_harq_now(1);
        delay_harq_now(1) = 0;
        counter_harq = counter_harq + 1;
    elseif currentpos_harq == 4
        delay_harq(counter_harq) = delay_harq_now(1);
        delay_harq_now(1) = 0;
        counter_harq = counter_harq + 1;
        delay_harq(counter_harq) = delay_harq_now(2);
        delay_harq_now(2) = 0;
        counter_harq = counter_harq + 1;
    end
end

delay_proposed = delay_proposed(1:counter_proposed-1);
delay_arq = delay_arq(1:counter_arq-1);
delay_harq = delay_harq(1:counter_harq-1);

fprintf("Ave. delay, proposed, ARQ, HARQ \n %f \n %f \n %f \n", mean(delay_proposed), mean(delay_arq), mean(delay_harq));