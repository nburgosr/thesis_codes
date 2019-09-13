function cfinal = plotThesisComparationCorrelations(figName,workspace,scenarioName,userNumber,c)

load(workspace)

figure('units','normalized','outerposition',[0 0 1 1])

subplot(2,3,1)
scenarioNameCorrelation = strcat(scenarioName,'IdealIdeal');
scenarioNameCorrelation = sprintf(scenarioNameCorrelation,userNumber);
userSignals = eval('demodUserSignals');
userSignalAutoCorr = max(xcorr(userSignals(userNumber,:),userSignals(userNumber,:)));
correlationIdealIdeal = eval(scenarioNameCorrelation);
imagesc([0 spaceSize]-spaceSize/2,[0 spaceSize]-spaceSize/2,abs(correlationIdealIdeal)/userSignalAutoCorr);
set(gca,'ydir','normal');
hold on
plot(pxy(userNumber,1)-spaceSize/2,pxy(userNumber,2)-spaceSize/2,'o','MarkerEdgeColor','k',...
    'MarkerFaceColor',[.49 1 .63],...
    'MarkerSize',10)
grid on;
grid minor;
for i=1:1:size(axy,1)
    plot(axy(i,1)-spaceSize/2,axy(i,2)-spaceSize/2,'b^','MarkerEdgeColor','k',...
    'MarkerFaceColor',[1 0 0],...
    'MarkerSize',9)
end

text(1.45-spaceSize/2, -0.6-spaceSize/2, 'i','FontSize',17,'FontName','CMU Serif','FontWeight','bold')
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

subplot(2,3,2);
scenarioNameCorrelation = strcat(scenarioName,'IdealRefl');
scenarioNameCorrelation = sprintf(scenarioNameCorrelation,userNumber);
correlationIdealRefl = eval(scenarioNameCorrelation);
imagesc([0 spaceSize]-spaceSize/2,[0 spaceSize]-spaceSize/2,abs(correlationIdealRefl)/userSignalAutoCorr);
set(gca,'ydir','normal');
hold on
plot(pxy(userNumber,1)-spaceSize/2,pxy(userNumber,2)-spaceSize/2,'o','MarkerEdgeColor','k',...
    'MarkerFaceColor',[.49 1 .63],...
    'MarkerSize',10)
grid on;
grid minor;
for i=1:1:size(axy,1)
    plot(axy(i,1)-spaceSize/2,axy(i,2)-spaceSize/2,'b^','MarkerEdgeColor','k',...
    'MarkerFaceColor',[1 0 0],...
    'MarkerSize',9)
end
text(1.45-spaceSize/2, -0.6-spaceSize/2, 'ii','FontSize',17,'FontName','CMU Serif','FontWeight','bold')
colorbar
c2 = caxis;
c3 = [min([c1 c2]), max([c1 c2])];
ax = gca; % current axes
ax.FontSize = 16;
ax.FontName = 'CMU Serif';
hold off

subplot(2,3,3)
scenarioNameCorrelation = strcat(scenarioName,'IdealObs');
scenarioNameCorrelation = sprintf(scenarioNameCorrelation,userNumber);
correlationIdealObs = eval(scenarioNameCorrelation);
imagesc([0 spaceSize]-spaceSize/2,[0 spaceSize]-spaceSize/2,abs(correlationIdealObs)/userSignalAutoCorr);
set(gca,'ydir','normal');
hold on
plot(pxy(userNumber,1)-spaceSize/2,pxy(userNumber,2)-spaceSize/2,'o','MarkerEdgeColor','k',...
    'MarkerFaceColor',[.49 1 .63],...
    'MarkerSize',10)
grid on;
grid minor;
for i=1:1:size(axy,1)
    plot(axy(i,1)-spaceSize/2,axy(i,2)-spaceSize/2,'b^','MarkerEdgeColor','k',...
    'MarkerFaceColor',[1 0 0],...
    'MarkerSize',9)
end

text(1.45-spaceSize/2, -0.6-spaceSize/2, 'iii','FontSize',17,'FontName','CMU Serif','FontWeight','bold')
colorbar
c4 = caxis;
c5 = [min([c3 c4]), max([c3 c4])];
ax = gca; % current axes
ax.FontSize = 16;
ax.FontName = 'CMU Serif';
hold off

