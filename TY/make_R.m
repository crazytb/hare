function [reward_f] = make_R(alpha, state, action, N_car, N_action, N_action_PW, K_m, mode)
a_counter = size(action,2);
s_counter = size(state,2);

reward_f = zeros(s_counter, s_counter,a_counter); 
for i = 1:a_counter
    for x = 1:s_counter
        for y = 1:s_counter
            if state(x).velocity == state(y).velocity
                if state(x).m_driving == state(y).m_driving
                    if state(x).m_count == state(y).m_count
                        if state(x).time < K_m
                            if state(x).time + 1 == state(y).time
                                if action(i).telgap == 0
                                    if state(x).teller == state(y).teller
                                        result_Rw = R_cal(alpha, x,y,i,N_car, N_action, state,action,N_action_PW, K_m, mode);
                                        reward_f (x,y,i) = result_Rw;
                                    end
                                elseif action(i).telgap > 0
                                    target = state(x).teller + action(i).telgap;
                                    if target < N_car
                                        if state(y).teller == target
                                            result_Rw = R_cal(alpha, x,y,i,N_car,N_action, state,action,N_action_PW, K_m, mode);
                                            reward_f (x,y,i) = result_Rw;
                                        elseif state(y).teller == state(x).teller
                                            result_Rw = R_cal(alpha, x,y,i,N_car,N_action, state,action,N_action_PW, K_m, mode);
                                            reward_f (x,y,i) = result_Rw;
                                        end
                                    end
                                    if target >= N_car  %% no reward
                                        if state(x).teller == state(y).teller
                                            if state(x).ack == state(y).ack
                                                reward_f (x,y,i) = -10;
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            
        end
    end
end
end


%             elseif state(x).time == K_m %&& state(y).time == K_m %% no reward
%                   reward_f(x,y,i) = 0;