%Esta funcao executa o metodo de interpolacao utilizando método de Newton
%Utiliza linha principal para exibição do polinômio
function metodo4(Xi,Yi, log)
  
    n = numel(Xi);
    load = -1;
    loadTaxa = 0;
    
    if(log == 's')
        m = 0;
        for i = 1:n-1
            m = m + i; %quantidade de vezes que tem que percorrer o vetor Y
        end
        loadTaxa = 1/m; 
        load = 0;
    end
    
    mensagemLoad(load);
    D = f(Xi, Yi, n, n, load, loadTaxa);
    %A linha n possui todos os números de ordem 0
    %A linha n-1 possui todos os elementos de ordem 1, com o elemento
    %D(n-1, j) dispensável
    %A linha n-2 possui todos os elementos de ordem 2, com o elemento
    %D(n-2,j) e D(n-1,j) dispensável
    %...
    
    %descomente a linha de baixo para visualizar a matriz
    %D
    fprintf('\n\nFuncao interpoladora:\n');
    for i = 1:n
          
        fprintf('%f', D(n-(i-1), 1));
        for j = 1:i-1
            fprintf('*(x-(%f))', Xi(j));
        end
        if(i < n)
            fprintf(' + ');
        end
    end
    fprintf('\n\n');
    
    testaMetodo4(D, Xi, n);
end

function [D] = f(X, Y, n, total, load, loadTaxa)
    D = [];
    if(n ~= 0)
        ordem = zeros(1, n-1);
        for i = 1:n-1
            aux = (double(Y(i+1)) - double(Y(i)))/(double(X(i+1+(total-n))) - double(X(i)));
            %fprintf('Y(i+1): %f\n', Y(i+1));
            %fprintf('Y(i): %f\n', Y(i));
            %fprintf('X(i+1): %f\n', X(i+1+(total-n)));
            %fprintf('X(i): %f\n\n', X(i));
            ordem(i) = aux;
            
            load = load + loadTaxa;
            mensagemLoad(load);
        end
        D = f(X, ordem, n-1, total, load, loadTaxa); %chama f para próxima ordem, que terá n-1 elementos
        mzero = zeros(1, total - n); %ajusta para matrizes terem o mesmo tamanho
        D = [D ; Y mzero]; %concatena na resposta tudo o que encontrou

    end
end

function testaMetodo4(D, X, n)

    in = input('Gostaria de testar a funcao? (s/n)\n', 's');
    if(in == 's')
        fprintf('  xi  \t  yi  \n');
        for i = 1:n
            y = calculaMetodo4(D, X, n, X(i));
            fprintf('%f\t%f\n----\n', X(i), y);
        end
    end
    
    in = input('Gostaria de interpolar a funcao? (s/n)\n', 's');
    while(in == 's')
        x = input('Digite um valor para x: ');       
        y = calculaMetodo4(D, X, n, x);
        
        fprintf('N(%f) = %f\n', x, y);
        
        in = input('Gostaria de interpolar a funcao novamente? (s/n)\n', 's');
    end
end

function [y] = calculaMetodo4(D, X, n, x)

    y = 0;
    for i = 1:n
        aux = D(n-(i-1), 1);
        for j = 1:i-1
            aux = aux * (x - X(j));
        end
        y = y + aux;
    end
end