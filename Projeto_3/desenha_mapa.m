function desenha_mapa(mapa)
    for i=1:size(mapa,1)
        line([mapa(i,2) mapa(i,4)],[mapa(i,3) mapa(i,5)]);
    end    
    axis equal
    xlabel('x');
    ylabel('y');
    %title('Deslocamento de Veiculo')
end