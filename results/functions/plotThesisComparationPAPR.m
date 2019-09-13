function plotThesisComparationPAPR()

legendNames = cell(1);
antennasPAPR = 'PAPRAntennas';
usersPAPR = 'PAPRUserSignals';

load('papr_sim_1X1_obs.mat')

mainFigure = figure('units','normalized','outerposition',[0 0 1 1]);
auxFigure = figure;

papr1x1Antennas =  eval(antennasPAPR); 
figure(auxFigure)
h = cdfplot(20*log10(papr1x1Antennas));
papr1x1AntennasXDATA = h.XData;
minX = min(papr1x1AntennasXDATA);
maxX = max(papr1x1AntennasXDATA);
papr1x1AntennasYDATA = 1-h.YData;
minY = min(papr1x1AntennasYDATA);
maxY = max(papr1x1AntennasYDATA);


figure(mainFigure)
semilogy(papr1x1AntennasXDATA,papr1x1AntennasYDATA,'-x','linewidth',2)
legendNames(1) = {'Antena solitaria - Escenario a'};
hold on

papr1x1Users =  eval(usersPAPR); 
figure(auxFigure)
h = cdfplot(20*log10(papr1x1Users));
papr1x1UsersXDATA = h.XData;
minX = min(minX,papr1x1UsersXDATA);
maxX = max(maxX,papr1x1UsersXDATA);
papr1x1UsersYDATA = 1-h.YData;
minY = min(minY,papr1x1UsersYDATA);
maxY = max(maxY,papr1x1UsersYDATA);

hold off

figure(mainFigure)
semilogy(papr1x1UsersXDATA,papr1x1UsersYDATA,'-o','linewidth',2)
legendNames = [legendNames {'Usuario solitario - Escenario a'}];

load('papr_sim_4X4_obs.mat')
papr4x4Antennas =  eval(antennasPAPR); 
papr4x4Users =  eval(usersPAPR);

for i=1:size(papr4x4Antennas,1)
    figure(auxFigure)
    h = cdfplot(20*log10(papr4x4Antennas(i,:)));
    papr4x4AntennasXDATA = h.XData;
    minX = min(minX,papr4x4AntennasXDATA);
    maxX = max(maxX,papr4x4AntennasXDATA);
    papr4x4AntennasYDATA = 1-h.YData;
    minY = min(minY,papr4x4AntennasYDATA);
    maxY = max(maxY,papr4x4AntennasYDATA);
    
    figure(mainFigure)
    semilogy(papr4x4AntennasXDATA,papr4x4AntennasYDATA,'-x','linewidth',2)
    legendNames = [legendNames {sprintf('Antena %d - Escenario f',i)}];
end

for i=1:size(papr4x4Users,1)
    figure(auxFigure)
    h = cdfplot(20*log10(papr4x4Users(i,:)));
    papr4x4UsersXDATA = h.XData;
    minX = min(minX,papr4x4UsersXDATA);
    maxX = max(maxX,papr4x4UsersXDATA);
    papr4x4UsersYDATA = 1-h.YData;
    minY = min(minY,papr4x4UsersYDATA);
    maxY = max(maxY,papr4x4UsersYDATA);
    
    figure(mainFigure)
    semilogy(papr4x4UsersXDATA,papr4x4UsersYDATA,'-o','linewidth',2)
    legendNames = [legendNames {sprintf('Usuario %d - Escenario f',i)}];
end

figure(auxFigure)

figure(mainFigure)
ylim([1e-3 1])
xlim([7 13.5])
ylabel('CCDF','FontName','CMU Serif')
xlabel('PAPR [dB]','FontName','CMU Serif')
grid on
ax = gca; % current axes
ax.FontSize = 16;
ax.FontName = 'CMU Serif';
legend(legendNames,'FontSize',14,'Location','southwest');

print('papr','-dpng','-r0')


end