maxAtBats = 1000;
maxFenceHeight = 0;

numRatios = 3;

for fenceHeight = 0:maxFenceHeight
    for atBats = 10:10:maxAtBats
        rsum = 0;
        for i = 1:numRatios
            disp(atBats);
            ratio = ABtoHR(atBats, fenceHeight, 0);
            if ~isnumeric(ratio)
                ratio = 0;
     
            end
            rsum = rsum + ratio;
        end
        ravg = rsum/numRatios;
        r(fenceHeight + 1, atBats/10) = ravg;
    end
end
figure(2);
xlabel('Number of Bats');
ylabel('At Bats to Home Runs ratio AB/HR');

hold on
i = 10:10:maxAtBats;
for j = 1:(maxFenceHeight + 1)
    scatter(i,r(j,:),10,[ (1 - (j/(maxFenceHeight + 1))) 0 0], 'filled' );
    
end
