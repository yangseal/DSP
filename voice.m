clc;
clear all;

%read data
[x,fs,nbit]=wavread('C:\Users\yangshuangpeng\Desktop\keshe\录音.wav');

t=1/fs;
figure(1) 

L=length(x)
L1=L/2;
X=zeros(1,L1);
X=fft(x);
magX=t*abs(X(1:1:L1));
k=(0:1:(L1-1));     
w=2*pi/L*k; 
subplot(2,1,1)
plot(x);
title('原信号时域图');
xlabel('点数 ');
ylabel('语音强度');
subplot(2,1 ,2)
plot(w/pi,magX);
title('原FFT频谱图');
xlabel('数字频率 ');
ylabel('幅度');


%window
N=201;
window_B=blackman(N);
M=N-1;

%low_pass
w_L=0.05*pi; 
h_L=zeros(1,N);
for i=0:N-1
    if i==M/2
     h_L(i+1)=w_L/pi;
    else
     h_L(i+1)=sin((i-M/2)*w_L)/((i-M/2)*pi);
    end   
end  
figure(2);    
title('低通滤波器');
h_L=h_L.*window_B';
freqz(h_L); 
y_L=filter(h_L,1,x);
wavwrite(y_L,fs,'voice_L');

L_y=length(y_L)
L1_y=L_y/2;
Y_L=zeros(1,L1_y);
Y_L=fft(y_L);
mag_L=t*abs(Y_L(1:1:L1_y));
k=(0:1:(L1_y-1));     
w=2*pi/L_y*k; 

%high_pass
w_H=0.05*pi; 
h_H=zeros(1,N);
for i=0:N-1
    if i==M/2
     h_H(i+1)=1-w_H/pi;
    else
     h_H(i+1)=sin((i-M/2)*pi)-sin((i-M/2)*w_H)/((i-M/2)*pi);
    end   
end  
figure(3);    
h_H=h_H.*window_B';
title('高通滤波器频谱图');
freqz(h_H); 
y_H=filter(h_H,1,x);
wavwrite(y_H,fs,'voice_H');


Y_H=zeros(1,L1_y);
Y_H=fft(y_H);
mag_H=t*abs(Y_H(1:1:L1_y));

%band_pass
w_L_BP=0.05*pi;
w_H_BP=0.15*pi; 
h_BP=zeros(1,N);
for i=0:N-1
    if i==M/2
     h_BP(i+1)=w_H_BP/pi-w_L_BP/pi;
    else
     h_BP(i+1)=(sin((i-M/2)*w_H_BP)-sin((i-M/2)*w_L_BP))/((i-M/2)*pi);
    end   
end  
figure(4);     
h_BP=h_BP.*window_B';
title('带通滤波器频谱图');
freqz(h_BP); 
y_BP=filter(h_BP,1,x);
wavwrite(y_BP,fs,'voice_BD');

Y_BP=zeros(1,L1_y);
Y_BP=fft(y_BP);
mag_BP=t*abs(Y_BP(1:1:L1_y));


%滤波后频域图
figure(5); 
subplot(4,1,1)
plot(x);
title('原信号时域图');
xlabel('点数 ');
ylabel('强度');
subplot(4,1,2)
plot(y_L);
title('经低通滤波后时域图');
xlabel('点数 ');
ylabel('强度');
subplot(4,1,3)
plot(y_H);
title('经高通滤波后时域图');
xlabel('点数 ');
ylabel('强度');
subplot(4,1,4)
plot(y_BP);
title('经带通滤波后时域图');
xlabel('点数 ');
ylabel('强度');

figure(6);
subplot(4,1,1)
plot(w/pi,magX);
title('原始信号FFT频谱图');
xlabel('数字频率 ');
ylabel('幅度');
subplot(4,1,2)

plot(w/pi,mag_L);
title('低通滤波后频谱图');
xlabel('数字频率 ');
ylabel('幅度');
axis([0,1,0,0.005])
subplot(4,1,3)
plot(w/pi,mag_H);
title('高通滤波后频谱图');
xlabel('数字频率 ');
ylabel('幅度');
axis([0,1,0,0.005])


subplot(4,1,4)
plot(w/pi,mag_BP);
title('经带通滤波后频谱图');
xlabel('数字频率 ');
ylabel('幅度');
axis([0,1,0,0.005]);

sound(x, fs);

%sound(y_L,fs)

%sound(y_H,fs)

%sound(y_BP,fs)


