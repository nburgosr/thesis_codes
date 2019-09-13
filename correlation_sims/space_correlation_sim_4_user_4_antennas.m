
clear all
clc
close all force
tic

imports

% Coordenandas en metros
% Generacion aleatoria de posiciones para usuarios

%% Parametros
% Parametros reales
scaleFactor =10^7;                                                          % Factor temporal de escalado de la simulacion
oversamplingFactor = 10;                                                    % Oversampling de la frecuencia portadora
FcReal = 6e10;                                                              % Frecuencia portadora real igual a 60 GHz
TcReal = 1/FcReal;                                                          % Periodo portadora real
FsReal = floor(FcReal*oversamplingFactor);                                  % Frecuencia de muestreo real
TsReal = 1/FsReal;                                                          % time de muestreo real
TsSymReal = 1e-9;                                                           % Periodo de simbolo de 1 ns
FsSymReal= 1/TsSymReal;                                                     % Frecuencia de simbolo 1 Gbaud

% Parametros escalados                                                            
Fc = FcReal/scaleFactor;                                                    % Frecuencia de la portadora escalada
Tc = 1/Fc;                                                                  % Periodo de la portadora escalado
Fs = FsReal/scaleFactor;                                                    % Frecuencia de muestreo escalada
Ts = 1/Fs;                                                                  % time de muestreo escalado
Tsym = TsSymReal*scaleFactor;                                               % Periodo de simbolo de 1 ns
Fsym= 1/Tsym;                                                               % Frecuencia de simbolo 1 Gbaud

% Otros
alfa = 0.22;                                                                % Roll-off factor
spaceSize = 3;                                                              % Tamano del espacio de simulacion
toaMax = 4*spaceSize*sqrt(2)/physconst('LightSpeed');
nBits = 20;                                                                 % Bits de informacion en simulacion
paddingBits = round(toaMax/TsSymReal);
modulation = 'BPSK';                                                        % Tipo de modulation
deltaSpace = 0.01;                                                          % Maxima variacion de coordenadas x,y
postionSeed = 1;                                                            % Seed de las posiciones
bitsSeed = 1;                                                               % Seed de los bits enviados
currentFigure = 2;                                                               
spatialCorrelation = 1;                                                     % Flag que indica si se calcula o no la correlacion espacial (heatmap)
signalLength = (nBits+paddingBits)*Fs*Tsym;

% Extremos del obstaculo
xHeight = 0.25;
yHeight = 0.7;
xCenter = -0.75;
yCenter = 0.75;
angle = pi/4;
obstacles = [xCenter,yCenter,yHeight,xHeight,angle,2.26];

% Posiciones fijas (descomentar)
axy = [0 0; 0 3; 3 0; 3 3];

try

