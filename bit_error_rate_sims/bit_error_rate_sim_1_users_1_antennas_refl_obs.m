clear all
clc
close all force

imports
%Simulación para 1 usuario y 1 antena, estimación de canal con reflexiones
%pero sin obstáculos en un canal con reflexiones y obstáculos.

%Coordenandas en metros
%Generacion aleatoria de posiciones para Users

%% Parametros
% Parametros reales
scaleFactor = 10^7;                                                         % Factor temporal de escalado de la simulacion
oversamplingFactor = 10;                                                    % Oversampling de la frecuencia portadora
FcReal = 6e10;                                                              % Frecuencia portadora real igual a 60 GHz
TcReal = 1/FcReal;                                                          % Periodo portadora real
FsReal = floor(FcReal*oversamplingFactor);                                  % Frecuencia de muestreo real
TsReal = 1/FsReal;                                                          % Tiempo de muestreo real
TsSymReal = 1e-9;                                                           % Periodo de simbolo de 1 ns

% Parametros escalados                                                            
Fc = FcReal/scaleFactor;                                                    % Frecuencia de la portadora escalada
Tc = 1/Fc;                                                                  % Periodo de la portadora escalado
Fs = FsReal/scaleFactor;                                                    % Frecuencia de muestreo escalada
Ts = 1/Fs;                                                                  % Tiempo de muestreo escalado
Tsym = TsSymReal*scaleFactor;                                               % Periodo de simbolo de 1 ns
Fsym= 1/Tsym;                                                               % Frecuencia de simbolo 1 Gbaud

spaceSize = 3;                                                              % Tamano del espacio de simulacion
iterationsNum = 5;                                                          % Número de repeticiones de cada iteration por valor de SNR

nBitsIteration = 60;                                                        % Número útiles por iteración
nTotalBitsIteration = nBitsIteration*2;                                     % Número de bits por iteración
signalLength = (nTotalBitsIteration)*Fs*Tsym;
totalNBits = 100020;                                                        % Cantidad total de bits de cada iteration por valor de SNR
bitsSeed = 1;                                                               % Semilla para replicar simulacion aleatoria

alfa = 0.22;                                                                % Roll-off
modulation = 'BPSK';                                                        % Tipo de modulation

Eb = 1;                                                                     % Energia por bit (1 normalizada)
snr = 0:1:10;                                                               % Valores de SNR en simulacion en DB
SNR=10.^(snr/10);                                                           % Valores de SNR en simulacion en magnitud
plotMarkers = 'o+xsd^v><ph.*';                                              % Marcadores para graficas

t = 0:Ts:2*nBitsIteration*Tsym-Ts;                                           % Vector de tiempo de duracion 10 ciclos de la portadora muestreado a Ts 
t = t+1e-10;                                                                 % Condicion para evitar indefinicion en el sampling cuando el denominador sea 0
time = Tsym.*linspace(nBitsIteration+1,2*nBitsIteration,nBitsIteration);     % Vector de tiempo con tiempos de muestreo por símbolo
hn = waitbar(0,sprintf('Calculando BER: iteration %d de %d, SNR = %d.',0,iterationsNum,snr(1)));

%% Posicion aleatoria de las Antennas y los Users
axy = [round(100*spaceSize*(2+sqrt(2))/4)/100 1.5];
pxy = [spaceSize-round(100*spaceSize*(2+sqrt(2))/4)/100 1.5];
postionsPlot(figure(1),pxy,axy,spaceSize)  

[nUsers,~] = size(pxy);                                                                 
[nAntennas,~] = size(axy);   

BERUsers = zeros(nUsers,length(snr));
eUsers = 0;

% Extremos del obstaculo
xHeight = 0.25;
yHeight = 0.7;
xCenter = -0.75;
yCenter = 0.75;
angle = -pi/4;
permittivity = 2.26;
obstacles = [xCenter,yCenter,yHeight,xHeight,angle,permittivity];

destiny = 'correo@gmail.com';
messageTitle = sprintf('BER%dX%d refl obs',nUsers,nAntennas);
title = sprintf("ber_sim_%dX%d_refl_obs",nUsers,nAntennas);

[hrhat,Hrhat] = filterMatrixWithReflections(nUsers,nAntennas,pxy,axy,spaceSize,signalLength,FcReal,oversamplingFactor);
[hrohat,Hrohat] = filterMatrixWithReflectionsAndObstacles(nUsers,nAntennas,pxy,axy,spaceSize,signalLength,FcReal,oversamplingFactor,obstacles);

