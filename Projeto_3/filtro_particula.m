% DANIEL SILVA DE MORAIS - 19/11/2019
% FILTRO DE PARTICULAS PARA LOCALIZACAO DE VEICULO QUE UTILIZA DADOS DE GPS

opengl('save','hardware')

% Load mapa e dados
mapa = load('mapa.txt');
data = load('dados_GPS_Waze_medidos.txt');
%grafo= load('G.mat');
%G = grafo.G;
matrizadj = load('matriz_adj.mat');
matrizadj = matrizadj.matriz_adj;
vertice = load('vertice.mat');
vertice = vertice.vertice;
angr = load('angrua.mat');
angr = angr.angrua;

NPASSOS = size(data,1);
NPARTICULA = 50;
NRESAMPLING = 0.90;

%npassos = 10;

% Conjnunto de particulas
% uma particula eh formada por [x y v v1 v2]
pf = zeros(NPARTICULA, 5);
pfgps = zeros(1, 5);
pfi = zeros(NPARTICULA, 5);
peso = ones(NPARTICULA, 1); %[w]
%pesoant = ones(NPARTICULA, 1); %[w]
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


% GERACAO DAS PARTICULAS
for k = 1:NPARTICULA
    pfi(k,1) = X(1) + 15 + Qv*25*randn*1.5; %x
    pfi(k,2) = X(2) + Qv*25*randn; %y
    pfi(k,3) = X(3) + Qv*25*randn; %v
    
    pfi(k,:) = initparticula(pfi(k,:),matrizadj,vertice);
end

peso = peso/NPARTICULA;

pf = pfi;

pfgps(1) = pfi(1);
pfgps(2) = pfi(2);
pfgps(4) = 11;
pfgps(5) = 12;

figure(1)

for i=1:NPASSOS
    
    % PREDICAO
    for k = 1:NPARTICULA 
        ang = angrua(pf(k,4),pf(k,5),angr);
        pf(k,1) = pf(k,1) + pf(k,3)*cosd(ang)*dt;    %x 
        pf(k,2) = pf(k,2) + pf(k,3)*sind(ang)*dt;    %y
        pf(k,3) = pf(k,3) + randn;                %v   
        
        %pf(k,:) = initparticula(pf(k,:),matrizadj,vertice);
    end
    
    % MEDICAO
    GPS = [data(i,2); data(i,3)];
        
    pfgps(1) = GPS(1);
    pfgps(2) = GPS(2);

    %pfgps = limiteparticula(pfgps,matrizadj,vertice)
    
       
    % ATUZALIZACAO DOS PESOS
    for k = 1:NPARTICULA             
        peso(k,1) = 1/sqrt((pf(k,1)-pfgps(1))^2 + (pf(k,2)-pfgps(2))^2);
    end
    
    % NORMALIZACAO DOS PESOS
    peso = peso./sum(peso);      
        
    % RESSAMPLE
  
    % --- Ordencacao das particulas por peso. Os primeiros pesos sao os mais bem avaliados. 
    [val, ind] = sort(peso); % TODO depois voltar AQUI para ajustar o id da rua.
    pf = pf(ind,:);
    peso = peso(ind);
    
    plot(pf(:,1),pf(:,2),'.g','MarkerSize',10)
    
    hold on   
    
     
    % --- pega 95% melhores particulas e os 5% da combinacao inicial.
    % TODO voltar a utilizar os 5%.
    % --- roleta
    
    pf(1:ceil(NPARTICULA*(1-NRESAMPLING)),:) = pfi(randperm(NPARTICULA,ceil(NPARTICULA*(1-NRESAMPLING))),:);
    
    [pf, peso] = roleta(pf,pfi,peso); 
    
%     Xc = mean(pf(:,1));
%     Yc = mean(pf(:,2));    
%     pose = [pose; Xc Yc];
%     %plot(G,'XData',G.Nodes.x,'YData',G.Nodes.y)    
%     plot(pose(:,1),pose(:,2),'k');
    
        
    %-----------------------------------------------------------------
    %plot(G,'XData',G.Nodes.x,'YData',G.Nodes.y)
    desenha_mapa(mapa);
    hold on
    plot(data(1:i,2), data(1:i,3),'.y','MarkerSize',10)
    plot(pf(:,1),pf(:,2),'.r','MarkerSize',10)
    %plot(pfgps(1), pfgps(2),'.c')
    hold off

    set(gca,'xtick',[110:5:155])
    set(gca,'ytick',[47:5:85])
    axis equal
    axis([110 155 47 85])
    
    pause(0.0001)
    
    disp(i);
    
end    
 

% suposiao que as partaculas estao no centro da rua, sempre.
% aplicar conceitos de genetica
% 


% figure(2)
% subplot(1,2,1);
% desenha_mapa(mapa);
% hold on
% plot(data(:,2),data(:,3),'.r')
% title('Deslocamento de Veiculo - GPS')
% 
% legend('GPS')
% set(gca,'xtick',[110:5:155])
% set(gca,'ytick',[47:5:85])
% axis equal
% axis([110 155 47 85])
% 
% subplot(1,2,2);
% desenha_mapa(mapa);
% hold on
% plot(filtr(:,1),filtr(:,2),'r')
% title('Deslocamento de Veiculo - FK')
% 
% legend('FP','GPS')
% set(gca,'xtick',[110:5:155])
% set(gca,'ytick',[47:5:85])
% axis equal
% axis([110 155 47 85])





%plot(G,'XData',G.Nodes.x,'YData',G.Nodes.y,'EdgeLabel',G.Edges.Weight)

