function [A,phi] = pulseShaping(nUsers,Symbols,nSymbols, t, alfa, T)

Lt = length(t);                                                             % Numero de muestras
hr = zeros(1,Lt);                                                           % Parte real
hi = zeros(1,Lt);                                                           % Parte imaginaria
A = zeros(nUsers,Lt);                                                  
phi = zeros(nUsers,Lt);                                                

for j=1:1:nUsers
    for i = 1:nSymbols
        if ~isnan(Symbols(j,i))
            hrm = (real(Symbols(j,i)).*(sin(pi*(t-i*T)/T)./(pi*(t-i*T)/T)).*(cos(alfa*pi*(t-i*T)/T)./(1-(2*alfa*(t-i*T)/T).^2))); %Pulso Riased-cosine
            hr = hr + hrm;

            him = (imag(Symbols(j,i)).*(sin(pi*(t-i*T)/T)./(pi*(t-i*T)/T)).*(cos(alfa*pi*(t-i*T)/T)./(1-(2*alfa*(t-i*T)/T).^2))); %Pulso Riased-cosine
            hi = hi + him; 
        end
    end

    A(j,:) = sqrt(hi.^2+hr.^2);
    phi(j,:) = angle(hr + 1i*hi);
    hr = zeros(1,Lt);                                                         
    hi = zeros(1,Lt);  
end

end