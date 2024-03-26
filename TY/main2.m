clear all
clc

MDPtoolbox_path = pwd;
addpath(MDPtoolbox_path);
alpha = 0.5;
discount = 0.98;
%% Topology
K_m = 3;
N_car = 3;
meter = 25;
car_width = 3;
distance = zeros (N_car,1);

for i=1:N_car
    distance(i,1) = i*(meter + car_width);
end

%% Network

PL = zeros (N_car,1);
for i=1:N_car
    PL(i,1) = 22.0*log10(distance(i,1))+28+20*log10(5);
end

BW = 2*10^7;
noise_dbm = -174 + 10*log10(BW);
noise_PW = 10^(noise_dbm/10);


%% action
N_action = 3;
N_action_PW = zeros (N_action,1);
N_action_dB = zeros (N_action,1);
for i = 1 : N_action
    N_action_PW (i,1) = (15 * (i));
    N_action_dB (i,1) = 10*log10(N_action_PW(i,1));
end

%% PER
Packet_size = 32*8; %% RTS(20bytes), In the simul = 32bytes
Input = zeros (N_car,N_action);
P_E = zeros (N_car,N_action);
for i = 1:N_car
    for j = 1:N_action
        Input (i,j) = N_action_dB(j,1) - PL(i,1)- noise_dbm - 30;
    end
end


for i = 1:N_car
    for j = 1:N_action
        Error = 0.5*(1-erf(sqrt(10^((Input(i,j))/10))));
        P_E(i,j) = 1-(1-Error)^Packet_size;
    end
end

%% modification for PER & Action set
N_action = N_action + 1;
N_action_PW = [0; N_action_PW];
P_E = padarray(P_E, [0 1], 1, 'pre');





%% State definition 

Total_potential_state_num = K_m * (N_car * (2^N_car)) + 1;
Combi_N_car = 2^N_car;


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
        state(s_counter) = temp_state(i);
    end    
end

%% Action composition

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
%% Transition probability definition

trans_PR = zeros(s_counter, s_counter,a_counter); 
for i = 1:a_counter
    for x = 1:s_counter
        for y = 1:s_counter
            if state(x).time + 1 == state(y).time
                if action(i).telgap == 0
                    if state(x).teller == state(y).teller
                        result_Pr = P_cal(x,y,i,N_car,state,action,P_E, 0);
                        trans_PR (x,y,i) = result_Pr;
                    end
                elseif action(i).telgap > 0
                    target = state(x).teller + action(i).telgap;
                    if target < N_car
                        if state(y).teller == target
                            result_Pr = P_cal(x,y,i,N_car,state,action,P_E, 0);
                            trans_PR (x,y,i) = result_Pr;
                         elseif state(y).teller == state(x).teller
                             result_Pr = P_cal(x,y,i,N_car,state,action,P_E, 1);
                             trans_PR (x,y,i) = result_Pr;    
                        end
                    end
                    if target >= N_car  %% no reward
                        if state(x).teller == state(y).teller
                            if state(x).ack == state(y).ack
                                result_Pr = P_cal(x,y,1,N_car,state,action,P_E,0);
                                trans_PR (x,y,i) = result_Pr;
                            end
                        end
                    end
                end
            elseif state(x).time == K_m %&& state(y).time == K_m %% no reward
%                 if state(x).teller == state(y).teller
%                     if state(x).ack == state(y).ack
%                         result_Pr = P_cal(x,y,1,N_car,state, action, P_E, 0);
%                         trans_PR (x,y,i) = result_Pr;
%                     end
%                 end
                    trans_PR(x,1,i) = 1;
            end
        end
    end
end 

%% Reward definition

reward_f = zeros(s_counter, s_counter,a_counter); 
for i = 1:a_counter
    for x = 1:s_counter
        for y = 1:s_counter
            if state(x).time + 1 == state(y).time
                if action(i).telgap == 0
                    if state(x).teller == state(y).teller
                        result_Rw = R_cal(alpha, x,y,i,N_car, N_action, state,action,N_action_PW, K_m);
                        reward_f (x,y,i) = result_Rw;
                    end
                elseif action(i).telgap > 0
                    target = state(x).teller + action(i).telgap;
                    if target < N_car
                        if state(y).teller == target
                            result_Rw = R_cal(alpha, x,y,i,N_car,N_action, state,action,N_action_PW, K_m);
                            reward_f (x,y,i) = result_Rw;
                         elseif state(y).teller == state(x).teller
                             result_Rw = R_cal(alpha, x,y,i,N_car,N_action, state,action,N_action_PW, K_m);
                             reward_f (x,y,i) = result_Rw;    
                        end
                    end
                    if target >= N_car  %% no reward
                        if state(x).teller == state(y).teller
                            if state(x).ack == state(y).ack
                                reward_f (x,y,i) = 0;
                            end
                        end
                    end
                end
            elseif state(x).time == K_m %&& state(y).time == K_m %% no reward
%                 if state(x).teller == state(y).teller
%                     if state(x).ack == state(y).ack
%                         reward_f (x,y,i) = 0;
%                     end
%                 end
                  reward_f(x,1,i) = 0;
            end
        end
    end
end 





 
%% Running 

P = trans_PR;
R = reward_f;

mdp_check(P,R)

[V, policy] = mdp_policy_iteration (P, R, discount);
V(1)

mu = get_stationary_distribution( mdp_computePpolicyPRpolicy(P, R, policy) );

bar(mu,0.4); ylim([0 1]);

total_energy = 0;
for ii = 1: s_counter
    total_energy = total_energy + mu (1,ii)* action(policy(ii,1)).PW;
end
total_energy
