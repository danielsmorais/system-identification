function [dmin, rua] = posicao(pf,peso,matrizadj,ve)
    tam = size(matrizadj,1);
    rua = [0 0]; %vertices da rua
    dmin = 1000; %menor distância entre a particula e a rua
    
    for i=1:tam
        for j=1:tam    
            if(matrizadj(i,j)==1)
                [a,b] = param_reta(ve(i,1),ve(i,2),ve(j,1),ve(j,2));
                [d,x,y] = dpr(pf(1,1),pf(1,2),a,b);
                
                %verificar limites alguma coisa quando eh para outro
                %lado... -?
                
                dx = ve(j,1)-ve(i,1);  % x2 - x1
                dy = ve(j,2)-ve(i,2);  % y2 - y1
                
                lx = -1; %x logico
                ly = -1; %y logico
                
                if dx >= 0                
                    if x >= ve(i,1) && x <= ve(j,1)
                        disp('x dentro do limite');
                        lx = 1;
                    else
                        disp('x fora do limite');
                        lx = 0;
                    end
                else
                    if x <= ve(i,1) && x >= ve(j,1)
                        disp('x dentro do limite');
                        lx = 1;
                    else
                        disp('x fora do limite');
                        lx = 0;
                    end                  
                end
                
                if dy >= 0                
                    if y >= ve(i,2) && y <= ve(j,2)
                        disp('y dentro do limite');
                        ly = 1;
                    else
                        disp('y fora do limite');
                        ly = 0;
                    end
                else
                    if y <= ve(i,2) && y >= ve(j,2)
                        disp('y dentro do limite');     
                        ly = 1;
                    else
                        disp('y fora do limite');
                        ly = 0;
                    end                  
                end
                
                if lx==1 && ly==1
                    %verificar min
                    if d<dmin
                        dmin = d;
                        rua = [i j];
                    end                
                end
            end
%             disp(dmin)
%             disp(rua)
%             disp('----------------')
        end   
    end
end