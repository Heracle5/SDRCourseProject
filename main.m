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
load filterbeta.mat;
load filtergamma.mat;
%%
f=sin(2*pi*2*10e2*t1)+sin(2*pi*3*10e2*t1);%the signal to be moduled
%f=filter(Num,1,f);%add a reshape filter
figure(1)
plot(t1,f);
title('Wave of the signal to be moduled');
xlabel("n");
ylabel("Amp");
N=length(f);
If=abs(fftshift(fft(f,N)));%fft
%fi=(-N/2:N/2-1)/N;%digital freq=analog freq*T
fi=((0:N-1)*1/N-1/2) ;
figure(2)
plot(fi,If);
title('基带信号采样后双边频域图像')
xlabel('*pi rad');
ylabel('|I(f)|');
%%
%Interp
f=interp(f,fs2/fs1);
N=length(f);
If=abs(fftshift(fft(f,N)));%fft
%fi=(-N/2:N/2-1)/N;%digital freq=analog freq*T
fi=2*((0:N-1)*1/N-1/2) ;
figure(3)
plot(fi,If);
title('基带信号采样率变换后双边频域图像')
xlabel('rad');
ylabel('|I(f)|');
[b,a]=sos2tf(SOS,G);
f=filter(b,a,f);
figure(4)
plot(t2,f);
title('Wave of the filtered interp signal');
xlabel("n");
ylabel("Amp");
N=length(f);
If=abs(fftshift(fft(f,N)));%fft
%fi=(-N/2:N/2-1)/N;%digital freq=analog freq*T
fi=2*((0:N-1)*1/N-1/2) ;
figure(5)
plot(fi,If);
title('基带信号采样率变换后经由DLPF滤波后双边频域图像')
xlabel('rad');
ylabel('|I(f)|');
%%
%I side and Q side Modulation
I=f;%I sideroad
Q=0;% Q sideroad
%%
c=cos(2*pi*fc*t2);%Carrier Signal
figure(6)
plot(t2,c);
title('Wave of the carrier signal');
xlabel("n");
ylabel("Amp");
%%
%DSB Modulation
%to be continued
s=f.*c;
figure(7)
plot(t2/0.001,s,t2/0.001,f,"r-");
title('Wave of the moduled signal');
xlabel('n');
ylabel("Amp");
legend('Modulated Message Signal','Message Signal m(n)')
%%
%DA module
Tx=interp(s+Q,5);
%%
%drawing the spectum of the signal
N=length(Tx);
If=abs(fftshift(fft(Tx,N)));%fft
%fi=fs2*5*(-N/2:N/2-1)/N;%digital freq=analog freq*T
%fi=(0:N-1)*fs1/N-fs1/2 ;
fi=((0:N-1)*fs2*5/N-fs2*5/2);
figure(8)
plot(fi,If);
title('发送信号双边频域图像')
xlabel('rad');
ylabel('|I(f)|');
%%
%Receiver part
ts3=0:1/(fs2*5):0.01-1/(fs2*5);
[b,a]=sos2tf(SOS1,G1);
Rx=filter(b, a, Tx);
N=length(Rx);
If=abs(fftshift(fft(Rx,N)));%fft
%fi=fs2*5*(-N/2:N/2-1)/N;%digital freq=analog freq*T
fi=(0:N-1)*fs2*5/N-fs2*5/2 ;
figure(9)
plot(fi,If);
title('发送信号经由选频滤波器后的双边频域图像')
xlabel('rad');
ylabel('|I(f)|');
%mix freq
Signal_mix=Rx.*cos(2*pi*389044*ts3);
N=length(Signal_mix);
If=abs(fftshift(fft(Signal_mix,N)));%fft
%fi=fs2*5*(-N/2:N/2-1)/N;%digital freq=analog freq*T
fi=(0:N-1)*fs2*5/N-fs2*5/2 ;
figure(10)
plot(fi,If);
title('混频后信号双边频域图像')
xlabel('rad');
ylabel('|I(f)|');
%filter
[b,a]=sos2tf(SOS2,G2);
Signal_filter=filter(b,a,Signal_mix);
N=length(Signal_filter);
If=abs(fftshift(fft(Signal_filter,N)));%fft
%fi=fs2*5*(-N/2:N/2-1)/N;%digital freq=analog freq*T
fi=(0:N-1)*fs2*5/N-fs2*5/2 ;
figure(11)
plot(fi,If);
title('中频滤波后信号双边频域图像')
xlabel('rad');
ylabel('|I(f)|');
figure(12)
plot(ts3,Signal_filter);
title('滤波后信号时域图像')
xlabel('rad');
ylabel('|I(f)|');
Signal_down=downsample(Signal_filter,5);
N=length(Signal_down);
If=abs(fftshift(fft(Signal_down,N)));%fft
%fi=fs2*5*(-N/2:N/2-1)/N;%digital freq=analog freq*T
fi=(0:N-1)*fs2/N-fs2/2 ;
figure(13)
plot(fi,If);
title('AD后信号双边频域图像')
xlabel('rad');
ylabel('|I(f)|');
%%
%Costas环
% mix=Tx.*cos(2*pi*fc*t2);
% N=length(mix);
% If=abs(fftshift(fft(mix,N)));%fft
% fi=fs2*(-N/2:N/2-1)/N;%digital freq=analog freq*T
% figure(8)
% plot(fi,If);
% title('发送信号双边频域图像')
% xlabel('rad');
% ylabel('|I(f)|');