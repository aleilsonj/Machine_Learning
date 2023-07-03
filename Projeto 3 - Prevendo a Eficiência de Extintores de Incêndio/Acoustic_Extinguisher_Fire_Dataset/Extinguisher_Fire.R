# Objetivo do Projeto com Feedback 2: 
# Seria possível usar Machine Learning para prever o 
# funcionamento de um extintor de incêndio com base em
# simulações feitas em computador e assim incluir uma camada 
# adicional de segurança nas operações de uma empresa?


# Introdução

# Um procedimento estabelecido pelas normas da ABNT é o teste hidrostático de 
# extintor. Esse teste determina que todos os extintores devem ser testados a 
# cada cinco anos com o objetivo de detectar possíveis falhas. No entanto, 
# surge a questão de se seria possível criar um modelo de Machine Learning para 
# prever o funcionamento de um extintor de incêndio com base em simulações 
# feitas no computador.

# Os dados obtidos neste trabalho são resultado de um experimento de extinção de
# chamas utilizando quatro tipos diferentes de combustíveis, utilizando um 
# sistema de extinção por ondas sonoras. A partir desses dados, foram fornecidos
# seis recursos de entrada e um de saída, que será objeto de predição do nosso 
# modelo de Machine Learning. Essa variável nos indica se o experimento foi 
# bem-sucedido ou falhou, ou seja, se conseguimos extinguir as chamas para os 
# respectivos combustíveis e situações durante o teste.

rm(list = ls())