try
    for k = 1:1:length(snr)    
        avgError=zeros(nUsers,1);    
        for iteration = 1:1:iterationsNum
            allBits = baseBandBERWithSeed(nUsers,totalNBits+nBitsIteration,bitsSeed);                % Generacion de una secuencia aleatoria para cada usuarioallBits = baseBandBER(nUsers,totalNBits+nBitsIteration, bitsSeed,0);                % Generacion de una secuencia aleatoria para cada usuarioallBits = baseBandBER(nUsers,totalNBits+nBitsIteration, bitsSeed,0);                % Generacion de una secuencia aleatoria para cada usuarioallBits = baseBandBER(nUsers,totalNBits+nBitsIteration, bitsSeed,0);                % Generacion de una secuencia aleatoria para cada usuarioallBits = baseBandBER(nUsers,totalNBits+nBitsIteration, bitsSeed,0);                % Generacion de una secuencia aleatoria para cada usuarioallBits = baseBandBER(nUsers,totalNBits+nBitsIteration, bitsSeed,0);                % Generacion de una secuencia aleatoria para cada usuario
            tic
            counter = 0;
            waitbar(((k-1)*iterationsNum+iteration)/(length(snr)*iterationsNum),...
                hn,sprintf('Calculando BER: iteration %d de %d, SNR = %d.',iteration,iterationsNum,snr(k)))

            parfor j = 1:1:totalNBits/nBitsIteration

                %% Senales banda base de cada usuario
                newBits = allBits(:,j*nBitsIteration+1:nBitsIteration*(j+1));
                previousBits = allBits(:,(j-1)*nBitsIteration+1:nBitsIteration*(j));
                pBaseBand = [previousBits newBits];                    % Conservacion de los bits útiles anteriores                     
                [pDigitalModulation, nSymbols] = digitalModulation(pBaseBand,modulation); % modulation digital

                 %% Oversampling y Pulse shaping
                [pDigitalModulationPulseShaping,phi] = pulseShaping(nUsers,pDigitalModulation, nSymbols, t, alfa, Tsym); % Senal con pulse shaping

                %% Pasa-banda
                [ppassBand,simulationTime] = passBand(pDigitalModulationPulseShaping, nUsers, signalLength, phi, Fc, Ts); % Senal con filtro passBand

                %% DIDO
                b = DIDO(nUsers,nAntennas,ppassBand,signalLength,Hrhat); 

                %% Calculo de senales estimadas o recibidas
                signalEstimations = signalEstimationWithNoise(b,hrohat,nAntennas,nUsers,snr(k));

                %% Receptor DIDO

                demodPulseShaped = zeros(size(signalEstimations));
                for m = 1: 1 : size(signalEstimations,1)
                    demodPulseShaped(m,:) = ssbdemod(signalEstimations(m,:),Fc,Fs,0);
                end

                sampler = Tsym./Ts*linspace(1,nBitsIteration,nBitsIteration);
                sampledSignal = demodPulseShaped(:,sampler);

                %% Muestreo y deteccion
                bitDetection = double(sampledSignal > 0);

                %% Conteo de errores
                comp = newBits == bitDetection;
                counter = counter + nBitsIteration;
                eUsers = sum(~comp,2) + eUsers;

            end
            bitsSeed = bitsSeed + 1;

            avgError = avgError + eUsers/counter;
            eUsers = 0;
            toc
        end
        BERUsers(:,k) =  avgError/iterationsNum;
    end
    close(hn)

    %% Calculo de BER teorico
    BERTh=(1/2)*erfc(sqrt(SNR));                                                % Calculo del BER teorico

    nameUsers = cell(1,nUsers+1);
    nameUsers(1) = {'Theoretical'};
    markerUsers = cell(nUsers,1);
    for user = 1:1:nUsers
        nameUsers(user+1) = {sprintf('Simulation - User %d',user)};
        markerUsers(user) = {plotMarkers(user)};
    end
    nameUsers = cellstr(nameUsers);
    markerUsers = cellstr(markerUsers);

    %% Grafica de bit error rate
    semilogy(snr,BERTh);              
    hold on
    for user = 1:1:nUsers
        semilogy(snr,BERUsers(user,:),char(markerUsers(user)));
    end
    legend(nameUsers,'FontSize',12);
    axis([min(snr) max(snr) 10^(-5) 1]);
    ax = gca; % current axes
    ax.FontSize = 11;
    hold off

    save(title);
    sendNotification(messageTitle,'Success',destiny);

catch 
    sendNotification(messageTitle,'Error',destiny);
end

sendNotification(messageTitle,'Finish',destiny);
