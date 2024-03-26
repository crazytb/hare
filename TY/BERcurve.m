clc
clear
close all


N_bits = 10000000;     % Generated bits
Max_dB = 12;
Eb_No_dB = 0:0.5:Max_dB;    % Eb/N0 dB scale
BER_buffer_arq = zeros(size(Eb_No_dB));   % BER buffer 
BER_buffer_harq = zeros(size(Eb_No_dB));   % BER buffer 
PER_buffer_arq = zeros(size(Eb_No_dB));   % BER buffer 
PER_buffer_harq = zeros(size(Eb_No_dB));   % BER buffer 


Packet_length = 1500*8;


for n=1:length(Eb_No_dB)
    Eb_No_ral_scale= 10 ^(Eb_No_dB(n)/10);    % Eb/N0 real scale conversion
    sigma_v=sqrt(1./(2*Eb_No_ral_scale));     %
    
    bits_v=randi([0 1],N_bits,1);         % Generating bits
    Symbols=bits_v*(-2)+1;                % symbol mapping
    
    noise_v1=randn(N_bits,1)*sigma_v;       % Generating AWGN
    noise_v2=randn(N_bits,1)*sigma_v;       % Generating AWGN
    
    rx_signal_1 = Symbols + noise_v1;
    rx_signal_2 = Symbols + noise_v2;
    
    demapped_bits_arq = rx_signal_1 < 0;        % Demapping
    demapped_bits_harq = (rx_signal_1 + rx_signal_2) < 0;
    
    BER_buffer_arq(n) = sum(bits_v ~= demapped_bits_arq) ./ N_bits; % BER calculation
    BER_buffer_harq(n) = sum(bits_v ~= demapped_bits_harq) ./ N_bits; % BER calculation

    PER_buffer_arq(n) = 1-(1-BER_buffer_arq(n))^Packet_length;
    PER_buffer_harq(n) = 1-(1-BER_buffer_harq(n))^Packet_length;
    
    fprintf('ARQ: Eb/No= %g   BER:    %g\n',Eb_No_dB(n) ,BER_buffer_arq(n))
    fprintf('HARQ: Eb/No= %g   BER:    %g\n',Eb_No_dB(n) ,BER_buffer_harq(n))
end

%% Calculate theoretic BPSK BER
Eb_N0_theory=0:0.05:Max_dB;
Ber_value_theory_arq=berawgn(Eb_N0_theory,'psk',2,'nondiff');
Ber_value_theory_harq=berawgn(Eb_N0_theory+3,'psk',2,'nondiff');

%% Calculate theoretic BPSK PER
% Per_value_theory_arq=1-(1-Ber_value_theory_arq).^Packet_length;
% Per_value_theory_harq=1-(1-Ber_value_theory_harq).^Packet_length;

Per_value_theory_arq=1-(1-Ber_value_theory_arq).^Packet_length;
Per_value_theory_harq=1-(1-Ber_value_theory_harq).^Packet_length;

%% Drawing figure_BER
figure()
semilogy(Eb_No_dB,BER_buffer_arq,'b*',Eb_No_dB,BER_buffer_harq,'r*',Eb_N0_theory,Ber_value_theory_arq,'b--',Eb_N0_theory,Ber_value_theory_harq,'r--'), xlabel('Eb/No [dB]'), ylabel('BER')
grid,axis([0 Max_dB 0.000001 1]), legend('Simulated result-ARQ','Simulated result-HARQ','Theoretical BPSK result-ARQ','Theoretical BPSK result-HARQ')

%% Drawing figure_PER
figure()
semilogy(Eb_No_dB,PER_buffer_arq,'b*',Eb_No_dB,PER_buffer_harq,'r*',Eb_N0_theory,Per_value_theory_arq,'b--',Eb_N0_theory,Per_value_theory_harq,'r--'), xlabel('Eb/No [dB]'), ylabel('PER')
grid,axis([0 Max_dB 0.000001 1]), legend('Simulated result-ARQ','Simulated result-HARQ','Theoretical BPSK result-ARQ','Theoretical BPSK result-HARQ')

%% Drawing figure
ppdulength = 1500*8;
succ_arq = (1 - Ber_value_theory_arq).^ppdulength;
succ_harq = 0.5.*(1 - Ber_value_theory_harq).^ppdulength;

figure()
plot(Eb_N0_theory,succ_arq,'b--',Eb_N0_theory,succ_harq,'r--'), xlabel('Eb/No [dB]'), ylabel('Tput')
grid,axis([0 Max_dB 0.000001 1]), legend('ARQ','HARQ')
