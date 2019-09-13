function boolean = intersection(axy,pxy,vSegment1,vSegment2)

%Calculo de pendiente y coeficiente para recta entre antena y usuario
[m1,n1] = lineEquation(axy,pxy);

%Calculo de pendiente y coeficiente para la recta que contiene el segmento
[m2,n2] = lineEquation(vSegment1,vSegment2);

%Probar si las rectas son paralelas
if m1 == m2
    boolean = logical(0); 
else
    x = (m1*axy(1)-m2*vSegment1(1)+vSegment1(2)-axy(2))/(m1-m2);
    y = m1*x+n1;
    
    if inSegment(vSegment1,vSegment2,x,y) && inSegment(axy,pxy,x,y)
        boolean = logical(1);
    else
        boolean = logical(0);
    end
end
end

function [m,n] = lineEquation(xy1,xy2)
    
m = (xy2(2)-xy1(2))/(xy2(1)-xy1(1));
n = xy2(2)-m*xy2(1);

end

function inside = inSegment(vSegment1,vSegment2,x,y)

%Verificacion de punto en el segmento
xMax = max(vSegment1(1),vSegment2(1));
xMin = min(vSegment1(1),vSegment2(1));
yMax = max(vSegment1(2),vSegment2(2));
yMin = min(vSegment1(2),vSegment2(2));

%Si esta inside de los limites entonces esta en el segmento
    if x <= xMax && x >= xMin && y <= yMax && y >= yMin
        inside = logical(1);
    else
        inside = logical(0);
    end

end

