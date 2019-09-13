function sBaseBand = baseBandBERWithSeed(nUsers,nBits,seed)

if seed ~= 0
    s = rng(seed,'twister');
end
%%Funcion que genera secuencias de 0 y 1 segun la cantidad de usuarios
%%el numero de bits. 

%Cada fila de la matriz es un usuario
sBaseBand = randi([0,1],nUsers,nBits);

end