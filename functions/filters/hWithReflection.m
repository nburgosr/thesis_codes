function   filter = hWithReflection(p1,p2,spaceSize,Fc,n,oversamplingFactor,obstacles)
    relativeP1 = p1 - spaceSize/2;
    relativeP2 = p2 - spaceSize/2;
    tx_set = sweepingTransceiver(relativeP1, 360, 64);
    rx_set = sweepingTransceiver(relativeP2,360,1);
    
    try
    if length(obstacles) == 6 
        [~, tr_ccomps] = ch_trace( tx_set, rx_set, [spaceSize+0.1, spaceSize+0.1, 3.1], 'max_refl',2,'obstacles',obstacles);
    else
        [~, tr_ccomps] = ch_trace( tx_set, rx_set, [spaceSize+0.1, spaceSize+0.1, 3.1], 'max_refl',2);
    end
    timeToArrival = tr_ccomps.toa;
    reflectionGain = tr_ccomps.g_r;
    pathDistance = tr_ccomps.d;
    
    filter = zeros(1,n);
    
    for i = 1:1:length(timeToArrival)
        if ~isnan(pathDistance(i)) && ~isnan(reflectionGain(i))
            lambda = physconst('LightSpeed')/Fc;
            freeSpaceLoss = fspl(pathDistance(i),lambda);
            tau_xy = pathDistance(i)/physconst('LightSpeed');
            n = round(tau_xy*Fc*oversamplingFactor);
            gap = round(tau_xy*Fc*oversamplingFactor);
            filter(gap) = db2mag(-(2*freeSpaceLoss-mag2db(reflectionGain(i))));
        end
    end
    catch
        filter = zeros(1,n);
    end
end