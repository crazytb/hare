function [trans_PR] = make_P(P_E, state, action, N_car, K_m, number_of_velocity,m_counter)
a_counter = size(action,2);
s_counter = size(state,2);




trans_PR = zeros(s_counter, s_counter,a_counter); 
for i = 1:a_counter
    for x = 1:s_counter
        for y = 1:s_counter
            if state(x).time + 1 == state(y).time && state(x).time < K_m
                if state(x).velocity == state(y).velocity
                    if state(x).m_driving == state(y).m_driving
                        if state(x).m_count == state(y).m_count
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
                        end
                    end
                end
            elseif state(x).time == K_m %&& state(y).time == K_m %% no reward
                if state(y).time == 0 && prod(state(y).ack) == 0
                    if prod(state(x).ack) == 1
                        if state(y).m_driving == 1
                            if state(x).m_driving == 1
                                if state(x).m_count < (m_counter - 1)
                                    if state(y).m_count == state(x).m_count + 1
                                        if state(x).velocity == state(y).velocity
                                            trans_PR(x,y,i) = 1;
                                        end
                                    end
                                elseif state(x).m_count == (m_counter - 1)
                                    if state(y).m_count == 0
                                        if state(x).velocity == number_of_velocity
                                            if state(y).velocity == number_of_velocity
                                                trans_PR(x,y,i) = 1;
                                            end
                                        else
                                            if state(y).velocity == state(x).velocity + 1
                                                trans_PR(x,y,i) = 1;
                                            end
                                        end
                                    end
                                end
                            elseif state(x).m_driving == 2
                                if state(y).m_count == 0
                                    if state(y).velocity == state(x).velocity
                                        trans_PR(x,y,i) = 1;
                                    end
                                end
                            end
                        end
                    else
                        if state(x).m_driving == 2
                            if state(y).m_driving == 2
                                if state(y).m_count == 0
                                    if state(x).velocity == 1
                                        if state(y).velocity == 1
                                            trans_PR(x,y,i) = 1;
                                        end
                                    else
                                        if state(y).velocity == state(x).velocity - 1
                                            trans_PR(x,y,i) = 1;
                                        end
                                    end
                                end
                            end
                        else
                            if state(y).m_driving == 2
                                if state(y).m_count == 0
                                    if state(y).velocity == state(x).velocity
                                        trans_PR(x,y,i) = 1;
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


                       
