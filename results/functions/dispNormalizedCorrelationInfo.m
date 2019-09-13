function dispNormalizedCorrelationInfo(workspace,userNumber)

load(workspace)
fprintf('Para simulacion "%s"\n',workspace);
fprintf('Usuario número %d ubicado en (%.2f,%.2f).\n',userNumber,pxy(userNumber,1)-1.5,pxy(userNumber,2)-1.5);

% i,j parten de 0,0 y avanzan deltaSpace = 0.01

coordenades = round(pxy(userNumber,:)/deltaSpace);

userSignals = demodUserSignals;
userSignalAutoCorr = max(xcorr(userSignals(userNumber,:),userSignals(userNumber,:)));
scenarioName = 'correlations%d';
scenarioNameCorrelation = strcat(scenarioName,'IdealIdeal');
scenarioNameCorrelation = sprintf(scenarioNameCorrelation,userNumber);
correlationIdealIdeal = eval(scenarioNameCorrelation);
corrNormalized1 = abs(correlationIdealIdeal(coordenades(2),coordenades(1))/userSignalAutoCorr);
fprintf('Potencia correlacionada normalizada en escenario i: %.4f\n',corrNormalized1);
scenarioNameCorrelation = strcat(scenarioName,'IdealRefl');
scenarioNameCorrelation = sprintf(scenarioNameCorrelation,userNumber);
correlationIdealRefl = eval(scenarioNameCorrelation);
corrNormalized2 = abs(correlationIdealRefl(coordenades(2),coordenades(1))/userSignalAutoCorr);
fprintf('Potencia correlacionada normalizada en escenario ii: %.4f\n',corrNormalized2);
scenarioNameCorrelation = strcat(scenarioName,'IdealObs');
scenarioNameCorrelation = sprintf(scenarioNameCorrelation,userNumber);
correlationIdealObs = eval(scenarioNameCorrelation);
corrNormalized3 = abs(correlationIdealObs(coordenades(2),coordenades(1))/userSignalAutoCorr);
fprintf('Potencia correlacionada normalizada en escenario iii: %.4f\n',corrNormalized3);
scenarioNameCorrelation = strcat(scenarioName,'ReflRefl');
scenarioNameCorrelation = sprintf(scenarioNameCorrelation,userNumber);
correlationReflRefl = eval(scenarioNameCorrelation);
corrNormalized4 = abs(correlationReflRefl(coordenades(2),coordenades(1))/userSignalAutoCorr);
fprintf('Potencia correlacionada normalizada en escenario iv: %.4f\n',corrNormalized4);
scenarioNameCorrelation = strcat(scenarioName,'ReflObs');
scenarioNameCorrelation = sprintf(scenarioNameCorrelation,userNumber);
correlationReflObs = eval(scenarioNameCorrelation);
corrNormalized5 = abs(correlationReflObs(coordenades(2),coordenades(1))/userSignalAutoCorr);
fprintf('Potencia correlacionada normalizada en escenario v: %.4f\n',corrNormalized5);
scenarioNameCorrelation = strcat(scenarioName,'ObsObs');
scenarioNameCorrelation = sprintf(scenarioNameCorrelation,userNumber);
correlationObsObs = eval(scenarioNameCorrelation);
corrNormalized6 = abs(correlationObsObs(coordenades(2),coordenades(1))/userSignalAutoCorr);
fprintf('Potencia correlacionada normalizada en escenario vi: %.4f\n',corrNormalized6);

end