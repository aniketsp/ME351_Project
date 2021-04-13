gravity = 9.81;             %m/s^2
rho = 998;                  %kg/m^3
diameter = 0.00794;         %m
length = 0.3;               %m
area = (diameter/2)^2*pi;    %m^2
height = 0.10;              %m
volumeTotal = 0.32*0.26*0.1;
tubeHeightDrop = 1/150*length;
time = 1;
notEmpty = true;

syms velocity pressureDrop;
% frictionLoss = length/diameter * (velocity^2)/(2*gravity) * frictionFactor;
% frictionFactor = 1;
% pressureDrop = rho*gravity*(length/diameter * (velocity^2)/(2*gravity) * frictionFactor) + rho*gravity*tubeHeightDrop;
% velocity = sqrt(2*(gravity*height-pressureDrop/rho));
frictionFactor = 0.04;

while(notEmpty == true)
    eqn1 = [pressureDrop == + rho*gravity*(length/diameter * (velocity^2)/(2*gravity) * frictionFactor) + rho*gravity*tubeHeightDrop, velocity == + sqrt(2*(gravity*height-pressureDrop/rho))];
    S = solve(eqn1, pressureDrop, velocity);
    volumetricRate = double(S.velocity)*area;
    
    %Decrement Height
    height = height - volumetricRate/(0.32*0.26);
    time = time+1;
    if(height <= 0.02)
        notEmpty = false;
    end
end
sprintf("Time to Drain: %i", time)