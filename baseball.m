function [range, height] = baseball(ballSpeed, launchAngle, tau, method, varargin)
  
% If called with no arguments, echo a useage line. 
if nargin == 0
   disp(' ')
   disp('y=baseball(ballSpeed, launchAngle, tau, method, [varargin])')
   disp(' ')
   range=[];
   height=[];
   return
end

% Check input typing.
if (~isnumeric(ballSpeed)) | (~isnumeric(launchAngle)) | (~isnumeric(tau))
   disp(' ')
   disp('ERROR(function_skeleton): invalid function input')
   range=[];
   height=[];
   return
end

% Check that all varargin come in pairs.
if mod(length(varargin),2) ~= 0
  disp(' ')
  disp('Error: mis-match (odd number) of vargargin inputs')
  disp(' ')
  range=[];
  height=[];
  return
end

% Set defaults and parse the varargin arguments.
air=1;
doplot=1;
x_int=0;
f_int=0;
for i=1:2:length(varargin)
    switch lower(varargin{i})
    case 'air'
       air=varargin{i+1};
    case 'plot'
       doplot=varargin{i+1};
    case 'x-intercept'
       x_int=varargin{i+1};
    case 'fence-intercept'
       f_int=varargin{i+1};
    otherwise
       disp(' ')
       disp(sprintf('WARNING: unknown varargin <%s> ignored',varargin{i}))
       disp(' ')
    end
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

%Set the initial position row index
i = 1;
switch (upper(method))
    case 'EULER'
        %While the ball is in the air
        while (r(i, 2) > 0)
            %Calculate drag force in the x and y directions
            Fd = -0.5*air*Cd*rho*A*sqrt(v(1)^2 + v(2)^2).*v;
            
            %Calculate acceleration of the ball in the x and y directions
            a(1) = (1/m)*Fd(1);
            a(2) = (1/m)*Fd(2) - g;
            
            %Calculate the new velocity and position of the ball
            vnew = v + tau.*a;
            
            %Calculate the new position using the EULER method
            rnew = r(i,:) + tau.*v;

            %Increment the row index
            i = i + 1;
            %Set the current position and velocity to be the new v, r
            v = vnew;
            r(i,:) = rnew;
            %Calculate the elapsed time based on the loop index
            t = t + tau;    
        end
    case 'EULER-CROMER'
        %Same loop structure as EULER method except with EULER-CROMER
        %position calculation
        while (r(i, 2) > 0)
            Fd = -0.5*air*Cd*rho*A*sqrt(v(1)^2 + v(2)^2).*v;
            a(1) = (1/m)*Fd(1);
            a(2) = (1/m)*Fd(2) - g;
            vnew = v + tau.*a;

            %Calculate the new position using the EULER-CROMER method
            rnew = r(i,:) + tau.*vnew;

            i = i + 1;
            v = vnew;
            r(i,:) = rnew;
            t = t + tau;    
        end
    case 'MIDPOINT'
        %Same loop structure as EULER method except with MIDPOINT
        %position calculation
        while (r(i, 2) > 0) 
            Fd = -0.5*air*Cd*rho*A*sqrt(v(1)^2 + v(2)^2).*v;
            a(1) = (1/m)*Fd(1);
            a(2) = (1/m)*Fd(2) - g;
            vnew = v + tau.*a;
            
            %Calculate the new position using the MIDPOINT method
            rnew = r(i,:) + tau.*((vnew + v)./2);
            
            i = i + 1;
            v = vnew;
            r(i,:) = rnew;
            t = t + tau;    
        end
    otherwise 
        disp(' ')
        error('Error: No such method of trajectory calculation');
        disp(' ')
        range=[];
        height=[];
        return
end


%Grab the range as the final x position of the baseball



range = interp1(r((end-1):end,2), r((end-1):end,1), 0, 'pchip');

%Using pchip interpolation, grab the height of the ball at the fence
%position if the range is greater than the fence position, otherwise give 0
%as the height at the fence position
if range >= pitchLength
    height = interp1(r(:,1), r(:,2), pitchLength, 'pchip');
else
    height = 0;
end


if doplot == true
    hold on
    %Plot the baseball trajectory
    if air == true
        plot(r(:,1),r(:,2),'r.', 'MarkerSize', 5);
    else
        plot(r(:,1),r(:,2),'k-', 'MarkerSize', 5);
    end
    %Plot the height at the fence position
    if f_int == true
        plot(pitchLength, height, 'bo', 'MarkerSize', 5);
    end
    %Plot where the ball hits the ground
    if x_int == true
        plot(range, 0, 'ko');
    end
      
    %Plant some grass!
    %plot([0 300],[0 0], 'g-', 'LineWidth', 2);
    
    %Make the sky!
    set(gca,'Color',[240 248 255]./256);
    
    %Label the axes
    xlabel('Range (m)');
    ylabel('Height (m)');
    title('Motion of a baseball hit by the RDH (Robotic Designated Hitter)');
    
    
    xlim('auto');
    ylim([0 100]);
    grid on

end



end


