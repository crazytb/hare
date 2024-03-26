x = 13;
Error = zeros (x,1);
P_E = zeros (x,1);
d_l = 20 * 8;  %% 20 bytes

%% i-1 = E/No (dB)
for i = 1:x
    Error(i,1) = 0.5*(1-erf(sqrt(10^((i-1)/10))));
    P_E(i,1) = 1-(1-Error(i,1))^d_l;
end


db = 0:1:12;
figure()
semilogy (db, Error);
grid on

figure()
plot (db,P_E);
grid on

%% 
meter = 40;
PL = 22.0*log10(meter)+28+20*log10(5);
BW = 20*10^6;
noise_dbm = -174 + 10*log10(BW);
Input = PL+noise_dbm;