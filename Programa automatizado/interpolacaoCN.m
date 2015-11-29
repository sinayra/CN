%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Sinayra Pascoal Cotts Moreira - 10/0020666
%   Cálculo Numérico - Turma D
%   2/2015
%
%   Resumo:
%       Este programa recebe uma tabela com valores de x e y, apresenta e
%       calcula o polinômio interpolador utilizaNdo um dos seguintes
%       métodos:
%           1) Sistema linear
%           2) Lagrange
%           3) Lagrange igualmente espaçado
%           4) Newton
%           5) Diferença finita progressiva
%           6) Diferença finita regressiva
%           7) Spline linear
%           8) Spline cúbico natural
%           9) Spline cúbico
%
%       Para a tabela inserida, o programa verifica se a tabela constitui
%       uma função (dois valores de x's diferentes possuem dois y's
%       diferentes), organiza em ordem crescente os valores e, caso o
%       usuário não tenha selecionado a opção de igualmente espaçado, o
%       programa verifica se pode, ainda assim, pode utilizar os métodos
%       2), 5) e 6). Cada método está implementados nos arquivos
%       metodos[numero].m. Este arquivo (interpolacaoCN.m) possui o 
%       código do programa principal e o arquivo mensagemLoad.m é
%       responsável pelas mensagens de retorno caso o usuário deseje
%       acompanhar o tempo de processamento.
%
%   Para usar:
%       1- Execute interpolacaoCN
%       2- Informe se o intervalo é igualmente espaçado ou não (s/n)
%           2.1 - Se for igualmente espaçado, digite o valor de h
%       3- Preencha uma tabela com os xi's (caso necessário) e os yi's
%       correspondentes
%       4- Para encerrar a inserção de novos valores, digite qualquer letra
%       do teclado
%       5- A tabela será salva em memória e o polinômio de cada método será
%       calculado somente quando a opção de polinômio for escolhida
%       6- Para cada opção de interpolação, haverá a opção de testá-lo
%       7- Evite interromper o programa no meio das contas, utilzie a opção
%       de sair caso tenha encerrado a execução.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function interpolacaoCN
    
    clearAll();
    
    fileID = fopen('cospix.txt','w');
    %while(k <= 168)
       
        Xi = [];
        Yi = [];

        %eqn = input('Gostaria de escrever uma funcao f(x)? (s/n) ', 's');
        eqn = 's';
        %espacado = input('Gostaria de realizar uma interpolacao igualmente espacada? (s/n) ', 's');
        espacado = 's';
        if(espacado == 's')
            %Xi(1,1) = input('Informe o valor inicial x0: ');
            Xi(1,1) = 0;
            %h = input('Informe o intervalo: ');
            h = 1;
            Yi(1,1) = myf(Xi(1,1));
            %k = input('Informe o valor de k: ');

        end

        %log = input('Gostaria de receber mensagens de progresso no cálculo dos métodos? (s/n) ', 's');
        log = 'n';

        if(~isempty(Xi))
            
            [Xi, Yi, isFunc] = isFuncao(Xi, Yi);
            if(isFunc)

                metodo1s = '1. Sistema Linear\n';
                metodo2s = '2. Lagrange\n';
                metodo3s = '3. Langrange igualmente espacado'; %%%%%  Verifica h
                metodo4s = '4. Newtown/diferença dividida\n';
                metodo5s = '5. Diferenca finita progressiva'; %%%%%  Verifica h
                metodo6s = '6. Diferenca finita regressiva'; %%%%%  Verifica h
                metodo7s = '7. Spline linear\n';
                metodo8s = '8. Spline cúbico natural\n';
                metodo9s = '9. Spline cúbico\n';
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

                j = 2;
                while(j <= 9)
                    fprintf('Metodo %d\n', j);
                    %fprintf('Escolha uma operacao para os seguintes valores');
                    %mostraTabela(Xi, Yi);

                    %s = strcat(metodo1s, metodo2s, s1, metodo4s, s2, s3, metodo7s, metodo8s, metodo9s, sair);
                    %in = input(s);
                    in = j;
                    if(in >= 0 && in <= 9)
                        if(in == 0)
                            break;
                        end
                        fprintf(fileID, '\n', toc);

                        if(valido(in))
                            switch in
                                case 1
                                    %metodo1(Xi, Yi, log, fileID);
                                case 2
                                    for k = 4:2:170 
                                        Xi = [];
                                        Yi = [];
                                        Xi(1,1) = 0;
                                        Yi(1,1) = myf(Xi(1,1));
        
                                        fp = fopen('erros.txt', 'a');
                                        fprintf(fp, '\n\nPara k = %d\n\n', k);
                                        fprintf('\n\nPara k = %d\n\n', k);
                                        fclose(fp);
                                        
                                        for i = 2:k
                                            aux = Xi(1,i-1) + h; %adiciona próximo elemento Xi
                                            Xi = [Xi aux];  %necessário para verificação se valores inseridos são função
                                            Yi = [Yi myf(Xi(1,i))];
                                        end
                                        metodo2(Xi, Yi, log, fileID);
                                    end
                                case 3
                                    for k = 4:2:170 
                                        Xi = [];
                                        Yi = [];
                                        Xi(1,1) = 0;
                                        Yi(1,1) = myf(Xi(1,1));
                                        
                                        fp = fopen('erros.txt', 'a');
                                        fprintf(fp, '\n\nPara k = %d\n\n', k);
                                        fprintf('\n\nPara k = %d\n\n', k);
                                        fclose(fp);
                                        
                                        for i = 2:k
                                            aux = Xi(1,i-1) + h; %adiciona próximo elemento Xi
                                            Xi = [Xi aux];  %necessário para verificação se valores inseridos são função
                                            Yi = [Yi myf(Xi(1,i))];
                                        end
                                        metodo3(Xi, Yi, h, log, fileID);
                                    end
                                        

                                case 4
                                    for k = 4:2:170 
                                        Xi = [];
                                        Yi = [];
                                        Xi(1,1) = 0;
                                        Yi(1,1) = myf(Xi(1,1));
                                        
                                        fp = fopen('erros.txt', 'a');
                                        fprintf(fp, '\n\nPara k = %d\n\n', k);
                                        fprintf('\n\nPara k = %d\n\n', k);
                                        fclose(fp);
                                        
                                        for i = 2:k
                                            aux = Xi(1,i-1) + h; %adiciona próximo elemento Xi
                                            Xi = [Xi aux];  %necessário para verificação se valores inseridos são função
                                            Yi = [Yi myf(Xi(1,i))];
                                        end
                                        metodo4(Xi, Yi, log, fileID);
                                    end
                                        
                                    
                                case 5
                                    for k = 4:2:170 
                                        Xi = [];
                                        Yi = [];
                                        Xi(1,1) = 0;
                                        Yi(1,1) = myf(Xi(1,1));
                                        
                                        fp = fopen('erros.txt', 'a');
                                        fprintf(fp, '\n\nPara k = %d\n\n', k);
                                        fprintf('\n\nPara k = %d\n\n', k);
                                        fclose(fp);
                                        
                                        for i = 2:k
                                            aux = Xi(1,i-1) + h; %adiciona próximo elemento Xi
                                            Xi = [Xi aux];  %necessário para verificação se valores inseridos são função
                                            Yi = [Yi myf(Xi(1,i))];
                                        end
                                        metodo5(Xi, Yi, h, log, fileID);
                                    end
                                    
                                case 6
                                    for k = 4:2:170
                                        Xi = [];
                                        Yi = [];
                                        Xi(1,1) = 0;
                                        Yi(1,1) = myf(Xi(1,1));
                                        
                                        fp = fopen('erros.txt', 'a');
                                        fprintf(fp, '\n\nPara k = %d\n\n', k);
                                        fprintf('\n\nPara k = %d\n\n', k);
                                        fclose(fp);
                                        
                                        for i = 2:k
                                            aux = Xi(1,i-1) + h; %adiciona próximo elemento Xi
                                            Xi = [Xi aux];  %necessário para verificação se valores inseridos são função
                                            Yi = [Yi myf(Xi(1,i))];
                                        end
                                        metodo6(Xi, Yi, h, log, fileID);
                                    end
                                    
                                case 7
                                    for k = 4:2:170
                                        Xi = [];
                                        Yi = [];
                                        Xi(1,1) = 0;
                                        Yi(1,1) = myf(Xi(1,1));
                                        
                                        fp = fopen('erros.txt', 'a');
                                        fprintf(fp, '\n\nPara k = %d\n\n', k);
                                        fprintf('\n\nPara k = %d\n\n', k);
                                        fclose(fp);
                                        
                                        for i = 2:k
                                            aux = Xi(1,i-1) + h; %adiciona próximo elemento Xi
                                            Xi = [Xi aux];  %necessário para verificação se valores inseridos são função
                                            Yi = [Yi myf(Xi(1,i))];
                                        end
                                        metodo7(Xi, Yi, log, fileID);
                                    end
                                    
                                case 8
                                    for k = 4:2:170
                                        Xi = [];
                                        Yi = [];
                                        Xi(1,1) = 0;
                                        Yi(1,1) = myf(Xi(1,1));
                                        
                                        fp = fopen('erros.txt', 'a');
                                        fprintf(fp, '\n\nPara k = %d\n\n', k);
                                        fprintf('\n\nPara k = %d\n\n', k);
                                        fclose(fp);
                                        
                                        for i = 2:k
                                            aux = Xi(1,i-1) + h; %adiciona próximo elemento Xi
                                            Xi = [Xi aux];  %necessário para verificação se valores inseridos são função
                                            Yi = [Yi myf(Xi(1,i))];
                                        end
                                        
                                        metodo8(Xi, Yi, log, fileID);
                                    end
                                    
                                case 9
                                    for k = 4:2:170
                                        Xi = [];
                                        Yi = [];
                                        Xi(1,1) = 0;
                                        Yi(1,1) = myf(Xi(1,1));
                                        
                                        fp = fopen('erros.txt', 'a');
                                        fprintf(fp, '\n\nPara k = %d\n\n', k);
                                        fprintf('\n\nPara k = %d\n\n', k);
                                        fclose(fp);
                                        
                                        for i = 2:k
                                            aux = Xi(1,i-1) + h; %adiciona próximo elemento Xi
                                            Xi = [Xi aux];  %necessário para verificação se valores inseridos são função
                                            Yi = [Yi myf(Xi(1,i))];
                                        end
                                        y0 = 1;
                                        yn = Xi(length(Xi));
                                        %yn = (yn + 1) * exp(yn); %x*exp(x)
                                        %yn = (-2*yn)/((yn^2 + 1)^2); %1/(1+x^2)
                                        yn = pi*cos(pi*yn); %cos(pi*x-pi/2)
                                        metodo9(Xi, Yi, log, fileID, y0, yn);
                                    end
                                    
                                otherwise
                                    fprintf('Opcao invalida\n');
                            end
                        end
                    end                   
                    j = j + 1;
                end


            end

        else
            fprintf('Nada a interpolar, encerrando o programa');
        end
    %end
    clearAll();
    fclose(fileID);
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