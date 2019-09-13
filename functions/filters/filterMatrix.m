function [h,H] = filterMatrix(nUsers,nAntennas,usersPosition,antennasPosition,signalLength,Fc,oversamplingFactor)

h = zeros(nUsers*nAntennas,signalLength);
H = zeros(nUsers*nAntennas,signalLength);

k = 0;

%h array with length nUsers x nAntennas, h11 h12 h13 ... h21 h22 h23 .. hij
%i = user number and j = antenna number
for i=1:1:nUsers
    for j=1:1:nAntennas
        k = k + 1;
        h(k,:) = hXY(usersPosition(i,:),antennasPosition(j,:),Fc,signalLength,oversamplingFactor);
        H(k,:) = fft(h(k,:));
    end
end

end