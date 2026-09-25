clear,
clc;
close all;
addpath("C:\Users\weihao zhao\PhD\Conference\ECCE Europe 2026\Design 11kW HEF\Experiment data\Insertion_loss_loop_gain\loop_gain")
addpath("C:\Users\weihao zhao\PhD\Conference\ECCE Europe 2026\Design 11kW HEF\Experiment data\Insertion_loss_loop_gain");
%% with single load (defined impedance)
freq=[logspace(3.8,7.5,2001)]';
C=330e-12;
DUT.ZS=1./(2*pi*1i*freq*C);
DUT.ZL=51;
Model=PEF_CM_Impedance_11kW(freq);

OP.Rinj =22;
OP.Cinj =4.7e-9*4;
OP.ZG   =750;
OP.ZF   =340e3;

CT.Rc=6.22e3;
CT.ESR=20e-3;
CT.Cs=1e-12;
CT.Lself=456e-6;
CT.k=0.99;
CT.Lm=CT.k.*CT.Lself;
CT.Ll=CT.Lself-CT.Lm;
CT.R=39;
CT.n=13;
CT.freq=freq;

[AEF,CT]=AEF_Parameter_11kW_HEF(DUT,Model,OP,CT,freq);
k=(1./(1./(AEF.Zsrc)+1./(AEF.ZL)))./(AEF.Zinj+1*AEF.Zmo1);
Gloop=-AEF.Aop.*CT.GCT.*k./(1+k)./(AEF.ZL);
Mag_loop=20*log10(abs(Gloop));
Phase_loop=angle(Gloop).*180/pi;

figure(1)
subplot(211)
semilogx(freq,Mag_loop,"LineWidth",2);
hold on
xlim([30e3,10e6]);
xlabel("Freq (Hz)");
ylabel("Magnitude (dB)");
fontsize(gcf,16,"points");

subplot(212)
semilogx(freq,Phase_loop,"LineWidth",2);
hold on
xlim([30e3,10e6]);
xlabel("Freq (Hz)");
ylabel("Phase (degree)");
fontsize(gcf,16,"points");



%% Present the measurement result (defined load impedance)
[S11,S12,S21,S22, freq1] = Read_S("LG_ZS-330pF_ZL_51ohm_RG_750_RF_330k.csv");
% [S11,S12,S21,S22, ~] = Read_S("Loop_gain_HEF_GNDorLN.csv");


Gloop_meas=-2*S21./((1+S11).*(1-S22)+S12.*S21);
Phase=angle(Gloop_meas).*180/pi;

figure(1)
subplot(211)
semilogx(freq1, 20*log10(abs(Gloop_meas)),"--","LineWidth",2);
xlim([9e3,30e6]);
hold on
grid on
xlabel("Freq (Hz)")
ylabel("Magnitude (dB)");
legend("Model","Meas.","Sim.");
fontsize(gcf,16,"points");

subplot(212)
semilogx(freq1,(Phase) ,"--","LineWidth",2);
xlim([9e3,30e6]);
hold on
grid on
xlabel("Freq (Hz)")
ylabel("Phase (deg.)");
legend("Model","Meas.","Sim.");
fontsize(gcf,16,"points");

%% Based on the verified loop gain model to study the impacts of the grid impedance 
clear;
clc,
close all;
%%
freq=[logspace(4.2,5.5,601)]';
C=330e-12;
DUT.ZS=1./(2*pi*1i*freq*C);
ISC=[2:20]*1e3;
V=230;
Z=V./ISC;
X_over_R=10;
R=Z./sqrt(X_over_R^2+1);
X=X_over_R*Z./sqrt(X_over_R^2+1);
L=(X./(2*pi*50));
DUT.ZL=R+1i.*2*pi*freq.*L;
Model=PEF_CM_Impedance_11kW(freq);
                              % case with the LCM2 on the grid side
Model.Zlcm2=0;                % case without the LCM2 on the grid side

OP.Rinj =1;
OP.Cinj =4.7e-9*4;
OP.ZG   =750;
OP.ZF   =340e3;%1./(1./460e3+1i*2*pi*freq1*1e-12); 

