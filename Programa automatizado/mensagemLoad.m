function mensagemLoad(load)
    persistent total; 
    if(load >= 0)
        fprintf('\nCalculando... %3.2f%%', load * 100);
        if(load > 0)
            t = toc;
            fprintf('\tTempo gasto: %f s', t);
            total = total + t;
            
            aux = 1 - load;
            
            if(abs(aux) <= power(10, -6))
                fprintf('\n\nTempo total gasto: %f s', total);
            end
        else
            total = 0;
        end
    end

    tic
end