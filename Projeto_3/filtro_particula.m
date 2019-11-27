% DANIEL SILVA DE MORAIS - 19/11/2019
% FILTRO DE PARTÍCULAS PARA LOLIZAÇÃO DE VEÍCULO QUE UTILIZA DADOS DE GPS

opengl('save','hardware')

% Load mapa
mapa = load('mapa.txt');

NUM_PARTICULA = 100;    

% Conjnunto de particulas
% uma particula é formada por [x y v theta_rua id_rua fator]
%particula = zeros(NUM_PARTICULA,6);
pf.x = 0;
pf.y = 0;
pf.v = 0;
pf.w = 0;
pf.idr = -1;


% suposição que as partículas estão no centro da rua, sempre.
% aplicar conceitos de genética
% 


%desenhar linha : line([x0 x1],[y0 y1])



