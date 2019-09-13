function [passBandSignals, t] = passBand(pulseShaped,nUsers,signalLength, phi, Fc, Ts)

finalTime = signalLength*Ts; %Tiempo final en segundos
t = 0:Ts:finalTime-Ts; %Vector de tiempo de simulacion
passBandSignals = zeros(nUsers,signalLength); %Vector que contendra las senales passBand

for i=1:1:nUsers
    passBandSignals(i,:) = pulseShaped(i,:).*cos(2*pi*Fc*t + phi(i,:));
end
end