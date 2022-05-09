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
fs3=15e6;  %采样频率
ts3=1/fs3;
num=15e7;%数据长度
data=Tx;%科斯塔斯环的输入信号
fc2=16e6;  %本地频率
n=fs3/1000;  %累积时间为1ms
nn=[0:n-1];
nf=floor(length(data)/n);%将输入数据分成1ms的多个数据块
wfc=2*pi*fc2;  %本地信号
phi_prv=0;
temp=0;
frame=0;
carrier_phase=0;
phase=0;

%环路滤波器的参数
c1=153.7130;
c2=6.1498;

for frame=1:nf
    %产生本地的sin和cos函数
    expcol=exp(j*(wfc*ts3*nn+phase));
    sine=imag(expcol);
    cosine=real(expcol);
    
    x=data((1:n)+(frame-1)*n);
    %将数据转换到基带
    x_sine=x.*sine;
    x_cosine=x.*cosine;
    Q=sum(x_sine);
    I=sum(x_cosine);
    phase_discri(frame)=atan(Q/I);  %得到锁相环的输入
    
    %锁相环
    dfrq=c1*phase_discri(frame)+temp; %经过环路滤波器
    temp=temp+c2*phase_discri(frame); 
    wfc=wfc-dfrq*2*pi;  %改变本地频率
    dfrq_frame(frame)=wfc;
    phase=wfc*ts3*n+phase; %得到不同块的频率
    
end
mean_freq=mean(dfrq_frame/2/pi);