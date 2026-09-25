clear;
clc;
close all;
addpath("C:\Users\weihao zhao\PhD\Conference\ECCE Europe 2026\Design 11kW HEF\Experiment data\Measurement data\Meas_HEF");
addpath("C:\Users\weihao zhao\PhD\Conference\ECCE Europe 2026\Design 11kW HEF\Experiment data\Measurement data\Update System")
%%
dataname=["210v 4a cm ldm in.DAT","210v 4a cm no ldm.DAT"];
data=readmatrix(dataname(2));
index=find(data(:,1)==9e3);
length1=index(2)-index(1)-1;
freq=data([index(1):index(1)+length1],1);
freq(isnan(freq))=[];
Noise_floor.u0=data([index(1):index(1)+length(freq)-1],2);
Raw.u0=data([index(2):index(2)+length(freq)-1],2);
PEF.u0=data([index(3):index(3)+length(freq)-1],2);
HEF.u0=data([index(4):index(4)+length(freq)-1],2);

figure(1)
semilogx(freq,Raw.u0,"LineWidth",2);
hold on
semilogx(freq,PEF.u0,"LineWidth",2);
semilogx(freq,HEF.u0,"LineWidth",2);
grid on
xlim([9e3,30e6]);
xlabel("Freq (Hz)");
ylabel("CM Noise (dB\muV)");
fontsize(gcf,16,"points");

freq_LM_21=[9e3,150e3,150e3+1,500e3,[],500e3+1,5e6,[],5e6+1,30e6];
LM_QP_21=[66,66,66,56,[],56,56,[],60,60]-10;
LM_AVG_21=[56,56,56,46,[], 46,46, [],50,50];
figure(1)
semilogx(freq_LM_21,LM_QP_21,"LineWidth",2);
hold on
xlim([150e3,30e6]);
ylim([40,110]);
grid on
title("Quasi Peak Detector");
xlabel("Freq(Hz)")
ylabel("CM Magnitude (dB\muV)");
% plot(freq_LM_21, LM_QP_21,"LineWidth",2);
fontsize(gcf,16,"points");

figure(2)
semilogx(freq,PEF.u0-HEF.u0,"LineWidth",2);
hold on
% semilogx(freq,HEF.u0,"LineWidth",2);
grid on
xlim([9e3,30e6]);
xlabel("Freq (Hz)");
ylabel("CM Noise (dB\muV)");
fontsize(gcf,16,"points");
%% Predict Spectrum From System Impedance S parameter
dataname=["Cal_short.csv","DUT_OFF.csv","DUT_ON.csv","DUT_ON1.csv","LISN_off.csv","LISN_ON.csv"];
[~,~,C_cal,~, freq1] = Read_S2ABCD(dataname(1));
[~,~,C_src,~, ~] = Read_S2ABCD(dataname(3));
[~,~,C_L,~, ~] = Read_S2ABCD(dataname(6));

index=find(diff(freq1)==0);
freq1(index)=[];
C_cal(index)=[];
C_L(index)=[];
C_src(index)=[];

Z_L=1./(C_L-C_cal);
Z_src=1./(C_src-C_cal);

DUT.ZS=Z_src;
DUT.ZL=Z_L;
% C_L=1./abs(2*pi*freq.*Z_L);
% C_src=1./abs(2*pi*freq.*Z_src);
figure(3)
loglog(freq1,abs(Z_L),"LineWidth",2);
hold on
grid on
loglog(freq1,abs(Z_src),"LineWidth",2);
xlabel("Freq(Hz)");
ylabel("Impedance (\Omega)")
xlim([150e3,30e6]);
%% load S parameter -Passive Filter
data=readmatrix("PEF_CM_50ohm.csv");
freq1=data(:,1);
index=find(diff(freq1)==0);
data(index,:)=[];
freq1=data(:,1);

S11_mag=10.^(data(:,2)/20);
S21_mag=10.^(data(:,3)/20);
S12_mag=10.^(data(:,4)/20);
S22_mag=10.^(data(:,5)/20);

