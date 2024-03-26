function per = MakePer(bufferCounterLevel, harqActionLevel, mcsActionLevel, ebnodB, ppduLength)

size = bufferCounterLevel*harqActionLevel*mcsActionLevel;
per = struct('buffer', cell(1, size), 'harqaction', cell(1, size), 'mcsaction', cell(1, size), 'per', cell(1, size));
i = 1;

for iBuffer = 1:1:bufferCounterLevel
    for iHarq = 1:1:harqActionLevel
        for iMcs = 1:1:mcsActionLevel
            bufferVal = dec2base(iBuffer-1,log2(bufferCounterLevel),log10(bufferCounterLevel)/log10(log2(bufferCounterLevel)))-'0';
            mcsVal = iMcs-1;
            per(i) = struct('buffer',bufferVal,...
                    'harqaction',dec2bin(iHarq-1,2)-'0',...
                    'mcsaction',mcsVal,...
                    'per', [CalculatedPer(ebnodB + 3*bufferVal(1), ppduLength, mcsVal, channel, channelLevel), CalculatedPer(ebnodB + 3*bufferVal(2), ppduLength, mcsVal, channel, channelLevel)]);
            i = i+1;
        end
    end
end
