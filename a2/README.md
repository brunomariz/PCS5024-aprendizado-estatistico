# PCS5024 - Aprendizado Estatístico - Statistical Learning - 2025/1

Publicado em https://github.com/brunomariz/PCS5024-aprendizado-estatistico/edit/main/a2

Atividade e discussão no arquivo a2_curriculum.py.

Obs: para executar o arquivo, é necessário incluir os dados (santos_ssh.csv) no diretório.

---

# Comentários sobre a solução

No arquivo `a2_curriculum.py`, foram implementados o Teacher Forcing e o Curriculum Learning.

Para isso, os dados verdadeiros ("ground truth") foram passados para a RNN durante o treinamento, mais especificamente durante a etapa de decodificação, e esses dados foram utilizados como entrada para algumas das etapas da RNN no lugar de utilizar a saída do último estado oculto. Essa inserção dos dados verdadeiros faz com que o modelo tenha maior probabilidade de gerar um próximo estado oculto adequado.

A quantidade de dados verdadeiros que e inserida na etapa de treinamento foi chamada de "teacher forcing rate" (TFR). O TFR define a porcentagem de dados verdadeiros utilizados no treinamento, ou seja, se TFR for igual a 0.2, serão utilizados dados verdadeiros em 20% das entradas da RNN. Para implementar o Curriculum Learning, as funções de treinamento foram modificadas para aceitar diferentes niveis de TFR, definidas no loop principal de acordo com alguns métodos.

Foram implementados os seguintes métodos de Curriculum Learning:

- "linear": O nível de TFR começa em `initial_tfr` e decai linearmente até 0 ao final das épocas de treinamento.

- "proportional": O nivel de TFR é proporcional ao erro de teste, com fator `proportional_method_factor`.

- "constant": O nível de TFR se mantém constante do início ao fim, no valor `initial_tfr`. Note que esse método equivale ao teacher forcing sem curriculum learning, e quando `initial_tfr==0`, ele equivale ao modelo autoregressivo.

- "exponential": O nível de TFR começa em `initial_tfr` e decai exponencialmente até o valor `exponential_method_factor`.

Todos os métodos foram executados variando os valores de initial TFR e dos seus fatores, quando aplicável (proportional e exponential). Os resultados desses experimentos podem ser vistos no arquivo ![training_report.pdf](training_report.pdf).

## Método de obtenção dos resultados

O arquivo `a2_curriculum.py` pode ser executado diretamente com

```
python3 a2_curriculum.py
```

Isso utilizará os valores padrão dos parâmetros. Foram definidos novos parametros para a utilização de teacher forcing e curriculum learning, que podem ser utilizados para controlar o método de curriculum learning e seus parâmetros.

Para obter os resultados (arquivo training_report.pdf) os treinamentos foram executados em diversas máquinas com o uso do arquivo `run_experiments.sh`. Esse arquivo executa 1/5 dos experimentos, de acordo com o argumento passado para "section". Isso possibilita o uso de ate 5 máquinas para executar os experimentos em paralelo. Para executar os experimentos com `initial_tfr` igual a 0.1 e 0.2, por exemplo, foi utilizado o comando 

```
./run_curriculum.sh 0 
```

Após a finalização de todas as 5 seções, os arquivos com os resultados foram copiados para um único computador, onde foi executado o script `generate_report.py`, que leva o diretório onde estão os arquivos com os resultados como argumento. Isso produziu o arquivo `training_report.pdf`.


## Autoregressive Model

Para essa atividade, foram realizados experimentos utilizando 800 pontos "no passado" para tentar prever os próximos 400 pontos. O resultado do treinamento sem teacher forcing pode ser visto no relatório de treinamento (arquivo `training_report.pdf`), na página 1. Nesse resultado, foi utilizado o método constant, com `initial_tfr` igual a 0, portanto, o TFR foi mantido em zero durante todo o treinamento. Devido ao número alto de pontos no futuro em relação ao número de pontos no passado, podemos ver que o modelo sem teacher forcing teve bastante dificuldade em convergir, não reduzindo o erro de teste para menos de ~0.55.

![image](https://github.com/user-attachments/assets/fe010356-c1c6-430e-b7b4-980d5fcb6ddb)


## Teacher Forcing Model

Nas páginas seguintes do relatório de treinamento (paginas 2 a 11), estão apresentados os resultados para diferentes níveis de teacher forcing. Para isso, foi utilizado o método constant, e o valor de `initial_tfr` foi variado entre 0.1 e 1 em intervalos de 0.1. Podemos ver que para alguns valores de teacher forcing o resultado do treinamento supera o resultado sem teacher forcing algum. Especificamente, os erros finais de teste para `initial_tfr` igual 0.4, 0.6 e 0.7 chegaram proximos a 0.50. Podemos ver também que alguns valores de teacher forcing resultaram em treinamentos piores do que no caso sem teacher forcing, como foi o caso para teacher forcing de 0.2, por exemplo. Também podemos ver nesses resultados que o erro de treino cai drasticamente conforme o TFR aumenta, como esperado já que estão sendo dadas parte das respostas durante o treino.

![image](https://github.com/user-attachments/assets/cf7cf054-b246-4bb2-b069-ab153cf81246)


![image](https://github.com/user-attachments/assets/21bdbe72-55f5-4683-a3a9-50809bbf0cdb)


## Curriculum Learning Model

As paginas 12 a 56 do relatório de treinamento contém os experimentos referentes ao uso de curriculum learning, separados da seguinte maneira:

- Páginas 12 a 41: método exponencial
- Páginas 42 a 51: método linear
- Páginas 52 a 56: método proporcioinal

O melhores resultados para o método linear foram obtidos com os seguintes parâmetros, nas páginas 46 e 47:

- Curriculum method: Linear
- Initial TFR: 0.5, 0.6

![image](https://github.com/user-attachments/assets/1d0ed22d-9ad4-4d1c-8267-85154e17ed4a)


O melhores resultados para o método proporcional foram obtidos com os seguintes parâmetros, nas páginas 54 e 56:

- Curriculum method: proportional
- Proportional factor: 0.6, 1.0

![image](https://github.com/user-attachments/assets/3dd2ecdc-2094-4d94-9edb-200914183d9a)

![image](https://github.com/user-attachments/assets/ba51b5e7-1ae5-4f62-9dd8-b20ee2d24f5c)


Podemos observar que muitas combinacões de método e parâmetros do curriculum learning superam o teacher forcing. Em especial, na pagina 41 do relatório de treinamento, é possível observar que o método de currículo que obteve melhor convergência entre todos os testados foi o método exponencial, com erro de teste final de ~0.39. Para esse resultado, foram utilizados os seguintes parâmetros:

- Curriculum method: exponential
- Initial TFR: 1
- Exponential factor: 0.1

![image](https://github.com/user-attachments/assets/4366b329-43fd-4b52-b91e-d4f61ce4b544)

Com esses experimentos, foi possível observar o efeito do teacher forcing e do curriculum learning no treinamento de uma RNN. Foi observada uma melhoria na convergência do modelo ao utilizar teacher forcing com relação ao treinamento padrão, e uma melhoria maior ainda ao utilizar alguns métodos de curriculum learning.
