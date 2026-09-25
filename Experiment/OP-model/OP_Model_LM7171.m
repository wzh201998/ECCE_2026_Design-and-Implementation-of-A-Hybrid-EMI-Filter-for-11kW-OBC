clear;
clc,
close all;
%%
filename=["LM7171_CL_Gain.csv","LM7171_CL_Gain1.csv","LM7171_CL_Gain2.csv","LM7171_OL_Gain.csv"];
data=readmatrix(filename(4));
freq=data(:,1);
S11_mag=10.^(data(:,2)/20);
S11_phase=data(:,6).*pi./180;
S11=S11_mag.*(cos(S11_phase)+1i.*sin(S11_phase));

S21_mag=10.^(data(:,3)/20);
S21_phase=data(:,7).*pi./180;
S21=S21_mag.*(cos(S21_phase)+1i.*sin(S21_phase));

S12_mag=10.^(data(:,4)/20);
S12_phase=data(:,8).*pi./180;
S12=S12_mag.*(cos(S12_phase)+1i.*sin(S12_phase));

S22_mag=10.^(data(:,5)/20);
S22_phase=data(:,9).*pi./180;
S22=S22_mag.*(cos(S22_phase)+1i.*sin(S22_phase));
VGain=2*S21./((1+S11).*(1-S22)+S21.*S12);
figure(1)
semilogx(freq,20*log10(abs(VGain)),"LineWidth",2);
hold on