S11_phase=data(:,6).*pi/180;
S21_phase=data(:,7).*pi/180;
S12_phase=data(:,8).*pi/180;
S22_phase=data(:,9).*pi/180;

S11=S11_mag.*(cos(S11_phase)+1i*sin(S11_phase));
S21=S21_mag.*(cos(S21_phase)+1i*sin(S21_phase));
S12=S12_mag.*(cos(S12_phase)+1i*sin(S12_phase));
S22=S22_mag.*(cos(S22_phase)+1i*sin(S22_phase));
%% Convert the 50 ohm impedance to system impedance
Z0=50;
tauL=(DUT.ZL-Z0)./(DUT.ZL+Z0);
tauS=(DUT.ZS-Z0)./(DUT.ZS+Z0);

AV=S21.*(1-tauL.*tauS)./((1-S11.*tauS).*(1-S22.*tauL)-S21.*tauL.*S12.*tauS);
AVdB=20*log10(abs(1./AV));
figure(4)
semilogx(freq1,-data(:,3),"LineWidth",2);
hold on
grid on
xlim([9e3,30e6]);
fontsize(gcf,16,"points");
xlabel("Freq (Hz)");
ylabel("Insertion Loss (dB)");
semilogx(freq1,AVdB,"LineWidth",2);
%% Predict Spectrum Passive Filter
AVdB1=interp1(freq1,AVdB,freq);
% figure(4)
% semilogx(freq,AVdB1,"LineWidth",2);

PEF.pred=Raw.u0-AVdB1;
figure(5)
semilogx(freq,PEF.u0,"LineWidth",2);
hold on
semilogx(freq,PEF.pred,"LineWidth",2);
grid on
xlim([9e3,30e6]);
xlabel("Freq (Hz)");
ylabel("CM Noise (dB\muV)");
fontsize(gcf,16,"points");


%% load S parameter -Hybrid Filter
data=readmatrix("HEF_CM_50ohm.csv");
freq1=data(:,1);
index=find(diff(freq1)==0);
data(index,:)=[];
freq1=data(:,1);

S11_mag=10.^(data(:,2)/20);
S21_mag=10.^(data(:,3)/20);
S12_mag=10.^(data(:,4)/20);
S22_mag=10.^(data(:,5)/20);

S11_phase=data(:,6).*pi/180;
S21_phase=data(:,7).*pi/180;
S12_phase=data(:,8).*pi/180;
S22_phase=data(:,9).*pi/180;

S11=S11_mag.*(cos(S11_phase)+1i*sin(S11_phase));
S21=S21_mag.*(cos(S21_phase)+1i*sin(S21_phase));
S12=S12_mag.*(cos(S12_phase)+1i*sin(S12_phase));
S22=S22_mag.*(cos(S22_phase)+1i*sin(S22_phase));
%% Convert the 50 ohm impedance to system impedance
Z0=50;
tauL=(DUT.ZL-Z0)./(DUT.ZL+Z0);
tauS=(DUT.ZS-Z0)./(DUT.ZS+Z0);

AV=S21.*(1-tauL.*tauS)./((1-S11.*tauS).*(1-S22.*tauL)-S21.*tauL.*S12.*tauS);
AVdB=20*log10(abs(1./AV));
figure(4)
semilogx(freq1,-data(:,3),"LineWidth",2);
hold on
grid on
xlim([9e3,30e6]);
fontsize(gcf,16,"points");
xlabel("Freq (Hz)");
ylabel("Insertion Loss (dB)");
semilogx(freq1,AVdB,"LineWidth",2);
%% Predict Spectrum Passive Filter
AVdB1=interp1(freq1,AVdB,freq);
% figure(4)
% semilogx(freq,AVdB1,"LineWidth",2);

HEF.pred=Raw.u0-AVdB1;
figure(6)
semilogx(freq,HEF.u0,"LineWidth",2);
hold on
semilogx(freq,HEF.pred,"LineWidth",2);
grid on
xlim([9e3,30e6]);
xlabel("Freq (Hz)");
ylabel("CM Noise (dB\muV)");
fontsize(gcf,16,"points");
