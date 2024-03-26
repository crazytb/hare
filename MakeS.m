function state = MakeS(bufferCounterLevel, mcsStateLevel, ackLevel, channelLevel, slotCounterLevel)

size = bufferCounterLevel*mcsStateLevel*ackLevel*channelLevel*slotCounterLevel;
state = struct('buffer', cell(1, size), 'mcs', cell(1, size), 'ack', cell(1, size), 'channel', cell(1, size), 'leftslot', cell(1, size));
i = 1;
% tmpBufferSize = floor(log2(bufferCounterLevel)) + 1;
for iBuffer = 1:1:bufferCounterLevel
    for iMcs = 1:1:mcsStateLevel
        for iAck = 1:1:ackLevel
            for iChannel = 1:1:channelLevel
                for iSlot = 1:1:slotCounterLevel
                    tmpBuffer = dec2base(iBuffer-1,log2(bufferCounterLevel),log10(bufferCounterLevel)/log10(log2(bufferCounterLevel)))-'0';
                    tmpMcs = iMcs-1;
%                     tmpMcs = dec2base(iMcs-1,log2(mcsStateLevel),log10(mcsStateLevel)/log10(log2(mcsStateLevel)))-'0';
                    tmpAck = dec2bin(iAck-1,log2(ackLevel))-'0';
                    tmpChannel = dec2base(iChannel-1,log2(channelLevel),log10(channelLevel)/log10(log2(channelLevel)))-'0';
                    tmpLeftslot = iSlot-1;
%                     if ~((tmpBuffer(1)~=0 && tmpAck(1)==1) || (tmpBuffer(2)~=0 && tmpAck(2)==1) || (tmpBuffer(1)==0 && tmpAck(1)==0) || (tmpBuffer(2)==0 && tmpAck(2)==0))
                    if ~((tmpBuffer(1)~=0 && tmpAck(1)==1) || (tmpBuffer(2)~=0 && tmpAck(2)==1))
                        state(i) = struct('buffer',tmpBuffer,...
                            'mcs',tmpMcs,...
                            'ack',tmpAck,...
                            'channel',tmpChannel,...
                            'leftslot',tmpLeftslot);
%                         i = i+1;
                    end
                    i = i+1;
                end
            end
        end
    end
end
state( all( cell2mat( arrayfun( @(x) structfun( @isempty, x ), state, 'UniformOutput', false ) ), 1 ) ) = [];