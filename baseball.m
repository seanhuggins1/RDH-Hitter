function [range, height] = baseball(ballSpeed, launchAngle, tau, method, varargin)
    
%Air resistance switch off
air = 1;
if nargin > 5
    air = 0;
end


%%Important constants
%Baseball mass m (kg)
m = 0.145;
    
%Baseball diameter d (m)
d = 0.074;

%Calculate baseball cross-sectional area knowing diameter
A = pi*((d/2)^2);

%Gravitational acceleration g (m/s^2)
g = 9.81;

%Density of air rho (kg/m^3)
rho = 1.2;

%Baseball drag coefficient Cd (Dimensionless)
Cd = 0.35;

%Length of the baseball diamond before hitting the fence (m)
pitchLength = 121.92;



switch (upper(method))
    case 'EULER'
        method = 1;
        methodColor = 'r';
    case 'EULER-CROMER'
        method = 2;
        methodColor = 'g';
    case 'MIDPOINT'
        method = 3;
        methodColor = 'b';
    otherwise 
        error('No such method of trajectory calculation');
        range = 0;
end
        

hold on

%%Calculate the baseball trajectory
%Set the initial baseball height
initialHeight = 1;

%Initialize ball position vector
r = [ 0 initialHeight ];

%Set the initial components of velocity 
ballSpeedx = ballSpeed*cos(deg2rad(launchAngle));
ballSpeedy = ballSpeed*sin(deg2rad(launchAngle));

%Initialize ball velocity vector
v = [ballSpeedx, ballSpeedy];

%Set initial time
t = 0;

%Set the initial position index
i = 1;
%While the ball is in the air
while (r(i, 2) > 0)  
    
    %Calculate drag force in the x and y directions
    Fd = -0.5*air*Cd*rho*A*sqrt(v(1)^2 + v(2)^2).*v;
    
    %Calculate acceleration of the ball in the x and y directions
    a(1) = (1/m)*Fd(1);
    a(2) = (1/m)*Fd(2) - g;
 
    %Calculate the new velocity and position of the ball
    vnew = v + tau.*a;
    
    %EULER method
    if method == 1
        rnew = r(i,:) + tau.*v;
    %EULER-CROMER method
    elseif method == 2
        rnew = r(i,:) + tau.*vnew;
    %MIDPOINT method
    elseif method == 3
        rnew = r(i,:) + tau.*((vnew + v)./2);
    end
            
    %Increment the row index
    i = i + 1;
    %Set the current position and velocity to be the new v, r
    v = vnew;
    r(i,:) = rnew;
    %Calculate the elapsed time based on the loop index
    t = t + tau;
    
    end
end
%Grab the range as the final x position of the baseball
range = r(end,1);
height = interpl(r(:,1), r(:,2), pitchLength, 'pchip';

%Plot the baseball trajectory
plot(r(:,1),r(:,2),'r.', 'MarkerSize', 2);
plot(range, height, 'bo');

end

