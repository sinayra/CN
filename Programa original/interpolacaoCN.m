%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Sinayra Pascoal Cotts Moreira - 10/0020666
%   C�lculo Num�rico - Turma D
%   2/2015
%
%   Resumo:
%       Este programa recebe uma tabela com valores de x e y, apresenta e
%       calcula o polin�mio interpolador utilizaNdo um dos seguintes
%       m�todos:
%           1) Sistema linear
%           2) Lagrange
%           3) Lagrange igualmente espa�ado
%           4) Newton
%           5) Diferen�a finita progressiva
%           6) Diferen�a finita regressiva
%           7) Spline linear
%           8) Spline c�bico natural
%           9) Spline c�bico extrapolado
%
%       Para a tabela inserida, o programa verifica se a tabela constitui
%       uma fun��o (dois valores de x's diferentes possuem dois y's
%       diferentes), organiza em ordem crescente os valores e, caso o
%       usu�rio n�o tenha selecionado a op��o de igualmente espa�ado, o
%       programa verifica se pode, ainda assim, pode utilizar os m�todos
%       2), 5) e 6). Cada m�todo est� implementados nos arquivos
%       metodo[numero].m. Este arquivo (interpolacaoCN.m) possui o 
%       c�digo do programa principal e o arquivo mensagemLoad.m �
%       respons�vel pelas mensagens de retorno caso o usu�rio deseje
%       acompanhar o tempo de processamento.
%
%   Para usar:
%       1- Execute interpolacaoCN
%       2- Informe se o intervalo � igualmente espa�ado ou n�o (s/n)
%           2.1 - Se for igualmente espa�ado, digite o valor de h
%       3- Informe se deseja escrever uma fun��o ou n�o
%           3.1 Caso deseja escrever, escreva-a respeitando a nota��o imposta pelo MATLAB
%           3.2 Caso n�o deseja escrever, preencha uma tabela com os xi's (caso necess�rio) e os yi's correspondentes
%               3.2.a) Para encerrar a inser��o de novos valores, digite qualquer letra do teclado
%       4- A tabela ser� salva em mem�ria e o polin�mio de cada m�todo ser�
%       calculado somente quando a op��o de polin�mio for escolhida
%       5- Para cada op��o de interpola��o, haver� a op��o de test�-lo
%       6- Evite interromper o programa no meio das contas, utilzie a op��o
%       de sair caso tenha encerrado a execu��o.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function interpolacaoCN
    Xi = [];
    Yi = [];
    i = 0;
    h = 0;
    
    clearAll();
    
    eqn = input('Gostaria de escrever uma funcao f(x)? (s/n) ', 's');
    
    espacado = input('Gostaria de realizar uma interpolacao igualmente espacada? (s/n) ', 's');
    
    if(espacado == 's')
        Xi(1,1) = input('Informe o valor inicial x0: ');
        h = input('Informe o intervalo: ');
        if(eqn ~= 's')
            fprintf('\nInforme os yis correspondentes. Para encerrar este processo, digite uma letra qualquer. \n');

            i = 0;
            str = sprintf('y%d: ', i);
            in = input(str, 's');
            y = str2double(in);
            while(~isnan(y))
                y = double(y);
                Yi = [Yi y];

                i = i + 1;
                aux = Xi(1,i) + h; %adiciona pr�ximo elemento Xi
                Xi = [Xi aux];  %necess�rio para verifica��o se valores inseridos s�o fun��o

                str = sprintf('y%d: ', i);
                in = input(str, 's');
                y = str2double(in);
            end
            Xi(end) = []; %retira �ltimo elemento que est� a mais
        else
            Yi(1,1) = myf(Xi(1,1));
            k = input('Informe o valor de k: ');
            for i = 2:k
                aux = Xi(1,i-1) + h; %adiciona pr�ximo elemento Xi
                Xi = [Xi aux];  %necess�rio para verifica��o se valores inseridos s�o fun��o
                Yi = [Yi myf(Xi(1,i))];
            end
        end
    else
        if(eqn ~= 's')
            fprintf('Informe os xis e yis correspondentes. Para encerrar este processo, digite uma letra qualquer\n');

            str = sprintf('x%d: ', i);
            in = input(str, 's');
            x = str2double(in);

            while(~isnan(x))
                x = double(x);
                Xi = [Xi x];
                str = sprintf('y%d: ', i);
                in = input(str, 's');
                x = str2double(in);
                while(isnan(x))
                    fprintf('Escreva um valor valido para y!\n');
                    str = sprintf('y%d: ', i);
                    in = input(str, 's');
                    x = str2double(in);
                    x = double(x);
                end
                Yi = [Yi x];

                i = i + 1;

                str = sprintf('x%d: ', i);
                in = input(str, 's');
                x = str2double(in);
            end
        else
             fprintf('Informe os xis. Para encerrar este processo, digite uma letra qualquer\n');
              str = sprintf('x%d: ', i);
              in = input(str, 's');
              x = str2double(in);

            while(~isnan(x))
                x = double(x);
                Xi = [Xi x];
                
                i = i + 1;
                Yi = [Yi myf(Xi(1,i))];
                
                str = sprintf('x%d: ', i);
                in = input(str, 's');
                x = str2double(in);
            end
        end
    end
    
    log = input('Gostaria de receber mensagens de progresso no c�lculo dos m�todos? (s/n) ', 's');
 
    if(~isempty(Xi))
        if(espacado ~= 's')
            [Xi, Yi] = bubblesort(Xi, Yi);
        end
        [Xi, Yi, isFunc] = isFuncao(Xi, Yi);
        if(isFunc)
                       
            metodo1s = '1. Sistema Linear\n';
            metodo2s = '2. Lagrange\n';
            metodo3s = '3. Langrange igualmente espacado'; %%%%%  Verifica h
            metodo4s = '4. Newtown/diferen�a dividida\n';
            metodo5s = '5. Diferenca finita progressiva'; %%%%%  Verifica h
            metodo6s = '6. Diferenca finita regressiva'; %%%%%  Verifica h
            metodo7s = '7. Spline linear\n';
            metodo8s = '8. Spline c�bico natural\n';
            metodo9s = '9. Spline c�bico extrapolado\n';
            sair = '0. Encerrar programa\n';
            
            if(espacado ~= 's')
                [s1, valido3, h] = isPassoFixo(Xi, metodo3s);
                [s2, valido5] = isPassoFixo(Xi, metodo5s);
                [s3, valido6] = isPassoFixo(Xi, metodo6s);
            else
                s1 = strcat(metodo3s, '\n');
                s2 = strcat(metodo5s, '\n');
                s3 = strcat(metodo6s, '\n');
                
                valido3 = true;
                valido5 = true;
                valido6 = true;
            end
            valido = [true, true, valido3, true, valido5, valido6, true, true, true];

            while(1)
                fprintf('Escolha uma operacao para os seguintes valores');
                mostraTabela(Xi, Yi);
            
                s = strcat(metodo1s, metodo2s, s1, metodo4s, s2, s3, metodo7s, metodo8s, metodo9s, sair);
                in = input(s);

                if(in >= 0 && in <= 9)
                    if(in == 0)
                        break;
                    end
                    
                    if(valido(in))
                        switch in
                            case 1
                                metodo1(Xi, Yi, log);
                            case 2
                                metodo2(Xi, Yi, log);
                            case 3
                                metodo3(Xi, Yi, h, log);
                            case 4
                                metodo4(Xi, Yi, log);
                            case 5
                                metodo5(Xi, Yi, h, log);
                            case 6
                                metodo6(Xi, Yi, h, log);
                            case 7
                                metodo7(Xi, Yi, log);
                            case 8
                                metodo8(Xi, Yi, log);
                            case 9
                                metodo9(Xi, Yi, log);
                            otherwise
                                fprintf('Opcao invalida\n');
                        end
                    end
                end                   
            end
            
            
        end
        
    else
        fprintf('Nada a interpolar, encerrando o programa');
    end
    
    clearAll();
