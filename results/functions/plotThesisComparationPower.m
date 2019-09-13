function c3 = plotThesisComparationPower1X1(figName)

load('energy_1x1_idealideal.mat')

figure('units','normalized','outerposition',[0 0 1 1])

subplot(1,2,1)
scenarioNameEnergy = 'energy1IdealIdeal';
energyIdealIdeal = eval(scenarioNameEnergy);
imagesc([0 spaceSize]-spaceSize/2,[0 spaceSize]-spaceSize/2,10*log10(energyIdealIdeal));
set(gca,'ydir','normal');
hold on
plot(pxy(userNumber,1)-spaceSize/2,pxy(userNumber,2)-spaceSize/2,'ko','linewidth',3);
grid on;
grid minor;
for i=1:1:size(axy,1)
    plot(axy(i,1)-spaceSize/2,axy(i,2)-spaceSize/2,'rx','linewidth',3);
end
% legend(sprintf('Usuario %d',userNumber))
% xlabel('coordenada x [m]','FontName','CMU Serif')
% ylabel('coordenada y [m]','FontName','CMU Serif')
text(1.45-spaceSize/2, -0.6-spaceSize/2, 'a)','FontSize',17,'FontName','CMU Serif','FontWeight','bold')
colorbar
c1 = zeros(1,2);
if isempty(c)
    c1 = caxis;
else
    caux = caxis;
    c1 = [min([c caux]), max([c caux])];
end
ax = gca; % current axes
ax.FontSize = 16;
ax.FontName = 'CMU Serif';
hold off


load('energy_1x1_refl_obs.mat')

subplot(1,2,2);
scenarioNameEnergy = 'energy1IdealObs';
energyIdealRefl = eval(scenarioNameEnergy);
imagesc([0 spaceSize]-spaceSize/2,[0 spaceSize]-spaceSize/2,abs(correlationIdealRefl));
set(gca,'ydir','normal');
hold on
plot(pxy(userNumber,1)-spaceSize/2,pxy(userNumber,2)-spaceSize/2,'ko','linewidth',3);
grid on;
grid minor;
for i=1:1:size(axy,1)
    plot(axy(i,1)-spaceSize/2,axy(i,2)-spaceSize/2,'rx','linewidth',3);
end
% legend(sprintf('Usuario %d',userNumber))
% xlabel('coordenada x [m]','FontName','CMU Serif')
% ylabel('coordenada y [m]','FontName','CMU Serif')
text(1.45-spaceSize/2, -0.6-spaceSize/2, 'b)','FontSize',17,'FontName','CMU Serif','FontWeight','bold')
colorbar
c2 = caxis;
c3 = [min([c1 c2]), max([c1 c2])];
ax = gca; % current axes
ax.FontSize = 16;
ax.FontName = 'CMU Serif';
hold off

subs(2) = subplot(1,2,2);
caxis(c3)
colorbar off

subs(1) = subplot(1,2,1);
caxis(c3)
colorbar off 

cfinal= c11; 

% pos = get(subs,'Position');
% hoffset1 = 0.025;
% hoffset2 = 0.015;
% voffset1 = 0.015;
% voffset2 = 0.005;
% width = pos{5}(3);
% set(subs(1),'Position',[pos{1}(1)-hoffset2,pos{1}(2)-voffset2,width,pos{1}(end)])
% set(subs(2),'Position',[pos{2}(1)-hoffset2,pos{2}(2)-voffset2,width,pos{2}(end)])
% set(subs(3),'Position',[pos{3}(1)-hoffset2,pos{3}(2)-voffset2,width,pos{3}(end)])
% set(subs(4),'Position',[pos{4}(1)-hoffset2,pos{4}(2)-voffset2,width,pos{4}(end)])
% set(subs(5),'Position',[pos{5}(1)-hoffset2,pos{5}(2)-voffset2,width,pos{5}(end)])
% set(subs(6),'Position',[pos{6}(1)-hoffset2,pos{6}(2)-voffset2,width,pos{6}(end)])
% 
% pos = get(subs,'Position');
print(figName,'-dpng','-r0')


end