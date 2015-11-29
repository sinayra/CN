%Esta funcao executa o metodo de interpolacao utilizando método de Lagrange
%igualmente espaçado

function metodo3(Xi,Yi, h, log)
    
    n = numel(Xi);
    l = ones(1, n);
    
    load = -1;
    loadTaxa = 0;
    
    if(log == 's')
        loadTaxa = 1/(n); %tem que passar uma vez na matriz para calcular os produtos
        load = 0;
    end
    
    mensagemLoad(load);
    
    for i = 0:n-1
        prod = 1; %valor neutro
        for j = 0:n-1
            if(i ~= j)
                prod = double(prod) * double((i - j));
            end
        end
        l(i+1) = 1.0/prod;
        
        load = load + loadTaxa;
        mensagemLoad(load);
    end
    
    fprintf('\n\nFuncao interpoladora:\n');
    for i = 1:n
        fprintf('(%f)*(%f)', Yi(i), l(i));
        for j = 0:n-1
            if(j ~= i-1)
                fprintf('*(u-(%f))', j);
            end
            
        end
        if(i < n)
            fprintf(' + ');
        end
    end
    fprintf('\nConsidere u = (x-(%f))/%f', Xi(1,1), h);
    fprintf('\n\n');
    
    testaMetodo3(Xi, Yi, l, n, h);
end

function testaMetodo3(X, Y, l, n, h)

    in = input('Gostaria de testar a funcao? (s/n)\n', 's');
    if(in == 's')
        fprintf('  ui  \t  xi  \t  yi  \n');
        for i = 1:n
            [y, u] = calculaMetodo3(X, Y, l, n, h, X(i));
            fprintf('%3d\t%f\t%f\n----\n', u, X(i), y);
        end
    end
    
    in = input('Gostaria de interpolar a funcao? (s/n)\n', 's');
    while(in == 's')
        x = input('Digite um valor para x: ');
        
        [y, u] = calculaMetodo3(X, Y, l, n, h, x);
        fprintf('u = %f\nP(%f) = P[u](%f) = %f\n', u, x, u, y);
        
        in = input('Gostaria de interpolar a funcao novamente? (s/n)\n', 's');
    end

end

function [y, u] = calculaMetodo3(X, Y, l, n, h, x)
    u = (x - X(1,1))/h;
    y = 0;
    for i = 1:n
        aux = Y(i) * l(i);
        for j = 0:n-1
            if(j ~= i-1)
                aux = aux * (u - j);
            end
        end
        y = y + aux;
    end
end