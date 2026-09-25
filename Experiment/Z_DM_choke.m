clear,clc;
close all;
%% DM Choke Saturation
addpath("C:\Users\zhaow\PhD\Conference_writing\ECCE Europe_2026\Measurement\DM Choke")
data=readmatrix("DM choke_non_coupled.csv");
I=data(35:120,1);
L=data(35:120,2);
figure(1)
plot(I,L,"LineWidth",2);
hold on
grid on
xlabel("Current(A)");
ylabel("Inductance(\muH)");
fontsize(gcf,16,"points");

figure(2)
plot(I,L./L(1),"LineWidth",2);
hold on
grid on
xlabel("Current(A)");
ylabel("Remained inductance(\%)");
fontsize(gcf,16,"points");
%% DM choke Impedance
data=readmatrix("DM_WINDING_NONCOUPLED.CSV");
freq=data(:,1);
Z=data(:,2);
figure(2)
loglog(freq,Z,"LineWidth",2);
xlim([9e3,30e6]);
xlabel("Freq (Hz)");
ylabel("Impedance (\Omega)");
grid on
fontsize(gcf,16,"points");
%% CM Choke Saturaton
addpath("C:\Users\zhaow\PhD\Conference_writing\ECCE Europe_2026\Measurement\CM Choke\Large AL")
data=readmatrix("CM choke_high_AL.csv");
I=data(35:85,1);
L=data(35:85,2);
% I=data(278:329,1);
% L=data(278:329,2);
figure(1)
plot(I,L,"LineWidth",2);
hold on
grid on
xlabel("Current(A)");
ylabel("Inductance(mH)");
fontsize(gcf,16,"points");

figure(2)
plot(I,L./L(1),"LineWidth",2);
hold on
grid on
xlabel("Current(A)");
ylabel("Remained inductance(\%)");
fontsize(gcf,16,"points");
%% CM choke Impedance
data=readmatrix("CM_CHOKE_HIGH_AL.CSV");
freq=data(:,1);
Z=data(:,2);
figure(2)
loglog(freq,Z,"LineWidth",2);
xlim([9e3,30e6]);
xlabel("Freq (Hz)");
ylabel("Impedance (\Omega)");
grid on
fontsize(gcf,16,"points");

