opengl('save','hardware');

mapa = load('mapa.txt');
DATA = load('dados_GPS_Waze_medidos.txt');

desenha_mapa(mapa);
hold on
plot(DATA(:,2),DATA(:,3),'.r')