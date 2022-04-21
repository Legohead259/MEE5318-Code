clc
clear

C1 = 27e-9;
C2 = 100e-9;
R1 = 56e3;
R2 = 1.5e3; 
G = tf([C1*R1  0],[C1*R1*C2*R2  (C1*R1+C2*R2)  1])
bode(G);
[mag,phase,w] = bode(G);
subplot(2,1,1);
semilogx(w/2/pi,20*log10(squeeze(mag)),w/2/pi,mag,w/2/pi,magETFE);
xlabel('Frequency ( Hz )');
ylabel('Gain ( dB )');
grid;
subplot(2,1,2);
semilogx(w/2/pi,squeeze(phase));
xlabel('Frequency ( Hz )');
ylabel('Phase ( degree )');
grid;


