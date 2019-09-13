function bool = isInside(axy,mapPosition)

bool = 0;
antennasArraySize = size(axy);
for i = 1 : 1 : antennasArraySize(1)
    if isequal(axy(i,:), mapPosition)
        bool=1;
    end
end
end