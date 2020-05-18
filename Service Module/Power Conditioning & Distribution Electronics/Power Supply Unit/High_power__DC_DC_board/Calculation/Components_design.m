####
clc;
clear all;
close all;

####

Vcc = 36;
Vcc_max = 42;
Vout = 12;
Iout = 3;
f = 400000;
####
#inductance
L = 47E-6     #22uH for 5V / 47uH for 12V
DIL = ((Vcc - Vout)/L) * Vout/(f*Vcc)
DIL_ratio = DIL/Iout

#output capacitor
Cout = 47E-6
Resr_out = 0.23
DVout = DIL/(2*pi*Cout*f) + DIL*Resr_out
Resr_max = DVout/DIL
Icout = Vout*(Vcc_max-Vout)/(sqrt(12)*Vcc_max*L*f)

#input capacitor
Cin = 20E-6
Resr_in = 0.1
DVin = (Iout*0.25)/(Cin*f)

#Output voltage
Rls = 3.3E3
Rhs = Rls*(Vout - 0.8)/0.8

#UV lockout
Vstart = 30;
Vstop = 29;
Vena = 1.2;
I1 = 1.2E-6
Ihys = 3.4E-6;
Ruv1 = (Vstart - Vstop)/Ihys
Ruv2 = Vena/(((Vstart - Vena)/Ruv1)+I1)

#Select frequency
Rt = 101756/((0.001*f)^1.008)

#internal soft start
Tss = 1024/(f*0.001)

#Irush verification
Irush = (Cout*Vout)/Tss + DIL + Iout

#diode power
Cj = 100E-12;
Vfd = 0.65
PD = ((Vcc_max - Vout) * Iout * Vfd)/Vcc_max + (Cj*f*(Vcc + Vfd)^2)/2

#Bootstrap
Cboot = 0.1E-6

#Compensation
fp = Iout/(2*pi*Vout*Cout);
fz = 1/(2*pi*Resr_out*Cout);
fco1 = sqrt(fp*fz);
fco2 = sqrt(fp*f/2);
fco = (fco1+fco2)/2;
gmps = 17;
Vref = 0.8;
gmea = 350E-6;
Rc1 = ((2*pi*fco*Cout)/gmps)*(Vout/(Vref*gmea))
Cc1 = 1/(2*pi*Rc1*fp)
Cc21 = (Cout*Resr_out)/Rc1;
Cc22 = 1/(Rc1*f*pi);
Cc2 = max(Cc21,Cc22)

#Power dissipation estimation
Tr = Vcc_max*0.16E-9+3E-9;
Rdson = 92E-3;
Qg = 3E-9;
Iq = 146E-6;
Pcond = Iout^2 * Rdson * (Vout/Vcc)
Psw = Vcc*Tr*f*Iout
PGD = Vcc*Qg*f
PQ = Vcc*Iq
Ptot = Pcond+Psw+PGD+PQ