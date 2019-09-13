clear all
clc
close all force

imports

%Coordenandas en metros
%Generacion aleatoria de posiciones para Users

%% Parametros
% Parametros reales
scaleFactor = 10^7;                                                         % Factor temporal de escalado de la simulacion
oversamplingFactor = 10;                                                    % Oversampling de la frecuencia portadora
FcReal = 6e10;                                                              % Frecuencia portadora real igual a 60 GHz
TcReal = 1/FcReal;                                                          % Periodo portadora real
FsReal = floor(FcReal*oversamplingFactor);                                 % Frecuencia de muestreo real
TsReal = 1/FsReal;                                                          % Tiempo de muestreo real
TsSymReal = 1e-9;                                                           % Periodo de simbolo de 1 ns

% Parametros escalados                                                            
Fc = FcReal/scaleFactor;                                                    % Frecuencia de la portadora escalada
Tc = 1/Fc;                                                                  % Periodo de la portadora escalado
Fs = FsReal/scaleFactor;                                                    % Frecuencia de muestreo escalada
Ts = 1/Fs;                                                                  % Tiempo de muestreo escalado
Tsym = TsSymReal*scaleFactor;                                               % Periodo de simbolo de 1 ns
Fsym= 1/Tsym;                                                               % Frecuencia de simbolo 1 Gbaud

spaceSize = 3;                                                             % Tamano del espacio de simulacion
iterationsNum = 1;                                                         % Nï¿½mero de repeticiones de cada iteration por valor de SNR

nBitsIteration = 60;
nTotalBitsIteration = nBitsIteration*2;
signalLength = (nTotalBitsIteration)*Fs*Tsym;
totalNBits = 100020;                                                          % Cantidad total de bits de cada iteration por valor de SNR
bitsSeed = 1;                                                               % Semilla para replicar simulacion aleatoria

alfa = 0.22;                                                                % Roll-off
modulation = 'BPSK';                                                        % Tipo de modulation

Eb = 1;                                                                     % Energia por bit (1 normalizada)
snr = -10:1:10;                                                                % Valores de SNR en simulacion en DB
SNR=10.^(snr/10);                                                           % Valores de SNR en simulacion en magnitud
plotMarkers = 'o+xsd^v><ph.*';                                              % Marcadores para graficas

t = 0:Ts:2*nBitsIteration*Tsym-Ts;                                           % Vector de tiempo de duracion 10 ciclos de la portadora muestreado a Ts 
t = t+1e-10;                                                                 % Condicion para evitar indefinicion en el sampling cuando el denominador sea 0
time = Tsym.*linspace(nBitsIteration+1,2*nBitsIteration,nBitsIteration);
hn = waitbar(0,sprintf('Calculando BER: iteration %d de %d, SNR = %d.',0,iterationsNum,snr(1)));

%% Posicion aleatoria de las Antennas y los Users
axy = [0 3; 0 0; 3 3; 3 0];
pxy = [2.25 0.75;1.5 sqrt(2*0.75^2)+1.5;0.75 0.75; 1.5 1.5];

postionsPlot(figure(1),pxy,axy,spaceSize)  

[nUsers,~] = size(pxy);                                                                 % Numero de usuarios
[nAntennas,~] = size(axy);   

BERUsers = zeros(nUsers,length(snr));
eUsers = 0;

destiny = 'nburgosr@gmail.com';
messageTitle = sprintf('SimPCNICO BER%dX%d',nUsers,nAntennas);
title = 'papr_sim_4X4';

[hhat,Hhat] = filterMatrix(nUsers,nAntennas,pxy,axy,signalLength,FcReal,oversamplingFactor);

PAPRUserSignals = zeros(nUsers,totalNBits/nBitsIteration);
PAPRAntennas = zeros(nAntennas,totalNBits/nBitsIteration);

try
    
    allBits = baseBandBERWithSeed(nUsers,totalNBits+nBitsIteration,bitsSeed);                % Generacion de una secuencia aleatoria para cada usuarioallBits = baseBandBER(nUsers,totalNBits+nBitsIteration, bitsSeed,0);                % Generacion de una secuencia aleatoria para cada usuarioallBits = baseBandBER(nUsers,totalNBits+nBitsIteration, bitsSeed,0);                % Generacion de una secuencia aleatoria para cada usuarioallBits = baseBandBER(nUsers,totalNBits+nBitsIteration, bitsSeed,0);                % Generacion de una secuencia aleatoria para cada usuarioallBits = baseBandBER(nUsers,totalNBits+nBitsIteration, bitsSeed,0);                % Generacion de una secuencia aleatoria para cada usuarioallBits = baseBandBER(nUsers,totalNBits+nBitsIteration, bitsSeed,0);                % Generacion de una secuencia aleatoria para cada usuario
    
    parfor j = 1:1:totalNBits/nBitsIteration
        %% Senales banda base de cada usuario
        newBits = allBits(:,j*nBitsIteration+1:nBitsIteration*(j+1));
        previousBits = allBits(:,(j-1)*nBitsIteration+1:nBitsIteration*(j));

        pBaseBand = [previousBits newBits];                    % Conservacion de los 5 bits anteriores                   

        [pDigitalModulation, nSymbols] = digitalModulation(pBaseBand,modulation); % modulation digital

         %% Oversampling y Pulse shaping
        [pDigitalModulationPulseShaping,phi,complex] = pulseShaping(nUsers,pDigitalModulation, nSymbols, t, alfa, Tsym); % Senal con pulse shaping

        %% Pasa-banda
        [ppassBand,simulationTime] = passBand(pDigitalModulationPulseShaping, nUsers, signalLength, phi, Fc, Ts); % Senal con filtro passBand

        %% DIDO
        b = DIDO(nUsers,nAntennas,ppassBand,signalLength,Hhat); %ecualizando, calculo con reflexiones y obstaculos
   
%         for u=1:nUsers
%             PAPR = max(abs(ppassBand(u,:)))/rms(ppassBand(u,:));
%             fprintf('PAPR de señal usuario: %d\n',PAPR)
%         end
%         for a=1:nAntennas
%             PAPRhat = max(abs(b(a,:)))/rms(b(a,:));
%             fprintf('PAPR de señal antena: %d\n',PAPRhat)
%         end
        PAPRUserSignals(:,j) = max(abs(ppassBand'))./rms(ppassBand');
        PAPRAntennas(:,j) = max(abs(b'))./rms(b');
    end
    
    save(title);
    sendNotification(messageTitle,'Success',destiny);

catch 
    sendNotification(messageTitle,'Error',destiny);
end

sendNotification(messageTitle,'Finish',destiny);
