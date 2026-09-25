clear;
clc;
close all;
addpath("C:\Users\weihao zhao\PhD\Conference\ECCE Europe 2026\Design 11kW HEF\Experiment data\CM Choke\Small_AL")
addpath("C:\Users\weihao zhao\PhD\Conference\ECCE Europe 2026\Design 11kW HEF\Experiment data\CM Choke\Large_AL")
%% 
data=readmatrix("CM_CHOKE_HIGH_AL.csv");
freq=data(3:end-1,1);
Z_LCM2=data(3:end-1,2);
Phase=data(3:end-1,3);
% R=data(:,4);
% L=data(:,5);
% %%
Zreal=Z_LCM2.*cos(Phase.*pi/180);
Zimag=Z_LCM2.*sin(Phase.*pi/180);
Ae=0.855e-4;
le=10.2e-2;
N=4;
w=2*pi*freq;
mu0=4*pi*1e-7;
mur=Zimag.*le./(N^2*Ae.*w)./mu0;
mui=Zreal.*le./(N^2*Ae.*w)./mu0;
mutotal=sqrt(mur.^2+mui.^2);
figure(2)
semilogx(freq,mur,"LineWidth",2);
hold on
semilogx(freq,mui,"LineWidth",2);
figure(1)
semilogx(freq,abs(Z_LCM2),"LineWidth",2);
hold on

Al_max=140e-6;
Al_min=68e-6;
Al=(Al_min+Al_max)/2;

Lcm1_max=Al_max*2*N^2*mur./(abs(mutotal(1)) );
Lcm1_min=Al_min*2*N^2*mur./(abs(mutotal(1)));
Rcm1_min=2*pi*freq.*Al_min*2*N^2.*mui./(abs(mutotal(1)));
Rcm1_max=2*pi*freq.*Al_max*2*N^2.*mui./(abs(mutotal(1)));

Cpar=1e-12;
Zcm1_max=1./(1./(1i.*2*pi*freq.*Lcm1_max+Rcm1_max)+(1i.*2*pi*freq.*Cpar));
Zcm1_min=1./( 1./(1i.*2*pi*freq.*Lcm1_min+Rcm1_min)+(1i.*2*pi*freq.*Cpar));

figure(1)
semilogx(freq,abs(Zcm1_min),"LineWidth",2);
% %%
save("CM_High_AL.mat","freq","mutotal","mur","mui")
%%
data=readmatrix("CM_CHOKE_LOW_AL.csv");
freq=data(3:end-1,1);
Z_LCM1=data(3:end-1,2);
Phase=data(3:end-1,3);
% R=data(:,4);
% L=data(:,5);
% %%
Zreal=Z_LCM1.*cos(Phase.*pi/180);
Zimag=Z_LCM1.*sin(Phase.*pi/180);
Ae=0.855e-4;
le=10.2e-2;
N=4;
w=2*pi*freq;
mu0=4*pi*1e-7;
mur=Zimag.*le./(N^2*Ae.*w)./mu0;
mui=Zreal.*le./(N^2*Ae.*w)./mu0;
mutotal=sqrt(mur.^2+mui.^2);
figure(2)
semilogx(freq,mur,"LineWidth",2);
hold on
semilogx(freq,mui,"LineWidth",2);
figure(1)
semilogx(freq,abs(Z_LCM1),"LineWidth",2);
hold on
save("CM_Low_AL.mat","freq","mutotal","mur","mui")

Al_max=142e-6*0.95;
Al_min=60e-6*0.95;
Al=(Al_min+Al_max)/2;

Lcm1_max=Al_max*2*N^2*mur./(abs(mutotal(1)) );
Lcm1_min=Al_min*2*N^2*mur./(abs(mutotal(1)));
Rcm1_min=2*pi*freq.*Al_min*2*N^2.*mui./(abs(mutotal(1)));
Rcm1_max=2*pi*freq.*Al_max*2*N^2.*mui./(abs(mutotal(1)));

Cpar=1e-12;
Zcm1_max=1./(1./(1i.*2*pi*freq.*Lcm1_max+Rcm1_max)+(1i.*2*pi*freq.*Cpar));
Zcm1_min=1./( 1./(1i.*2*pi*freq.*Lcm1_min+Rcm1_min)+(1i.*2*pi*freq.*Cpar));

figure(1)
semilogx(freq,abs(Zcm1_min),"LineWidth",2);
%%
CY1=1.5e-9*3+4.7e-9;
ESL1=50e-9;
ZCY1=1i*2*pi*freq*ESL1+1./(1i*2*pi*freq*CY1)+3;

CY2=4.7e-9*4;
ESL2=30e-9;
ZCY2=1i*2*pi*freq*ESL2+1./(1i*2*pi*freq*CY2)+3;
%%
Zload=1./(1./(50+Z_LCM2)+1./ZCY2);
Zsrc=Z_LCM1+1./(1/50+1./ZCY1);

K1=Z_LCM2./Zload +1;
K2=Z_LCM1.*(K1./((ZCY2)) +1./(Zload)) +K1;
K3=(K2./(ZCY1) +K1./((ZCY2))+ 1./Zload).*Zsrc+K2 ;
IL_PEF=Zload.*K3./(Zload+Zsrc);
IL_PEFdB=20*(log10(abs(IL_PEF)));

figure(3)
semilogx(freq,abs(IL_PEFdB),"LineWidth",2);
hold on
