function [newpf, newpeso] = roleta(pf,pfi,peso)

    % Ajuste dos pesos para inteiro.
    peso = fix(peso/min(peso));
    % Soma dos pesos.
    somapeso = sum(peso(:));
    
    newpf = zeros(size(pf));
    newpeso = zeros(size(peso));
    
    for k=1:size(pf,1)
        
        % Sorteio de um valor entre 1 e somapeso.
        sorteio = randi(somapeso);
        % Indice no vetor de pesos
        ind = 0;
        
        while true
           ind = ind + 1; 
           sorteio = sorteio - peso(ind,1);
           if ~(sorteio>0)
               break;
           end
        end
        
        newpf(k,:) = pf(ind,:);
        newpeso(k,:) = peso(ind,:);
    end
end

%http://programadoraprendendo.blogspot.com/2012/12/algoritmos-de-selecao-metodo-da-roleta.html
%https://www.obitko.com/tutorials/genetic-algorithms/portuguese/selection.php


