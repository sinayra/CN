%Esta funcao executa o metodo de interpolacao utilizando m�todo de
%Diferen�a Finita Progressiva
%Utiliza linha principal para exibi��o do polin�mio
function metodo5(Xi,Yi, h, log, fileID)
  
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
    D = f(Yi, n, n, load, loadTaxa);
    %a matriz D segue o mesmo racioc�nio do m�todo 4, por�m aplicado para
    %diferen�a finita
    
    %D
    
    testaMetodo5(D, Xi, h, n, fileID, Yi)
end

function [D] = f(Y, n, total, load, loadTaxa)
    D = [];
    if(n ~= 0)
        ordem = zeros(1, n-1);
        for i = 1:n-1
            aux = double(Y(i+1)) - double(Y(i));
            %fprintf('Y(i+1): %f\n', Y(i+1));
            %fprintf('Y(i): %f\n', Y(i));
            %fprintf('aux: %f\n', aux);

            ordem(i) = aux;
            
            load = load + loadTaxa;
            mensagemLoad(load);
            
        end
        D = f(ordem, n-1, total, load, loadTaxa); %chama f para pr�xima ordem, que ter� n-1 elementos
        mzero = zeros(1, total - n); %ajusta para matrizes terem o mesmo tamanho
        D = [D ; Y mzero]; %concatena na resposta tudo o que encontrou

    end
end

function num = fatorial(n)
%function num = fact(n)
%n: input number whose factorial is required
%num: factorial of n
%
% This function symbolic math toolbox to evaluate the factorial of a number
% that is greater than 170. Other file example.m demonstrates the
% usefullness of this function.
%
%Nabin S. Sharma
%UMass Dartmouth
%Date:October 25, 2008
    
    if(n > 171)
        kfac = sym('k!');
        syms k;
        num = subs(kfac,k,n);
    else
        num = factorial(n);
    end 
end

function testaMetodo5(D, X, h, n, fileID, Y)
    %in = input('Gostaria de testar a funcao? (s/n)\n', 's');
    in = 's';
    if(in == 's')
        tic
        %fprintf('  xi  \t  yi  \n');
        for i = 1:n
            y = calculaMetodo5(D, X, h, n, X(i));
            if(y ~= Y(i))
                fp = fopen('erros.txt', 'a');
                fprintf(fp, '****Metodo 5: Erro! x = %f****\n', X(i));
                fprintf(fp, 'real: %f\tcalculado: %f\ndif: %f\n', Y(i), y, Y(i)-y);
                fclose(fp);
            end
            %fprintf('%f\t%f\n----\n', X(i), y);
        end
        fprintf(fileID, '%f;', toc);
    end
    
    %in = input('Gostaria de interpolar a funcao? (s/n)\n', 's');
    in = 'n';
    while(in == 's')
        x = input('Digite um valor para x: ');
        y = calculaMetodo5(D, X, h, n, x);
        
        fprintf('P(%f) = %f\n', x, y);
        
        in = input('Gostaria de testar a funcao novamente? (s/n)\n', 's');
    end
end

function [y] = calculaMetodo5(D, X, h, n, x)
    y = 0;
    for i = 1:n
        d = D(n-(i-1), 1) * 1/( ( factorial(i-1) * power(h, (i-1) ) ) );

        for j = 1:i-1
            d = d * (x - X(j));
        end
        y = y + d;
    end
end