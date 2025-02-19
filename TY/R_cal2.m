function [result] = R_cal2(alpha, state_num1,state_num2,action_num,N_car, N_action, state,action,N_action_PW, K_m)
temp3 = state(state_num1).teller;
interval = N_car - temp3;
temp1 = zeros (1,interval);
temp_action = action(action_num).PW;

if state(state_num2).time == K_m

    for z = 1:N_car
        if state(state_num2).ack(z) == 0
            temp1(1,z) = 0;
        elseif state(state_num2).ack(z) == 1
            temp1(1,z) = 1;
        end
    end
end
check_P = prod(temp1(1,:));
result = alpha * check_P + (alpha - 1) * (N_action_PW(temp_action)/(N_action_PW(N_action)*K_m));


end

