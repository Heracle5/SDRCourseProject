%%This is the code of SDR course design project
%We create a digital transmiter and receiver based on DSB Module
%%
%Init parameter setting
fs1=150e3;%we set the sampling rate of the f to 150kHz
t1=0:1/fs1:0.001;
fc=211011*4;
fs2=15e6;%we set the sampling rate of the carrier signal to 15MHz
t2=0:1/fs2:0.001;
%%
f=sin(2*pi*2*10e3*t1)+sin(2*pi*3*10e3*t1);%the signal to be moduled
figure(1)
plot(t1/0.001,f);
title('Wave of the signal to be moduled');
xlabel("n");
ylabel("Amp");
%%
c=cos(2*pi*fc*t2);%Carrier Signal
figure(2)
plot(t2/0.001,c);
title('Wave of the carrier signal');
xlabel("n");
ylabel("Amp");
%%
%DSB Modulation
%to be continued
m=sin(2*pi*2*10e3*t2)+sin(2*pi*3*10e3*t2);
s=m.*c;
figure(3)
plot(t2/0.001,s,t2/0.001,m,"r-");
title('Wave of the moduled signal');
xlabel('n');
ylabel("Amp");
legend('Modulated Message Signal','Message Signal m(n)')
%%
%I side and Q side Modulation
I=s;%I sideroad
Q=0;% Q sideroad

