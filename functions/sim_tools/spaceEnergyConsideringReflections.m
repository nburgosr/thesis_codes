function [orderedEnergy] = spaceEnergyConsideringReflections(nAntennas,signalLength,b,axy,spaceSize,deltaSpace,Fc,oversamplingFactor)

meshSize = spaceSize/deltaSpace+1;

h1 = waitbar(0,'HeatMap: Calculando energía...');
energy = zeros(meshSize);
nWidth = size(energy,2);
nLength = size(energy,1);

parfor i = 1:nLength
   for j = 1:nWidth
        try
            mapPosition = [deltaSpace*(i-1) deltaSpace*(j-1)];
            mapPositions{i,j} = mapPosition;

            %any antenna position
            if isInside(axy,mapPosition)
                energy(i,j) = 0;
            else
                h = zeros(nAntennas,signalLength);
                for k = 1:1:nAntennas
                    h(k,:) = hWithReflection(mapPosition,axy(k,:),spaceSize,Fc,signalLength,oversamplingFactor,[]);
                end
   
                stimatedSignal = receivedSignal(b,h,nAntennas,signalLength);
                stimatedSignal(1:round(length(stimatedSignal)/2)) = 0;
                
                energy(i,j) = sum(stimatedSignal.^2);
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

i_max = spaceSize/deltaSpace+1;
j_max = spaceSize/deltaSpace+1;


for norm = 1:1:size(axy,1)
    try
    i_d = axy(norm,1)/deltaSpace+1;
    j_d = axy(norm,2)/deltaSpace+1;
    
    neighbors = 0;
    nNeighbors = 0;
    
    if j_d > 1
        neighbors = neighbors + energy(i_d,j_d-1);
        nNeighbors = nNeighbors + 1;
        if i_d > 1
            neighbors = neighbors + energy(i_d-1,j_d-1);
            nNeighbors = nNeighbors + 1;
        end
        if i_d < i_max
            neighbors = neighbors + energy(i_d+1,j_d-1);
            nNeighbors = nNeighbors + 1;
        end
    end
    if j_d < j_max
        neighbors = neighbors + energy(i_d,j_d+1);
        nNeighbors = nNeighbors + 1;
        if i_d > 1
        	neighbors = neighbors + energy(i_d-1,j_d+1);
            nNeighbors = nNeighbors + 1;
        end
        if i_d < i_max
            neighbors = neighbors + energy(i_d+1,j_d+1);
            nNeighbors = nNeighbors + 1;
        end
    end
    if i_d > 1
        neighbors = neighbors + energy(i_d-1,j_d);
        nNeighbors = nNeighbors + 1;
    end
    if i_d < i_max
        neighbors = neighbors + energy(i_d+1,j_d);
        nNeighbors = nNeighbors + 1;
    end
    
    energy(i_d,j_d) = neighbors/nNeighbors;
    
    catch e
       fprintf("i_d = %d, j_d = %d, norm = %d",i_d,j_d,norm);
       fprintf(1,'The identifier was:\n%s',e.identifier);
       fprintf(1,'There was an error! The message was:\n%s',e.message);
    end
end

energy = energy';

orderedEnergy = energy;

end