# Definindo diretório de trabalho
setwd("C:/Users/ALEILSON/Documents/github/Machine_Learning/
      Projeto 3 - Prevendo a Eficiência de Extintores de Incêndio/
      Acoustic_Extinguisher_Fire_Dataset")

# Verificando diretório de trabalho
getwd()

# Pacotes utilizados
library(readxl)
library(ggplot2)
library(reshape2)
library(dplyr)
library(e1071)
library(randomForest)
library(lattice)
library(caret)

# Carregando dataset
df <- read_xlsx("Acoustic_Extinguisher_Fire_Dataset.xlsx")

# Verificando a existência de valores NA em df
any(is.na(df)) # Não foi encontrado valores NA em df

# Verificando as classes da variáveis de df 
str(df)

# Nomes das variáveis a serem convertidas
vetores <- c("SIZE", "STATUS", "FUEL")

# Loop para converter os vetores para a classe "factor"
for (vetor in vetores) {
  df[[vetor]] <- as.factor(df[[vetor]])
}

# Verificando as classes da variáveis de df 
str(df)

# Selecionando variáveis catégoricas
cat <- names(df)[sapply(df, is.factor) | sapply(df, is.character)]

# Selecionando numéricas
num <- names(df)[sapply(df, is.numeric)]

# ANÁLISE EXPLORATÓRIA DOS DADOS
## Histograma - Desibel
hist(df$DESIBEL,
     main = "Histograma Decibel",
     xlab = "Desibel (dB)", ylab = "Freq. Absoluta",
     col = c("blue"),
     border = FALSE,
     xlim = c(70,118), ylim = c(0,2500),
     labels = TRUE)

## Ao investigar o histograma resultando dos dados obtidos através do
# decibelímetro que tinha como objetivo medir a intensidade do som durante o
# experimento. É visto que a variável Desibel não segue uma distribuição normal.
# Além disso esse vetor apresenta dois sino durante a distribuição uma no
# intervalo de 80 - 100 dB e outro 100 - 113 dB.

# Boxplot - Desibel
boxplot(df$DESIBEL,
        main = "Boxplot - Desibel",
        ylab = "Desibel (dB)",
        col = "red")

summary(df$DESIBEL)

# A variável decibel tem como valor mínimo 72 dB e valor máximo 113 dB. Essa 
# variável apresentou uma maior concentração de dados no terceiro quartil em 
# comparação com o primeiro quartil.Ao observar o boxplot do decibel, não foram
# detectados valores extremos.


## Histograma - AirFlow
hist(df$AIRFLOW,  
     main = "Fluxo de Ar durante o Experimento", 
     xlab = "Fluxo de Ar (m/s)", ylab = "Freq. Absoluta", 
     col = c("blue"), 
     border = FALSE, 
     xlim = c(0,18), ylim = c(0,2200),
     labels = TRUE)

# Observando o histograma da variável Airflow é visto que os maiores picos
# dos dados estão localizados no primeiro intervalo com fluxo de ar de 0 - 5
# sendo a maior contagem de Fluxo de Ar proxima a 5 e a segunda maior próxima a
# 0, ou seja, os extintores de incêndio estão em estado de repouso.
# A variável Airflow não tem um distrbuição dem formato de sino, um indicativo
# que não apresenta uma distrbuição normal.

# Boxplot - Airflow
boxplot(df$AIRFLOW,
        main = "Boxplot - Fluxo de Ar",
        ylab = "Fluxo de Ar (m/s)",
        col = "red")

summary(df$AIRFLOW)

# 1 - Os limite inferior da variável Airflow foi 0 m/s, esse fluxo de ar ocorre
# com o experimento em estado de repouso. Já o limite superior observado no boxplot
# foi de 17 m/s.
# 2 - O ponto do primeiro quartil foi  3,2 m/s e linha preta que representa a
# mediana (2° quartil) está localizada em 5,8 m/s e o 3° quartil 11,2 m/s. Ainda
# sobre o box plot o 3° quartil apresenta maior concentração dos dados e não foram
# encontrados valores outliers.


## Histograma - Frequency
hist(df$FREQUENCY,  
     main = "Frequência Durante o Experimento", 
     xlab = "Frequência (Hz)", ylab = "Freq. Absoluta", 
     col = c("blue"), 
     border = FALSE, 
     xlim = c(0,80), ylim = c(0,2000),
     labels = TRUE)

# A frequência do som durante o experimento possui uma distribuição uniforme no 
# intervalo de 0 a 20 Hz, seguida de uma queda no intervalo seguinte. 
# Posteriormente, mantém-se de forma irregular nas medidas de frequência 
# subsequentes.

# Boxplot - Frenquecy
boxplot(df$FREQUENCY,
        main = "Boxplot - Frenquência",
        ylab = "Frenquência (Hz)",
        col = "red")

summary(df$FREQUENCY)

# Os valores mínimos e máximos observados na variável frequency foram, 
# respectivamente, 1 Hz e 75 Hz, enquanto a mediana, que representa o segundo 
# quartil, foi de 27,5 Hz. Não foram detectados valores outliers nessa variável.
# Foi observada uma maior concentração de dados no terceiro quartil.

# Histograma - Distance
hist(df$DISTANCE,  
     main = "Distância durante o Experimento", 
     xlab = "Distância (cm)", ylab = "Freq. Absoluta", 
     col = c("blue"), 
     border = FALSE, 
     xlim = c(0,200), ylim = c(0,2000),
     labels = TRUE)

# A única barra de contagem irregular no histograma é a primeira, que apresentou
# uma contagem de 1836. As demais barras seguem uma distribuição uniforme. 
# Assim como observado nas variáveis anteriores, esta variável também não 
# apresenta uma distribuição normal.

# Boxplot - DISTANCE
boxplot(df$DISTANCE,
        main = "Boxplot - Distância",
        ylab = "Distância (Hz)",
        col = "red")

summary(df$DISTANCE)


## 1. O que acontece com o sucesso do experimento a medida que o tamanho do
## recipiente, ou chama aumenta?

# criando tabela cruzada de frenquência entre SIZE e STATUS
tab <- table(df$SIZE, df$STATUS)

# Editando os cabeçalhos das colunas
colnames(tab) <- c("Falha", "Sucesso")

# Visualizando a tabela com os cabeçalhos editados
print(tab)
# obtendo a tabela de frequências relativas fixando as colunas da tabela 
tab2 = prop.table(tab, margin=2)

plot(tab2,  xlab = "Tamanho do Combustivel", ylab="Resultado do Experimento", 
     col=c("lightblue","darkblue"),
     main=c("Grafico de mosaicos para as variáveis tipo",
            "Size e Status"))

# Considerando os combustíveis líquidos, ao observar a relação entre as 
# variáveis Size, que representa o tamanho do recipiente do combustível, e o 
# tamanho da chama, e Status, que representa se o experimento de apagar as 
# chamas foi um sucesso ou não, nota-se que conforme o tamanho do recipiente 
# aumenta de 1 a 5, ou seja, 
# o tamanho da chama, o número de falhas ao extinguir a chama também aumenta. 
# Consequentemente, o número de sucessos na extinção das chamas no experimento 
# proposto diminui.

# Considerando o combustível GLP (gás), observa-se que à medida que o tamanho da
# chama aumenta de 6 a 7, as falhas ao extinguir as chamas também aumentam. 
# Por outro lado, o número de sucessos reduz. É possível observar um padrão 
# nessas informações entre as variáveis Size e Status, um padrão inverso, em 
# que à medida que um aumenta, o outro diminui.


## 2. Qual o resultado final do experimento para os direntes tipos de
## combustíveis?

# criando tabela cruzada de frenquência entre FUEL e STATUS
tab1 <- table(df$FUEL, df$STATUS)

# Editando os cabeçalhos das colunas
colnames(tab1) <- c("Falha", "Sucesso")

# Editando os cabeçalhos das linhas
rownames(tab1) <- c("Gasolina", "Querosene", "GLP", "Thinner")

# Visualizando a tabela com os cabeçalhos editados
print(tab1)

# obtendo a tabela de frequências relativas fixando as colunas da tabela 
tab1 = prop.table(tab1, margin=2)

plot(tab1,  xlab = "Tipo de Combustivel", ylab="Resultado do Experimento", 
     col=c("lightblue","darkblue"),
     main=c("Grafico de mosaicos para as variáveis tipo",
            "Fuel e Status"))

# O número de sucessos observados no experimento variou entre os diferentes 
# tipos de combustíveis. No caso da gasolina, foi observado um maior número de 
# sucessos em comparação com as falhas relacionadas a esse combustível. 
# Por outro lado, o querosene apresentou um número superior de falhas ao 
# extinguir as chamas. Esse mesmo padrão se repete com o thinner Já o GLP 
# (GÁS DE PETRÓLEO LIQUEFEITO) tem um comportamento semelhante ao da gasolina, 
# com um número superior de sucessos na tentativa de extinguir as chamas.

# 3. O que acontece com o objeto de experimento a medida que a distancia
##   aumenta?

# Criando tabela de de frequência entre DISTANCE e STATUS
# contagem_status <- as.data.frame(table(df$DISTANCE, df$STATUS))

# Plot - 1
plot1 <- ggplot(df, aes(x = DISTANCE, fill = STATUS)) +
  geom_density(alpha = 0.5) +  
  labs(x = "Distância", y = "Densidade", fill = "Status") +
  scale_fill_manual(values = c("red", "blue"), labels = c("Falha", "Sucesso")) +
  theme_minimal() +
  theme(
    panel.border = element_blank(),
    legend.position = "top",
    legend.title = element_blank(),
    legend.key.size = unit(0.5, "cm"),
    axis.title = element_text(size = 12),
    axis.text = element_text(size = 10),
    plot.title = element_text(size = 14, hjust = 0.5)
  ) +
  ggtitle("Densidade de Sucesso e Falha por Distância")


plot1

# Ao observar o gráfico acima, podemos deduzir que à medida que a distância 
# aumenta, o número de sucessos na extinção de chamas diminui. Outro ponto 
# interessante observado nesse gráfico é que quando a distância atinge o 
# intervalo de 100 a 110 cm, as linhas de falhas e sucessos se cruzam, 
# indicando que nessa distância as falhas e os sucessos são equilibrados.

## 4. Como o Fluxo de Ar afeta o sucesso e falha do experimento?

# Plot - 2
plot2 <- ggplot(df, aes(x = AIRFLOW, fill = STATUS)) +
  geom_density(alpha = 0.5) +  
  labs(x = "Fluxo de Ar", y = "Densidade", fill = "Status") +
  scale_fill_manual(values = c("red", "blue"), labels = c("Falha", "Sucesso")) +
  theme_minimal() +
  theme(
    panel.border = element_blank(),
    legend.position = "top",
    legend.title = element_blank(),
    legend.key.size = unit(0.5, "cm"),
    axis.title = element_text(size = 12),
    axis.text = element_text(size = 10),
    plot.title = element_text(size = 14, hjust = 0.5)
  ) +
  ggtitle("Densidade de Sucesso e Falha por Fluxo de Ar")

plot2

# Ao observar o gráfico plot2, especialmente as barras vermelhas que representam
# as falhas, é possível perceber que a maioria delas está concentrada nos fluxos
# de ar mais baixos. Por consequência, os fluxos de ar mais altos apresentaram 
# uma maior proporção de sucesso na extinção das chamas. Portanto, fazendo uma 
# análise simples desse gráfico, podemos concluir que quanto maior o fluxo de ar,
# maiores são as chances de sucesso no experimento.

# 5. Como a frequência afeta o experimento?

# Plot - 3
plot3 <- ggplot(df, aes(x = FREQUENCY, fill = STATUS)) +
  geom_density(alpha = 0.5) +  
  labs(x = "Frequência (Hz)", y = "Densidade", fill = "Status") +
  scale_fill_manual(values = c("red", "blue"), labels = c("Falha", "Sucesso")) +
  theme_minimal() +
  theme(
    panel.border = element_blank(),
    legend.position = "top",
    legend.title = element_blank(),
    legend.key.size = unit(0.5, "cm"),
    axis.title = element_text(size = 12),
    axis.text = element_text(size = 10),
    plot.title = element_text(size = 14, hjust = 0.5)
  ) +
  ggtitle("Distribuição de Sucesso e Falha por Frequência (Hz)")


plot3

# Ao analisar o resultado do gráfico de densidade no gráfico 3, observa-se que 
# quando a frequência está próxima de 6 Hz, há um maior número de falhas. 
# À medida que a frequência aumenta para 8 Hz, foi observado um aumento no 
# número de sucessos em comparação com as falhas. Esse padrão é observado 
# até 40 Hz. No entanto, a partir de 40 Hz em diante, o número de falhas é 
# superior ao número de sucessos.

# 6.
ggplot(df, aes(x = DESIBEL, fill = STATUS)) +
  geom_density(alpha = 0.5) +  
  labs(x = "Decibel (dB)", y = "Densidade", fill = "Status") +
  scale_fill_manual(values = c("red", "blue"), labels = c("Falha", "Sucesso")) +
  theme_minimal() +
  theme(
    panel.border = element_blank(),
    legend.position = "top",
    legend.title = element_blank(),
    legend.key.size = unit(0.5, "cm"),
    axis.title = element_text(size = 12),
    axis.text = element_text(size = 10),
    plot.title = element_text(size = 14, hjust = 0.5)
  ) +
  ggtitle("Distribuição de Sucesso e Falha por Decibel")

# O número de sucessos e falhas no experimento apresentou um comportamento 
# semelhante. Observamos poucos casos no intervalo de 70 dB até um pouco mais 
# de 80 dB e, ao nos aproximarmos de 85 dB, podemos observar um aumento nas 
# observações para ambos os casos, seguido de uma queda aos 90 dB. 
# Um padrão semelhante ocorre quando o experimento atinge os 100 dB.

# Calcula a matriz de correlação
matrizcorr <- cor(df[,num])
matriz_melt <- melt(matrizcorr)

# Definir cores personalizadas
colors <- c("#FFFFFF", "#FF0000")

# Plotar o heatmap com texto
ggplot(matriz_melt, aes(Var2, Var1, fill = value)) +
  geom_tile(color = "black") +
  geom_text(aes(label = round(value, 2)), color = "black", size = 3) +
  scale_fill_gradientn(colors = colors) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    panel.border = element_blank(),
    legend.position = "right",
    legend.title = element_blank(),
    legend.key.size = unit(0.5, "cm"),
    axis.title = element_text(size = 12),
    axis.text = element_text(size = 10),
    plot.title = element_text(size = 14, hjust = 0.5)
  ) +
  labs(x = NULL, y = NULL) +
  ggtitle("Heatmap Correlação")

