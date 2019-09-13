cd ..
cd mmTrace 
setup
cd ..
% Agrega y revisa directorios necesarios
try
    cd functions
    imports
    cd ..
catch exception
    disp('La carpeta Herramientas y sus archivos no estan presentes. Programa abortado por falta de dependencias.')
    exit()
end

cd correlation_sims
