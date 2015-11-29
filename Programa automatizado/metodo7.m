%Esta funcao executa o metodo de interpolacao utilizando método de Spline
%linear

function metodo7(Xi,Yi, log, fileID)
  
    n = numel(Xi);
    xs = zeros(1, n-1);
    intervalo = ones(n-1, 2);
    
    load = -1;
    loadTaxa = 0;
    
    if(log == 's')
        loadTaxa = 1/(n-1); %tem que passar uma vez na matriz para calcular os produtos
        load = 0;
    end
    
    mensagemLoad(load);
    for i = 1:n-1
        intervalo(i, 1) = Xi(i);
        intervalo(i, 2) = Xi(i+1);
        
        xs(i) = 1/(Xi(i) - Xi(i+1));
        
        load = load + loadTaxa;
        mensagemLoad(load);
    end
    
    testaMetodo7(Xi, Yi, intervalo, xs, n, fileID);
end

function testaMetodo7(X, Y, intervalo, xs, n, fileID)

    %in = input('Gostaria de testar a funcao? (s/n)\n', 's');
    in = 's';
    if(in == 's')
        tic
        %fprintf('  i  \t  xi  \t  S(i)  \t  S(i+1)\n');
        for i = 1:n
            [Yf] = calculaMetodo7(X, Y, intervalo, xs, n, X(i));
            if(Yf(1) ~= Y(i))
                fp = fopen('erros.txt', 'a');
                fprintf(fp, '****Metodo 2: Erro! x = %f****\n', X(i));
                fprintf(fp, 'real: %f\tcalculado: %f\ndif: %f\n', Y(i), Yf(1), Y(i)-Yf(1));
                fclose(fp);
            end

            %fprintf('%f\t%f\n----\n', X(i), y);
           % fprintf('%3d\t%f', i-1, X(i));
            if(i == 1)
                %fprintf('\t \t%f', Yf(1));
            else
                if(i == n)
                 %   fprintf('\t%f', Yf(1));
                else
                  %  fprintf('\t%f\t%f', Yf(1), Yf(2));
                end
            end
            %fprintf('\n----\n');
        end
        fprintf(fileID, '%f;', toc);
    end

    %in = input('Gostaria de interpolar a funcao? (s/n)\n', 's');
    in = 'n';
    
    while(in == 's')
        x = input('Digite um valor para x: ');
        
        [Yf, I] = calculaMetodo7(X, Y, intervalo, xs, n, x);
        for i = 1:numel(Yf)
            fprintf('S(%d)(%f) = %f\n', I(i), x, Yf(i));
        end
        
        in = input('Gostaria de interpolar a funcao novamente? (s/n)\n', 's');
    end

end

function [Yf, I] = calculaMetodo7(X, Y, intervalo, xs, n, x)
    
    Yf = [];
    I = [];
    for i = 1:n-1
        if(x >= intervalo(i, 1) && x <= intervalo(i, 2))
            y = Y(i) * (x - X(i+1)) - Y(i+1)*(x - X(i));
            y = y * xs(i);

            Yf = [Yf y];
            I = [I i];

        end
    end
end

