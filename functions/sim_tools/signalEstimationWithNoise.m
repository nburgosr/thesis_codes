function [signalsEstimation] = signalEstimationWithNoise(b,h,nAntennas,nUsers,snr)
%C�lculo de las se�ales recibidas por medio de la convoluci�n entre las
%se�ales emitidas y los filtros de propagaci�n.

bSize = size(b); 
sectionSize =  round(bSize(2)/2);
signalsEstimation = zeros(nUsers,sectionSize);

k = 0; 
for i = 1:1:nUsers
    
    signalsEstimationAux = zeros(1,bSize(2));
    
    for j = 1:1:nAntennas
        
        k = (i-1)*nAntennas;
        
        Conv = conv(b(j,:),h(k+j,:));
        Conv = Conv(1:bSize(2));
        
        signalsEstimationAux = signalsEstimationAux + Conv;
        
        k = k + 1;
        
    end
    
    signalsEstimationAux = signalsEstimationAux(sectionSize+1:end);
    signalsEstimationAux = awgn(signalsEstimationAux,snr,'measured');
    signalsEstimation(i,:) = signalsEstimationAux;
end

end