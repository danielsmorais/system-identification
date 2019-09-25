// format('v',7)

// for i=1:5 strcat(string(matriz_AIC_ARMAX(i,1:8)/10000),' & ') end


format('v');

for i=1:5
    disp(string(i) + " & " + strcat(string(matriz_AIC_ARX(i,1:8)),' & ') + " \\");
end

for i=1:5
    disp(string(i) + " & " + strcat(string(matriz_AIC_ARMAX(i,1:8)),' & ') + " \\");
end
