function plotUserSignal(currentFigure,nUsers,userIndex,userSignal,userDigitalSignal,timeArray,timeSymbolArray)

figure(currentFigure)
subplot(nUsers,1,userIndex)
hold on
plot(timeArray,userSignal)
plot(timeSymbolArray,userDigitalSignal,'ro')
hold off
xlim([timeArray(1) timeArray(end)])
ylim([min(userSignal) max(userSignal)])
ax = gca; % current axes
ax.FontSize = 13;
legend({sprintf('Señal del usuario %d',userIndex),...
    sprintf('Símbolos de la señal del usuario %d',userIndex)},...
    'FontSize',13,...
    'Location','northwest');
xlabel('Tiempo [s]')
ylabel('Amplitud')

end


