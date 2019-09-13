function h = filterForAllAntennas(mapPosition,axy,nAntennas,spaceSize,Fc,signalLength,oversamplingFactor,varargin)

p = inputParser;
addOptional(p,'Reflections',0);
addOptional(p,'Obstacles',[]);
parse(p,varargin{:});

reflectionsFlag = p.Results.Reflections;
obstacles = p.Results.Obstacles;

h = zeros(nAntennas,signalLength);

for k = 1:1:nAntennas
    if reflectionsFlag
        h(k,:) = hWithReflection(mapPosition,axy(k,:),spaceSize,Fc,signalLength,oversamplingFactor,obstacles);
    else
        h(k,:) = hXY(mapPosition,axy(k,:),Fc,signalLength,oversamplingFactor);
    end
end

end