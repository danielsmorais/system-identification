%DANIEL SILVA DE MORAIS - 22/11/2019
%DISTANCIA ENTE PONTO E RETA
%[d,x,y]: distancia e ponto de interseccao das retas perpendiculares
%xp e yp: coordenada do ponto
%a e b: parâmetros da reta : y = a*x+b
function [d,x,y] = dpr(xp,yp,a,b)
    if(a==Inf)
        x = xp;
        y = b;
        d = abs(yp-b);
    elseif(b==Inf)
        x = a;
        y = yp;
        d = abs(xp-a);
    else
        x = ((1/a)*xp + yp - b)/(a + 1/a);
        y = a*x+b;    
        d = sqrt((x-xp)^2 + (y-yp)^2);         
    end   
end