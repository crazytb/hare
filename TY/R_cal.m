function [result] = R_cal(alpha, state_num1,state_num2,action_num,N_car, N_action, state,action,N_action_PW, K_m, mode)
temp3 = state(state_num1).teller;
interval = N_car - temp3;
temp1 = zeros (1,interval);
temp_action = action(action_num).PW;
test_time = K_m / N_car ;

if mode == 0
    
    for z = 1:N_car - temp3
        if state(state_num1).ack(z +temp3) == 1 && state(state_num2).ack(z+temp3) == 0
            temp1(1,z) = 0;
        elseif state(state_num1).ack(z+temp3) == 1 && state(state_num2).ack(z+temp3) == 1
            temp1(1,z) = 0;
        elseif state(state_num1).ack(z+temp3) == 0 && state(state_num2).ack(z+temp3) == 1
            temp1(1,z) = 1; % - P_E(z, temp_action);
        elseif state(state_num1).ack(z+temp3) == 0 && state(state_num2).ack(z+temp3) == 0
            temp1(1,z) = 0;
        end
    end
    check_P = sum(temp1(1,:))/N_car;
    result = alpha * check_P + (alpha - 1) * (N_action_PW(temp_action)/(N_action_PW(N_action)*K_m));
elseif mode == 1
    
    c_time = state(state_num2).time;
    k_temp = 1;
    for z = 1:N_car - temp3
        if state(state_num1).ack(z +temp3) == 1 && state(state_num2).ack(z+temp3) == 0
            temp1(1,z) = 0;
        elseif state(state_num1).ack(z+temp3) == 1 && state(state_num2).ack(z+temp3) == 1
            temp1(1,z) = 0;
        elseif state(state_num1).ack(z+temp3) == 0 && state(state_num2).ack(z+temp3) == 1
            temp1(1,z) = 1 - (k_temp * log(c_time/(test_time * (z+temp3)))); % - P_E(z, temp_action);
%%            temp1(1,z) = k_temp * ((z+temp3)/c_time);
%             if temp1(1,z) < 0
%                 temp1(1,z) = 0;
%             end
        elseif state(state_num1).ack(z+temp3) == 0 && state(state_num2).ack(z+temp3) == 0
            temp1(1,z) = 0;
        end
    end
    check_P = sum(temp1(1,:))/N_car;
    result = alpha * check_P + (alpha - 1) * (N_action_PW(temp_action)/(N_action_PW(N_action)*K_m));
elseif mode == 2
     c_time = state(state_num2).time;
    k_temp = 1;
    for z = 1:N_car - temp3
        if state(state_num1).ack(z +temp3) == 1 && state(state_num2).ack(z+temp3) == 0
            temp1(1,z) = 0;
        elseif state(state_num1).ack(z+temp3) == 1 && state(state_num2).ack(z+temp3) == 1
            temp1(1,z) = 0;
        elseif state(state_num1).ack(z+temp3) == 0 && state(state_num2).ack(z+temp3) == 1
            temp1(1,z) = 1 - (k_temp * log(c_time/(test_time * (N_car + 1 - (z+temp3))))); % - P_E(z, temp_action);
%%            temp1(1,z) = k_temp * ((z+temp3)/c_time);
%             if temp1(1,z) < 0
%                 temp1(1,z) = 0;
%             end
        elseif state(state_num1).ack(z+temp3) == 0 && state(state_num2).ack(z+temp3) == 0
            temp1(1,z) = 0;
        end
    end
    check_P = sum(temp1(1,:))/N_car;
    result = alpha * check_P + (alpha - 1) * (N_action_PW(temp_action)/(N_action_PW(N_action)*K_m));
end

end

