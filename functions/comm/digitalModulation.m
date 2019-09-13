function [sDigitalModulation,nSymbols] = digitalModulation(sBaseBand,modulationType)

%%Funcion que transforma secuencias de 0 y 1 en simbolos complejos segun la
%%modulacion digital ingresada. Por ahora se soporta solo BPSK.

switch modulationType
    case 'BPSK'
        sDigitalModulation = sBaseBand*2-1;
        nSymbols = size(sDigitalModulation,2);
    otherwise
        disp('Modulacion no soportada')
end