subplot(2,3,4)
scenarioNameCorrelation = strcat(scenarioName,'ReflRefl');
scenarioNameCorrelation = sprintf(scenarioNameCorrelation,userNumber);
correlationReflRefl = eval(scenarioNameCorrelation);
imagesc([0 spaceSize]-spaceSize/2,[0 spaceSize]-spaceSize/2,abs(correlationReflRefl)/userSignalAutoCorr);
set(gca,'ydir','normal');
hold on
plot(pxy(userNumber,1)-spaceSize/2,pxy(userNumber,2)-spaceSize/2,'o','MarkerEdgeColor','k',...
    'MarkerFaceColor',[.49 1 .63],...
    'MarkerSize',10)
grid on;
grid minor;
for i=1:1:size(axy,1)
    plot(axy(i,1)-spaceSize/2,axy(i,2)-spaceSize/2,'b^','MarkerEdgeColor','k',...
    'MarkerFaceColor',[1 0 0],...
    'MarkerSize',9)
end

text(1.45-spaceSize/2, -0.6-spaceSize/2, 'iv','FontSize',17,'FontName','CMU Serif','FontWeight','bold')
colorbar
c6 = caxis;
c7 = [min([c5 c6]), max([c5 c6])];
ax = gca; % current axes
ax.FontSize = 16;
ax.FontName = 'CMU Serif';
hold off

subplot(2,3,5)
scenarioNameCorrelation = strcat(scenarioName,'ReflObs');
scenarioNameCorrelation = sprintf(scenarioNameCorrelation,userNumber);
correlationReflObs = eval(scenarioNameCorrelation);
imagesc([0 spaceSize]-spaceSize/2,[0 spaceSize]-spaceSize/2,abs(correlationReflObs)/userSignalAutoCorr);
set(gca,'ydir','normal');
hold on
plot(pxy(userNumber,1)-spaceSize/2,pxy(userNumber,2)-spaceSize/2,'o','MarkerEdgeColor','k',...
    'MarkerFaceColor',[.49 1 .63],...
    'MarkerSize',10)
grid on;
grid minor;
for i=1:1:size(axy,1)
    plot(axy(i,1)-spaceSize/2,axy(i,2)-spaceSize/2,'b^','MarkerEdgeColor','k',...
    'MarkerFaceColor',[1 0 0],...
    'MarkerSize',9)
end

text(1.45-spaceSize/2, -0.6-spaceSize/2, 'v','FontSize',17,'FontName','CMU Serif','FontWeight','bold')
colorbar
c8 = caxis;
c9 = [min([c7 c8]), max([c7 c8])];
ax = gca; % current axes
ax.FontSize = 16;
ax.FontName = 'CMU Serif';
hold off

subplot(2,3,6);
scenarioNameCorrelation = strcat(scenarioName,'ObsObs');
scenarioNameCorrelation = sprintf(scenarioNameCorrelation,userNumber);
correlationObsObs = eval(scenarioNameCorrelation);
imagesc([0 spaceSize]-spaceSize/2,[0 spaceSize]-spaceSize/2,abs(correlationObsObs)/userSignalAutoCorr);
set(gca,'ydir','normal');
hold on
plot(pxy(userNumber,1)-spaceSize/2,pxy(userNumber,2)-spaceSize/2,'o','MarkerEdgeColor','k',...
    'MarkerFaceColor',[.49 1 .63],...
    'MarkerSize',10)
grid on;
grid minor;
for i=1:1:size(axy,1)
    plot(axy(i,1)-spaceSize/2,axy(i,2)-spaceSize/2,'b^','MarkerEdgeColor','k',...
    'MarkerFaceColor',[1 0 0],...
    'MarkerSize',9)
end

text(1.45-spaceSize/2, -0.6-spaceSize/2, 'vi','FontSize',17,'FontName','CMU Serif','FontWeight','bold')
h = colorbar('northoutside');
set(h, 'Position', [.13 .94 .775 .015])
set(h, 'FontSize', 16)
c10 = caxis;
c11 = [min([c9 c10]), max([c9 c10])];
ax = gca; % current axes
ax.FontSize = 16;
ax.FontName = 'CMU Serif';
hold off
caxis(c11)

subs(2) = subplot(2,3,2);
caxis(c11)
colorbar off

subs(1) = subplot(2,3,1);
caxis(c11)
colorbar off 

subs(3) = subplot(2,3,3);
caxis(c11)
colorbar off 

subs(4) = subplot(2,3,4);
caxis(c11)
colorbar off 

subs(5) = subplot(2,3,5);
caxis(c11)
colorbar off

subs(6) = subplot(2,3,6);

cfinal= c11; 

print(figName,'-dpng','-r0')

end