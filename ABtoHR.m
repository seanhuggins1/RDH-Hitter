% function [ratio] = ABtoHR(atBats, fenceHeight)
%
% Function which calculates the AB/HR ratio for the robotic designated
% hitter
%
% Required Input:
% ===============
%
% atBats (:) number of times the RDH is up to bat.
% fenceHeight (:) height of the fence at the 400ft mark on the pitch.
%
% Output:
% =======
%
% ratio	(:) AB/HR ratio, returns 0 if there were no home runs.
%
% Requires: no external m-files
% =========
%
% Example Use: ratio=ABtoHR(1000,10);
% ============
%
% Author:
% =======
%
% SHuggins 7 Oct. 2018
%
function [ratio] = ABtoHR(atBats, fenceHeight)

    %Set the mean initial ball speed and standard deviation speed
    speedMean = 44.704;
    speedStdv = 6.7056;
    %Mean launch angle and standard deviation launch speed
    angleMean = 45;
    angleStdv = 10;
    
    %Set a counter for the home runs
    homeRuns = 0;
    
    %Choose a length for the pitch
    pitchLength = 121.92;
    
    %Throw a ball for the robot atBats times
    for i = 1:atBats
        %Grab a ball speed from the gaussian distribution
        ballSpeed = speedMean + speedStdv*randn;

        %Grab a launch angle from the gaussian distribution
        launchAngle = angleMean + angleStdv*randn;
        
        %Grab the ball range and height from the baseball function
        [range, height] = baseball(ballSpeed, launchAngle, 0.1, 'midpoint', 'plot', 0);
        %If the range is beyond the length of the pitch, and the height is
        %greater than the height of the fence, its a home run!
        if (range > pitchLength) && (height > fenceHeight)
            homeRuns = homeRuns + 1;
        end
    end
    
    %If there are no home runs, set the ratio to 0, otherwise return the
    %atBats/homeRuns ratio
    if homeRuns == 0
        ratio = 0;
    else
        ratio = atBats/homeRuns;
    end
   
end