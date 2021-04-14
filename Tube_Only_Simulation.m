clear
clc
close

%Model for computing the drainage of a tank with attached pipe

%Constants
gravity = 9.81;             %m/s^2
rho = 998;                  %kg/m^3
diameter = 0.00794;         %m
viscosity = 1.0016e-3;
roughness = 0.0025/1000;
% relaRough = roughness/(diameter*1000);

%Geometry and Simulation Parameters
length = 0.6;               %m
area = (diameter/2)^2*pi;   %m^2
height = 0.10;              %m
volumeTotal = 0.32*0.26*0.1;
tubeHeightDrop = 1/150*length;
minorLossFactor = 0.5;

%Computation Initializations
time = 1;
notEmpty = true;
heightArray = [];
reArray = [];
frictionArray = [];


syms velocity;

b = roughness/14.8*(diameter/2);

frictionFactorGuess = 0.024;
frictionFactorComp = 0;
while(notEmpty == true)
    factorGuessDeviation = 10;
    iterations = 0;
    while((factorGuessDeviation > 0.002) & (iterations < 50))
        velocity = sqrt((150*gravity*height+gravity*length)/(75*(1+length*frictionFactorGuess/diameter+minorLossFactor)));
        Re = velocity*rho*diameter/viscosity;
        a = 2.51/Re;
        frictionFactorComp = 1/(2*lambertw( log(10)/(2*a)*10^(b/(2*a)))/log(10) - (b/a))^2;
        factorGuessDeviation = abs(frictionFactorComp - frictionFactorGuess);
        frictionFactorGuess = frictionFactorComp;
        iterations = iterations+1;

        fprintf("Re: %f, It: %i\n", Re, iterations);
    end
    
    volumetricRate = velocity*area;    
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
figure(1);
subplot(2,1,1)
plot(timeArray, heightArray);
title('Tank Height over Time');
ylabel('Height [m]');
xlabel("Time (s)");
% axis([0 205 0 0.1])
legend("20cm Tube Length");
subplot(2,1,2)
plot(timeArray, reArray);
title('Reynolds Number over Time');
ylabel('Re');
xlabel("Time (s)");
% axis([0 205 3000 7500])
legend("20cm Tube Length");

% subplot(3,1,3)
% plot(timeArray, frictionArray);
% title('Friction Factor');
% ylabel('Friction Factor []');
% xlabel("Time (s)");