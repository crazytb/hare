function [P, R] = MakeP_onlyARQ(state, action, dataRate)

global bufferCounterLevel channelLevel numLinks slotCounterLevel
maxBufferPerLink = bufferCounterLevel^(1/numLinks);
maxChannelPerLink = channelLevel^(1/numLinks);
P = zeros(size(state,2), size(state,2), size(action,2));
R = zeros(size(state,2), size(action,2));

% For each iNow, just insert transition probabilities to corresponding to
% iNext, like P(iNow, "state([])", iAct). Let's define function, input ([])
% to the field of state.
for iNow = 1:1:size(state,2)
    for iAct = 1:1:size(action,2)
        [per1, per2] = CalculatedPer(state(iNow), action(iAct));
        if sum(action(iAct).harqaction) == 0    % Valid no HARQ action
            if state(iNow).leftslot ~= 0    % Last slot이 아닌 경우
                % Case 1: L1 성공, L2 성공
                P(iNow, StateToField([0 0 action(iAct).mcsaction 1 1 state(iNow).channel(1) state(iNow).channel(2) state(iNow).leftslot-1], state), iAct)...
                    = (1-per1)*(1-per2);
                R(StateToField([0 0 action(iAct).mcsaction 1 1 state(iNow).channel(1) state(iNow).channel(2) state(iNow).leftslot-1], state), iAct)...
                    = 2*(1/slotCounterLevel)*dataRate(action(iAct).mcsaction+1);
                % Case 2: L1 성공, L2 실패
                P(iNow, StateToField([0 1 action(iAct).mcsaction 1 0 state(iNow).channel(1) state(iNow).channel(2) state(iNow).leftslot-1], state), iAct)...
                    = (1-per1)*per2;
                R(StateToField([0 1 action(iAct).mcsaction 1 0 state(iNow).channel(1) state(iNow).channel(2) state(iNow).leftslot-1], state), iAct)...
                    = (1/slotCounterLevel)*dataRate(action(iAct).mcsaction+1);
                % Case 3: L1 실패, L2 성공
                P(iNow, StateToField([1 0 action(iAct).mcsaction 0 1 state(iNow).channel(1) state(iNow).channel(2) state(iNow).leftslot-1], state), iAct)...
                    = per1*(1-per2);
                R(StateToField([1 0 action(iAct).mcsaction 0 1 state(iNow).channel(1) state(iNow).channel(2) state(iNow).leftslot-1], state), iAct)...
                    = (1/slotCounterLevel)*dataRate(action(iAct).mcsaction+1);
                % Case 3: L1 실패, L2 실패
                P(iNow, StateToField([1 1 action(iAct).mcsaction 0 0 state(iNow).channel(1) state(iNow).channel(2) state(iNow).leftslot-1], state), iAct)...
                    = per1*per2;
                fprintf('No HARQ, No last slot, (%d, %d)\n',iNow, iAct);
            else    % Last slot인 경우, channel environment distribution 필요함
                for iChan1 = 0:1:maxChannelPerLink-1
                    for iChan2 = 0:1:maxChannelPerLink-1
                        P(iNow, StateToField([0 0 action(iAct).mcsaction 1 1 iChan1 iChan2 slotCounterLevel-1], state), iAct)...
                            = (1/channelLevel)*(1-per1)*(1-per2);
                        R(StateToField([0 0 action(iAct).mcsaction 1 1 iChan1 iChan2 slotCounterLevel-1], state), iAct)...
                            = 2*(1/slotCounterLevel)*dataRate(action(iAct).mcsaction+1);
                        % Case 2: L1 성공, L2 실패
                        P(iNow, StateToField([0 1 action(iAct).mcsaction 1 0 iChan1 iChan2 slotCounterLevel-1], state), iAct)...
                            = (1/channelLevel)*(1-per1)*per2;
                        R(StateToField([0 1 action(iAct).mcsaction 1 0 iChan1 iChan2 slotCounterLevel-1], state), iAct)...
                            = (1/slotCounterLevel)*dataRate(action(iAct).mcsaction+1);
                        % Case 3: L1 실패, L2 성공
                        P(iNow, StateToField([1 0 action(iAct).mcsaction 0 1 iChan1 iChan2 slotCounterLevel-1], state), iAct)...
                            = (1/channelLevel)*per1*(1-per2);
                        R(StateToField([1 0 action(iAct).mcsaction 0 1 iChan1 iChan2 slotCounterLevel-1], state), iAct)...
                            = (1/slotCounterLevel)*dataRate(action(iAct).mcsaction+1);
                        % Case 3: L1 실패, L2 실패
                        P(iNow, StateToField([1 1 action(iAct).mcsaction 0 0 iChan1 iChan2 slotCounterLevel-1], state), iAct)...
                            = (1/channelLevel)*per1*per2;
                    end
                end                
                fprintf('No HARQ, Last slot, (%d, %d)\n',iNow, iAct);
            end
        
        else    % Invalid action
            P(iNow, iNow, iAct) = 1;
            R(iNow, iAct) = -100;
            fprintf('Invalid action, (%d, %d)\n',iNow, iAct);
        end
    end
end