CT.Rc=6.22e3;
CT.ESR=20e-3;
CT.Cs=1e-12;
CT.Lself=456e-6;
CT.k=0.99;
CT.Lm=CT.k.*CT.Lself;
CT.Ll=CT.Lself-CT.Lm;
CT.R=39;
CT.n=13;
CT.freq=freq;

[AEF,CT]=AEF_Parameter_11kW_HEF(DUT,Model,OP,CT,freq);
k=(1./(1./(AEF.Zsrc)+1./(AEF.ZL)))./(AEF.Zinj+1*AEF.Zmo1);
Gloop=AEF.Aop.*CT.GCT.*k./(1+k)./(AEF.ZL);
Mag_loop=20*log10(abs(Gloop));
Phase_loop=angle(Gloop).*180/pi;

figure(1)
subplot(211)
semilogx(freq,Mag_loop,"LineWidth",2);
hold on
xlim([30e3,10e6]);
xlabel("Freq (Hz)");
ylabel("Magnitude (dB)");
fontsize(gcf,16,"points");

subplot(212)
semilogx(freq,Phase_loop,"LineWidth",2);
hold on
xlim([30e3,10e6]);
xlabel("Freq (Hz)");
ylabel("Phase (degree)");
fontsize(gcf,16,"points");
%%
for i=1:19
temp=find(abs(Mag_loop(1:end,i))<=5);
index_mag_0(i)=temp(1);
PM(i)=min( abs(Phase_loop(index_mag_0(i),i)+180), abs(Phase_loop(index_mag_0(i),i)-180));

figure(2)
subplot(211)
semilogx(freq(1:end),Mag_loop(1:end,i),"LineWidth",2);
hold on
xlim([10e3,30e6]);
grid on
xlabel("Freq (Hz)");
ylabel("Magnitude (dB)");
fontsize(gcf,16,"points");
xlim([20e3,10e6]);


subplot(212)
semilogx(freq(1:end),(Phase_loop(1:end,i)),"LineWidth",2);
hold on
semilogx(freq(index_mag_0(i)),(Phase_loop(index_mag_0(i),i)),"o","MarkerSize",10,"LineWidth",2);
xlim([10e3,30e6]);
grid on
xlabel("Freq (Hz)");
ylabel("Phase (degree)");
fontsize(gcf,16,"points");
xlim([20e3,10e6]);
end
%% Visulize result
freq1=ones([1,length(ISC)]).*freq;
ISC1=ones([1,length(freq)])'.*ISC;

figure(11)
subplot(121)
surfc(freq1,ISC1,(Phase_loop),"FaceColor","interp");
colorbar
hold on
xlim([20e3,300e3]);
xlabel("Freq (Hz)");
ylabel("Short Circuit Current (A)");
zlabel("Phase (degree)");

fontsize(gcf,16,"points");

subplot(122)
surfc(freq1,ISC1,(Mag_loop),"FaceColor","interp")
hold on
colorbar
xlim([20e3,300e3]);
xlabel("Freq (Hz)");
ylabel("Short Circuit Current (A)");
zlabel("Gain (dB)");
fontsize(gcf,16,"points");


figure(12)
subplot(121)
contourf(freq1,ISC1,(Phase_loop));
colorbar

subplot(121)
contourf(freq1,ISC1,(Mag_loop));
colorbar
%%
figure(20)
plot(ISC,PM,"ro","LineWidth",2);
xlabel("Short Circuit Current (kA)");
ylabel("Phase Margin");
grid on
xlim([2e3,20e3]);
fontsize(gcf,16,"points");




%%
function [S11,S12,S21,S22,freq]=Read_S(filename)
data=readmatrix(filename);
freq=data(:,1);
S11_mag=10.^(data(:,2)/20);
S11_phase=data(:,6).*pi/180;
S11=S11_mag.*(1i*sin(S11_phase)+cos(S11_phase));

S21_mag=10.^(data(:,3)/20);
S21_phase=data(:,7).*pi/180;
S21=S21_mag.*(1i*sin(S21_phase)+cos(S21_phase));

S12_mag=10.^(data(:,4)/20);
S12_phase=data(:,8).*pi/180;
S12=S12_mag.*(1i*sin(S12_phase)+cos(S12_phase));

S22_mag=10.^(data(:,5)/20);
S22_phase=data(:,9).*pi/180;
S22=S22_mag.*(1i*sin(S22_phase)+cos(S22_phase));



end