function [xRange] = baseball(ballSpeed, launchAngle, tau, method, fenceHeight, varargin)
    
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
        xRange = 0;
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


homer = false;

i = 1;
tauCorrections = 0;
%While the ball is in the air
while ((r(i, 2) > 0) && (tauCorrections < 2))   
    
    %Calculate drag force in the x and y directions
    Fd = -0.5*air*Cd*rho*A*sqrt(v(1)^2 + v(2)^2).*v;
    
    %Calculate acceleration of the ball in the x and y directions
    a(1) = (1/m)*Fd(1);
    a(2) = (1/m)*Fd(2) - g;
 
    %Calculate the new velocity and position of the ball
    vnew = v + tau.*a;
    
    %EULER method
    if method == 1;
        rnew = r(i,:) + tau.*v;
    %EULER-CROMER method
    elseif method == 2;
        rnew = r(i,:) + tau.*vnew;
    %MIDPOINT method
    elseif method == 3;
        rnew = r(i,:) + tau.*((vnew + v)./2);
    end
            
    
    %If the ball is past and above the fence, we know it's a home run,
    %continue its trajectory past the fence
    if ((rnew(1) >= pitchLength) && (rnew(2) > fenceHeight))
        homer = true;
        %Increment the row index
        i = i + 1;
        %Set the current position and velocity to be the new v, r
        v = vnew;
        r(i,:) = rnew; 
        %Calculate the elapsed time based on the loop index
        t = t + tau;
        
        %Reset tau
        tau = tau*(10^tauCorrections);
        tauCorrections = 0; 
    %If the ball is below ground, or past and below the height of the
    %fence, reset the ball to its previous position and increment its
    %trajectory with a smaller tau.
    elseif ((rnew(2) <= 0) | (~homer && (rnew(1) >= pitchLength) && rnew(2) <= fenceHeight))
        tau = tau/10;
        tauCorrections = tauCorrections + 1;
        
    %If the ball is somewhere within the pitch, just increment normally
    else
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
xRange = r(end,1);

%Plot the baseball trajectory
%If it's a home run, plot a blue line, otherwise plot a red one
if homer
    plot(r(:,1),r(:,2),'b-', 'LineWidth', 1);
    
else
    plot(r(:,1),r(:,2),'r.', 'MarkerSize', 2);
end

%disp(sprintf('The baseball was in the air for %s seconds', num2str(t)));
%disp(sprintf('It had a horizontal range of %.2f meters', xRange));

%121.92m = 400ft






%xlabel('range (m)');
%ylabel('height (m)');


%    switch(upper(method))
%        case 'EULER'
%            ;
%        case 'EULER-CROMER'
%            ;
%        case 'MIDPOINT'
%            ;
%    end
    
    
    
    
    
    
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here
    
end

