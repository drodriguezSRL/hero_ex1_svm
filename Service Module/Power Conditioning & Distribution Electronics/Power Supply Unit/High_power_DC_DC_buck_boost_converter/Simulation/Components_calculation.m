#driver LT8390
clc;
clear all;
close all;

#parameters
Vin = 36;
Vin_max = 42;
Vin_min = 30;
Vout = 36;
Iout = 6;
f = 400E3;
I_rip = 0.3;

#Rt frequency setting
Rt = 100E3;

#inductor selection (The inductance must be larger than the greatest value below)
Lbuck = Vout*(Vin_max-Vout)/(f*Iout*I_rip*Vin_max)
Lboost = Vin_min^2 * (Vout-Vin_min)/(f*Iout*I_rip*Vout^2)
L = 33E-6

#Rsense selection
DIL_boost = Vin_min*(Vout-Vin_min)/(f*L*Vout)
DIL_buck = Vout*(Vin_max-Vout)/(f*L*Vin_max)
Rsense_boost = (2*50E-3*Vin_min)/(2*Iout*Vout + DIL_boost*Vin_min)
Rsense_buck = (2*50-3)/(2*Iout + DIL_buck)
Rsense = 0.7*min(Rsense_boost,Rsense_buck)
Lmin = (10*Vout*Rsense)/f

#Mosfet selection
pt = 1.5;
k = 1.7;
RdsA = 10E-3;
RdsB = 10E-3;
RdsC = 10E-3;
CrssC = 15E-12;
RdsD = 10E-3;
PA = (Iout*Vout/Vin_min)^2 * pt * RdsA
PB = ((Vin_max-Vout)/Vin_max)*Iout^2*pt*RdsB
PC = ((((Vout-Vin_min)*Vout)/Vin^2)*Iout^2*pt*RdsC) + (k*Vout^3*(Iout/Vin_min)*CrssC*f)
PD = (Vout/Vin_min) * Iout^2 * pt*RdsD

#Schottky diode (optionnal)

#Cin and Cout selection
Irms = Iout/2; %worst-case condition commonly used for design
Cin = 40E-6+(2*4.7E-6); %with low ESR

Cout = 3*47E-6 + 3*10E-6;
ESR_out = 500E-3/3;

DVout_boost = Iout*(Vout-Vin_min)/(Cout*f*Vout)
DVout_buck = Vout*(1-(Vout/Vin_max))/(8*L*f^2*Cout)

DVesr_boost = (Vout*Iout*ESR_out)/Vin_min
DVesr_buck = (Vout*(1-(Vout/Vin_max))*ESR_out)/(f*L)

#INTvcc reg
#Regulator bypass by a 4.7uF / 16V capacitor

#Bootstrap top gate driver supply
#capacitor between 0.1uF and 0.47uF with X7R dielectric

#Programming Vin UVLO
Ruv1 = 120E3;
Ruv2 = 5.1E3;

Vuvp = 1.233*(Ruv1+Ruv2)/Ruv2 + 2.5E-6 * Ruv1 
Vuvm = 1.220*(Ruv1+Ruv2)/Ruv2

#Current limit Vctrl > 1.35V (Vref)
Iisout = Iout*1.5;
Iisin = 36*Iisout/30;

Risout = 100E-3/Iisout
Risin = 100E-3/Iisin

#Feedback voltage
Rfb1 = 150E3;
Rfb2 = 4.27E3;
Vo = 1*(Rfb1+Rfb2)/Rfb2
Vov = 1.1*(Rfb1+Rfb2)/Rfb2
Vshort = 0.25*(Rfb1+Rfb2)/Rfb2

#soft-start
tss = 10E-3;
Css = 12.5E-6*tss/1

#compensation
Rc1 = 27E3;
Cc1 = 4.7E-9;
Cc2 = 100E-12;