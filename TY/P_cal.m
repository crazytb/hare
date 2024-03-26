function [result] = P_cal(state_num1,state_num2,action_num,N_car,state,action,P_E, mode)
temp3 = state(state_num1).teller;
interval = N_car - temp3;
temp1 = zeros (1,interval);
temp2 = 1;
temp_action = action(action_num).PW;
temp_target = state(state_num1).teller + action(action_num).telgap;
velocity = state(state_num1).velocity;
for z = 1:N_car - temp3
    if state(state_num1).ack(z +temp3) == 1 && state(state_num2).ack(z+temp3) == 0
        temp1(1,z) = 0;
    elseif state(state_num1).ack(z+temp3) == 1 && state(state_num2).ack(z+temp3) == 1
        temp1(1,z) = 1;
    elseif state(state_num1).ack(z+temp3) == 0 && state(state_num2).ack(z+temp3) == 1
        temp1(1,z) = 1 - P_E(z, temp_action, velocity);
    elseif state(state_num1).ack(z+temp3) == 0 && state(state_num2).ack(z+temp3) == 0
        temp1(1,z) = P_E(z, temp_action, velocity);
    end
end


for z = 1:temp_target
    temp2 = temp2 * state(state_num2).ack(z); 
end

if mode == 1
    result = (1-temp2) *prod(temp1(1,:));
elseif mode == 0
    result = temp2 * prod (temp1(1,:));
end

end

