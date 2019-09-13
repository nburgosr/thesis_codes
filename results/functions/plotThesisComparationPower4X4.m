function c3 = plotThesisComparationPower4X4(c,figName)

goalPower = -46-15;

%1 user
load('energy_sim_1_user_4_antennas_triangule.mat')

figure('units','normalized','outerposition',[0 0 1 1])

%%

subplot(2,2,1)
scenarioNameEnergy = 'energy1ObsObs';
energy1User = eval(scenarioNameEnergy);

G = 0;
for i=1:size(pxy,1)
    user_i = round(pxy(i,1)/deltaSpace);
    user_j = round(pxy(i,2)/deltaSpace);
    Gaux =((goalPower-10*log10(energy1User(user_i,user_j)/12000)));
    G = min([G Gaux]);
end

[MAX, i]= max(max(10*log10(energy1User/12000)+G,[],1));
disp(MAX);

imagesc([0 spaceSize]-spaceSize/2,[0 spaceSize]-spaceSize/2,10*log10(energy1User/12000)+G);
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

text(1.45-spaceSize/2, -0.6-spaceSize/2, 'a','FontSize',17,'FontName','CMU Serif','FontWeight','bold')
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

%%

load('energy_sim_2_user_4_antennas_triangule.mat')

subplot(2,2,2)
scenarioNameEnergy = 'energy1ObsObs';
energy1User = eval(scenarioNameEnergy);

G = 0;
for i=1:size(pxy,1)
    user_i = round(pxy(i,1)/deltaSpace);
    user_j = round(pxy(i,2)/deltaSpace);
    Gaux =((goalPower-10*log10(energy1User(user_i,user_j)/12000)));
    G = min([G Gaux]);
end

[MAX, i]= max(max(10*log10(energy1User/12000)+G,[],1));
disp(MAX);


imagesc([0 spaceSize]-spaceSize/2,[0 spaceSize]-spaceSize/2,10*log10(energy1User/12000)+G);
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

text(1.45-spaceSize/2, -0.6-spaceSize/2, 'b','FontSize',17,'FontName','CMU Serif','FontWeight','bold')
colorbar
c2 = caxis;
c3 = [min([c1 c2]), max([c1 c2])];
ax = gca; % current axes
ax.FontSize = 16;
ax.FontName = 'CMU Serif';
hold off

%%
load('energy_sim_3_user_4_antennas_triangule.mat')

subplot(2,2,3)
scenarioNameEnergy = 'energy1ObsObs';
energy1User = eval(scenarioNameEnergy);

G = 0;
for i=1:size(pxy,1)
    user_i = round(pxy(i,1)/deltaSpace);
    user_j = round(pxy(i,2)/deltaSpace);
    Gaux =((goalPower-10*log10(energy1User(user_i,user_j)/12000)));
    G = min([G Gaux]);
end

[MAX, i]= max(max(10*log10(energy1User/12000)+G,[],1));
disp(MAX);

imagesc([0 spaceSize]-spaceSize/2,[0 spaceSize]-spaceSize/2,10*log10(energy1User/12000)+G);
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

text(1.45-spaceSize/2, -0.6-spaceSize/2, 'c','FontSize',17,'FontName','CMU Serif','FontWeight','bold')
colorbar
c4 = caxis;
c5 = [min([c3 c4]), max([c3 c4])];
ax = gca; % current axes
ax.FontSize = 16;
ax.FontName = 'CMU Serif';
hold off


%%

load('energy_sim_4_user_4_antennas_triangule.mat')

subplot(2,2,4);
scenarioNameEnergy = 'energy1ObsObs';
energyIdealRefl = eval(scenarioNameEnergy);

G = 0;
for i=1:size(pxy,1)
    user_i = round(pxy(i,1)/deltaSpace);
    user_j = round(pxy(i,2)/deltaSpace);
    Gaux =((goalPower-10*log10(energyIdealRefl(user_i,user_j)/12000)));
    G = min([G Gaux]);
end

[MAX, i]= max(max(10*log10(energy1User/12000)+G,[],1));
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

text(1.45-spaceSize/2, -0.6-spaceSize/2, 'd','FontSize',17,'FontName','CMU Serif','FontWeight','bold')
h = colorbar('northoutside');

set(h, 'Position', [.13 .94 .775 .015])
set(h, 'FontSize', 16)
c6 = caxis;
c7 = [min([c5 c6]), max([c5 c6])];
ax = gca; % current axes
ax.FontSize = 16;
ax.FontName = 'CMU Serif';
hold off
caxis(c7)

subs(2) = subplot(2,2,2);
caxis(c7)
colorbar off

subs(1) = subplot(2,2,1);
caxis(c7)
colorbar off 

subs(3) = subplot(2,2,3);
caxis(c7)
colorbar off 

subs(4) = subplot(2,2,4);
caxis(c7)

cfinal= c7; 

print(figName,'-dpng','-r0')


end