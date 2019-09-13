function h = filterForAllAntennasWithReflections(mapPosition,axy,nAntennas,spaceSize,Fc,signalLength,oversamplingFactor,varargin)

h = zeros(nAntennas,signalLength);

for k = 1:1:nAntennas
    h(k,:) = hWithReflection(mapPosition,axy(k,:),spaceSize,Fc,signalLength,oversamplingFactor,obstacles);
end

end