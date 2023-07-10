# Projeto com FeedBack 2 da Formação Cientista de Dados da Data Science Academy
# Machine Learning na Segurança do Trabalho: Prevendo a Eficiência de Extintores de Incêndio
## Visão Geral do Projeto:
O objetivo deste estudo é explorar a possibilidade de criar um modelo de Machine Learning para prever o funcionamento de extintores de incêndio com base em simulações computacionais. O teste hidrostático de extintor, estabelecido pelas normas da ABNT, visa identificar possíveis falhas nos extintores. Para aumentar a segurança nesse procedimento, busca-se adicionar uma camada adicional de segurança através de modelos de Machine Learning. Os dados utilizados são provenientes de um experimento de extinção de chamas com diferentes tipos de combustíveis, utilizando um sistema de extinção por ondas sonoras. O objetivo é predizer se a extinção das chamas foi bem-sucedida ou falhou com base em seis recursos de entrada.
O projeto utilizará técnicas de machine learning para prever o consumo de energia de carros elétricos com base em diversos fatores de utilização dos veículos e características dos veículos. Três modelos distintos foram testados e avaliados: regressão linear, árvore de decisão e random forest, sendo este último utilizado para feature selection. Os modelos foram treinados e validados com o conjunto de dados adquirido.

## Metodologia:
A metodologia a ser utilizada no projeto foi a seguinte:

1. **Coleta e Preparação de Dados**: O conjunto de dados foi obtido como resultado dos testes de extinção de quatro chamas de combustíveis diferentes com um sistema de extinção de ondas sonoras.

2. **Análise Exploratória de Dados**: Foi realizada uma análise exploratória dos dados para obter insights sobre as características dos veículos elétricos e os fatores que afetam o consumo de energia.

3. **Seleção e Treinamento dos Modelos**: modelos distintos foram testados e avaliados: regressão logistica, KNN e random forest. A seleção do modelo mais adequado foi baseada na precisão do modelo.

4. **Validação dos Modelos**: Os modelos treinados foram validados com um conjunto de dados de teste para avaliar a precisão dos modelos.

## Tecnologias Utilizadas:
As seguintes tecnologias foram utilizadas no projeto:

- R
- RStudio

Pacotes utilizados:
Os seguintes pacotes R foram utilizados neste projeto:

- **ggplot2** - para visualizações gráficas
- **reshape2** - para transformação de dados
- **corrplot** - para visualização de correlações
- **dplyr** - para manipulação de dados
- **hrbrthemes** - para temas de gráficos
- **randomForest** - para construção do modelo de random forest
- **gmodels** - para visualização de resultados de modelos
- **lattice** - para visualização de gráficos
- **caret** - para seleção de modelos e tuning de hiperparâmetros



