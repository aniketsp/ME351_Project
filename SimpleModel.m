gravity = 9.81;     %m/s^2
rho = 998;          %kg/m^3
diameter = 0.00794;
length = 0.3;
area = (diameter/2)^2*pi
height = 10;

tubeHeightDrop = 1/150*length;

syms velocity pressureDrop frictionLoss;
% frictionLoss = length/diameter * (velocity^2)/(2*gravity) * frictionFactor;

% frictionFactor = 1;
% pressureDrop = rho*gravity*(length/diameter * (velocity^2)/(2*gravity) * frictionFactor) + rho*gravity*tubeHeightDrop;
% velocity = sqrt(2*(gravity*height-pressureDrop/rho));

frictionFactor = 0.05;
eqn1 = [0 == -pressureDrop + rho*gravity*(length/diameter * (velocity^2)/(2*gravity) * frictionFactor) + rho*gravity*tubeHeightDrop, 0 == - velocity + sqrt(2*(gravity*height-pressureDrop/rho))];
S = solve(eqn1, pressureDrop, velocity)


%MATLAB SOLVE 2 EQ 2 UNKNOWNS