function plotBaseBandReceivedSignal(currentFigure,nUsers,userIndex,userSignal,userBaseBandReceivedSignal,userDigitalSignal,timeArray,timeSymbolArray)

figure(currentFigure)
subplot(nUsers,1,userIndex)
hold on
plot(timeArray,userSignal)
plot(timeArray,userBaseBandReceivedSignal,'g')
plot(timeSymbolArray,userDigitalSignal,'ro')
hold off
xlim([timeArray(1) timeArray(end)])
ylim([min(userSignal) max(userSignal)])
ax = gca; % current axes
ax.FontSize = 13;
legend({sprintf('Señal del usuario %d',userIndex),...
    sprintf('Símbolos de la señal del usuario %d recibida',userIndex),...
    sprintf('Símbolos de la señal banda base del usuario %d recibida',userIndex)},...
    'FontSize',13,...
    'Location','northwest');
xlabel('Tiempo [s]')
ylabel('Amplitud')

end