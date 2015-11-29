%Esta funcao executa o metodo de interpolacao utilizando método de Lagrange
%igualmente espaçado

function metodo3(Xi,Yi, h, log, fileID)
    
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
    
   
    testaMetodo3(Xi, Yi, l, n, h, fileID);
end

function testaMetodo3(X, Y, l, n, h, fileID)

    %in = input('Gostaria de testar a funcao? (s/n)\n', 's');
    in = 's';
    if(in == 's')
        tic
        %fprintf('  ui  \t  xi  \t  yi  \n');
        for i = 1:n
            [y, u] = calculaMetodo3(X, Y, l, n, h, X(i));
            if(y ~= Y(i))
                fp = fopen('erros.txt', 'a');
                fprintf(fp, '****Metodo 3: Erro! x = %f****\n', X(i));
                fprintf(fp, 'real: %f\tcalculado: %f\ndif: %f\n', Y(i), y, Y(i)-y);
                fclose(fp);
            end
           % fprintf('%3d\t%f\t%f\n----\n', u, X(i), y);
        end
        fprintf(fileID, '%f;', toc);
    end
    in = 'n';
    %in = input('Gostaria de interpolar a funcao? (s/n)\n', 's');
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