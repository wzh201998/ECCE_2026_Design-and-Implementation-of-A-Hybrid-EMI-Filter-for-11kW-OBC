function [A,B,C,D, freq] = Read_S2ABCD(filename)
data=readmatrix(filename);
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

for i=1:length(freq)
S(:,:,i)=[S11(i),S12(i);S21(i),S22(i)];
end

ABCD=s2abcd(S,50);

A=squeeze(ABCD(1,1,:));
B=squeeze(ABCD(1,2,:));
C=squeeze(ABCD(2,1,:));
D=squeeze(ABCD(2,2,:));
end