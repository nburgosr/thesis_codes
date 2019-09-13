function [b] = DIDO(nUsers,nAntennas,usersSignals,signalLength,H)

S = zeros(size(usersSignals));
b = zeros(nAntennas,signalLength);
B = zeros(nAntennas,signalLength);
S = fft(usersSignals, [], 2); 

for i=1:1:signalLength
    H_i = zeros(nUsers,nAntennas);
    for j=1:1:nUsers
        H_row = H((nAntennas*(j-1)+1:nAntennas*j),i).';
        H_i(j,:) = H_row; 
    end
    H_i_inv = pinv(H_i);
    B(:,i) = H_i_inv*S(:,i);
end

for i=1:1:nAntennas
    b(i,:) = ifft(B(i,:));
end
end