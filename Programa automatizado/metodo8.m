%Esta funcao executa o metodo de interpolacao utilizando método de Spline
%cúbico natural

function metodo8(Xi,Yi, log, fileID)
  
    n = numel(Xi);
    hs = zeros(1, n-1);
    A = zeros(n-2, n-2);
    g = zeros(n-2, 1);
    y = zeros(n-2, 1);
    f = zeros(n-1, 1);
    intervalo = ones(n-1, 2);
    
    load = -1;
    loadTaxa = 0;
    
    if(log == 's')
        loadTaxa = 1/((n-1) + (n-2) + (n-2) + 1 + (n-2)); 
        load = 0;
    end
    
    mensagemLoad(load);
    %ajustando h e calculando deltay
    for i = 1:n-1
        
        intervalo(i, 1) = Xi(i);
        intervalo(i, 2) = Xi(i+1);
        
        hs(i) = Xi(i+1) - Xi(i);
        f(i) = (Yi(i+1) - Yi(i))/hs(i);
        
        load = load + loadTaxa;
        mensagemLoad(load);
    end

    
    for i = 1:n-2
        y(i) = f(i+1) - f(i);
        
        load = load + loadTaxa;
        mensagemLoad(load);
    end
    
    y = 6 * y;
    %ajustando A
    j = -1;
    for i = 1:n-2
        coluna = 1;
        
        if(j + coluna >= 1 && j + coluna <= (n-2))
            A(i, coluna+j) = hs(i);
        end
        
        coluna = coluna + 1;
        if(j + coluna >= 1 && j + coluna <= (n-2))
            A(i, coluna+j) = 2 * (hs(i) + hs(i+1));
        end
        
        coluna = coluna + 1;
        if(j + coluna >= 1 && j + coluna <= (n-2))
            A(i, coluna+j) = hs(i+1);
        end
        
        j = j + 1;
        
        load = load + loadTaxa;
        mensagemLoad(load);
    end
    
    A = [A y];
    
    [L, U] = lu(A);     %deu certo usando decomposição de lu
    %U
    load = load + loadTaxa;
    mensagemLoad(load);
    A = U;
    
    n = numel(y); %para parar de ficar confuso os índices e ficar semelhante a resolução do método 1
    g(n) = A(n,(n+1))/A(n,n);
    
    i = n-1;        %De trás para frente
    while(i >= 1)

        j = n;
        while(j > i)
            g(i) = g(i) - g(j)*A(i,j); %subtrai todos os a's que possuem valor com seus respectivos x's
            j = j - 1;
        end
        g(i) = g(i) + A(i, n+1); %soma com respectivo yi que foi triangulizado
        g(i) = g(i) / A(i,i); %divide com xi respectivo
        
        i = i - 1;
        
        load = load + loadTaxa;
        mensagemLoad(load);
        
    end
    
    g = [0 ; g ; 0];
    load = load + loadTaxa;
    mensagemLoad(load);
    %%%%%%%%%%%%% tudo está pronto para escrever as equações agora %%%%%%%%%%%%%
    n = numel(Xi);
    
   
    resolveMetodo8(Xi, Yi, intervalo, g, hs, f, n, fileID);
    
end

function resolveMetodo8(X, Y, intervalo, g, hs, f, n, fileID)
    
    %in = input('Gostaria de testar a funcao? (s/n)\n', 's');
    in = 's';
    if(in == 's')
        tic
        %fprintf('  i  \t  xi  \t  S(i)  \t  S(i+1)\n');
        for i = 1:n
            [Yf] = calculaMetodo8(X, Y, intervalo, g, hs, f, n, X(i));
             if(Yf(1) ~= Y(i))
                fp = fopen('erros.txt', 'a');
                fprintf(fp, '****Metodo 2: Erro! x = %f****\n', X(i));
                fprintf(fp, 'real: %f\tcalculado: %f\ndif: %f\n', Y(i), Yf(1), Y(i)-Yf(1));
                fclose(fp);
            end
            %fprintf('%f\t%f\n----\n', X(i), y);
            %fprintf('%3d\t%f', i-1, X(i));
            if(i == 1)
           %     fprintf('\t \t%f', Yf(1));
            else
                if(i == n)
          %          fprintf('\t%f', Yf(1));
                else
         %           fprintf('\t%f\t%f', Yf(1), Yf(2));
                end
            end
        %    fprintf('\n----\n');
        end
        fprintf(fileID, '%f;', toc);
        
        
    end
    
    %in = input('Gostaria de interpolar a funcao? (s/n)\n', 's');
    in = 'n';
    
    while(in == 's')
        x = input('Digite um valor para x: ');
        
        [Yf, I] = calculaMetodo8(X, Y, intervalo, g, hs, f, n, x);
        for i = 1:numel(Yf)
            fprintf('S(%d)(%f) = %f\n', I(i), x, Yf(i));
        end
        
        in = input('Gostaria de interpolar a funcao novamente? (s/n)\n', 's');
    end

end

function [Yf, I] = calculaMetodo8(X, Y, intervalo, g, h, f, n, x)
    
    Yf = [];
    I = [];
    for i = 2:n
        if(x >= intervalo(i-1, 1) && x <= intervalo(i-1, 2))
            a = (g(i) - g(i-1))/(6*h(i-1));
            b = g(i)/2;
            c = f(i-1) + (2*h(i-1)*g(i) + g(i-1)*h(i-1))/6;
            d = Y(i);

            y = a * power(x - X(i), 3) + b * power(x - X(i), 2) + c * (x - X(i)) + d;

            Yf = [Yf y];
            I = [I i-1];

        end
    end
end

function Yf = calcula1DerivadaMetodo8(X, intervalo, g, h, f, n, x)
    Yf = [];
    
    for i = 2:n
        if(x >= intervalo(i-1, 1) && x <= intervalo(i-1, 2))
            a = (g(i) - g(i-1))/(6*h(i-1));
            b = g(i)/2;
            c = f(i-1) + (2*h(i-1)*g(i) + g(i-1)*h(i-1))/6;
            
            y = 3* a * power(x - X(i), 2) + 2 * b * (x - X(i)) + c;

            Yf = [Yf y];

        end
    end
end

function Yf = calcula2DerivadaMetodo8(X, intervalo, g, h, n, x)
    Yf = [];
    
    for i = 2:n
        if(x >= intervalo(i-1, 1) && x <= intervalo(i-1, 2))
            a = (g(i) - g(i-1))/(6*h(i-1));
            b = g(i)/2;
            
            y = 6 * a * (x - X(i)) + 2 * b;

            Yf = [Yf y];

        end
    end
end
