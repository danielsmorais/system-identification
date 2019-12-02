% DANIEL SILVA DE MORAIS - 19/11/2019
% FILTRO DE PARTICULAS PARA LOLIZACAO DE VEICULO QUE UTILIZA DADOS DE GPS

opengl('save','hardware')

% Load mapa e dados
mapa = load('mapa.txt');
data = load('dados_GPS_Waze_medidos.txt');

npassos = size(data,1);
NUM_PARTICULA = 100;    

% Conjnunto de particulas
% uma particula eh formada por [x y v]
particula = zeros(NUM_PARTICULA, 3);
peso = zeros(NUM_PARTICULA, 2);

dt = data(2,1)-data(1,1);

% Vetor de estados
% X = [x; y; v]
X = [120; 67; 0];
% Matriz de transicao
% Xk+1 = PHI*Xk + u
theta = 0;
PHI = [1 0 cos(theta)*dt;
       0 1 sin(theta)*dt;
       0 0 1];
% Variancia da estimativa
% Inicialmente nula pois a condicao inicial eh conhecida
P = [0 0 0; 
     0 0 0;
     0 0 0];
 
% Variancia do ruido dinamico
Q = [0.5^2 0 0;
     0 0.5^2 0;
     0 0 0.5^2]*0.6;
Qv = 0.5^2*0.6;

% Matriz de medicao
H = [1 0 0;
     0 1 0];
 
% Variancia do ruido de medicao
R = [6.7^2 0;
     0 6.9^2];

 % Dados filtrados
% 3 colunas = x y v
filtr = zeros(npassos,3);

figure(2)
 
for i=1:npassos
    
    % Fase de predicao   
    for k = 1:NUM_PARTICULA
        
        %saber o peso e theta da rua
  
        particula(k,1) = X(1) + Qv*randn;
        particula(k,2) = X(2) + Qv*randn;
        particula(k,3) = X(3) + Qv*randn;
        %peso(k,1) = peso(k,1)/sum();
    end
    
    % Medicao GPS
    Y = [data(i,2); data(i,3)];
    
    
    % Fase de correcao 
    for k = 1:NUM_PARTICULA             
        particula(k,1) = 
        particula(k,2) = X(2);
        particula(k,3) = X(3);
    end  
    
    
    % salva os pontos
    filtr(i,1) = X(1,1);
    filtr(i,2) = X(2,1);
    filtr(i,3) = X(3,1);
    
    if i~=1
        
        v = [v; sqrt((filtr(i,2)-filtr(i-1,2))^2 + (filtr(i,1)-filtr(i-1,1))^2)/dt];
    else
        v = X(3,1);
    end   
    
    plot(particula(:,1),particula(:,2),'.r');
    hold on
    pause(0.001)
    
end    
 

% suposiao que as partaculas estao no centro da rua, sempre.
% aplicar conceitos de genetica
% 


figure(1)
subplot(1,2,1);
desenha_mapa(mapa);
hold on
plot(data(:,2),data(:,3),'.r')
title('Deslocamento de Veiculo - GPS')

subplot(1,2,2);
desenha_mapa(mapa);
hold on
plot(filtr(:,1),filtr(:,2),'r')
title('Deslocamento de Veiculo - FK')




