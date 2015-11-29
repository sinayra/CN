%Esta funcao executa o metodo de interpolacao utilizando sistemas lineares

function metodo1(Xi,Yi, log, fileID)
    
    n = numel(Xi);
    X = zeros(n);        %cria matriz nxn
    Y = [];
    A = [];
    load = -1;
    loadTaxa = 0;
    
    if(log == 's')
        loadTaxa = 1/(2*n); %tem que passar duas vezes na matriz: uma para triangulizar e outra para calcular coeficientes
        load = 0;
    end
    
    for j = 1:n         %ajusta matriz X
        for i = 1:n
            X(i,j) = power(Xi(i),(j-1));
        end
    end
    
    for i = 1:n         %ajusta matriz Y
        Y = [Y ; Yi(i)];    
    end
    
    X = [X Y];
    mensagemLoad(load);
    
    %eliminação de gauss
    for i = 2:n
        X = gauss(X, i, n, i-1);
        
        load = load + loadTaxa;
        mensagemLoad(load);
        
        tri = false; %flag que verifica se coluna está "triangulizada"
        while(~tri)
            tri = true;
            for j = i:n
                if(X(j,i-1) ~= 0) %elemento abaixo não está "triangulizado"
                    X = gauss(X, j, n, i-1);
                    tri = false;
                    break;
                end
            end
        end

    end
    
   % X
   %[L, U] = lu(X);     %deu certo usando decomposição de lu
   %U
    
    A(n) = X(n,(n+1))/X(n,n);
    load = load + loadTaxa;
    mensagemLoad(load);
    
    i = n-1;        %De trás para frente
    while(i >= 1)

        j = n;
        while(j > i)
            A(i) = A(i) - A(j)*X(i,j); %subtrai todos os a's que possuem valor com seus respectivos x's
            j = j - 1;
        end
        A(i) = A(i) + X(i, n+1); %soma com respectivo yi que foi triangulizado
        A(i) = A(i) / X(i,i); %divide com xi respectivo
        
        i = i - 1;
        
        load = load + loadTaxa;
        mensagemLoad(load);
    end
    
    load = load + loadTaxa;
    mensagemLoad(load);
    
    testaMetodo1(A, n, Xi, fileID);
end

%linha é a linha base
%i e todas as debaixos dela serão operadas
function [X] = gauss(Xi, i, n, linha)
        
        X = Xi;
        
        j = 1;
        while(X(linha, j) == 0) %linha base
            j = j+1;
        end
        b = X(linha,j);

        j = 1;
        while(X(i, j) == 0) %linha onde o primeiro elemento será zerado
            j = j+1;
        end
        a = X(i,j);
       
        r = a/b; %fator que deve ser multiplicado a X(linha) para que X(i) tenha o elemento X(i,j) zerado
        
        for k = i:n
            for j = 1:n+1  %aplica em todas as linhas

                X(k,j) = X(k,j) - r*X(linha,j); %gauss
                
                tol = 1.e-6;
                if(X(k,j) < 0 && X(k,j) > -tol)  %Para lidar com números não normalizados
                    X(k,j) = 0;
                end
            end
        end
end


function testaMetodo1(A, n, Xi, fileID)
    %in = input('Gostaria de testar a funcao? (s/n)\n', 's');
    in = 's';
    if(in == 's')
        tic
        
        %fprintf('  xi  \t  yi  \n');
        for i = 1:n
            y = calculaMetodo1(Xi(i), A, n);
            %fprintf('%f\t%f\n----\n', Xi(i), y);
        end
        
        fprintf(fileID, '%f\n', toc);
    end
    
end

function [y] = calculaMetodo1(x, A, n)
    y = 0;
    for i = 1:n
        y = y + A(i) * power(x, i-1);
    end
end