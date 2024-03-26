function channelModel = MakeChannelModel(channelTransitionProb)

global channelLevel
channelModel = zeros(channelLevel);

for i = 1:1:channelLevel
    for j = 1:1:channelLevel
        if dist(i,j) == 1
            channelModel(i,j) = channelTransitionProb;
        elseif dist(i,j) == 0
            if i == 1 || i == channelLevel
                channelModel(i,j) = 1 - channelTransitionProb;
            else
                channelModel(i,j) = 1 - 2*channelTransitionProb;
            end
        end
    end
end
