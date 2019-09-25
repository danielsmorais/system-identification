// Identifica sistema a partir de pontos entrada/saida

exec('funcoes_identificacao.sci', -1);


// Armazena a pasta atual
OLDDIR=pwd();
// Pasta de leitura dos arquivos
DATADIR='/home/daniel/Git/system-identification/Projeto_1/barra-bola';
//DATADIR='C:\Users\Daniel Morais\Documents\git\system-identification\Projeto_1\barra-bola';

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

orderMAX = 10;
delayMAX = 10;

estr = 2;      //quantidade mínima de parâmetros

thetaARX = cell(orderMAX,delayMAX);
thetaARMAX = cell(orderMAX,delayMAX);

resARX = zeros(orderMAX,delayMAX);      //guarda os residuos
resARMAX = zeros(orderMAX,delayMAX);    //guarda os residuos

matriz_AIC_ARX = zeros(orderMAX,delayMAX+1);
matriz_AIC_ARMAX = zeros(orderMAX,delayMAX+1);

for order=1:orderMAX
    for delay=0:delayMAX
        
        // Colocar o código aqui para gerar uma tabela com a relação de ordem e atraso.
        // Testar o Akaike
        // Ter que escolher parte de teste e de identificação

        // Identificacao ARX
        //disp('Modelo ARX:');
        // Calculo dos parametros
        [theta,res]=identifyARX(u,y,order,delay);
        //disp('PARAMETROS:');
        //disp(theta);
        //disp('DESVIO PADRAO DOS RESIDUOS:');
        //disp(stdev(res));
        
        thetaARX{order,delay+1} = theta;
        qtdAmostras = length(res);
        resARX(order,delay+1) = stdev(res);
        AIC = 2*(order*estr) - 2*log(stdev(res)^2); 
        matriz_AIC_ARX(order,delay+1) = AIC;
     
        // Identificacao ARMAX
        //disp('Modelo ARMAX:');
        // Calculo dos parametros
        [theta,res]=identifyARMAX(u,y,order,delay);
        //disp('PARAMETROS:');
        //disp(theta);
        //disp('DESVIO PADRAO DOS RESIDUOS:');
        //disp(stdev(res));
        
        thetaARMAX{order,delay+1} = theta;
        qtdAmostras = length(res);
        resARMAX(order,delay+1) = stdev(res);
        AIC = 2*(order*estr) - 2*log(stdev(res)^2); 
        matriz_AIC_ARMAX(order,delay+1) = AIC;

        // Volta p1ara a pasta anterior
        chdir(OLDDIR);               
        
    end
end

// format('v',7)
// for i=1:5 strcat(string(matriz_AIC_ARX(i,1:8)/10000),' & ') end
// for i=1:5 strcat(string(matriz_AIC_ARMAX(i,1:8)/10000),' & ') end



