function plotThesisComparationBERScenarioA()

legendNames = cell(1);
legendNames2 = cell(1);
legendNames3 = cell(1);
plotMarkers = 'o+xsd^v><ph.*';                                              
load('ber_sim_1X1_ideal_ideal.mat','snr','BERUsers','alfa','SNR')

mainFigure = figure('units','normalized','outerposition',[0 0 1 1]);
mainFigure2 = figure('units','normalized','outerposition',[0 0 1 1]);
mainFigure3 = figure('units','normalized','outerposition',[0 0 1 1]);

BERTh=(1/2)*erfc(sqrt(SNR/((1+alfa)))); 

figure(mainFigure)
semilogy(snr,BERTh,'-x','linewidth',2)
legendNames(1) = {'BPSK Teórico'};
hold on

semilogy(snr,BERUsers,'-x','linewidth',2)
legendNames = [legendNames {'BPSK Usuario solitario en canal ideal, caso i'}];

load('ber_sim_1X1_refl_refl.mat','BERUsers')
semilogy(snr,BERUsers,'-x','linewidth',2)
legendNames = [legendNames {'BPSK Usuario solitario en canal con reflexiones, caso iv'}];

load('ber_sim_1X1_obs_obs.mat','BERUsers')
semilogy(snr,BERUsers,'-x','linewidth',2)
legendNames = [legendNames {'BPSK Usuario solitario en canal con obstáculo, caso vi'}];


ylabel('Throughput [Mbps]','FontName','CMU Serif')
xlabel('SNR [dB]','FontName','CMU Serif')
grid on
ax = gca; % current axes
ax.FontSize = 16;
ax.FontName = 'CMU Serif';
legend(legendNames,'FontSize',14,'Location','southwest');

print('speed1x1','-dpng','-r0')

end