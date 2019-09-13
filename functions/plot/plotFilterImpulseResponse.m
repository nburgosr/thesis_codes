function plotFilterImpulseResponse(currentFigure,nAntennas,nUsers,impulseResponses,timeArray,varargin)

timeArray = timeArray*1e9;

figure(currentFigure)

for i = 1:nUsers
    for j = 1:nAntennas
        k = (i-1)*nUsers + j;
        subplot(nUsers,nAntennas,k);
        plot(timeArray,impulseResponses(k,:));
        xlim([timeArray(1) timeArray(end)])
        ylim([min(impulseResponses(k,:)) max(impulseResponses(k,:))])
        
        [M,I] = max(impulseResponses(k,:));
        text(timeArray(I),M/2,sprintf('Delay de %d [ns]',round(timeArray(I))));
        
        ax = gca; % current axes
        ax.FontSize = 11;
        titleSubplot = sprintf('Filtro de antena %d a usuario %d',j,i);
        title(titleSubplot);
        xlabel('Tiempo [ns]')
        ylabel('Amplitud')

    end
end

end