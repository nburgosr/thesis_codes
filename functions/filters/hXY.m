function  filter = hXY(p1,p2,Fc,n,oversamplingFactor)

    %Parametros
    d = distance(p1,p2); %distance
    lambda = physconst('LightSpeed')/Fc;
    freeSpaceLoss = fspl(d,lambda);
    tau_xy = d/physconst('LightSpeed'); %gap
    gap = round(tau_xy*Fc*oversamplingFactor);
    filter = zeros(1,n);
    filter(gap) = db2mag(-2*freeSpaceLoss);

end