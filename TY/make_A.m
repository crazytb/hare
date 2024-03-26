function [action] = make_A(N_action,N_car)

temp_Total_potential_action_num = N_action * N_car;
for i = 1:temp_Total_potential_action_num
    telgap = mod((i-1),N_car);
    PWgap = floor ((i-1)/N_car)+1;
    temp_action(i).telgap = telgap;
    temp_action(i).PW = PWgap;
    if temp_action(i).PW ==1
        if temp_action(i).telgap > 0
            temp_action(i).avail = 0;
        elseif temp_action(i).telgap == 0
            temp_action(i).avail = 1;
        end
    elseif temp_action(i).PW > 1
        temp_action(i).avail = 1;
    end        
end
a_counter = 0;
for i = 1:temp_Total_potential_action_num
    if temp_action(i).avail == 1
        a_counter = a_counter + 1;
        action(a_counter) = temp_action(i);    
    end
end
end

