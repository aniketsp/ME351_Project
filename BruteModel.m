clear
clc

gravity = 9.81;             %m/s^2
rho = 998;                  %kg/m^3
diameter = 0.00794;         %m
length = 0.4;               %m
area = (diameter/2)^2*pi;   %m^2
height = 0.10;              %m
volumeTotal = 0.32*0.26*0.1;
tubeHeightDrop = 1/150*length;
time = 1;
notEmpty = true;
heightArray = [height];
viscosity = 1.0016e-3;
roughness = 0.0025;

syms velocity pressureDrop;
% frictionLoss = length/diameter * (velocity^2)/(2*gravity) * frictionFactor;
% frictionFactor = 1;
% pressureDrop = rho*gravity*(length/diameter * (velocity^2)/(2*gravity) * frictionFactor) + rho*gravity*tubeHeightDrop;
% velocity = sqrt(2*(gravity*height-pressureDrop/rho));

%frictionFactor = 0.039;
% frictionFactor = 64*viscosity/(rho*velocity*diameter)

eqn1 = [pressureDrop == + rho*gravity*(length/diameter * (velocity^2)/(2*gravity) * 0.45) + rho*gravity*tubeHeightDrop, velocity == + sqrt(2*(gravity*height-pressureDrop/rho))];
S = solve(eqn1, pressureDrop, velocity);
previousV = double(S.velocity)
% 
% reynolds = rho*double(S.velocity)*diameter/1e-3


b = roughness/14.8*(diameter/2);
while(notEmpty == true)
%     Re = velocity*rho*diameter/viscosity;
%     a = 2.51/Re;
%     frictionFactor = 1/(2*lambertw( log(10)/(2*a)*10^(b/(2*a)))/log(10) - (b/a))^2;
    
    reCheck = previousV*rho*diameter/viscosity;
    Re = velocity*rho*diameter/viscosity;
    if (reCheck > 4000)
        frictionFactor = 1/(2*lambertw( log(10)/(2*(2.51/(velocity*rho*diameter/viscosity)))*10^(roughness/14.8*(diameter/2)/(2*(2.51/(velocity*rho*diameter/viscosity)))))/log(10) - (roughness/14.8*(diameter/2)/(2.51/(velocity*rho*diameter/viscosity))))^2;
    else
        frictionFactor = 64/Re;
    end
    
    eqn1 = [pressureDrop == + rho*gravity*(length/diameter * (velocity^2)/(2*gravity) * frictionFactor ) + rho*gravity*tubeHeightDrop, velocity == + sqrt(2*(gravity*height-pressureDrop/rho))];
    S = solve(eqn1, pressureDrop, velocity);
    volumetricRate = double(S.velocity)*area;
    previousV = double(S.velocity)
    %Decrement Height
    height = height - volumetricRate/(0.32*0.26);
    heightArray = [heightArray, height];
    time = time+1;
    if(height <= 0.02)
        notEmpty = false;
    end
end
sprintf("Time to Drain: %i", time)

timeArray = linspace(1, time, time);
plot(timeArray, heightArray);