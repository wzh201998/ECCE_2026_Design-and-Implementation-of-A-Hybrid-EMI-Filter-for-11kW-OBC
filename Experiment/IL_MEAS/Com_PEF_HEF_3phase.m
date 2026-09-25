clear;
clc;
close all;
addpath("C:\Users\weihao zhao\PhD\Conference\ECCE Europe 2026\Design 11kW HEF\Experiment data\Measurement");
%%
data=readmatrix("PEF_CM_50ohm.csv");
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
figure(1)
semilogx(freq,-S12,"LineWidth",2);
hold on
xlim([30e3,30e6]);
grid on
xlabel("Freq (Hz)");
ylabel("CM Insertion Loss (dB)");


data=readmatrix("HEF_CM_50ohm.csv");
freq=data(:,1);
S11=data(:,2);
S11_Phase=data(:,6);

S21=data(:,3);
S21_Phase=data(:,7);

HEFIL=-S21;
figure(1)
semilogx(freq,HEFIL,"LineWidth",2);
grid on
legend("Passive filter","Hybrid filter");
fontsize(gcf,16,"points");

figure(2)
semilogx(freq,abs(HEFIL-PEFIL),"LineWidth",2)
hold on
xlim([30e3,30e6]);
grid on
xlabel("Freq (Hz)");
ylabel("CM Insertion Loss (dB)");
fontsize(gcf,16,"points");
% %% PEF TPB2 installed
% data=readmatrix("PEF_TPB_Installed.csv");
% freq=data(:,1);
% S11=data(:,2);
% S11_Phase=data(:,6);
% 
% S21=data(:,3);
% S21_Phase=data(:,7);
% 
% S12=data(:,4);
% S12_Phase=data(:,8);
% 
% S22=data(:,5);
% S22_Phase=data(:,9);
% PEFIL=-S21;
% figure(1)
% semilogx(freq,-S12,"LineWidth",2);
% hold on
% xlim([30e3,30e6]);
% grid on
% xlabel("Freq (Hz)");
% ylabel("CM Insertion Loss (dB)");
%%
data=readmatrix("HEF_CM_50_sim.txt");
IL=data(:,2);
freq0=data(:,1);
figure(2)
semilogx(freq0,IL,"LineWidth",2)
%%
data=readmatrix("PEF_DM_50ohm.csv");
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
