function c3 = plotThesisComparationPower1X1(c,figName)

goalPower = -70;

load('energy_1x1_refl_obs.mat')

figure('units','normalized','outerposition',[0 0 1 1])

subplot(1,2,1)
scenarioNameEnergy = 'energy1IdealObs';
energyIdealIdeal = eval(scenarioNameEnergy);

user_i = round(pxy(:,1)/deltaSpace);
user_j = round(pxy(:,2)/deltaSpace);
G = goalPower-10*log10(energyIdealIdeal(user_i,user_j)/12000);

[MAX, i]= max(max(10*log10(energyIdealIdeal/12000)+G,[],1));
disp(MAX);

imagesc([0 spaceSize]-spaceSize/2,[0 spaceSize]-spaceSize/2,10*log10(energyIdealIdeal/12000)+G);
set(gca,'ydir','normal');
hold on
plot(pxy(:,1)-spaceSize/2,pxy(:,2)-spaceSize/2,'o','MarkerEdgeColor','k',...
    'MarkerFaceColor',[.49 1 .63],...
    'MarkerSize',10)
grid on;
grid minor;
for i=1:1:size(axy,1)
    plot(axy(i,1)-spaceSize/2,axy(i,2)-spaceSize/2,'b^','MarkerEdgeColor','k',...
    'MarkerFaceColor',[1 0 0],...
    'MarkerSize',9)
end

text(1.45-spaceSize/2, -0.3-spaceSize/2, 'a)','FontSize',17,'FontName','CMU Serif','FontWeight','bold')
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
scenarioNameEnergy = 'energy1ObsObs';
energyIdealRefl = eval(scenarioNameEnergy);

user_i = round(pxy(:,1)/deltaSpace);
user_j = round(pxy(:,2)/deltaSpace);
G = goalPower-10*log10(energyIdealRefl(user_i,user_j)/12000);

[MAX, i]= max(max(10*log10(energyIdealRefl/12000)+G,[],1));
disp(MAX);

imagesc([0 spaceSize]-spaceSize/2,[0 spaceSize]-spaceSize/2,10*log10(energyIdealRefl/12000)+G);
set(gca,'ydir','normal');
hold on
plot(pxy(:,1)-spaceSize/2,pxy(:,2)-spaceSize/2,'o','MarkerEdgeColor','k',...
    'MarkerFaceColor',[.49 1 .63],...
    'MarkerSize',10)
grid on;
grid minor;
for i=1:1:size(axy,1)
    plot(axy(i,1)-spaceSize/2,axy(i,2)-spaceSize/2,'b^','MarkerEdgeColor','k',...
    'MarkerFaceColor',[1 0 0],...
    'MarkerSize',9)
end

text(1.45-spaceSize/2, -0.3-spaceSize/2, 'b)','FontSize',17,'FontName','CMU Serif','FontWeight','bold')
h = colorbar('northoutside');
% hoffset3 = 0.00725;
set(h, 'Position', [.13 .94 .775 .015])
set(h, 'FontSize', 16)
c2 = caxis;
c3 = [min([c1 c2]), max([c1 c2])];
ax = gca; % current axes
ax.FontSize = 16;
ax.FontName = 'CMU Serif';
hold off

subs(2) = subplot(1,2,2);
caxis(c3)
subs(1) = subplot(1,2,1);
caxis(c3)
colorbar off

cfinal= c3; 

print(figName,'-dpng','-r0')


end