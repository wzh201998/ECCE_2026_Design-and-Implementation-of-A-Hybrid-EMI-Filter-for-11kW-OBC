function [AEF,CT]=AEF_Parameter_11kW_HEF(DUT,Model,OP,CT,freq1)
%% measured output impedance
[~,~,C1,~, freq]=Read_S2ABCD("Zoutcl_op-amp4.csv");
%  Zoutcl_op-amp4.csv
% "Zoutcl_op-amp_7171.csv"
index_f=find(diff(freq)==0);
freq(index_f)=[];
AEF.Zmo=1./C1;
AEF.Zmo(index_f)=[];
AEF.Zmo1_r=interp1(freq,real(AEF.Zmo),freq1);
AEF.Zmo1_i=interp1(freq,imag(AEF.Zmo),freq1);
AEF.Zmo1=AEF.Zmo1_r+1i*AEF.Zmo1_i;
% %% Simlated output impedance
% data=readmatrix("Z_out_cl.txt");
% freq=data(:,1);
% Zoutr=data(:,2);
% Zouti=data(:,3);
% 
% AEF.Zmo1_r=interp1(freq,Zoutr,freq1);
% AEF.Zmo1_i=interp1(freq,Zouti,freq1);
% AEF.Zmo1=AEF.Zmo1_r+1i*AEF.Zmo1_i;
%%
AEF.Zsrc=Model.Zlcm1+1./( 1./Model.Zcy1 +1./DUT.ZS);
AEF.ZL=1./(1./(Model.Zcy2)+1./(Model.Zlcm2 +DUT.ZL));

figure(7)
subplot(211)
loglog(freq1,abs(AEF.Zsrc),"LineWidth",2);
grid on
hold on
loglog(freq1,abs(AEF.ZL),"LineWidth",2);
% grid on
legend("Zsrc","ZL")

subplot(212)
semilogx(freq1,angle(AEF.Zsrc)*180/pi, "LineWidth",2)
grid on
hold on
semilogx(freq1,angle(AEF.ZL)*180/pi, "LineWidth",2)


s=1i.*2*pi*freq1;
[~,~,~,CT.GCT]=CT_bandwidth_cal(CT);

AEF.Rinj=OP.Rinj;
AEF.Cinj=OP.Cinj;
AEF.ZG=OP.ZG  ;
AEF.ZF=OP.ZF;

AEF.Go=10^(80/20);            % Obtain from the LM7171 datasheet, different from each op-amp
omega1=2*pi*25.572e3;           % Obtain from the LM7171 datasheet, different from each op-amp
omega2=2*pi*255097000;          % Obtain from the LM7171 datasheet, different from each op-amp
AEF.Gop=AEF.Go./((1+s/omega1).*(1+s/omega2));

% omega1=2*pi*25.2e3;           % Obtain from the LM7171 datasheet, different from each op-amp
% omega2=2*pi*1.7e6;            % Obtain from the LM7171 datasheet, different from each op-amp
% omega3=2*pi*96.03e6;          % Obtain from the LM7171 datasheet, different from each op-amp
% AEF.Gop=AEF.Go./((1+s/omega1).*(1+s/omega2).*(1+s/omega3));
% figure()
% semilogx(freq1,20*log10(abs(AEF.Gop)),"LineWidth",2);
% hold on
% yyaxis right
% plot(freq1,angle(AEF.Gop).*180/pi,"LineWidth",2);
GBP=160e6;                      % Obtain from the LM7171A datasheet,
alpha=AEF.ZF./(AEF.ZG+AEF.ZF);
beta=AEF.ZG./(AEF.ZG+AEF.ZF);
f0=GBP./beta;
AEF.Aop=-alpha.*(AEF.Gop)./(1+beta.*AEF.Gop)./sqrt(1+freq1.^2./f0.^2./(1+beta.*AEF.Gop).^2); % Inverting version
AEF.Zinj=AEF.Rinj+1./(s.*AEF.Cinj);
% +Model.Zlcm1 + Model.Zcy1;
% Zout=Zmo;
% AEF.Aop=(AEF.Go./AEF.Zmo)./(1./AEF.Zmo+1./AEF.Zinj+1./(AEF.ZF+AEF.ZG) +(AEF.ZG./(AEF.ZF+AEF.ZG)).*(AEF.Gop./AEF.Zmo) );

AEF.K1=AEF.Zsrc.*AEF.ZL./(AEF.Zsrc+AEF.ZL)./(AEF.Zinj+12*AEF.Zmo1);
AEF.K2=CT.GCT.*AEF.Aop./AEF.ZL;
AEF.IL1=1-(AEF.K2-1).*AEF.K1;
AEF.ILMagdB=20*log10(abs(AEF.IL1));
end


function [Sen,fL,fH,Rm]=CT_bandwidth_cal(CT)
% Sen: sensitivity [V/A], s=R/n (load resistance over turns ratio)
% fL: Lower cutoff frequency (Hz)
% fH: Higher cutoff frequency (Hz)
% R: Load resistance on the secondary side
% n: turns ratio;
% Lm: Magnetization inductance
% Ll: Leakage inductance, secondary side
% Cs: parasitic capacitance, secondary side
% ESR: Secondary side ESR, winding resistance
% Rc: Core resistance

freq =CT.freq;
Rc   =CT.Rc   ;
ESR  =CT.ESR  ;
Cs   =CT.Cs   ;
% Lself=CT.Lself;
% k    =CT.k    ;
Lm   =CT.Lm   ;
Ll   =CT.Ll   ;
R    =CT.R    ;
n    =CT.n    ;

s=2*pi*freq.*1i;

Sen=R/n;

% Den=Ll.*(s.^3+s.^2.*( (Lm.*(Ll+ESR.*R.*Cs)+ Rc.*R.*Cs.*(Lm+Ll))./(R.*Cs.*Lm.*Ll)) +s.*(Lm.*(ESR+R+Rc)+Rc.*(Ll+ESR.*R.*Cs) )./(R.*Cs.*Lm.*Ll) +(Rc.*(ESR+R)./(R.*Cs.*Lm.*Ll ))  );
% Rm=Rc.*s./(n.*Cs.*Den);
Rm=s.*(Rc./Cs)./(n.*(s.*Rc.*(s+1./(R.*Cs)) +(s.*Ll+ESR).*(s+Rc./Lm).*(s+1./(R.*Cs)) +(s+Rc./Lm)./Cs) ) ;

fL=Rc.*(R+ESR)./(Rc+R+ESR)./(2.*pi.*Lm);
wL=2*pi.*fL;
fp1=1./(R.*Cs.*2.*pi);
fp2=Rc./(2.*pi.*Ll);

fH=min(fp1,fp2);

% Rm=R.*Rc.*s./(n.*(Rc+R+ESR).*(s+wL));
% figure(1)
% subplot(211)
% semilogx(freq,20.*log10(abs(Rm)));
% hold on
% subplot(212)
% semilogx(freq,((angle(Rm).*180./pi)));
% hold on
end