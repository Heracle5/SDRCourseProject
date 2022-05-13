amp1=2;
 amp2=0.5;
 Tt=0.01;
 Tr=1e-3;
 fs=1e6;
 fc=1e5;
 N=round(Tt/Tr);
 x1=[amp1.*ones(Tr*fs/2,1);amp2.*ones(Tr*fs/2,1)];
 t=(1/fs:1/fs:Tt)';
 x=repmat(x1,N,1).*cos(2*pi*fc.*t);
 figure
 plot(t,x)
 hold on
 A=1;
 %%
 % checkwav
 % z=zeros(length(x)/N,1);
 % for i=1:length(z)
 %     z(i)=(1/N)*(sum(x((i)*10-9:i*10,:))^2);
 % end
 % figure
 % plot(linspace(0,0.01,length(z)),z)
 % hold on
 % %%
 % % error Voltage
 % errorv=zeros(length(x)/N,1);
 % errorv=A-log(z);
 % figure
 % plot(errorv)
 % hold on
 % %%
 % %环路增益
 % g=K*sum(errorv);
 AveragingLength=100;%环路滤波器增益(dB)
 g=0;
 reflevel = 10;
 ref = log(reflevel);%设置步长因子
 StepSize = 0.01;
 K = StepSize;%设置最大增益
 maxGain_dB =60;
 maxGain=10^(maxGain_dB/10);
 N=length(x);
 %powX平方律检波器的输出
 for p=1:N
     y(p)=x(p)*exp(g);
 if(p>AveragingLength)
 powX(p)= 2*mean(y(p-AveragingLength:p).^2);
 else
 powX(p)= 2*mean(y(1:p).^2);
 end
 %对数放大
%对数放大
 logZ =log(powX(p));%误差电压
 e= ref - logZ;
 g = min(g+K*e, maxGain);
 end
 figure
 plot(t,y)