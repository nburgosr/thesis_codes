function stimatedSignalAux = receivedSignal(b,h,nAntennas,signalLength)

stimatedSignalAux = zeros(1,signalLength);

for m = 1:1:nAntennas
    Conv = conv(b(m,:),h(m,:));
    Conv = Conv(1:signalLength);

    stimatedSignalAux = stimatedSignalAux + Conv;
end

end