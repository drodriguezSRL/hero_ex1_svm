####
clc;
close all;
clear all;
pkg load control;

####
fr = 75000;
wr = 2*pi*fr;

L = 10E-6
C = 1/(L*wr^2)
Cstd = 470E-9;
fr_corr = 1/(2*pi*sqrt(L*Cstd))
p = tf('s')

Rc = 0.5;
Yc = 1/(C*p);
Zc = Rc+Yc

Rl = 16E-3;
Yl = L*p;
Zl = Rl + Yl

sys = Zc/(Zc+Zl)
bode(sys)
[Mg, Phi, wg, wphi] = margin(sys);
f0 = wphi/(2*pi);
w1 = 2*pi*450000;
w2 = 2*pi*350000;
w3 = 2*pi*250000;
[G1,phase1] = bode(sys,w1);
G1dB = 20*log10(G1);
[G2,phase2] = bode(sys,w2);
G2dB = 20*log10(G2);
[G3,phase3] = bode(sys,w3);
G3dB = 20*log10(G3);