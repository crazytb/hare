function [stateArray] = FieldToState(state, bufferCounterLevel, mcsStateLevel, ackLevel, channelLevel, integer)

stringArray = dec2bin(integer, log2(bufferCounterLevel * mcsStateLevel * ackLevel * channelLevel));

charRetx = stringArray(1 : log2(retxCounterLevel));
charMcs = stringArray(1+log2(retxCounterLevel) : log2(retxCounterLevel)+log2(mcsLevel));
charAck = stringArray(1+log2(retxCounterLevel)+log2(mcsLevel) : log2(retxCounterLevel)+log2(mcsLevel)+log2(ackLevel));
charChannel = stringArray(1+log2(retxCounterLevel)+log2(mcsLevel)+log2(ackLevel) : end);

stateArray = [bin2dec(charRetx), bin2dec(charMcs), bin2dec(charAck), bin2dec(charChannel)];