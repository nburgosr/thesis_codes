function plotThesisComparationBER()

legendNames = cell(1);
legendNames2 = cell(1);
legendNames3 = cell(1);
plotMarkers = 'o+xsd^v><ph.*';                                              % Marcadores para graficas
load('ber_sim_1X1_ideal_ideal.mat','snr','BERUsers','alfa','SNR')

mainFigure = figure('units','normalized','outerposition',[0 0 1 1]);
mainFigure2 = figure('units','normalized','outerposition',[0 0 1 1]);
mainFigure3 = figure('units','normalized','outerposition',[0 0 1 1]);

BERTh=(1/2)*erfc(sqrt(SNR/((1+alfa)/2))); 

figure(mainFigure)
semilogy(snr,BERTh,'-x','linewidth',2)
legendNames(1) = {'BPSK Teórico'};
hold on

semilogy(snr,BERUsers,'-x','linewidth',2)
legendNames = [legendNames {'BPSK Usuario solitario en canal ideal estima ideal'}];

load('ber_sim_1X1_ideal_refl.mat','BERUsers')
semilogy(snr,BERUsers,'-x','linewidth',2)
legendNames = [legendNames {'BPSK Usuario solitario en canal con reflexiones estima ideal'}];

load('ber_sim_1X1_ideal_obs.mat','BERUsers')
semilogy(snr,BERUsers,'-x','linewidth',2)
legendNames = [legendNames {'BPSK Usuario solitario en canal con obstaculo estima ideal'}];

load('ber_sim_1X1_refl_refl.mat','BERUsers')
semilogy(snr,BERUsers,'-x','linewidth',2)
legendNames = [legendNames {'BPSK Usuario solitario en canal con reflexiones estima reflexiones'}];

load('ber_sim_1X1_refl_obs.mat','BERUsers')
semilogy(snr,BERUsers,'-x','linewidth',2)
legendNames = [legendNames {'BPSK Usuario solitario en canal con obstaculos estima reflexiones'}];

load('ber_sim_1X1_obs_obs.mat','BERUsers')
semilogy(snr,BERUsers,'-x','linewidth',2)
legendNames = [legendNames {'BPSK Usuario solitario en canal con obstaculos estima obstaculos'}];


ylabel('BER','FontName','CMU Serif')
xlabel('SNR [dB]','FontName','CMU Serif')
grid on
ax = gca; % current axes
ax.FontSize = 16;
ax.FontName = 'CMU Serif';
legend(legendNames,'FontSize',14,'Location','southwest');

print('ber1x1','-dpng','-r0')

%%
figure(mainFigure2)

semilogy(snr,BERTh,'-x','linewidth',2)
legendNames2(1) = {'BPSK Teórico'};
hold on

load('ber_sim_3X4_ideal_ideal.mat','BERUsers')
for i=1:size(BERUsers,1)
    semilogy(snr,BERUsers(i,:),'-x','linewidth',2)
    legendNames2 = [legendNames2 {sprintf('BPSK Usuario %d ideal ideal',i)}];
end

load('ber_sim_3X4_ideal_refl.mat','BERUsers')
for i=1:size(BERUsers,1)
    semilogy(snr,BERUsers(i,:),'-x','linewidth',2)
    legendNames2 = [legendNames2 {sprintf('BPSK Usuario %d en canal con reflexiones estima ideal',i)}];
end

load('ber_sim_3X4_ideal_refl.mat','BERUsers')
for i=1:size(BERUsers,1)
    semilogy(snr,BERUsers(i,:),'-x','linewidth',2)
    legendNames2 = [legendNames2 {sprintf('BPSK Usuario %d en canal con obstaculos estima ideal',i)}];
end

load('ber_sim_3X4_refl_refl.mat','BERUsers')
for i=1:size(BERUsers,1)
    semilogy(snr,BERUsers(i,:),'-x','linewidth',2)
    legendNames2 = [legendNames2 {sprintf('BPSK Usuario %d en canal con reflexiones estima reflexiones',i)}];
end

load('ber_sim_3X4_refl_obs.mat','BERUsers')
for i=1:size(BERUsers,1)
    semilogy(snr,BERUsers(i,:),'-x','linewidth',2)
    legendNames2 = [legendNames2 {sprintf('BPSK Usuario %d en canal con obstaculos estima reflexiones',i)}];
end

load('ber_sim_3X4_obs_obs.mat','BERUsers')
for i=1:size(BERUsers,1)
    semilogy(snr,BERUsers(i,:),'-x','linewidth',2)
    legendNames2 = [legendNames2 {sprintf('BPSK Usuario %d en canal con obstaculos estima obstaculos',i)}];
end

ylabel('BER','FontName','CMU Serif')
xlabel('SNR [dB]','FontName','CMU Serif')
grid on
ax = gca; % current axes
ax.FontSize = 16;
ax.FontName = 'CMU Serif';
legend(legendNames2,'FontSize',14,'Location','southwest');

print('ber3x4','-dpng','-r0')

%%
figure(mainFigure3)
semilogy(snr,BERTh,'-x','linewidth',2)
legendNames3(1) = {'BPSK Teórico'};
hold on

% load('ber_sim_4X4_ideal_ideal.mat','BERUsers')
% for i=1:size(BERUsers,1)
%     semilogy(snr,BERUsers(i,:),'-x','linewidth',2)
%     legendNames3 = [legendNames3 {sprintf('BPSK Usuario %d ideal ideal',i)}];
% end

% load('ber_sim_4X4_ideal_refl.mat','BERUsers')
% for i=1:size(BERUsers,1)
%     semilogy(snr,BERUsers(i,:),'-x','linewidth',2)
%     legendNames3 = [legendNames3 {sprintf('BPSK Usuario %d ideal refl',i)}];
% end
% 
% load('ber_sim_4X4_ideal_obs.mat','BERUsers')
% for i=1:size(BERUsers,1)
%     semilogy(snr,BERUsers(i,:),'-x','linewidth',2)
%     legendNames3 = [legendNames3 {sprintf('BPSK Usuario %d ideal obs',i)}];
% end
% 
% load('ber_sim_4X4_refl_refl.mat','BERUsers')
% for i=1:size(BERUsers,1)
%     semilogy(snr,BERUsers(i,:),'-x','linewidth',2)
%     legendNames3 = [legendNames3 {sprintf('BPSK Usuario %d refl refl',i)}];
% end
% 
% load('ber_sim_4X4_refl_obs.mat','BERUsers')
% for i=1:size(BERUsers,1)
%     semilogy(snr,BERUsers(i,:),'-x','linewidth',2)
%     legendNames3 = [legendNames3 {sprintf('BPSK Usuario %d refl obs',i)}];
% end

load('ber_sim_4X4_ideal_ideal.mat','BERUsers')
for i=1:size(BERUsers,1)
    semilogy(snr,BERUsers(i,:),'-x','linewidth',2)
    legendNames3 = [legendNames3 {sprintf('BPSK Usuario %d obs obs',i)}];
end

ylabel('BER','FontName','CMU Serif')
xlabel('SNR [dB]','FontName','CMU Serif')
grid on
ax = gca; % current axes
ax.FontSize = 16;
ax.FontName = 'CMU Serif';
legend(legendNames3,'FontSize',14,'Location','southwest');

print('ber4x4','-dpng','-r0')

end