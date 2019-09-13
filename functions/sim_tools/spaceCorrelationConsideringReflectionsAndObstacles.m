function [orderedCorrelations,correlationsStruct] = spaceCorrelationConsideringReflectionsAndObstacles(nAntennas,FcSim,FsSim,userSignal,signalLength,b,axy,spaceSize,deltaSpace,Fc,oversamplingFactor,obstacles)

meshSize = spaceSize/deltaSpace+1;

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
%         try
            mapPosition = [deltaSpace*(i-1) deltaSpace*(j-1)];
            mapPositions{i,j} = mapPosition;

            %any antenna position
            if isInside(axy,mapPosition)
                correlations(i,j) = 0;
            else
                h = zeros(nAntennas,signalLength);
                for k = 1:1:nAntennas
                    h(k,:) = hWithReflection(mapPosition,axy(k,:),spaceSize,Fc,signalLength,oversamplingFactor,obstacles);
                end
   
                stimatedSignal = receivedSignal(b,h,nAntennas,signalLength);
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
    end
end
close(h1)

i_max = spaceSize/deltaSpace+1;
j_max = spaceSize/deltaSpace+1;


for norm = 1:1:size(axy,1)
    try
    i_d = axy(norm,1)/deltaSpace+1;
    j_d = axy(norm,2)/deltaSpace+1;
    
    neighbors = 0;
    nNeighbors = 0;
    
    if j_d > 1
        neighbors = neighbors + correlations(i_d,j_d-1);
        nNeighbors = nNeighbors + 1;
        if i_d > 1
            neighbors = neighbors + correlations(i_d-1,j_d-1);
            nNeighbors = nNeighbors + 1;
        end
        if i_d < i_max
            neighbors = neighbors + correlations(i_d+1,j_d-1);
            nNeighbors = nNeighbors + 1;
        end
    end
    if j_d < j_max
        neighbors = neighbors + correlations(i_d,j_d+1);
        nNeighbors = nNeighbors + 1;
        if i_d > 1
        	neighbors = neighbors + correlations(i_d-1,j_d+1);
            nNeighbors = nNeighbors + 1;
        end
        if i_d < i_max
            neighbors = neighbors + correlations(i_d+1,j_d+1);
            nNeighbors = nNeighbors + 1;
        end
    end
    if i_d > 1
        neighbors = neighbors + correlations(i_d-1,j_d);
        nNeighbors = nNeighbors + 1;
    end
    if i_d < i_max
        neighbors = neighbors + correlations(i_d+1,j_d);
        nNeighbors = nNeighbors + 1;
    end
    
    correlations(i_d,j_d) = neighbors/nNeighbors;
    
    catch e
       fprintf("i_d = %d, j_d = %d, norm = %d",i_d,j_d,norm);
       fprintf(1,'The identifier was:\n%s',e.identifier);
       fprintf(1,'There was an error! The message was:\n%s',e.message);
    end
end

correlations = correlations';
correlationsStruct.mapPositions = mapPositions';
correlationsStruct.maxCorrelation = maxCorrelation';
correlationsStruct.centerCorrelation = centerCorrelation';

orderedCorrelations = correlations;

end