clear;
clc;
close all;
addpath("C:\Users\weihao zhao\PhD\Conference\ECCE Europe 2026\Design 11kW HEF\Experiment data\Insertion Loss");
%%
data=readmatrix("PEF_CM_50ohm.csv");
freq=data(:,1);
S11_Mag=10.^(data(:,2)/20);
S11_Phase=data(:,6).*pi/180;
S11=S11_Mag.*(1i*sin(S11_Phase)+cos(S11_Phase));

S21_Mag=10.^(data(:,3)/20);
S21_Phase=data(:,7).*pi/180;
S21=S21_Mag.*(1i*sin(S21_Phase)+cos(S21_Phase));

S12_Mag=10.^(data(:,4)/20);
S12_Phase=data(:,8).*pi/180;
S12=S12_Mag.*(1i*sin(S12_Phase)+cos(S12_Phase));

S22_Mag=10.^(data(:,5)/20);
S22_Phase=data(:,9).*pi/180;
S22=S22_Mag.*(1i*sin(S22_Phase)+cos(S22_Phase));

PEFIL=-20*log10(abs(S21_Mag));
figure(1)
semilogx(freq,PEFIL,"LineWidth",2);
hold on
xlim([30e3,30e6]);
grid on
xlabel("Freq (Hz)");
ylabel("CM Insertion Loss (dB)");

% DUT.ZS=1./(1i*2*pi*freq*400e-12);
% DUT.ZL=25;
% tauS=(DUT.ZS-50)./(DUT.ZS+50);
% tauL=(DUT.ZL-50)./(DUT.ZL+50);
% IL_PEF=S21.*(1-tauL.*tauS)./((1-S11.*tauS).*(1-S22.*tauL)-S21.*S12.*tauL.*tauS);
% IL_PEFdB1=-20*(log10(abs(IL_PEF)));
% 
% figure(2)
% semilogx(freq,IL_PEFdB1,"LineWidth",2);
% hold on
% xlim([30e3,30e6]);
% grid on
% xlabel("Freq (Hz)");
% ylabel("CM Insertion Loss (dB)");

%%
data=readmatrix("HEF_CM_50ohm.csv");
freq=data(:,1);
S11_Mag=10.^(data(:,2)/20);
S11_Phase=data(:,6).*pi/180;
S11=S11_Mag.*(1i*sin(S11_Phase)+cos(S11_Phase));

S21_Mag=10.^(data(:,3)/20);
S21_Phase=data(:,7).*pi/180;
S21=S21_Mag.*(1i*sin(S21_Phase)+cos(S21_Phase));

S12_Mag=10.^(data(:,4)/20);
S12_Phase=data(:,8).*pi/180;
S12=S12_Mag.*(1i*sin(S12_Phase)+cos(S12_Phase));

S22_Mag=10.^(data(:,5)/20);
S22_Phase=data(:,9).*pi/180;
S22=S22_Mag.*(1i*sin(S22_Phase)+cos(S22_Phase));

HEFIL=-20*log10(abs(S21_Mag));
figure(1)
semilogx(freq,HEFIL,"LineWidth",2);
grid on
legend("Passive filter","Hybrid filter");
fontsize(gcf,16,"points");
ylim([0,160])
%%
figure(2)
semilogx(freq,abs(HEFIL-PEFIL),"LineWidth",2);
grid on
legend();
fontsize(gcf,16,"points");
ylim([0,80])
xlim([30e3,30e6])
%%
%%
% DUT.ZS=1./(1i*2*pi*freq*400e-12);
% DUT.ZL=25;
% tauS=(DUT.ZS-50)./(DUT.ZS+50);
% tauL=(DUT.ZL-50)./(DUT.ZL+50);
% IL_HEF=S21.*(1-tauL.*tauS)./((1-S11.*tauS).*(1-S22.*tauL)-S21.*S12.*tauL.*tauS);
% IL_HEFdB1=-20*(log10(abs(IL_HEF)));

figure(2)
semilogx(freq,IL_HEFdB1,"LineWidth",2);
hold on
xlim([30e3,30e6]);
grid on
xlabel("Freq (Hz)");
ylabel("CM Insertion Loss (dB)");

figure(3)
semilogx(freq,abs(HEFIL-PEFIL),"LineWidth",2)
hold on
% semilogx(freq,abs(IL_HEFdB1-IL_PEFdB1),"LineWidth",2)

xlim([30e3,30e6]);
grid on
xlabel("Freq (Hz)");
ylabel("CM Insertion Loss (dB)");
fontsize(gcf,16,"points");
%%
clear,
clc;
close all;
%%
data=readmatrix("PEF_DM7_50ohm.csv");
freq=data(:,1);
S11=data(:,2);
S11_Phase=data(:,6);

S21=data(:,3);
S21_Phase=data(:,7);

S12=data(:,4);
S12_Phase=data(:,8);

S22=data(:,5);
S22_Phase=data(:,9);
PEFIL=-S21;
figure(3)
semilogx(freq,-S12,"LineWidth",2);
hold on
xlim([9e3,30e6]);
grid on
xlabel("Freq (Hz)");
ylabel("DM Insertion Loss (dB)");
fontsize(gcf,16,"points");
%%
clear;
clc;
close all;
%%
data=readmatrix("PEF_DM_50ohm_No_LDM.csv");
freq=data(:,1);
S11=data(:,2);
S11_Phase=data(:,6);

S21=data(:,3);
S21_Phase=data(:,7);

S12=data(:,4);
S12_Phase=data(:,8);

S22=data(:,5);
S22_Phase=data(:,9);
PEFIL=-S21;
figure(3)
semilogx(freq,-S12,"LineWidth",2);
hold on
xlim([9e3,30e6]);
grid on
xlabel("Freq (Hz)");
ylabel("DM Insertion Loss (dB)");
fontsize(gcf,16,"points");
%%
data=readmatrix("DM_Sim_ideal.txt");
freq1=data(:,1);
DM_mag=data(:,2);
figure(3)
semilogx(freq1,DM_mag,"LineWidth",2);
%%
data=readmatrix("DM_Sim.txt");
freq1=data(:,1);
DM_mag=data(:,2);
figure(3)
semilogx(freq1,DM_mag,"LineWidth",2);
%%
data=readmatrix("bode100_dm_pef.csv");
freq11=data(:,1);
DM_IL=20*log10(data(:,3));
figure(3)
semilogx(freq11,-DM_IL,"LineWidth",2);
%%
f1=1/(2*pi*sqrt(25e-6*6.6e-6))
f2=1/(2*pi*sqrt(25e-6*5e-6))