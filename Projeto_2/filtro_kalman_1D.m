opengl('save','hardware')

%Filtra os dados do GPS 1D
% Armazena a pasta atual
OLDDIR=pwd();
% Pasta de leitura dos arquivos
%DATADIR='/home/daniel/Git/system-identification/Projeto_2';
DATADIR='C:\Users\Daniel Morais\Documents\git\system-identification\Projeto_2';
if (~chdir(DATADIR))
    error('Folder does not exist');
end

% Arquivo com as medicoes
FILE='dados_GPS_1D_medidos.txt';
% Leitura dos dados
% 3 colunas = t x y
data = dlmread(FILE);
npassos = size(data,1);
deltaT = data(2,1)-data(1,1);

% Arquivo com os dados reais
FILE='dados_GPS_1D_internos.txt';
% Leitura dos dados
% 4 colunas = t x y v
real = dlmread(FILE);

% Vetor de estados
% X = [l; v]
X = [0;0];
% Matriz de transicao
% Xk+1 = PHI*Xk + u
PHI = [1 deltaT; 0 1];
% Variancia da estimativa
% Inicialmente nula pois a condicao inicial eh conhecida
P = [0 0; 0 0];
% Variancia do ruido dinamico
Q = [0.5^2 0; 0 1.5^2]
% Matriz de medicao
theta = 32*(pi/180);  %// 32 graus = angulo da via
H = [cos(theta) 0; sin(theta) 0];
% Variancia do ruido de medicao
R = [5^2 0; 0 5^2];

% Dados filtrados
% 3 colunas = x y v
filtr = zeros(npassos,3);

% Filtragem
for (i=1:npassos)
    % Fase de predicao
    X = PHI*X;
    P = PHI*P*PHI' + Q;
    
    % Medicao
    Y = [data(i,2); data(i,3)];
    
    % Fase de correcao
    K = P*H'*inv(H*P*H'+R);
    X = X + K*(Y-H*X);
    P = P - K*H*P;
    
    % salva os pontos
    filtr(i,1) = cos(theta)*X(1,1);
    filtr(i,2) = sin(theta)*X(1,1);
    filtr(i,3) = X(2,1);
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
