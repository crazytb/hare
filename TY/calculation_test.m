state_num1 = 12;
state_num2 = 21;
temp_action = 2;
temp3 = state(state_num1).teller;
interval = N_car - temp3;
temp1 = zeros (1,interval);
temp2 = 1;
%temp_action = action(action_num).PW;


for z = 1:N_car - temp3
    if state(state_num1).ack(z +temp3) == 1 && state(state_num2).ack(z+temp3) == 0
        temp1(1,z) = 0;
    elseif state(state_num1).ack(z+temp3) == 1 && state(state_num2).ack(z+temp3) == 1
        temp1(1,z) = 1;
    elseif state(state_num1).ack(z+temp3) == 0 && state(state_num2).ack(z+temp3) == 1
        temp1(1,z) = 1 - P_E(z, temp_action);
    elseif state(state_num1).ack(z+temp3) == 0 && state(state_num2).ack(z+temp3) == 0
        temp1(1,z) = P_E(z, temp_action);
    end
end
test_result = prod (temp1(1,:))