end

function [metodo, valido, h] = isPassoFixo(Xi, str)
    n = numel(Xi);
    metodo = strcat(str, '\n');
    valido = true;
    
    h = 0;
    if n >= 2
        h = Xi(2) - Xi(1);
        for i = 2:n
            h1 = Xi(i) - Xi(i-1);
            if(h ~= h1)
                metodo = strcat(str, ' (Indisponivel)\n');
                valido = false;
                break;
            end
        end
    end
end

function [Xi, Yi] = bubblesort(A, B)
    n = numel(A);
    Xi = A;
    Yi = B;
    
    bubble = true;
    while(bubble)
        bubble = false;
        for i = 2:n
            if(Xi(i) < Xi(i-1))
                aux = Xi(i-1);
                Xi(i-1) = Xi(i);
                Xi(i) = aux;

                aux = Yi(i-1);
                Yi(i-1) = Yi(i);
                Yi(i) = aux;
                
                bubble = true;
            end
        end
    end
end

function mostraTabela(A,B)
    n = numel(A);
    fprintf('\n');
    fprintf(' i \t  Xi\t  Yi\n');
    
    for i = 1:n
        fprintf('%2d\t%f\t%f\n', i-1, A(i), B(i));
    end
end

function [Xi, Yi, isFunc] = isFuncao(A, B)
    isFunc = true;
    n = numel(A);
    
    Xi = A;
    Yi = B;
    
    for i = 1:n-1
        if(Xi(i) == Xi(i+1))
            if(Yi(i) ~= Yi(i+1))
                fprintf('Os valores inseridos nao sao uma funcao. Encerrando programa\n');
                isFunc = false;
                break;
            else
                Xi(i) = [];
                Yi(i) = [];
            end
        end
    end
end

function y = myf(x)
    persistent str f;

    if(isempty(str))
        str = input('Digite a equacao f(x): ', 's');
        f = @(x) str;
    end    
    y = double(subs(f, {x}));
end

function clearAll
    clear persistent
    clear all;
    clear str;
    clear f;
    clear myf
    
    Vars=whos;
    PersistentVars=Vars([Vars.persistent]);
    PersistentVarNames={PersistentVars.name};
    clear(PersistentVarNames{:});
end