clear all
clc

MDPtoolbox_path = pwd;
addpath(MDPtoolbox_path);

K_m = 3;
N_car = 5;

alpha = 0.60;
discount = 0.90;
mode = 0;
number_of_action = 3;     %% if set n, in practice, n + 1 actions
number_of_velocity = 3;
given_velocity = 8;
term_velocity = 4;
head_time = 1.6;
safe_distance = 2;
car_width = 3;
Packet_size = 32*8; %% RTS(20bytes), In the simul = 32bytes
m_counter = 2; %%adaptive increase
d_mode = 2; %%1 = acc , 2 = deacc
%% Topology

velocity = zeros (1, number_of_velocity);

for i = 1: number_of_velocity
   velocity (1,i) = given_velocity + (i-1)*term_velocity; 
end


distance = zeros (N_car,number_of_velocity);

for j = 1:number_of_velocity
    for i=1:N_car
        distance(i,j) = i*(head_time*velocity(1,j) + car_width+safe_distance);
    end
end

%% Network

PL = zeros (N_car,number_of_velocity);

for j=1:number_of_velocity
    for i=1:N_car
        PL(i,j) = 22.0*log10(distance(i,j))+28+20*log10(5);
    end
end

BW = 2*10^7;
noise_dbm = -174 + 10*log10(BW);
noise_PW = 10^(noise_dbm/10);


%% Power action
N_action = number_of_action;
N_action_PW = zeros (N_action,1);
N_action_dB = zeros (N_action,1);
for i = 1 : N_action
    N_action_PW (i,1) = (15 * (i));
    N_action_dB (i,1) = 10*log10(N_action_PW(i,1));
end

%% PER

Input = zeros (N_car,N_action,number_of_velocity);
P_E = zeros (N_car,N_action);
for k = 1:number_of_velocity
    for i = 1:N_car
        for j = 1:N_action
            Input (i,j,k) = N_action_dB(j,1) - PL(i,k)- noise_dbm - 30;
        end
    end
end
for k = 1:number_of_velocity
    for i = 1:N_car
        for j = 1:N_action
            Error = 0.5*(1-erf(sqrt(10^((Input(i,j,k))/10))));
            P_E(i,j,k) = 1-(1-Error)^Packet_size;
        end
    end
end
%% modification for PER & Action set
N_action = N_action + 1;
N_action_PW = [0; N_action_PW];
P_E = padarray(P_E, [0 1], 1, 'pre');





%% State definition 
[state] = make_S(N_car,K_m,number_of_velocity,m_counter, d_mode);


%% Action composition
action = make_A(N_action,N_car);


%% Transition probability definition
P = make_P(P_E, state, action, N_car, K_m, number_of_velocity,m_counter);


%% Reward definition
R = make_R(alpha, state, action, N_car, N_action, N_action_PW, K_m, mode);


%% Running 

mdp_check(P,R)

[V, policy] = mdp_policy_iteration (P, R, discount);
%V(1)

mu = get_stationary_distribution( mdp_computePpolicyPRpolicy(P, R, policy) );

bar(mu,0.4); ylim([0 1]);

avg_energy = 0;

s_counter = size(state, 2);

avg_velocity = 0;

for i = 1: size(mu,2)
    avg_velocity = avg_velocity + mu(i)*state(i).velocity;
end

for ii = 1: s_counter
    avg_energy = avg_energy + mu (1,ii)* action(policy(ii,1)).PW;
end


prob_suc = zeros (number_of_velocity, 1);
prob_end = zeros (number_of_velocity, 1);
comp = ones(1, N_car);
for jj = 1:number_of_velocity
for ii = 1: s_counter
    if state(ii).time == K_m && state(ii).velocity == jj
       prob_end(jj,1) = prob_end(jj,1) + mu (1, ii);
       if state(ii).ack == comp
            prob_suc(jj,1) = prob_suc(jj,1) + mu(1,ii);
       end
    end
end
end


prob_velocity = zeros (number_of_velocity, 1);
for jj = 1: number_of_velocity
    for ii = 1:s_counter
        if state(ii).velocity == jj
            prob_velocity(jj,1) = prob_velocity(jj,1) + mu(1,ii);
        end
    end
end
prob_out = zeros (number_of_velocity, 1);

outage_probability = 0;

for jj = 1: number_of_velocity
    prob_out(jj,1) = 1-(prob_suc(jj,1)/prob_end(jj,1));
    outage_probability = outage_probability + prob_out(jj,1) * prob_velocity(jj,1);
end   


outage_probability
avg_velocity
avg_energy = avg_energy * 45 / 4

