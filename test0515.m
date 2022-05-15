 
%  Design a minimum-order CIC compensator that compensates...
%  for the droop in the passband for the CIC decimator.
Fs = 15230000;% Input sampling frequency
Fpass = 130200;% Frequency band of interest
D = 5;% Decimation factor of CIC
d1 = fdesign.decimator(D,'CIC',1,Fpass,65,Fs); %design a cic filter 
Hcic = design(d1);
Hd(1) = cascade(dfilt.scalar(1/gain(Hcic)),Hcic);
d2 = fdesign.ciccomp(Hcic.DifferentialDelay, Hcic.NumberOfSections,Fpass,761000,.005,66,Fs/D); % design a cic compensator filter 
Hd(2) = design(d2);
fcfwrite([Hcic Hd(2)],'CICdesciption','dec'); % 其中，生成的.fcf文件描述滤波器的结构
hvt=fvtool(Hd(1),Hd(2),cascade(Hd(1),Hd(2)),'Fs',[Fs Fs/D Fs],'ShowReference', 'off');
legend(hvt, 'CIC','CIC compensator', 'Whole response','Location', 'Northeast'); 
