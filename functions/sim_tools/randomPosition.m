function positions = randomPosition(n,distribution,size,seed,option)
if option
    s = rng(seed);
end
%%Funcion que genera una posicion x,y segun el size del espacio de
%%simulacion. 

positions = zeros(n,2);

switch distribution
    case 'uniforme'
        positions = rand(n,2)*size;
        positions = floor(positions*10)/10; %Limita el delta de variacion
    otherwise
        disp('distribution no soportada');
end

end