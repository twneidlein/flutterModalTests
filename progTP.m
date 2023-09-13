clear all
close all
clc
warning off  

Fe=10240; %frequency measurements are being recorded at
N_trig=100; 
Tacq=5;
V_trig=0.1;
moy=2;
N=8192;
point=input('Enter the measurement point number: ');

for bloc=1:moy
    accept=0;
    while accept==0
        fprintf(['Initialization of point measurement ' num2str(point) ' for the bloc: ' num2str(bloc) '\n'])
        [t,data]=acquTP(Fe,N,N_trig,Tacq,V_trig,point,bloc);
        reponse=input('Accept (y/n):','s');
        if reponse=='y'
            accept=1;
        end
    end
    assignin('base',['force_point' num2str(point) '_bloc_' num2str(bloc)],data(:,1))
    assignin('base',['accel_point' num2str(point) '_bloc_' num2str(bloc)],data(:,2))
end
clear accept data Fe bloc moy N N_trig point reponse Tacq V_trig

    

