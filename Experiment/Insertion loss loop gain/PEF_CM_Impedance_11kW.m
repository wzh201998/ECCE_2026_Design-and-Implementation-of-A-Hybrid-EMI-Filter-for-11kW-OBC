% clear,
% clc,
% close all;
% Author Weihao Zhao
% For IEEE ECCE EU 2026 
%%
function [Model]=PEF_CM_Impedance_11kW(freq1)
Model.Cy1=1.5e-9*3+4.7e-9;
Model.Cy1_ESL=85e-9;
Model.Cy1_ESR=1.5;
Model.Zcy1=1./(1i.*2*pi*freq1.*Model.Cy1) + 1i.*2*pi*freq1.*Model.Cy1_ESL+ Model.Cy1_ESR;

Model.Cy2=4.7e-9*4;
Model.Cy2_ESL=12.83e-9;
Model.Cy2_ESR=2;
Model.Zcy2=1./(1i.*2*pi*freq1.*Model.Cy2) + 1i.*2*pi*freq1.*Model.Cy2_ESL+ Model.Cy2_ESR;

%% CM Choke 1 %%
load("CM_Low_AL.mat")
Al_min=68e-6;
N=4;
Lcm1_min=Al_min*2*N^2*mur./(abs(mutotal(1)));
Rcm1_min=2*pi*freq.*Al_min*2*N^2.*mui./(abs(mutotal(1)));
Cpar=10e-12;
Zcm1_min=1./( 1./(1i.*2*pi*freq.*Lcm1_min+Rcm1_min)+(1i.*2*pi*freq.*Cpar));
ZLCM1=interp1(freq,Zcm1_min,freq1);
Model.Zlcm1=ZLCM1;

%%
load("CM_High_AL.mat")
Al_min=60e-6*0.95;
N=4;
Lcm2_min=Al_min*2*N^2*mur./(abs(mutotal(1)));
Rcm2_min=2*pi*freq.*Al_min*2*N^2.*mui./(abs(mutotal(1)));
Cpar=10e-12;
Zcm2_min=1./( 1./(1i.*2*pi*freq.*Lcm2_min+Rcm2_min)+(1i.*2*pi*freq.*Cpar));
ZLCM2=interp1(freq,Zcm2_min,freq1);
Model.Zlcm2=ZLCM2;

figure(101)
semilogx(freq,abs(Lcm1_min))
hold on
semilogx(freq,abs(Lcm2_min))
end