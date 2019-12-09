function pf = initparticula(pf,matrizadj,ve)
    %pf: particula
    %matrizadj: matriz de adjacencia
    %ve: matriz de vertices na ordem

    tam = size(matrizadj,1);
    rua = [0 0]; %vertices da rua
    dmin = 1000; %menor distancia entre a particula e a rua
    pose = [0 0];
    
    for i=1:tam
        for j=1:tam    
            if(matrizadj(i,j)==1)
                [a,b] = param_reta(ve(i,1),ve(i,2),ve(j,1),ve(j,2));
                [d,x,y] = dpr(pf(1),pf(2),a,b);
                
                if(d < dmin)
                    dmin = d;
                    rua = [i j];
                    pose = [x y];
                end                
            end
        end
    end
    
    pf(1) = pose(1);
    pf(2) = pose(2);
    pf(4) = rua(1);
    pf(5) = rua(2);
    
    disp(rua);

end