clear;
clc;
close all;
addpath("C:\Users\weihao zhao\PhD\PhD Work\Multi-Objective Optimization Hybrid EMI Filter\V6-1phase\Visulize OPT Result V6 1phase\opt1phase\Validate_AEF_IL\Update System")
%%
dataname=["Cal_short.csv","DUT_OFF.csv","DUT_ON.csv","DUT_ON1.csv","LISN_off.csv","LISN_ON.csv"];
[~,~,C_cal,~, freq] = Read_S2ABCD(dataname(1));
[~,~,C_src,~, ~] = Read_S2ABCD(dataname(2));
[~,~,C_L,~, ~] = Read_S2ABCD(dataname(6));

index=find(diff(freq)==0);
freq(index)=[];
C_cal(index)=[];
C_L(index)=[];
C_src(index)=[];

Z_L=1./(C_L-C_cal);
Z_src=1./(C_src-C_cal);

DUT.ZS=Z_src;
DUT.ZL=Z_L;
% C_L=1./abs(2*pi*freq.*Z_L);
% C_src=1./abs(2*pi*freq.*Z_src);
figure(1)
loglog(freq,abs(Z_L),"LineWidth",2);
hold on
grid on
loglog(freq,abs(Z_src),"LineWidth",2);
xlabel("Freq(Hz)");
ylabel("Impedance (\Omega)")
xlim([150e3,30e6]);