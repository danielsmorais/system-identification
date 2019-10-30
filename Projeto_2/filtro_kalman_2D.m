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
FILE='dados_GPS_2D_medidos.txt';
% Leitura dos dados
% 3 colunas = t x y
data = dlmread(FILE);
npassos = size(data,1);
deltaT = data(2,1)-data(1,1);


% Manipulação dos dados -----------------------------



%----------------------------------------------------

% Vetor de estados
% X = [x; y; theta; v; w]
X = [0; 0; 0; 0; 0];
% Matriz de transicao
% Xk+1 = PHI*Xk + u
        % theta = 0.5;
%         PHI = [1 0 0 cos(theta)*deltaT 0;
%                0 1 0 sin(theta)*deltaT 0;
%                0 0 1 0 deltaT;
%                0 0 0 1 0;
%                0 0 0 0 1];
   
  
% Variancia da estimativa
% Inicialmente nula pois a condicao inicial eh conhecida
P = zeros(5);
% Variancia do ruido dinamico
Q = diag([0.1^2 0.1^2 0.1^2 0.1 0.1^2]);

% Matriz de medicao
H = [1 0 0 0 0;
     0 1 0 0 0];
% Variancia do ruido de medicao
R = [0.8 0; 0 0.8];

% Dados filtrados
% 3 colunas = x y th v w
filtr = zeros(npassos,5);

theta = 0;
v = 0;
% Filtragem
for (i=2:npassos)
    % Fase de predicao
    
    % Cálculo de theta pelos dados do GPS -- tem que ser pelos dados estimados...   
    theta = atan((data(i,3)-data(i-1,3))/(data(i,2)-data(i-1,2)));
    if data(i,2)<data(i-1,2)
        theta = theta + pi;
    end
    
    v = sqrt((data(i,3)-data(i-1,3))^2 + (data(i,2)-data(i-1,2))^2)/deltaT;
    
    PHI = [1 0 -sin(theta)*deltaT*v cos(theta)*deltaT 0;
           0 1 0 cos(theta)*deltaT*v 0;
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
end

% Percurso xy
plot(filtr(:,1), filtr(:,2), 'b', data(:,2), data(:,3), 'ro');
% Evolucao de x
% plot(real(:,1), real(:,2), 'kx', data(:,1), filtr(:,1), '-b', data(:,1), data(:,2), 'ro');
% Evolucao de y
% plot(real(:,1), real(:,3), 'kx', data(:,1), filtr(:,2), '-b', data(:,1), data(:,3), 'ro');
% Evolucao de v
% plot(real(:,1), real(:,4), 'kx', data(:,1), filtr(:,3), '-b');

% Volta para a pasta anterior
chdir(OLDDIR);
