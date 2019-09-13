function sBaseBand = baseBand(nUsers,nBits,paddingBits,varargin)

p = inputParser;
addOptional(p,'Seed',0);
parse(p,varargin{:});

seed = p.Results.Seed;

if seed ~= 0
    s = rng(seed,'twister');
end
%%Funcion que genera secuencias de 0 y 1 segun la cantidad de usuarios
%%el numero de bits. 

%Cada fila de la matriz es un usuario
sBaseBand = randi([0,1],nUsers,nBits);
sPaddingBits = ones(nUsers,paddingBits)*NaN;
sBaseBand = [sPaddingBits sBaseBand];

end