# As variáveis Distance e Airflow apresentaram uma alta correlação negativa (-0,71),
# o que indica uma associação forte e inversa entre elas. Essa correlação 
# próxima de -1 sugere que, à medida que a distância aumenta, o fluxo de ar 
# diminui e vice-versa. Essas variáveis requerem atenção especial durante a 
# criação do modelo, pois a alta correlação entre elas pode causar problemas de 
# multicolinearidade.

# A multicolinearidade ocorre quando duas ou mais variáveis independentes estão
# altamente correlacionadas entre si. Isso pode afetar negativamente a 
# interpretação dos coeficientes estimados e a estabilidade do modelo. 
# Para evitar problemas decorrentes da multicolinearidade, é importante 
# considerar estratégias como a remoção de uma das variáveis altamente 
# correlacionadas.

## Pré-Processamento
# Label Encoding
# Criando a codificação categórica

unique(df$FUEL)

# Transformando a coluna em números
df$FUEL <- recode(df$FUEL,
                  "gasoline" = 1,
                  "kerosene" = 2,
                  "thinner" = 3,
                  "lpg" = 4)

# Padronização da variáveis numéricas
df[, num] <- scale(df[, num])

# dividindo dados em treino e teste
set.seed(10)

indice_treinamento <- createDataPartition(df$FUEL, p = 0.7, list = FALSE)
dados_treinamento <- df[indice_treinamento,]
dados_teste <- df[-indice_treinamento,]

