#include <iostream>
#include <fstream>
#include <string>
#include <stdlib.h>

using namespace std;
int main(){
    ifstream in ("erros.txt");
    ofstream out ("erros-filtrado.txt");
    string linha, buffer, k;

    buffer.clear();
    while(getline(in, linha)){
        if(linha[0] == 'P'){
            k.clear();
            k = '\n' + linha + "\n\n";
            continue;
        }
        buffer += linha + '\n';

        size_t found = linha.find('\t');
        if (found != std::string::npos){
            std::string::size_type sz;
            string reals, calculados;
            double real, calculado;
            reals.clear();
            calculados.clear();

            reals = linha.substr(6,found-6);
            calculados = linha.substr(found+12);

            real = atof(reals.c_str());
            calculado = atof(calculados.c_str());

            if(real != calculado){
                getline(in, linha);
                buffer += linha + '\n';
                buffer = k + buffer;
                out << buffer;
                k.clear();
                buffer.clear();
            }
            else{
                getline(in, linha);
                buffer.clear();
            }
        }
    }
    in.close();
    out.close();
}
