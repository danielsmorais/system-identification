function [a,b] = param_reta(x1,y1,x2,y2)

    if(x1==x2)
        a = x1;
        b = Inf;
    elseif(y1==y2)
        a = Inf;
        b = y1;   
    else
        a = (y2-y1)/(x2-x1);
        b = -y1/(a*x1);        
    end
    
    %vamos considerar que nao ha coordenadas negativas e nem próximas de zero.
end