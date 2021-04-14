clear
clc
close

%Model for computing the drainage of a tank with attached pipe and t-joint

%Constants & Fluid Properties
g = 9.81;             %m/s^2
rho = 998;                  %kg/m^3
viscosity = 1.0016e-3;
minorLossFactor = 0.5+0.962;

%Geometry
d_1 = 0.00794;              %m
d_2 = 0.01125;              %m
L_1 = 0.42;                 %m %Key Adjustable Parameter
L_2 = 0.02;                 %m

area_1 = (d_1/2)^2*pi;      %m^2
area_2 = (d_2/2)^2*pi;      %m^2
height = 0.10;              %m
volumeTotal = 0.32*0.26*0.1;
tubeHeightDrop = 1/150*(L_1-0.02);
roughness = 0.0025/1000;
% relaRough = roughness/(diameter*1000);

%Computation Initializations
time = 1;
notEmpty = true;
heightArray = [];
reArray = [];
frictionArray = [];


syms velocity;

b = roughness/14.8*(d_1/2);

frictionFactorGuess = 0.024;
frictionFactorComp = 0;
volumetricRate = 0;
while(notEmpty == true)
    factorGuessDeviation = 10;
    iterations = 0;
    while((factorGuessDeviation > 0.002) & (iterations < 50))
        
        velocity = sqrt((g*(300*height+L_1))/(150*(0.062 + L_1*frictionFactorGuess/d_1 + L_2*frictionFactorGuess/16.12/d_2 + minorLossFactor)));
        Re = velocity*rho*d_1/viscosity;
        a = 2.51/Re;
        frictionFactorComp = 1/(2*lambertw( log(10)/(2*a)*10^(b/(2*a)))/log(10) - (b/a))^2;
        factorGuessDeviation = abs(frictionFactorComp - frictionFactorGuess);
        frictionFactorGuess = frictionFactorComp;
        volumetricRate = velocity*area_1;    
        
        iterations = iterations+1;
        
        fprintf("Re: %f, It: %i\n", Re, iterations);
    end
    
    %Decrement Height
    height = height - volumetricRate/(0.32*0.26);
    heightArray = [heightArray, height];
    reArray = [reArray, Re];
    frictionArray = [frictionArray, frictionFactorGuess];
    time = time+1;
    
    %Debugger Output 2
%     if (mod(time,15) == 0)
%         fprintf("Elapsed Time: %i\n", time)
%     end
    
    %Check Drainage to End Computation
    if(height <= 0.02)
        notEmpty = false;
    end
end

fprintf("Total Time to Drain: %i", time)

timeArray = linspace(1, time-1, time-1);

figure(1)
subplot(2,1,1)
plot(timeArray, heightArray);
title('Tank Height');
ylabel('Height [m]');
xlabel("Time (s)");
subplot(2,1,2)
plot(timeArray, reArray);
title('Reynolds Number');
ylabel('Re []');
xlabel("Time (s)");
% subplot(3,1,3)
% plot(timeArray, frictionArray);
% title('Friction Factor');
% ylabel('Friction Factor []');
% xlabel("Time (s)");