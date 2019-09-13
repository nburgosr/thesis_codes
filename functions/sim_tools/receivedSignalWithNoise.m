function stimatedSignalAux = receivedSignalWithNoise(b,h,nAntennas,signalLength,snr)

stimatedSignalAux = zeros(1,signalLength);


for m = 1:1:nAntennas
    Conv = conv(b(m,:),h(m,:));
    Conv = Conv(1:signalLength);

    Conv = awn(Conv,snr,'measured');

    stimatedSignalAux = stimatedSignalAux + Conv;
end

end