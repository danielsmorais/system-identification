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
X = [0; 0; 0];
% Matriz de transicao
% Xk+1 = PHI*Xk + u
PHI = [1 0 dt;
       0 1 dt;
       0 0 1];
% Variancia da estimativa
% Inicialmente nula pois a condicao inicial eh conhecida
P = [0 0 0; 
     0 0 0;
     0 0 0];
% Variancia do ruido dinamico
Q = [0.5^2 0 0;
     0 1.5^2 0;
     0 0 0.5^2];

% Matriz de medicao
theta = 0*(pi/180); % 0 graus = angulo da via
H = [cos(theta) 0; sin(theta) 0];
% Variancia do ruido de medicao
R = [5^2 0; 0 5^2];



% suposiao que as partaculas estao no centro da rua, sempre.
% aplicar conceitos de genetica
% 


%desenhar linha : line([x0 x1],[y0 y1])



