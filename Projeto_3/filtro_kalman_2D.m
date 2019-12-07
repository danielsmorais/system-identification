opengl('save','hardware')

%Filtra os dados do GPS 1D
% Armazena a pasta atual
OLDDIR=pwd();
% Pasta de leitura dos arquivos
DATADIR=OLDDIR;

if (~chdir(DATADIR))
    error('Folder does not exist');
end

% Arquivo com as medicoes
%FILE='dados_GPS_2D_medidos.txt';
FILE = 'dados_GPS_Waze_medidos.txt';
% Leitura dos dados
% 3 colunas = t x y
data = dlmread(FILE);
npassos = size(data,1);
deltaT = data(2,1)-data(1,1);


%---------------------------------------------------------------------
% FAZER OS TESTES VARIANDO O RU�?DO DINÂMICO, POIS O RUIDO DO SENSOR É
% CONHECIDO OU PODE ESTIMAR. CALULAR O DESVIO PADRÃO DAS AMOSTRAS...
%---------------------------------------------------------------------

% Vetor de estados
% X = [x; y; theta; v; w]
X = [120; 67; 0; 0; 0];  
  
% Variancia da estimativa
% Inicialmente nula pois a condicao inicial eh conhecida
P = zeros(5);
% Variancia do ruido dinamico
Q = diag([1 1 0.01 0.0001 0.00001])*0.5;
    % Percebi que o theta nao afeta quase nada na filtragem

% Matriz de medicao
H = [1 0 0 0 0;
     0 1 0 0 0];

% Variancia do ruido de medicao
R = [0.1 0; 0 0.1]*250;


% Dados filtrados
% 5 colunas = x y th v w
filtr = zeros(npassos,5);

theta = 0;
v = 0;
w = 0;

traco = 0;

% -- PRIMEIRA ITERACAO-------------------------

% Predicao
PHI = [1 0 -sin(theta)*deltaT*v cos(theta)*deltaT 0;
       0 1 cos(theta)*deltaT*v sin(theta)*deltaT 0;
       0 0 1 0 deltaT;
       0 0 0 1 0;
       0 0 0 0 1]; 
   
X = PHI*X;
P = PHI*P*PHI' + Q;

% Medicao
Y = [data(1,2); data(1,3)];

% Fase de correcao
K = P*H'*inv(H*P*H'+R);
X = X + K*(Y-H*X);
P = P - K*H*P;

theta = atan((X(2)-0)/(X(1)-0));
% if data(1,2)<0.0
%     theta = theta + pi;
% end
v = sqrt((X(2)-0)^2 + (X(1)-0)^2)/deltaT;

filtr(1,1) = X(1,1);
filtr(1,2) = X(2,1);
filtr(1,3) = X(3,1);
filtr(1,4) = X(4,1);
filtr(1,5) = X(5,1);

traco = trace(P);

% Filtragem
for i=2:npassos
    
    % Fase de predicao
 
    PHI = [1 0 -sin(theta)*deltaT*v cos(theta)*deltaT 0;
           0 1 cos(theta)*deltaT*v sin(theta)*deltaT 0;
           0 0 1 0 deltaT;
           0 0 0 1 0;
           0 0 0 0 1];

    
    X = PHI*X;
    P = PHI*P*PHI' + Q;
    
    % Medicao
    Y = [data(i,2); data(i,3)];
    
    % Fase de correcao
    K = P*H'*inv(H*P*H'+R);
    X = X + K*(Y-H*X);
    P = P - K*H*P;
    
    % salva todos os pontos --- tem que mutiplicar por H
    filtr(i,1) = X(1,1);
    filtr(i,2) = X(2,1);
    filtr(i,3) = X(3,1);
    filtr(i,4) = X(4,1);
    filtr(i,5) = X(5,1);
    
    theta = atan((filtr(i,2)-filtr(i-1,2))/(filtr(i,1)-filtr(i-1,1)));
%     if filtr(i,1)<filtr(i-1,1)
%         theta = theta + pi;
%     end  
    
    v = sqrt((filtr(i,2)-filtr(i-1,2))^2 + (filtr(i,1)-filtr(i-1,1))^2)/deltaT;
    
    traco = [traco; trace(P)];
end

% Percurso xy
figure(1)
    plot(data(:,2), data(:,3), 'r.');
    hold on
    plot(filtr(:,1), filtr(:,2), 'b','LineWidth',1.5);
    hold off    
    xlabel('x');
    ylabel('y');
    title('Posição do veículo')
    legend('GPS','FKE')
%     grid on
%     grid minor
    set(gca,'xtick',[-2:2:20])
    set(gca,'ytick',[-2:2:14])
    axis equal
    axis([-2 20 -2 14])
    set(gcf, 'PaperSize', [5.5 4]);
    
    
    hold off
    legend('FP')  
    set(gca,'xtick',[110:5:155])
    set(gca,'ytick',[47:5:85])
    axis equal
    axis([110 155 47 85])    
    
    

% Evolucao de x
% figure(2)
% subplot(2,1,1);
%     plot(1:550,filtr(:,1),'b-');
%     hold on
%     plot(1:550,data(:,2),'r');
%     hold off    
%     xlabel('t');
%     ylabel('x');
%     title('Evolução de x')
%     legend('FKE','GPS')
%     set(gca,'xtick',[0:100:550])
%     set(gca,'ytick',[-1:5:20])
%     %axis equal
%     axis([0 550 -2 20])
% %     set(gcf, 'PaperSize', [4 2.2]);
% %     set(gcf, 'Position',[1500 500 400 200])
% % Evolucao de y
% subplot(2,1,2);
%     plot(1:550,filtr(:,2),'b');
%     hold on
%     plot(1:550,data(:,3),'r');
%     hold off    
%     xlabel('t');
%     ylabel('y');
%     title('Evolução de y')
%     legend('FKE','GPS')
%     set(gca,'xtick',[0:100:550])
%     set(gca,'ytick',[-1:5:20])
%     %axis equal
%     axis([0 550 -2 20])
%     set(gcf, 'PaperSize', [4 4]);
%     set(gcf, 'Position',[1500 200 400 400])    
% % Evolucao de theta estimado
%     %plot(1:550,filtr(:,3),'b')
% % Evolucao de v estimado
%     %plot(1:550,filtr(:,4),'b')
% % Evolucao de w estimado
%     %plot(1:550,filtr(:,5),'b')   
%     
%     
% figure(3)    
% plot(traco)

% Volta para a pasta anterior
chdir(OLDDIR);
