# Título do Projeto: Machine Learning em Logística - Previsão de Consumo de Energia de Carros Elétricos
## Visão Geral do Projeto:
O objetivo deste projeto é fornecer insights para uma empresa de transporte que deseja migrar sua frota de carros elétricos para reduzir custos. Para atingir este objetivo, será utilizado um conjunto de dados de veículos elétricos adquiridos na Polônia a partir de 2 de novembro de 2020.

O projeto utilizará técnicas de machine learning para prever o consumo de energia de carros elétricos com base em diversos fatores de utilização dos veículos e características dos veículos. Três modelos distintos foram testados e avaliados: regressão linear, árvore de decisão e random forest, sendo este último utilizado para feature selection. Os modelos foram treinados e validados com o conjunto de dados adquirido.

## Metodologia:
A metodologia a ser utilizada no projeto foi a seguinte:

1. **Coleta e Preparação de Dados**: O conjunto de dados de veículos elétricos adquiridos na Polônia a partir de 2 de novembro de 2020 foi coletado e preparado para ser utilizado no projeto. A limpeza de dados, a seleção de características relevantes e a normalização de dados foram realizadas nesta etapa.

2. **Análise Exploratória de Dados**: Foi realizada uma análise exploratória dos dados para obter insights sobre as características dos veículos elétricos e os fatores que afetam o consumo de energia.

3. **Seleção e Treinamento dos Modelos**: Três modelos distintos foram testados e avaliados: regressão linear, árvore de decisão e random forest. A seleção do modelo mais adequado foi baseada na precisão do modelo na previsão do consumo de energia de carros elétricos. O modelo selecionado foi treinado com o conjunto de dados adquirido.

4. **Validação dos Modelos**: Os modelos treinados foram validados com um conjunto de dados de teste para avaliar a precisão dos modelos na previsão do consumo de energia de carros elétricos.

5. **Implantação do Modelo**: Após a validação dos modelos, o modelo de melhor desempenho foi escolhido e implantado em um ambiente de produção para permitir a previsão do consumo de energia de carros elétricos em tempo real.

## Resultados Esperados:
Espera-se que este projeto forneça uma previsão precisa do consumo de energia de carros elétricos com base em diversos fatores de utilização dos veículos e características dos veículos. Com essa previsão, a empresa de transporte poderá tomar decisões mais informadas sobre a migração de sua frota para carros elétricos e reduzir seus custos.

## Tecnologias Utilizadas:
As seguintes tecnologias foram utilizadas no projeto:

- R
- RStudio

Pacotes utilizados:
Os seguintes pacotes R foram utilizados neste projeto:

- **readxl** - para leitura de arquivos Excel
- **ggplot2** - para visualizações gráficas
- **reshape2** - para transformação de dados
- **corrplot** - para visualização de correlações
- **dplyr** - para manipulação de dados
- **hrbrthemes** - para temas de gráficos
- **randomForest** - para construção do modelo de random forest
- **gmodels** - para visualização de resultados de modelos
- **lattice** - para visualização de gráficos
- **caret** - para seleção de modelos e tuning de hiperparâmetros

## Referências:
[1] Polônia Dataset de Veículos Elétricos: [https://data.mendeley.com/datasets/tb9yrptydn/2]


