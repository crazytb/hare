d_mode = 2;  %%1 = acc , 2 = deacc
number_of_velocity = 5;
K_m = 3;
N_car = 4;
m_counter = 7;
Combi_N_car = 2^N_car;
Total_potential_state_num = K_m * (N_car * (2^N_car)) + 1;


Combi_N_car = 2^N_car;
Total_potential_state_num = K_m * (N_car * (2^N_car)) + 1;

for i = 1:Total_potential_state_num
    if i == 1
        temp_state(i).time = 0;
        temp_state(i).teller = 0;
        for j = 1:N_car
            temp_state(i).ack(j)=0;
        end
        
    else
        
        cal_teller1 = mod(i-2, Combi_N_car *N_car);
        cal_teller2 = floor (cal_teller1/Combi_N_car);
        temp_u_car = mod((i-1),Combi_N_car);
        
        temp_state(i).teller = cal_teller2;
    
        if temp_u_car == 0
            temp_u_car = Combi_N_car;
        end
        temp_U1 = dec2bin(temp_u_car-1);
        temp_U1 = temp_U1 - '0';
        if size(temp_U1,2) < N_car
            t_pad = N_car - size(temp_U1,2);
            temp_U1 = padarray(temp_U1,[0 t_pad],0,'pre');
        end
        U1 = flip(temp_U1);
        temp_state(i).time = floor((i-2)/(N_car * (2^N_car))) + 1;
        for j = 1:N_car
            temp_state(i).ack(j) = U1(j);
        end               
    end
    temp_state(i).avail = 1;
end



for i = 1:Total_potential_state_num
    if temp_state(i).teller > 0
        result = prod(temp_state(i).ack(1:(temp_state(i).teller)));
        temp_state(i).avail = result;
    end
end

s_counter = 0;
for i = 1:Total_potential_state_num
    if temp_state(i).avail == 1
        s_counter = s_counter + 1;
        m_state(s_counter) = temp_state(i);
    end    
end


mid_counter = 0;
for k = 1:number_of_velocity
    for s = 1:d_mode
        for q = 1:m_counter
            for i = 1: s_counter
                mid_counter = mid_counter + 1;
                mid_state (mid_counter).velocity = k;
                mid_state (mid_counter).m_driving = s;
                mid_state (mid_counter).m_count = q-1;
                mid_state (mid_counter).time = m_state(i).time;
                mid_state (mid_counter).teller = m_state(i).teller;
                mid_state (mid_counter).ack = m_state(i).ack;
            end
        end
    end
end
 
real_counter = 0;
for x = 1:mid_counter
    if mid_state(x).m_driving == 2
        if mid_state(x).m_count > 0
            mid_state(x).avail = 0;
        else
            mid_state(x).avail = 1;
        end
    else
        mid_state(x).avail = 1;
    end
end 

real_counter = 0;
for i = 1:mid_counter
    if mid_state(i).avail == 1
        real_counter = real_counter + 1;
        state(real_counter) = mid_state(i);
    end    
end
