function postionsPlot(h,users,antennas,spaceSize)

figure(h)
hold on
plot(users(:,1)-spaceSize/2,users(:,2)-spaceSize/2,'ro')
plot(antennas(:,1)-spaceSize/2,antennas(:,2)-spaceSize/2,'b*')
hold off
legend('Usuarios','Antenas')
xlim([0 spaceSize]-spaceSize/2)
ylim([0 spaceSize]-spaceSize/2)

[nAntennas,~] = size(antennas);
[nUsers,~] = size(users);
for i=1:nAntennas
    text(antennas(i,1)-spaceSize/2,antennas(i,2)-spaceSize/2,sprintf('Ant %d',i));
end
for i=1:nUsers
    text(users(i,1)-spaceSize/2,users(i,2)-spaceSize/2,sprintf('User %d',i));
end
end