for i=2:1:4
    tic
    
    currentFigure = 2;     
    disp('Iteration')
    disp(i)
    if i == 1
        pxy = [0.75 0.75];
    elseif i == 2
        pxy = [0.75 0.75;2.25 0.75];
    elseif i == 3
        pxy = [0.75 0.75;2.25 0.75;1.5 sqrt(2*0.75^2)+1.5];
    elseif i == 4
        pxy = [0.75 0.75;2.25 0.75;1.5 sqrt(2*0.75^2)+1.5;1.5 1.5];
    end
    
    [nUsers,~] = size(pxy);                                                                
    [nAntennas,~] = size(axy); 
    
    title = sprintf("corr_sim_%d_user_%d_antennas_triangule",nUsers,nAntennas);

    %% Posicion aleatoria de las antenas, los usuarios y obstaculos

    [hhat,Hhat] = filterMatrix(nUsers,nAntennas,pxy,axy,signalLength,FcReal,oversamplingFactor);
    [hrhat,HRhat] = filterMatrixWithReflections(nUsers,nAntennas,pxy,axy,spaceSize,signalLength,FcReal,oversamplingFactor);
    [hrohat,HROhat] = filterMatrixWithReflectionsAndObstacles(nUsers,nAntennas,pxy,axy,spaceSize,signalLength,FcReal,oversamplingFactor,obstacles);

    postionsPlot(figure(1),pxy,axy,spaceSize)                                             % Disposicion grafica de usuarios y antenas

    %% Senales banda base de cada usuario
    pBaseBand = baseBand(nUsers,nBits, paddingBits,'Seed',bitsSeed);                % Generacion de una secuencia aleatoria para cada usuario
    [pDigitalModulation, nSymbols] = digitalModulation(pBaseBand,modulation);   % modulation digital 
    t = 0:Ts:nSymbols*Tsym-Ts;                                                  % Vector de time de duracion 10 ciclos de la portadora muestreado a Ts 
    t = t+1e-10;                                                                % Condicion para evitar indefinicion en el sampling cuando el denominador sea 0

    %% Oversampling y Pulse shaping
    [pDigitalModulationPulseShaping,phi,~] = pulseShaping(nUsers,pDigitalModulation, nSymbols, t, alfa, Tsym); % Senal con pulse shaping

    %% Pasa-banda
    [ppassBand,simulationTime] = passBand(pDigitalModulationPulseShaping, nUsers, signalLength, phi, Fc, Ts); % Senal con filtro passBand
    demodUserSignals = zeros(size(ppassBand));
    for j=1:nUsers
        demodUserSignals(j,:) = ssbdemod(ppassBand(j,:),Fc,Fs,0);
    end

    time = Tsym.*linspace(paddingBits+1,nBits+paddingBits,nBits);
    pDigitalModulation(isnan(pDigitalModulation))=0;

    for j=1:nUsers
        plotUserSignal(currentFigure,nUsers,j,ppassBand(j,:),pDigitalModulation(j,paddingBits+1:nBits+paddingBits),t,time);
    end
    currentFigure = currentFigure + 1;

    %% DIDO
    b = DIDO(nUsers,nAntennas,ppassBand,signalLength,Hhat);
    br = DIDO(nUsers,nAntennas,ppassBand,signalLength,HRhat); 
    bro = DIDO(nUsers,nAntennas,ppassBand,signalLength,HROhat);

    %% Calculo de correlacion en el espacio
    if i == 1

        %User 1
        tic
        correlations1IdealIdeal = spaceCorrelation(nAntennas,Fc,Fs,demodUserSignals,signalLength,b,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor);
        toc
        tic
        correlations1IdealRefl = spaceCorrelationConsideringReflections(nAntennas,Fc,Fs,demodUserSignals,signalLength,b,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor);
        toc
        tic
        correlations1IdealObs = spaceCorrelationConsideringReflectionsAndObstacles(nAntennas,Fc,Fs,demodUserSignals,signalLength,b,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor,obstacles);
        toc
        tic
        correlations1ReflRefl = spaceCorrelationConsideringReflections(nAntennas,Fc,Fs,demodUserSignals,signalLength,br,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor);
        toc
        tic
        correlations1ReflObs = spaceCorrelationConsideringReflectionsAndObstacles(nAntennas,Fc,Fs,demodUserSignals,signalLength,br,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor,obstacles);
        toc
        tic
        correlations1ObsObs = spaceCorrelationConsideringReflectionsAndObstacles(nAntennas,Fc,Fs,demodUserSignals,signalLength,bro,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor,obstacles);
        toc

    elseif i == 2

        %User 1
        tic
        correlations1IdealIdeal = spaceCorrelation(nAntennas,Fc,Fs,demodUserSignals(1,:),signalLength,b,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor);
        toc
        tic
        correlations1IdealRefl = spaceCorrelationConsideringReflections(nAntennas,Fc,Fs,demodUserSignals(1,:),signalLength,b,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor);
        toc
        tic
        correlations1IdealObs = spaceCorrelationConsideringReflectionsAndObstacles(nAntennas,Fc,Fs,demodUserSignals(1,:),signalLength,b,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor,obstacles);
        toc
        tic
        correlations1ReflRefl = spaceCorrelationConsideringReflections(nAntennas,Fc,Fs,demodUserSignals(1,:),signalLength,br,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor);
        toc
        tic
        correlations1ReflObs = spaceCorrelationConsideringReflectionsAndObstacles(nAntennas,Fc,Fs,demodUserSignals(1,:),signalLength,br,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor,obstacles);
        toc
        tic
        correlations1ObsObs = spaceCorrelationConsideringReflectionsAndObstacles(nAntennas,Fc,Fs,demodUserSignals(1,:),signalLength,bro,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor,obstacles);
        toc
        
        %User 2
        tic
        correlations2IdealIdeal = spaceCorrelation(nAntennas,Fc,Fs,demodUserSignals(2,:),signalLength,b,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor);
        toc
        tic
        correlations2IdealRefl = spaceCorrelationConsideringReflections(nAntennas,Fc,Fs,demodUserSignals(2,:),signalLength,b,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor);
        toc
        tic
        correlations2IdealObs = spaceCorrelationConsideringReflectionsAndObstacles(nAntennas,Fc,Fs,demodUserSignals(2,:),signalLength,b,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor,obstacles);
        toc
        tic
        correlations2ReflRefl = spaceCorrelationConsideringReflections(nAntennas,Fc,Fs,demodUserSignals(2,:),signalLength,br,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor);
        toc
        tic
        correlations2ReflObs = spaceCorrelationConsideringReflectionsAndObstacles(nAntennas,Fc,Fs,demodUserSignals(2,:),signalLength,br,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor,obstacles);
        toc
        tic
        correlations2ObsObs = spaceCorrelationConsideringReflectionsAndObstacles(nAntennas,Fc,Fs,demodUserSignals(2,:),signalLength,bro,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor,obstacles);
        toc

    elseif i == 3

         %User 1
        tic
        correlations1IdealIdeal = spaceCorrelation(nAntennas,Fc,Fs,demodUserSignals(1,:),signalLength,b,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor);
        toc
        tic
        correlations1IdealRefl = spaceCorrelationConsideringReflections(nAntennas,Fc,Fs,demodUserSignals(1,:),signalLength,b,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor);
        toc
        tic
        correlations1IdealObs = spaceCorrelationConsideringReflectionsAndObstacles(nAntennas,Fc,Fs,demodUserSignals(1,:),signalLength,b,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor,obstacles);
        toc
        tic
        correlations1ReflRefl = spaceCorrelationConsideringReflections(nAntennas,Fc,Fs,demodUserSignals(1,:),signalLength,br,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor);
        toc
        tic
        correlations1ReflObs = spaceCorrelationConsideringReflectionsAndObstacles(nAntennas,Fc,Fs,demodUserSignals(1,:),signalLength,br,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor,obstacles);
        toc
        tic
        correlations1ObsObs = spaceCorrelationConsideringReflectionsAndObstacles(nAntennas,Fc,Fs,demodUserSignals(1,:),signalLength,bro,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor,obstacles);
        toc
        
        %User 2
        tic
        correlations2IdealIdeal = spaceCorrelation(nAntennas,Fc,Fs,demodUserSignals(2,:),signalLength,b,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor);
        toc
        tic
        correlations2IdealRefl = spaceCorrelationConsideringReflections(nAntennas,Fc,Fs,demodUserSignals(2,:),signalLength,b,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor);
        toc
        tic
        correlations2IdealObs = spaceCorrelationConsideringReflectionsAndObstacles(nAntennas,Fc,Fs,demodUserSignals(2,:),signalLength,b,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor,obstacles);
        toc
        tic
        correlations2ReflRefl = spaceCorrelationConsideringReflections(nAntennas,Fc,Fs,demodUserSignals(2,:),signalLength,br,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor);
        toc
        tic
        correlations2ReflObs = spaceCorrelationConsideringReflectionsAndObstacles(nAntennas,Fc,Fs,demodUserSignals(2,:),signalLength,br,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor,obstacles);
        toc
        tic
        correlations2ObsObs = spaceCorrelationConsideringReflectionsAndObstacles(nAntennas,Fc,Fs,demodUserSignals(2,:),signalLength,bro,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor,obstacles);
        toc

        %User 3
        tic
        correlations3IdealIdeal = spaceCorrelation(nAntennas,Fc,Fs,demodUserSignals(3,:),signalLength,b,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor);
        toc
        tic
        correlations3IdealRefl = spaceCorrelationConsideringReflections(nAntennas,Fc,Fs,demodUserSignals(3,:),signalLength,b,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor);
        toc
        tic
        correlations3IdealObs = spaceCorrelationConsideringReflectionsAndObstacles(nAntennas,Fc,Fs,demodUserSignals(3,:),signalLength,b,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor,obstacles);
        toc
        tic
        correlations3ReflRefl = spaceCorrelationConsideringReflections(nAntennas,Fc,Fs,demodUserSignals(3,:),signalLength,br,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor);
        toc
        tic
        correlations3ReflObs = spaceCorrelationConsideringReflectionsAndObstacles(nAntennas,Fc,Fs,demodUserSignals(3,:),signalLength,br,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor,obstacles);
        toc
        tic
        correlations3ObsObs = spaceCorrelationConsideringReflectionsAndObstacles(nAntennas,Fc,Fs,demodUserSignals(3,:),signalLength,bro,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor,obstacles);
        toc

    elseif i == 4

                 %User 1
        tic
        correlations1IdealIdeal = spaceCorrelation(nAntennas,Fc,Fs,demodUserSignals(1,:),signalLength,b,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor);
        toc
        tic
        correlations1IdealRefl = spaceCorrelationConsideringReflections(nAntennas,Fc,Fs,demodUserSignals(1,:),signalLength,b,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor);
        toc
        tic
        correlations1IdealObs = spaceCorrelationConsideringReflectionsAndObstacles(nAntennas,Fc,Fs,demodUserSignals(1,:),signalLength,b,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor,obstacles);
        toc
        tic
        correlations1ReflRefl = spaceCorrelationConsideringReflections(nAntennas,Fc,Fs,demodUserSignals(1,:),signalLength,br,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor);
        toc
        tic
        correlations1ReflObs = spaceCorrelationConsideringReflectionsAndObstacles(nAntennas,Fc,Fs,demodUserSignals(1,:),signalLength,br,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor,obstacles);
        toc
        tic
        correlations1ObsObs = spaceCorrelationConsideringReflectionsAndObstacles(nAntennas,Fc,Fs,demodUserSignals(1,:),signalLength,bro,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor,obstacles);
        toc
        
        %User 2
        tic
        correlations2IdealIdeal = spaceCorrelation(nAntennas,Fc,Fs,demodUserSignals(2,:),signalLength,b,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor);
        toc
        tic
        correlations2IdealRefl = spaceCorrelationConsideringReflections(nAntennas,Fc,Fs,demodUserSignals(2,:),signalLength,b,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor);
        toc
        tic
        correlations2IdealObs = spaceCorrelationConsideringReflectionsAndObstacles(nAntennas,Fc,Fs,demodUserSignals(2,:),signalLength,b,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor,obstacles);
        toc
        tic
        correlations2ReflRefl = spaceCorrelationConsideringReflections(nAntennas,Fc,Fs,demodUserSignals(2,:),signalLength,br,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor);
        toc
        tic
        correlations2ReflObs = spaceCorrelationConsideringReflectionsAndObstacles(nAntennas,Fc,Fs,demodUserSignals(2,:),signalLength,br,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor,obstacles);
        toc
        tic
        correlations2ObsObs = spaceCorrelationConsideringReflectionsAndObstacles(nAntennas,Fc,Fs,demodUserSignals(2,:),signalLength,bro,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor,obstacles);
        toc

        %User 3
        tic
        correlations3IdealIdeal = spaceCorrelation(nAntennas,Fc,Fs,demodUserSignals(3,:),signalLength,b,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor);
        toc
        tic
        correlations3IdealRefl = spaceCorrelationConsideringReflections(nAntennas,Fc,Fs,demodUserSignals(3,:),signalLength,b,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor);
        toc
        tic
        correlations3IdealObs = spaceCorrelationConsideringReflectionsAndObstacles(nAntennas,Fc,Fs,demodUserSignals(3,:),signalLength,b,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor,obstacles);
        toc
        tic
        correlations3ReflRefl = spaceCorrelationConsideringReflections(nAntennas,Fc,Fs,demodUserSignals(3,:),signalLength,br,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor);
        toc
        tic
        correlations3ReflObs = spaceCorrelationConsideringReflectionsAndObstacles(nAntennas,Fc,Fs,demodUserSignals(3,:),signalLength,br,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor,obstacles);
        toc
        tic
        correlations3ObsObs = spaceCorrelationConsideringReflectionsAndObstacles(nAntennas,Fc,Fs,demodUserSignals(3,:),signalLength,bro,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor,obstacles);
        toc

        %User 4
        tic
        correlations4IdealIdeal = spaceCorrelation(nAntennas,Fc,Fs,demodUserSignals(4,:),signalLength,b,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor);
        toc
        tic
        correlations4IdealRefl = spaceCorrelationConsideringReflections(nAntennas,Fc,Fs,demodUserSignals(4,:),signalLength,b,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor);
        toc
        tic
        correlations4IdealObs = spaceCorrelationConsideringReflectionsAndObstacles(nAntennas,Fc,Fs,demodUserSignals(4,:),signalLength,b,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor,obstacles);
        toc
        tic
        correlations4ReflRefl = spaceCorrelationConsideringReflections(nAntennas,Fc,Fs,demodUserSignals(4,:),signalLength,br,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor);
        toc
        tic
        correlations4ReflObs = spaceCorrelationConsideringReflectionsAndObstacles(nAntennas,Fc,Fs,demodUserSignals(4,:),signalLength,br,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor,obstacles);
        toc
        tic
        correlations4ObsObs = spaceCorrelationConsideringReflectionsAndObstacles(nAntennas,Fc,Fs,demodUserSignals(4,:),signalLength,bro,axy,spaceSize,deltaSpace,FcReal,oversamplingFactor,obstacles);
        toc


    end


    figure(currentFigure)
    colormap('hot');
    imagesc([0 spaceSize],[0 spaceSize],(correlations1IdealObs));
    set(gca,'ydir','normal');
    hold on
    plot(pxy(1,1),pxy(1,2),'ko','linewidth',3);
    legend('User 1')
    xlabel('x coordenade [m]')
    ylabel('y coordenade [y]')
    colorbar
    c2 = caxis;
    ax = gca; % current axes
    ax.FontSize = 15;
    hold off
    currentFigure = currentFigure+1;

    figure(currentFigure)
    colormap('hot');
    imagesc([0 spaceSize],[0 spaceSize],(correlations1ReflObs));
    set(gca,'ydir','normal');
    hold on
    plot(pxy(1,1),pxy(1,2),'ko','linewidth',3);
    legend('User 1')
    xlabel('x coordenade [m]')
    ylabel('y coordenade [y]')
    colorbar
    c2 = caxis;
    ax = gca; % current axes
    ax.FontSize = 15;
    hold off
    currentFigure = currentFigure+1;

    figure(currentFigure)
    colormap('hot');
    imagesc([0 spaceSize],[0 spaceSize],(correlations1ObsObs));
    set(gca,'ydir','normal');
    hold on
    plot(pxy(1,1),pxy(1,2),'ko','linewidth',3);
    legend('User 1')
    xlabel('x coordenade [m]')
    ylabel('y coordenade [y]')
    colorbar
    c2 = caxis;
    ax = gca; % current axes
    ax.FontSize = 15;
    hold off
    currentFigure = currentFigure+1;

    save(title)
%     sendNotification('SimPC2 COR4X4','Success','correo@gmail.com');

    toc
end
 
catch
    sendNotification('COR4X4','Error','correo@gmail.com');
end

sendNotification('COR4X4','Finish','correo@gmail.com');
        
