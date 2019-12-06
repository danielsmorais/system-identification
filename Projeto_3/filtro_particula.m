% DANIEL SILVA DE MORAIS - 19/11/2019
% FILTRO DE PARTICULAS PARA LOLIZACAO DE VEICULO QUE UTILIZA DADOS DE GPS

opengl('save','hardware')

% Load mapa e dados
mapa = load('mapa.txt');
data = load('dados_GPS_Waze_medidos.txt');

npassos = size(data,1);
NUM_PARTICULA = 20;
NUM_RESAMPLING = 0.95;

%npassos = 10;

% Conjnunto de particulas
% uma particula eh formada por [x y v]
pf = zeros(NUM_PARTICULA, 3);
pfi = zeros(NUM_PARTICULA, 3);
peso = ones(NUM_PARTICULA, 2);

dt = data(2,1)-data(1,1);

% Vetor de estados
% X = [x; y; v]
X = [120, 67, 0];
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
Q = [2^2 0 0;
     0 2^2 0;
     0 0 2^2];
Qv = 2^2;

% Matriz de medicao
H = [1 0 0;
     0 1 0];
 
% Variancia do ruido de medicao
R = [6.7^2 0;
     0 6.9^2];

% Dados filtrados
% 3 colunas = x y v
filtr = zeros(npassos,3);


% Fase de predicao   
for k = 1:NUM_PARTICULA
    %saber o peso e theta da rua  
    pfi(k,1) = X(1) + Qv*randn;
    pfi(k,2) = X(2) + Qv*randn;
    pfi(k,3) = X(3) + Qv*randn;     
end

pf = pfi;

figure(1)


for i=1:npassos
    
    % Fase de predicao   
    for k = 1:NUM_PARTICULA
        
        %saber o peso e theta da rua  
        pf(k,1) = X(1) + Qv*randn;
        pf(k,2) = X(2) + Qv*randn;
        pf(k,3) = X(3) + Qv*randn;     
    end
    
    % Medicao GPS
    Y = [data(i,2); data(i,3)];
       
    % Fase de atualizacao
    for k = 1:NUM_PARTICULA             
        peso(k,1) = 1/sqrt((pf(k,1)-Y(1))^2 + (pf(k,2)-Y(2))^2);
    end
    
    % Normalizacao dos pesos
    peso(:,1) = peso(:,1)./sum(peso(:,1));    
    
    % resample com novas particulas    
    [val, ind] = sort(peso(:,1));   %depois voltar AQUI para ajustar o id da rua.
    
    l% ordenacao por peso. As ultimas posicoes sao mais bem avaliadas
    pf = pf(ind,:);
    peso = peso(ind,:);
     
    % pega 95% melhores, os 5% são da combinacao inicial
    
    
       
    
    
    % salva os pontos
    filtr(i,1) = X(1);
    filtr(i,2) = X(2);
    filtr(i,3) = X(3);
    
    if i~=1
        
        v = [v; sqrt((filtr(i,2)-filtr(i-1,2))^2 + (filtr(i,1)-filtr(i-1,1))^2)/dt];
    else
        v = X(3);
    end   
    
    plot(pf(:,1),pf(:,2),'.b')
    legend('FP')  
    set(gca,'xtick',[110:5:155])
    set(gca,'ytick',[47:5:85])
    axis equal
    axis([110 155 47 85])
    hold off
    
    pause(0.001)
    
end    
 

% suposiao que as partaculas estao no centro da rua, sempre.
% aplicar conceitos de genetica
% 


figure(2)
subplot(1,2,1);
desenha_mapa(mapa);
hold on
plot(data(:,2),data(:,3),'.r')
title('Deslocamento de Veiculo - GPS')

legend('GPS')
set(gca,'xtick',[110:5:155])
set(gca,'ytick',[47:5:85])
axis equal
axis([110 155 47 85])

subplot(1,2,2);
desenha_mapa(mapa);
hold on
plot(filtr(:,1),filtr(:,2),'r')
title('Deslocamento de Veiculo - FK')

legend('FP','GPS')
set(gca,'xtick',[110:5:155])
set(gca,'ytick',[47:5:85])
axis equal
axis([110 155 47 85])







