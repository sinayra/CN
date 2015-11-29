%Esta funcao executa o metodo de interpolacao utilizando método de Lagrange

function metodo2(Xi,Yi, log)
  
    n = numel(Xi);
    l = ones(1, n);
    
    load = -1;
    loadTaxa = 0;
    
    if(log == 's')
        loadTaxa = 1/(n); %tem que passar uma vez na matriz para calcular os produtos
        load = 0;
    end
    
    mensagemLoad(load);
    
    for i = 1:n
        prod = 1; %valor neutro
        for j = 1:n
            if(i ~= j)
                prod = double(prod) * (double(Xi(i)) - double(Xi(j)));
            end
        end
        l(i) = 1.0/prod;
        
        load = load + loadTaxa;
        mensagemLoad(load);
    end
    
    fprintf('\n\nFuncao interpoladora:\n');
    for i = 1:n
        fprintf('(%f)', Yi(i)* l(i));
        for j = 1:n
            if(j ~= i)
                fprintf('*(x-(%f))', Xi(j));
            end
            
        end
        if(i < n)
            fprintf(' + ');
        end
    end
    fprintf('\n\n');
    
    testaMetodo2(Xi, Yi, l, n);
end

function testaMetodo2(X, Y, l, n)

    in = input('Gostaria de testar a funcao? (s/n)\n', 's');
    if(in == 's')
        fprintf('  xi  \t  yi  \n');
        for i = 1:n
            y = calculaMetodo2(X, Y, l, n, X(i));
            fprintf('%f\t%f\n----\n', X(i), y);
        end
    end
    
    in = input('Gostaria de interpolar a funcao? (s/n)\n', 's');
    while(in == 's')
        x = input('Digite um valor para x: ');
        
        y = calculaMetodo2(X, Y, l, n, x);
        fprintf('P(%f) = %f\n', x, y);
        
        in = input('Gostaria de interpolar a funcao novamente? (s/n)\n', 's');
    end

end

function [y] = calculaMetodo2(X, Y, l, n, x)
    y = 0;
    for i = 1:n
        aux = Y(i) * l(i);
        for j = 1:n
            if(j ~= i)
                aux = aux * (x - X(j));
            end
        end
        y = y + aux;
    end
end