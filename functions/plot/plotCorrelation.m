function plotCorrelation(currentFigure,spaceSize,correlations,pxy)

        figure(currentFigure)
        colormap('hot');
        imagesc([0 spaceSize],[0 spaceSize],(correlations));
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

end