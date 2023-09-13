

function [t,data_trigg]=acquTP(Fe,N,N_trig,Tacq,V_trig,point,bloc)
mesure_ok=0;
while mesure_ok==0;
    
    Te=1/Fe;

    d = daq.getDevices;
    s = daq.createSession('ni');
    s.Rate=Fe;
    ch=addAnalogInputChannel(s,'Dev1',0:1,'IEPE');  %IEPE for Voltage
    
    s.DurationInSeconds =Tacq;
    fprintf(['Press a key to start measuring at the point ' num2str(point) ' for the block ' num2str(bloc) '\n'])
    pause
    [data,time]=startForeground(s);
    figure(100)
    subplot(2,1,1)  
    plot(time,data(:,1))
    xlabel('seconds')
    ylabel('volts')
    title('lane 1')
    grid
    subplot(2,1,2)
    plot(time,data(:,2))
    xlabel('seconds')
    ylabel('volts')
    title('lane 2')
    grid

    k=find(sign(data(:,1)-V_trig)+1,1);
    k=k-N_trig;
  
    if (k+N-1)<length(time)&not(isempty(k))&(k>0)
        mesure_ok=1;
    else
        clc
        fprintf('ATTENTION: the measurement must be repeated! \n')
        fprintf('Triggering does not allow complete acquisition of a block \n')  
        fprintf('Press any key to start again \n')
        pause
    end
end
    
    
data_trigg=data(k:k+N-1,:);
t=(0:Te:(N-1)*Te)';
freq=0:Fe/N:Fe-Fe/N;
FFT_1=fft(data_trigg(:,1))*2/N;
FFT_2=fft(data_trigg(:,2))*2/N;




figure(101)
subplot(2,3,1)
plot(t,data_trigg(:,1))
xlabel('seconds')
ylabel('volts')
title('lane 1 with trigger')
grid
subplot(2,3,2)
plot(freq(1:N/2),abs(FFT_1(1:N/2)))
xlabel('Hz')
ylabel('module')
title('fft lane 1')
grid
subplot(2,3,4)
plot(t,data_trigg(:,2))
xlabel('seconds')
ylabel('volts')
title('lane 2 with trigger')
grid
subplot(2,3,5)
plot(freq(1:N/2),abs(FFT_2(1:N/2)))
xlabel('Hz')
ylabel('module')
title('fft lane 2')
grid
subplot(2,3,3)
plot(freq(1:N/2),20*log10(abs(FFT_1(1:N/2))))
xlabel('Hz')
ylabel('module in dB ref 1V')
title('fft lane 1')
grid
subplot(2,3,6)
plot(freq(1:N/2),20*log10(abs(FFT_2(1:N/2))))
xlabel('Hz')
ylabel('module in dB ref 1V')
title('fft lane 2')
grid




