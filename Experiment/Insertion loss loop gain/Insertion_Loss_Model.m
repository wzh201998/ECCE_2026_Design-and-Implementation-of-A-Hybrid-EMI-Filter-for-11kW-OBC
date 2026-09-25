% Author Weihao Zhao
% Date: 05_05_2025
% Used for 11kW Hybrid EMI Filter
% Paper Design and Implementation of a CM Hybrid EMI Filter for A
% Three-Phase/Single-Phase Onboard Charger
%% PEF Insertion loss
clear,
clc,
close all;
addpath("C:\Users\weihao zhao\PhD\Conference\ECCE Europe 2026\Design 11kW HEF\Experiment data\Insertion_loss_loop_gain");
%%
data=readmatrix("PEF_CM1_50ohm.csv");
freq1=data(:,1);
S11=data(:,2);
S11_Phase=data(:,6);

S21=data(:,3);
S21_Phase=data(:,7);

S12=data(:,4);
S12_Phase=data(:,8);

S22=data(:,5);
S22_Phase=data(:,9);
PEF_IL=-S21;
figure(2)
semilogx(freq1,-S12,"LineWidth",2);
hold on
xlim([30e3,30e6]);
grid on
xlabel("Freq (Hz)");
ylabel("CM Insertion Loss (dB)");
%%
DUT.ZL=ones([length(freq1),1]).*50;
DUT.ZS=ones([length(freq1),1]).*50;
Model=PEF_CM_Impedance_11kW(freq1);
K1=Model.Zlcm2./DUT.ZL +1;
K2=Model.Zlcm1.*(K1./((Model.Zcy2)) +1./(DUT.ZL)) +K1;
K3=(K2./(Model.Zcy1) +K1./((Model.Zcy2))+ 1./DUT.ZL).*DUT.ZS+K2 ;
IL_PEF=DUT.ZL.*K3./(DUT.ZL+DUT.ZS);
IL_PEFdB=20*(log10(abs(IL_PEF)));

figure(2)
semilogx(freq1,IL_PEFdB,"--","LineWidth",2);
hold on

%% HEF Insertion loss
data=readmatrix("HEF_CM1_50ohm.csv");
freq1=data(:,1);
S11=data(:,2);
S11_Phase=data(:,6);

S21=data(:,3);
S21_Phase=data(:,7);

S12=data(:,4);
S12_Phase=data(:,8);

S22=data(:,5);
S22_Phase=data(:,9);
HEF_IL=-S21;
figure(2)
semilogx(freq1,(HEF_IL),"LineWidth",2);
hold on
xlim([30e3,30e6]);
grid on
xlabel("Freq (Hz)");
ylabel("CM Insertion Loss (dB)");


figure(5)
semilogx(freq1,abs(HEF_IL-PEF_IL),"LineWidth",2);
hold on
xlim([30e3,30e6]);
grid on
xlabel("Freq (Hz)");
ylabel("CM Insertion Loss (dB)");
%%
OP.Rinj =0.1;
OP.Cinj =4.7e-9*4;
OP.ZG   =770;
OP.ZF   =340e3;%1./(1./460e3+1i*2*pi*freq1*1e-12); 
% OP.ZF=1./(1./340e3+1i*2*pi*freq1*1e-12); 

CT.Rc=6.22e3;
CT.ESR=20e-3;
CT.Cs=1e-12;
CT.Lself=456e-6;
CT.k=0.99;
CT.Lm=CT.k.*CT.Lself;
CT.Ll=CT.Lself-CT.Lm;
CT.R=39;
CT.n=13;
CT.freq=freq1;
[AEF,CT]=AEF_Parameter_11kW_HEF(DUT,Model,OP,CT,freq1);
figure(5)
semilogx(freq1,abs(AEF.ILMagdB),"--","LineWidth",2);
hold on
figure(2)
semilogx(freq1,AEF.ILMagdB+IL_PEFdB,"--","LineWidth",2);
hold on
grid on
xlim([10e3,30e6])
%%
data=readmatrix("PEF_DM_50ohm.csv");
freq1=data(:,1);
S11=data(:,2);
S11_Phase=data(:,6);

S21=data(:,3);
S21_Phase=data(:,7);

S12=data(:,4);
S12_Phase=data(:,8);

S22=data(:,5);
S22_Phase=data(:,9);
DM_IL=-S21;
figure(2)
semilogx(freq1,(DM_IL),"LineWidth",2);
hold on
xlim([10e3,30e6]);
grid on
xlabel("Freq (Hz)");
ylabel("CM Insertion Loss (dB)");
%%
data=readmatrix("PEF_DM_50ohm_No_LDM_trafo.csv");
freq1=data(:,1);
S11=data(:,2);
S11_Phase=data(:,6);

S21=data(:,3);
S21_Phase=data(:,7);

S12=data(:,4);
S12_Phase=data(:,8);

S22=data(:,5);
S22_Phase=data(:,9);
DM_IL=-S21;
figure(2)
semilogx(freq1,(DM_IL),"LineWidth",2);
hold on
xlim([10e3,30e6]);
grid on
xlabel("Freq (Hz)");
ylabel("CM Insertion Loss (dB)");