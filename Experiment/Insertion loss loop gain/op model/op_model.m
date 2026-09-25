clear,
clc,
close all;
addpath("C:\Users\weihao zhao\PhD\Conference\ECCE Europe 2026\Design 11kW HEF\Experiment data\Insertion Loss\op model");
%% Simulation
data=readmatrix("RG770RF340k_OL.txt");
freq=data(:,1);
Gain=data(:,2);
Phase=data(:,3);

figure(1)
semilogx(freq,Gain);
hold on

figure(2)
semilogx(freq,Phase);
hold on
%%
s=1i*2*pi*freq;
AEF.Go=10^(80/20);            % Obtain from the LM7171 datasheet, different from each op-amp
omega1=2*pi*25.572e3;           % Obtain from the LM7171 datasheet, different from each op-amp
omega2=2*pi*255097000;          % Obtain from the LM7171 datasheet, different from each op-amp
AEF.Gop=AEF.Go./((1+s/omega1).*(1+s/omega2));



figure(1)
semilogx(freq,20*log10(abs(AEF.Gop)));
hold on
xlim([9e3,800e6]);


figure(2)
semilogx(freq,angle(AEF.Gop).*180/pi);
hold on
xlim([9e3,800e6]);
%% Simulation
clear,
clc,
close all;
data=readmatrix("RG770RF340k_CL.txt");
freq=data(:,1);
Gain=data(:,2);
Phase=data(:,3);

figure(1)
semilogx(freq,Gain);
hold on

figure(2)
semilogx(freq,Phase);
hold on

%%
s=1i*2*pi*freq;
AEF.Go=10^(80/20);            % Obtain from the LM7171 datasheet, different from each op-amp
omega1=2*pi*25.572e3;           % Obtain from the LM7171 datasheet, different from each op-amp
omega2=2*pi*255097000;          % Obtain from the LM7171 datasheet, different from each op-amp
AEF.Gop=AEF.Go./((1+s/omega1).*(1+s/omega2));



AEF.ZF=340e3;
AEF.ZG=770;

GBP=160e6;                      % Obtain from the LM7171A datasheet,
alpha=AEF.ZF./(AEF.ZG+AEF.ZF);
beta=AEF.ZG./(AEF.ZG+AEF.ZF);
f0=GBP./beta;
AEF.Aop=alpha.*(AEF.Gop)./(1+beta.*AEF.Gop)./sqrt(1+freq.^2./f0.^2./(1+beta.*AEF.Gop).^2); % Inverting version


figure(1)
semilogx(freq,20*log10(abs(AEF.Aop)));
hold on
xlim([9e3,30e6]);


figure(2)
semilogx(freq,angle(AEF.Aop).*180/pi);
hold on
xlim([9e3,30e6]);