# variáveis importantes de acordo com o RF
modelo <- randomForest(STATUS ~ . ,
                       data = df,
                       ntree = 100, nodesize = 10,
                       importance = TRUE)

varImpPlot(modelo) 

# Treinar o modelo de regressão logística
modelo_glm <- train(STATUS ~ ., 
                data = dados_treinamento,
                method = "glm", 
                family = "binomial")

# Fazer previsões nos dados de teste
previsoes_glm <- predict(modelo_glm, newdata = dados_teste)

# Calcular a acurácia
acuracia_glm <- confusionMatrix(previsoes_glm, dados_teste$STATUS)$overall['Accuracy']

# Obter a matriz de confusão
matriz_confusao_glm <- confusionMatrix(previsoes_glm, dados_teste$STATUS)

# Segundo modelo GLM
modelo_glm_2 <- train(STATUS ~ SIZE + FUEL+ DESIBEL + AIRFLOW + FREQUENCY, 
                      data = dados_treinamento,
                      method = "glm", 
                      family = "binomial")

# Fazer previsões nos dados de teste
previsoes_glm_2 <- predict(modelo_glm_2, newdata = dados_teste)

# Calcular a acurácia
acuracia_glm_2 <- confusionMatrix(previsoes_glm_2, dados_teste$STATUS)$overall['Accuracy']

