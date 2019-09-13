function plotThesisComparationBERScenarioG()

legendNames = cell(1);
legendNames2 = cell(1);
legendNames3 = cell(1);
plotMarkers = 'p^so+xsd^v><ph.*';                                           
load('ber_sim_1X1_ideal_ideal.mat','snr','BERUsers','alfa','SNR')

mainFigure = figure('units','normalized','outerposition',[0 0 1 1]);
mainFigure2 = figure('units','normalized','outerposition',[0 0 1 1]);
mainFigure3 = figure('units','normalized','outerposition',[0 0 1 1]);

BERTh=(1/2)*erfc(sqrt(SNR/((1+alfa)))); 

%%
figure(mainFigure2)

semilogy(snr,BERTh,'-kx','linewidth',2)
legendNames2(1) = {'BPSK Teórico'};
hold on

load('ber_sim_3X4_ideal_ideal.mat','BERUsers')
for i=1:size(BERUsers,1)
    semilogy(snr,BERUsers(i,:),strcat('-b',plotMarkers(i)),'linewidth',2)
    legendNames2 = [legendNames2 {sprintf('BPSK Usuario %d en canal, caso i',i)}];
end

load('ber_sim_3X4_refl_refl.mat','BERUsers')
for i=1:size(BERUsers,1)
    semilogy(snr,BERUsers(i,:),strcat('-r',plotMarkers(i)),'linewidth',2)
    legendNames2 = [legendNames2 {sprintf('BPSK Usuario %d en canal con reflexiones, caso iv',i)}];
end

load('ber_sim_3X4_obs_obs.mat','BERUsers')
for i=1:size(BERUsers,1)
    semilogy(snr,BERUsers(i,:),strcat('-g',plotMarkers(i)),'linewidth',2)
    legendNames2 = [legendNames2 {sprintf('BPSK Usuario %d en canal con obstáculo, caso vi',i)}];
end

ylabel('BER','FontName','CMU Serif')
xlabel('SNR [dB]','FontName','CMU Serif')
ylim([1e-7 1])
grid on
ax = gca; % current axes
ax.FontSize = 16;
ax.FontName = 'CMU Serif';
legend(legendNames2,'FontSize',14,'Location','southwest');

print('ber3x4','-dpng','-r0')

end