function pf = limiteparticula(pf,matrizadj,vert)

    
    % pf particula
    % ve vertices que a particula se encontra [ve1; ve2] 
    
    ve = [vert(pf(4),:); vert(pf(5),:)];
    
    [a,b] = param_reta(ve(1,1),ve(1,2),ve(2,1),ve(2,2));
    [d,x,y] = dpr(pf(1,1),pf(1,2),a,b);

    dx = ve(2,1)-ve(1,1);  % x2 - x1
    dy = ve(2,2)-ve(1,2);  % y2 - y1

    lx = -1; %x logico
    ly = -1; %y logico
    foralimx = 0; % fora do limite... para esquerda ou direita, cima ou baixo?
    foralimy = 0; % fora do limite... para esquerda ou direita, cima ou baixo?

    if dx >= 0                
        if (x >= ve(1,1)) && (x <= ve(2,1))
            %disp('x dentro do limite 1');
            lx = 1;
        else
            %disp('x fora do limite 2');
            lx = 0;
            
            if (x > ve(2,1)) && (ve(2,1) >= ve(1,1))
                foralimx = 2;  %fora pelo segundo vertice
            else
                foralimx = 1;  %fora pelo primeiro vertice 
            end
        end
    else
        if x <= ve(1,1) && x >= ve(2,1)
            %disp('x dentro do limite 3');
            lx = 1;
        else
            %disp('x fora do limite 4');
            lx = 0;
            
            if (x < ve(2,1)) && (ve(2,1) <= ve(1,1))
                foralimx = 2;   %fora pelo primeiro vertice
            else
                foralimx = 1;   %fora pelo segundo vertice
            end            
        end                  
    end

    if dy >= 0                
        if y >= ve(1,2) && y <= ve(2,2)
            %disp('y dentro do limite 5');
            ly = 1;
        else
            %disp('y fora do limite 6');
            ly = 0;
            
            if (y > ve(2,2)) && (ve(2,2) >= ve(1,2))
                foralimy = 2;   %fora pelo segundo vertice
            else
                foralimy = 1;   %fora pelo primeiro vertice
            end            
        end
    else
        if y <= ve(1,2) && y >= ve(2,2)
            %disp('y dentro do limite 7');     
            ly = 1;
        else
            %disp('y fora do limite 8');
            ly = 0;
            
            if (y < ve(2,2)) && (ve(2,2) <= ve(1,2))
                foralimy = 2;    %fora pelo primeiro vertice
            else
                foralimy = 1;    %fora pelo segundo vertice
            end      
        end                  
    end

    vesaida = 0;
    if lx==1 && ly==1
        disp('dentro do limite');
        
        pf(1) = x;
        pf(2) = y;
            
    else
        disp('fora do limite');
        
        % CALCULAR AS NOVAS POSICOES E VERTICES PARA A PARTICULA
        
        if foralimx == 1 && foralimy == 0
            vesaida = 1;
        elseif foralimx == 2 && foralimy == 0
            vesaida = 2;
        elseif foralimx == 0 && foralimy == 1
            vesaida = 1;
        elseif foralimx == 0 && foralimy == 2
            vesaida = 2;
        elseif foralimx == 1 && foralimy == 1
            vesaida = 1;
        elseif foralimx == 2 && foralimy == 2
            vesaida = 2;
        end
        
        if vesaida == 1  
            %vesaida == 1
            ra = randsample(setdiff(1:size(matrizadj,1), pf(4)), 1);
            while(ra==0)
                ra = randsample(setdiff(1:size(matrizadj,1), pf(4)), 1);
            end
            
            [a,b] = param_reta(vert(pf(5),1),vert(pf(5),2),vert(ra,1),vert(ra,2));
            [d,x,y] = dpr(pf(1),pf(2),a,b);
            
            pf(1) = x;
            pf(2) = y;
            pf(4) = pf(5);
            pf(5) = ra;


        else
            %vesaida == 2
            ra = randsample(setdiff(1:size(matrizadj,1), pf(5)), 1);
            while(ra==0)
                ra = randsample(setdiff(1:size(matrizadj,1), pf(5)), 1);
            end      
            
            [a,b] = param_reta(vert(pf(4),1),vert(pf(4),2),vert(ra,1),vert(ra,2));
            [d,x,y] = dpr(pf(1),pf(2),a,b);
            
            pf(1) = x;
            pf(2) = y;
            pf(4) = pf(4);            
            pf(5) = ra;             

        end
    end
    
    
%     fprintf('forax = %.4f foray = %.4f\n', foralimx, foralimy);
%     fprintf('x = %.4f y = %.4f\n', x, y);
% 
%     f = 1;

end