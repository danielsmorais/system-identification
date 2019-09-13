// Identifica sistema a partir de pontos entrada/saida

// Armazena a pasta atual
OLDDIR=pwd();
// Pasta de leitura dos arquivos
DATADIR='/home/daniel/Git/system-identification/Projeto_1/barra-bola';
if (~chdir(DATADIR)) then
    error('Folder does not exist');
end

// Arquivo a ser lido
FILE='ballbeam.dat';
// Leitura dos dados
data = read(FILE, -1, 2);
num_points = size(data,"r");
if (num_points<100) then
    error('Number of points too small to obtain a good identification.');
end

// Pontos de identificacao
// Sinal de entrada
u = data(1:num_points,1);
// Sinal de saida
y = data(1:num_points,2);

// Definicao da estrutura

orderMAX = 4;
delayMAX = 10;

tabelaARX = zeros(orderMAX,delayMAX);
tabelaARMAX = zeros(orderMAX,delayMAX);

for order=1:orderMAX
    for delay=0:delayMAX
        
        // Colocar o código aqui para gerar uma tabela com a relação de ordem e atraso.
        // Testar o Akaike
        // Ter que escolher parte de teste e de identificação

    end
end


order = 2;
delay = 10;

// Identificacao ARX
disp('Modelo ARX:');
// Calculo dos parametros
[theta,res]=identifyARX(u,y,order,delay);
disp('PARAMETROS:');
disp(theta);
disp('DESVIO PADRAO DOS RESIDUOS:');
disp(stdev(res));

// Identificacao ARMAX
disp('Modelo ARMAX:');
// Calculo dos parametros
[theta,res]=identifyARMAX(u,y,order,delay);
disp('PARAMETROS:');
disp(theta);
disp('DESVIO PADRAO DOS RESIDUOS:');
disp(stdev(res));

// Volta para a pasta anterior
chdir(OLDDIR);