# Obter a matriz de confusão
matriz_confusao_glm_2 <- confusionMatrix(previsoes_glm_2, dados_teste$STATUS)

# Modelo de Classificação KNN
# Arquivo de controle
ctrl <- trainControl(method = "repeatedcv", repeats = 3)

# Criando Modelo KNN
knn_v1 <- train(STATUS ~ ., 
                data = dados_treinamento,
                method = "knn",
                trControl = ctrl,
                tuneLength = 20)

# Plot
plot(knn_v1)

# previsões nos dados de teste
knnpredict <- predict(knn_v1, newdata = dados_teste)

# Calculo da acurácia
knnacuracia <- confusionMatrix(knnpredict, dados_teste$STATUS)$overall['Accuracy']

# matriz de confusão
knnmatriz_confusao <- confusionMatrix(knnpredict, dados_teste$STATUS)


# Naive bayes)
modelo_nb <- naiveBayes(STATUS ~ ., 
                        data = dados_treinamento)


# Fazer previsões nos dados de teste
predict_nb <- predict(modelo_nb, newdata = dados_teste)

# Calcular a acurácia
acuracia_nb <- confusionMatrix(predict_nb, dados_teste$STATUS)$overall['Accuracy']

# Obter a matriz de confusão
matriz_confusaonb <- confusionMatrix(predict_nb, dados_teste$STATUS)


# Random Forest
modelo_rf <- randomForest(STATUS ~ .,
                          data = dados_treinamento,
                          ntree = 500,
                          mtry = 5)

# Fazer previsões nos dados de teste
predict_rf <- predict(modelo_rf, newdata = dados_teste)

# Calcular a acurácia
acuracia_rf <- confusionMatrix(predict_rf, dados_teste$STATUS)$overall['Accuracy']

# Obter a matriz de confusão
matriz_confusaorf <- confusionMatrix(predict_rf, dados_teste$STATUS)
