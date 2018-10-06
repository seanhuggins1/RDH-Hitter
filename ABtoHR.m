function [ratio] = ABtoHR(atBats, fenceHeight, plot)
    figure(1);
    %Mean initial ball speed and standard deviation speed
    speedMean = 44.704;
    speedStdv = 6.7056;
    %Mean launch angle and standard deviation launch speed
    angleMean = 45;
    angleStdv = 10;
    
    %Set a counter for the home runs
    homeRuns = 0;
    
    
    %Throw a ball for the robat atBats times
    for i = 1:atBats
        %Grab a ball speed from the gaussian distribution
        ballSpeed = speedMean + speedStdv*rand;
        %Grab a launch angle from the gaussian distribution
        launchAngle = angleMean + angleStdv*rand;
        %If the final range of the ball is past the pitch, we have a home
        %run!
        if baseball(ballSpeed, launchAngle, 0.1, 'euler', fenceHeight) >= 121.92
            homeRuns = homeRuns + 1;
        end
    end
    
    %If there are no home runs, report such, otherwise display the
    %atBats/homeRuns ratio
    if homeRuns == 0
        ratio = 'No home runs';
    else
        
        ratio = atBats/homeRuns;
        
        %disp(sprintf('The atBats/homeRuns ratio for the RDH is %f', ratio));
        
    end
    
    if plot == true
        %Build a fence!
        plot([121.92 121.92], [0 fenceHeight], 'Color', [165 42 42]./256, 'LineWidth', 2);
    
        %Plant some grass!
        plot([0 250],[0 0], 'g-', 'LineWidth', 2);
    
        axis([0 140 0 60]);
    
        %Make the sky!
        set(gca,'Color',[240 248 255]./256);
    
    
        grid on
        %set the units aspect ratio
        daspect([1 1 1])
    
        %Label the axes
        xlabel('Range (m)');
        ylabel('Height (m)');
    
        %Set the title
        title(strcat(num2str(atBats),' baseball hits by the Robotic Designated Hitter (RDH)'));
    end
end