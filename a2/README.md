# PCS5024 - Aprendizado Estatístico - Statistical Learning - 2025/1

Atividade e discussão no arquivo a2_curriculum.py.

Obs: para executar o arquivo, é necessário incluir os dados (santos_ssh.csv) no diretório.

---
> Abaixo é possivel ler uma cópia da discussão do arquivo a2_curriculum.py. Essa cópia pode estar desatualizada. Para garantir a leitura da versão mais atual, por favor, leia no arquivo `a2_curriculum.py`. Caracteres de pontuação também foram evitados para evitar erros na codificação.

# Comentários sobre a solucao

No arquivo `a2_curriculum.py`, foram implementados o Teacher Forcing e o Curriculum Learning.

Para isso, os dados verdadeiros ("ground truth") foram passados para a RNN durante o treinamento, mais especificamente durante a etapa de decodificacao, e esses dados foram utilizados como entrada para algumas das etapas da RNN no lugar de utilizar a saida do ultimo estado oculto. Essa insercao dos dados verdadeiros faz com que o modelo tenha maior probabilidade de gerar um proximo estado oculto adequado.

A quantidade de dados verdadeiros que e inserida na etapa de treinamento foi chamada de "teacher forcing rate" (TFR). O TFR define a porcentagem de dados verdadeiros utilizados no treinamento, ou seja, se TFR for igual a 0.2, serao utilizados dados verdadeiros em 20% das entradas da RNN. Para implementar o Curriculum Learning, as funcoes de treinamento foram modificadas para aceitar diferentes niveis de TFR, definida no loop principal de acordo com alguns metodos.

Foram implementados os seguintes metodos de Curriculum Learning:

- "linear": O nivel de TFR comeca em initial_tfr e decai linearmente ate 0 ao final das epocas de treinamento.

- "proportional": O nivel de TFR eh proporcional ao erro de teste, com fator proportional_method_factor.

- "constant": O nivel de TFR se mantem constante do inicio ao fim, no valor initial_tfr. Note que esse metodo equivale ao teacher forcing sem curriculum learning, e quando initial_tfr==0 ele equivale ao modelo autoregressivo.

- "exponential": O nivel de TFR comeca em initial_tfr e decai exponencialmente ate o valor exponential_method_factor.

Todos os metodos foram executados variando os valores de initial TFR e dos seus fatores, quando aplicavel (proportional e exponential). Os resultados desses experimentos podem ser vistos no arquivo training_report.pdf.

## Metodo de obtencao dos resultados

O arquivo a2_curriculum.py pode ser executado diretamente com

```
python3 a2_curriculum.py
```

Isso utilizara os valores padrao dos parametros. Foram definidos novos parametros para a utilizacao de teacher forcing e curriculum learning, que podem ser utilizados para controlar o metodo de curriculum learning e seus parametros.

Para obter os resultados (arquivo training_report.pdf) os treinamentos foram executados em diversas maquinas com o uso do arquivo run_experiments.sh. Esse arquivo executa 1/5 dos experimentos, de acordo com o argumento passado para "section". Isso possibilita o uso de ate 5 maquinas para executar os experimentos em paralelo. Para executar os experimentos com initial_tfr igual a 0.1 e 0.2, por exemplo, foi utilizado o comando 

```
./run_curriculum.sh 0 
```

Apos a finalizacao de todas as 5 secoes, os arquivos com os resultados foram copiados para um unico computador, onde foi executado o script generate_report.py, que leva o diretorio onde estao os arquivos com os resultados como argumento. Isso produziu o arquivo training_report.py.


## Autoregressive Model

Para essa atividade, foram realizados experimentos utilizando 800 pontos "no passado" para tentar prever os proximos 400 pontos. O resultado do treinamento sem teacher forcing pode ser visto no relatorio de treinamento (arquivo training_report.pdf), na pagina 1. Nesse resultado, foi utilizado o metodo constant, com initial_tfr igual a 0, portanto, o TFR foi mantido em zero durante todo o treinamento. Devido ao numero alto de pontos no futuro em relacao ao numero de pontos no passado, podemos ver que o modelo sem teacher forcing teve bastante dificuldade em convergir, nao reduzindo o erro de teste para menos de ~0.55.

![image](https://github.com/user-attachments/assets/fe010356-c1c6-430e-b7b4-980d5fcb6ddb)


## Teacher Forcing Model

Nas paginas seguintes do relatorio de treinamento (paginas 2 a 11), estao apresentados os resultados para diferentes niveis de teacher forcing. Para isso, foi utilizado o metodo constant, e o valor de initial_tfr foi variado entre 0.1 e 1 em intervalos de 0.1. Podemos ver que para alguns valores de teacher forcing o resultado do treinamento supera o resultado sem teacher forcing algum. Especificamente, os erros finais de teste para initial_tfr igual 0.4, 0.6 e 0.7 chegaram proximos a 0.50. Podemos ver tambem que alguns valores de teacher forcing resultaram em treinamentos piores do que no caso sem teacher forcing, como foi o caso para teacher forcing de 0.2, por exemplo. Tambem podemos ver nesses resultados que o erro de treino cai drasticamente conforme o TFR aumenta, como esperado ja que estao sendo dadas parte das respostas durante o treino.

![image](https://github.com/user-attachments/assets/cf7cf054-b246-4bb2-b069-ab153cf81246)


![image](https://github.com/user-attachments/assets/21bdbe72-55f5-4683-a3a9-50809bbf0cdb)


## Curriculum Learning Model

As paginas 12 a 56 do relatorio de treinamento contem os experimentos referentes ao uso de curriculum learning, separados da seguinte maneira:

- Paginas 12 a 41: metodo exponencial
- Paginas 42 a 51: metodo linear
- Paginas 52 a 56: metodo proporcioinal

O melhores resultados para o metodo linear foram obtidos com os seguintes parametros, nas paginas 46 e 47:

- Curriculum method: Linear
- Initial TFR: 0.5, 0.6

O melhores resultados para o metodo proporcional foram obtidos com os seguintes parametros, nas paginas 54 e 56:

- Curriculum method: proportional
- Proportional factor: 0.6, 1.0 

Tambem podemos observar que muitas combinacoes de metodo e parametros do curriculum learning superam o teacher forcing. Em especial, na pagina 41 do relatorio de treinamento, eh possivel observar que o metodo de curriculo que obteve melhor convergencia entre todos os testados foi o metodo exponencial, com erro de teste final de ~0.39. Para esse resultado, foram utilizados os seguintes parametros:

- Curriculum method: exponential
- Initial TFR: 1
- Exponential factor: 0.1

![image](https://github.com/user-attachments/assets/4366b329-43fd-4b52-b91e-d4f61ce4b544)

Com esses experimentos foi possivel observar o efeito do teacher forcing e do curriculum learning no treinamento de uma RNN. Foi observada uma melhoria na convergencia do modelo ao utilizar teacher forcing com relacao ao treinamento padrao, e uma melhoria maior ainda ao utilizar alguns metodos de curriculum learning.





