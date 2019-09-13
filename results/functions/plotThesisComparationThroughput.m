function plotThesisComparationThroughput()

R = 1000;

legendNames = cell(1);
legendNames2 = cell(1);
load('ber_sim_1X1.mat')

mainFigure = figure('units','normalized','outerposition',[0 0 1 1]);
mainFigure2 = figure('units','normalized','outerposition',[0 0 1 1]);

figure(mainFigure)
snr = eval('snr');
BERTh = eval('BERTh');
BERTh = R*(1-BERTh);
BERUsers = eval('BERUsers');
BERUsers = R*(1-BERUsers);

plot(snr,BERTh,'-x','linewidth',2)
legendNames(1) = {'BPSK Teórico'};
hold on

plot(snr,BERUsers,'-x','linewidth',2)
legendNames = [legendNames {'BPSK Usuario solitario en espacio libre'}];

load('ber_sim_1X1_refl.mat')
snr = eval('snr');
BERUsers = eval('BERUsers');
BERUsers = R*(1-BERUsers);
plot(snr,BERUsers,'-x','linewidth',2)
legendNames = [legendNames {'BPSK Usuario solitario en canal con reflexiones'}];

load('ber_sim_1X1_obs.mat')
snr = eval('snr');
BERUsers = eval('BERUsers');
BERUsers = R*(1-BERUsers);
plot(snr,BERUsers,'-x','linewidth',2)
legendNames = [legendNames {'BPSK Usuario solitario en canal con obstaculos'}];

ylabel('Throughput [Gbps]','FontName','CMU Serif')
xlabel('Eb/No [dB]','FontName','CMU Serif')
grid on
ax = gca; % current axes
ax.FontSize = 16;
ax.FontName = 'CMU Serif';
legend(legendNames,'FontSize',14,'Location','southwest');

print('speed1x1','-dpng','-r0')

%%
figure(mainFigure2)

BERTh = R*(1-BERTh);
plot(snr,BERTh,'-x','linewidth',2)
legendNames2(1) = {'Throughput Teórico'};
hold on

load('ber_sim_3X4.mat')
snr = eval('snr');
BERUsers = eval('BERUsers');
BERUsers = R*(1-BERUsers);
for i=1:size(BERUsers,1)
    plot(snr,BERUsers(i,:),'-x','linewidth',2)
    legendNames2 = [legendNames2 {sprintf('BPSK Usuario %d',i)}];
end

ylabel('Throughput [Gbps]','FontName','CMU Serif')
xlabel('Eb/No [dB]','FontName','CMU Serif')
grid on
ax = gca; % current axes
ax.FontSize = 16;
ax.FontName = 'CMU Serif';
legend(legendNames2,'FontSize',14,'Location','southwest');

print('speed3x4','-dpng','-r0')


end