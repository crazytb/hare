function [per1, per2] = CalculatedPer_revised(pickedState, pickedAction, ebnodB, ppduLength, channelLevel, numLinks)

% global ebnodB ppduLength channelLevel numLinks
% effebNoLinear = 10^(ebNodB/10);
% effebNo = zeros(2, 1);
% effebNoLinear = zeros(2, 1);

numberOfChannelStates = channelLevel^(1/numLinks);
channelCoeff = 0.5/numberOfChannelStates:1/numberOfChannelStates:1;
scaleParam = sqrt(2/pi)*ebnodB;
ix = raylinv(channelCoeff, scaleParam);

% ix = -1*log(flip(channelCoeff))*ebnodB;

channelIndex = [pickedState.channel(1), pickedState.channel(2)];
bufferIndex = [pickedState.buffer(1), pickedState.buffer(2)];
harqIndex = pickedAction.harqaction;
% harqIndex = [pickedAction.harqaction(1), pickedAction.harqaction(2)];
mcsIndex = pickedAction.mcsaction;


ebnodBPerLink = zeros(2, 1);
ebnodBPerLink(1) = 10^((ix(channelIndex(1)+1)+(3*harqIndex*(bufferIndex(1))))/10);
ebnodBPerLink(2) = 10^((ix(channelIndex(2)+1)+(3*harqIndex*(bufferIndex(2))))/10);

% QPSK, 16QAM, 64QAM, 256QAM
calculatedBer = zeros(2, 4);
calculatedBer(1,:) = [qfunc(sqrt(2*ebnodBPerLink(1)));...
    2*(3/4)*qfunc(sqrt((24/15)*ebnodBPerLink(1)));...
    2*(5/6)*qfunc(sqrt((36/63)*ebnodBPerLink(1)));...
    2*(7/8)*qfunc(sqrt((48/255)*ebnodBPerLink(1)))];
calculatedBer(2,:) = [qfunc(sqrt(2*ebnodBPerLink(2)));...
    2*(3/4)*qfunc(sqrt((24/15)*ebnodBPerLink(2)));...
    2*(5/6)*qfunc(sqrt((36/63)*ebnodBPerLink(2)));...
    2*(7/8)*qfunc(sqrt((48/255)*ebnodBPerLink(2)))];

selectedBer = [calculatedBer(1,mcsIndex+1), calculatedBer(2,mcsIndex+1)];
% selectedBer = [calculatedBer(1,pickedState.mcs+1), calculatedBer(2,pickedState.mcs+1)];

per1 = 1-((1-selectedBer(1)).^ppduLength(mcsIndex+1));
per2 = 1-((1-selectedBer(2)).^ppduLength(mcsIndex+1));

% state, action input --> per output