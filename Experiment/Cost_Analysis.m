clear;
clc;
close all

% Data
data = [38 29 47 1.6]./(74);
% Create pie chart
label={'Capacitor','Inductor','Active Filter','PCB'};
pie(data,label);