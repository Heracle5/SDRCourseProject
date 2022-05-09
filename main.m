%%This is the code of SDR course design project
%We create a digital transmiter and receiver based on DSB Module
%%
%Init parameter setting
clear all
clc
fs1=150e3;%we set the sampling rate of the f to 150kHz
t1=0:1/fs1:0.01-1/fs1;
fc=211011*4;
fs2=15e6;%we set the sampling rate of the carrier signal to 15MHz
t2=0:1/fs2:0.01-1/fs2;
load filteralpha.mat;
%%
f=sin(2*pi*2*10e2*t1)+sin(2*pi*3*10e2*t1);%the signal to be moduled
%f=filter(Num,1,f);%add a reshape filter
figure(1)
plot(t1,f);
title('Wave of the signal to be moduled');
xlabel("n");
ylabel("Amp");
%%
%Interp
f=interp(f,fs2/fs1);
f=filter(Num,1,f);
figure(2)
plot(t2,f);
title('Wave of the interp signal');
xlabel("n");
ylabel("Amp");
%%
%I side and Q side Modulation
I=f;%I sideroad
Q=0;% Q sideroad
%%
c=cos(2*pi*fc*t2);%Carrier Signal
figure(3)
plot(t2,c);
title('Wave of the carrier signal');
xlabel("n");
ylabel("Amp");
%%
%DSB Modulation
%to be continued
s=f.*c;
figure(4)
plot(t2/0.001,s,t2/0.001,f,"r-");
title('Wave of the moduled signal');
xlabel('n');
ylabel("Amp");
legend('Modulated Message Signal','Message Signal m(n)')
%%
Tx=s+Q;
%%
%drawing the spectum of the signal
N=length(Tx);
If=abs(fftshift(fft(Tx,N)));%fft
fi=fs2*(-N/2:N/2-1)/N;%digital freq=analog freq*T
figure(5)
plot(fi,If);
title('发送信号双边频域图像')
xlabel('rad');
ylabel('|I(f)|');
%%
%Receiver part
%%
%Costas环
mix=Tx.*cos(2*pi*fc*t2);
N=length(mix);
If=abs(fftshift(fft(mix,N)));%fft
fi=fs2*(-N/2:N/2-1)/N;%digital freq=analog freq*T
figure(6)
plot(fi,If);
title('发送信号双边频域图像')
xlabel('rad');
ylabel('|I(f)|');