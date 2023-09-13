clear all
clc
close all

load data_beam.mat

accelData = zeros(length(accel_point1_bloc_1),10);

accelData(:,1) = accel_point1_bloc_1;
accelData(:,2) = accel_point1_bloc_2;
accelData(:,3) = accel_point2_bloc_1;
accelData(:,4) = accel_point2_bloc_2;
accelData(:,5) = accel_point3_bloc_1;
accelData(:,6) = accel_point3_bloc_2;
accelData(:,7) = accel_point4_bloc_1;
accelData(:,8) = accel_point4_bloc_2;
accelData(:,9) = accel_point5_bloc_1;
accelData(:,10) = accel_point5_bloc_2;

%acceleration data is converted from volts to g's of acceleration
accelData = accelData ./ 0.1;

forceData(:,1) = force_point1_bloc_1;
forceData(:,2) = force_point1_bloc_2;
forceData(:,3) = force_point2_bloc_1;
forceData(:,4) = force_point2_bloc_2;
forceData(:,5) = force_point3_bloc_1;
forceData(:,6) = force_point3_bloc_2;
forceData(:,7) = force_point4_bloc_1;
forceData(:,8) = force_point4_bloc_2;
forceData(:,9) = force_point5_bloc_1;
forceData(:,10) = force_point5_bloc_2;

%force data is converted from volts to newtons of force
forceData = forceData ./ 0.00214;

figure
plot(t,accelData(:,1:2))
title("Acceleration Data from Node 1")
xlabel("Time (s)")
ylabel("Acceleration (g)")
legend
figure
plot(t,accelData(:,3:4))
title("Acceleration Data from Node 2")
xlabel("Time (s)")
ylabel("Acceleration (g)")
legend
figure
plot(t,accelData(:,5:6))
title("Acceleration Data from Node 3")
xlabel("Time (s)")
ylabel("Acceleration (g)")
legend
figure
plot(t,accelData(:,7:8))
title("Acceleration Data from Node 4")
xlabel("Time (s)")
ylabel("Acceleration (g)")
legend
figure
plot(t,accelData(:,9:10))
title("Acceleration Data from Node 5")
xlabel("Time (s)")
ylabel("Acceleration (g)")
legend

figure
plot(t,forceData(:,1:2))
title("Force Data from Node 1")
xlabel("Time (s)")
ylabel("Force (Newtons)")
legend
figure
plot(t,forceData(:,3:4))
title("Force Data from Node 2")
xlabel("Time (s)")
ylabel("Force (Newtons)")
legend
figure
plot(t,forceData(:,5:6))
title("Force Data from Node 3")
xlabel("Time (s)")
ylabel("Force (Newtons)")
legend
figure
plot(t,forceData(:,7:8))
title("Force Data from Node 4")
xlabel("Time (s)")
ylabel("Force (Newtons)")
legend
figure
plot(t,forceData(:,9:10))
title("Force Data from Node 1")
xlabel("Time (s)")
ylabel("Force (Newtons)")
legend

fs = 10240;
N = size(accelData,1);
noverlap = 0;

[tfHappy, f] = tfestimate(forceData, accelData, boxcar(N), noverlap, N, fs);

ii = 1;
jj = 1;
while(jj < 11)
    H(:,ii) = mean([tfHappy(:,jj) tfHappy(:,jj+1)],2);
    
    figure
    plot(f,abs(H(:,ii)));
    title(["FRF Magnitude " + int2str(ii)])
    xlabel("Frequency (Hz)")
    ylabel("Magnitude")

    figure 
    plot(f,20*log10(abs(H(:,ii))));
    title(["FRF Decibels " + int2str(ii)])
    xlabel("Frequency (Hz)")
    ylabel("Magnitude (db)")

    figure
    imaginary(:,ii) = imag(H(:,ii));
    plot(f,imaginary(:,ii));
    title(["Imaginary Part of FRF " + int2str(ii)])
    xlabel("Frequency (Hz)")
    ylabel("Magnitude")

    v(ii,1) = imaginary(466,ii);
    v(ii,2) = imaginary(1251,ii);
    v(ii,3) = imaginary(2374,ii);
    v(ii,4) = imaginary(3775,ii);


    jj = jj + 2;
    ii = ii +1;
end

vnorm = v/norm(v);
figure
plot(vnorm)
title("Normalized 4 Mode Shape")
xlabel("Nodes")
ylabel("Normalized Magnitude")

mac = abs(vnorm)' * abs(vnorm);
figure
bar3(mac)
title("MAC")

% h2 = tfestimate(accelData,forceData,boxcar(nfft),noverlap,nfft,fs)