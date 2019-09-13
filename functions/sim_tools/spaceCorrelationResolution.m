function [orderedCorrelations,correlationsStruct] = spaceCorrelationResolution(FcSim,FsSim,userSignal,signalLength,b,axy,spaceSize,spaceSim,originSim,deltaSpace,Fc,channelType,oversamplingFactor,noise,No,obstacles)

nAntennas = size(axy,1);

meshSize = round(spaceSim/deltaSpace+1);

h1 = waitbar(0,'HeatMap: Calculando interferencias...');
correlations = zeros(meshSize);
nWidth = size(correlations,2);
nLength = size(correlations,1);

correlationsStruct = struct();
mapPositions = cell(nLength,nWidth);
maxCorrelation = cell(nLength,nWidth);
centerCorrelation = cell(nLength,nWidth);

parfor i = 1:nLength
   for j = 1:nWidth
        try
            mapPosition = originSim - spaceSim/2 + [deltaSpace*(i-1) deltaSpace*(j-1)];
            mapPositions{i,j} = mapPosition;

            %any antenna position
            if isInside(axy,mapPosition)
                correlations(i,j) = 0;
            else
                h = filterForAllAntennas(channelType,mapPosition,axy,spaceSize,Fc,signalLength,oversamplingFactor,obstacles);
                
                stimatedSignal = receivedSignal(nAntennas,No,b,h,noise);
                stimatedSignal(1:round(length(stimatedSignal)/2)) = 0;
                
                demodPulseShaped = ssbdemod(stimatedSignal,FcSim,FsSim,0);
              
                E1 = sum(abs(userSignal).^2);
                E2 = sum(abs(demodPulseShaped).^2);

                r = xcorr(userSignal, demodPulseShaped*sqrt(E1/E2));
       
                centerValue = r(floor(length(r)/2)+1);
                maxValue = max(r);
                
                maxCorrelation{i,j} = maxValue;
                centerCorrelation{i,j} = centerValue;
                
                correlations(i,j) = centerValue;
            end
        catch e
            disp('Fails with')
            fprintf('position %d,%d\n',mapPosition(1),mapPosition(2))
            fprintf(1,'The identifier was:\n%s',e.identifier);
            fprintf(1,'There was an error! The message was:\n%s',e.message);
        end
    end
end
close(h1)

correlations = correlations';
correlationsStruct.mapPositions = mapPositions';
correlationsStruct.maxCorrelation = maxCorrelation';
correlationsStruct.centerCorrelation = centerCorrelation';


orderedCorrelations = correlations;


end