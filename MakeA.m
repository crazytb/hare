function A = MakeA(harqActionLevel, mcsActionLevel)

size = harqActionLevel*mcsActionLevel;
A = struct('harqaction', cell(1, size), 'mcsaction', cell(1, size));
i = 1;
for iHarq = 1:1:harqActionLevel
    for iMcs = 1:1:mcsActionLevel
        A(i) = struct('harqaction',iHarq-1, 'mcsaction',iMcs-1);
%         A(i) = struct('harqaction',dec2bin(iHarq-1,2)-'0', 'mcsaction',dec2bin(iMcs-1,2)-'0');
        i = i + 1;
    end
end