function desenha_mapa(mapa)
    for i=1:37
        line([mapa(i,2) mapa(i,3)],[mapa(i,3) mapa(i,4)]);
    end
end