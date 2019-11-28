% DANIEL SILVA DE MORAIS - 19/11/2019
% FILTRO DE PARTÍCULAS PARA LOLIZAÇÃO DE VEÍCULO QUE UTILIZA DADOS DE GPS

opengl('save','hardware')

% Load mapa
mapa = load('mapa.txt');

NUM_PARTICULA = 100;    

% Conjnunto de particulas
% uma particula é formada por [x y v peso id_rua ]
particula = zeros(NUM_PARTICULA, 5);


% suposição que as partículas estão no centro da rua, sempre.
% aplicar conceitos de genética
% 


%desenhar linha : line([x0 x1],[y0 y1])



