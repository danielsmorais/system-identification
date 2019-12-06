% DANIEL SILVA DE MORAIS - 19/11/2019
% FILTRO DE PARTICULAS PARA LOLIZACAO DE VEICULO QUE UTILIZA DADOS DE GPS

opengl('save','hardware')

% Load mapa e dados
mapa = load('mapa.txt');
data = load('dados_GPS_Waze_medidos.txt');

NPASSOS = size(data,1);
NPARTICULA = 20;
NRESAMPLING = 0.95;

%npassos = 10;

% Conjnunto de particulas
% uma particula eh formada por [x y v]
pf = zeros(NPARTICULA, 3);
pfi = zeros(NPARTICULA, 3);
peso = ones(NPARTICULA, 2);
pose = [];

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
Qv = 0.5^2;

% Matriz de medicao
H = [1 0 0;
     0 1 0];
 
% Variancia do ruido de medicao
R = [6.7^2 0;
     0 6.9^2];

% Dados filtrados
% 3 colunas = x y v
filtr = zeros(NPASSOS,3);


% Fase de predicao   
for k = 1:NPARTICULA
    %saber o peso e theta da rua  
    pfi(k,1) = X(1) + Qv*10*randn;
    pfi(k,2) = X(2) + Qv*10*randn;
    pfi(k,3) = X(3) + Qv*10*randn;     
end

pf = pfi;

figure(1)


for i=1:NPASSOS
    
    % PREDICAO
    for k = 1:NPARTICULA        
        %saber o peso e theta da rua  
        pf(k,1) = pf(k,1) + Qv*randn;
        pf(k,2) = pf(k,2) + Qv*randn;
        pf(k,3) = pf(k,3) + Qv*randn;     
    end
    
    % MEDICAO
    Y = [data(i,2); data(i,3)];
       
    % ATUZALIZACAO DOS PESOS
    for k = 1:NPARTICULA             
        peso(k,1) = 1/sqrt((pf(k,1)-Y(1))^2 + (pf(k,2)-Y(2))^2);
    end
    
    % NORMALIZACAO DOS PESOS
    peso(:,1) = peso(:,1)./sum(peso(:,1));      
        
    % RESSAMPLE
  
    % --- Ordencacao das particulas por peso. Os primeiros pesos sao os mais bem avaliados. 
    [val, ind] = sort(peso(:,1)); % TODO depois voltar AQUI para ajustar o id da rua.
    pf = pf(ind,:);
    peso = peso(ind,:);
    
    
    plot(pf(:,1),pf(:,2),'.g')
    hold on   
    
     
    % --- pega 95% melhores particulas e os 5% da combinacao inicial.
    % TODO voltar a utilizar os 5%.
    % --- roleta
    [pf, peso] = roleta(pf,peso); 
    
    Xc = mean(pf(:,1));
    Yc = mean(pf(:,2));    
    pose = [pose; Xc Yc];
    
    plot(pose(:,1),pose(:,2),'k')
   
    % salva os pontos
%     filtr(i,1) = X(1);
%     filtr(i,2) = X(2);
%     filtr(i,3) = X(3);
%     
%     if i~=1
%         
%         v = [v; sqrt((filtr(i,2)-filtr(i-1,2))^2 + (filtr(i,1)-filtr(i-1,1))^2)/dt];
%     else
%         v = X(3);
%     end   
    
    plot(pf(:,1),pf(:,2),'.r')
    hold off
    legend('FP')  
    set(gca,'xtick',[110:5:155])
    set(gca,'ytick',[47:5:85])
    axis equal
    axis([110 155 47 85])
    
    pause(0.00001)
    
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







