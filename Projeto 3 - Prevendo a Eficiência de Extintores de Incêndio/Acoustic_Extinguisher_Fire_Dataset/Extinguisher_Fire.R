
# Objetivo do Projeto com Feedback 2: 
# Seria possível usar Machine Learning para prever o 
# funcionamento de um extintor de incêndio com base em
# simulações feitas em computador e assim incluir uma camada 
# adicional de segurança nas operações de uma empresa?

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
## Desibel
hist(df$DESIBEL,
     main = "Altura dos alunos do 1º ano do Ensino Médio",
     xlab = "Desibel (dB)", ylab = "Freq. Absoluta",
     col = c("blue"),
     border = FALSE,
     xlim = c(70,118), ylim = c(0,2500),
     labels = TRUE)

## Ao investigar o histograma resultando dos dados obtidos através do
# decibelímetro que tinha como objetivo medir a intensidadade do som durante o
# experimento. É visto que a variável Desibel não segue uma distrbuição normal.
# Além disso esse vetor apresenta dois sino durante a distrbuição uma no
# inervalo de 80 - 100 dB e outro 100 - 113 dB.

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
# 2 - O ponto do primero quartil foi  3,2 m/s e linha preta que representa a
# mediana (2° quartil) está localizada em 5,8 m/s e o 3° quaritl 11,2 m/s. Ainda
# sobre o box plot o 3° quartil aprensata maior concentração dos dados e não foram
# encontrados valores outliers.

## |Histograma - Frequency
hist(df$FREQUENCY,  
     main = "Frequência Durante o Experimento", 
     xlab = "Frequência (Hz)", ylab = "Freq. Absoluta", 
     col = c("blue"), 
     border = FALSE, 
     xlim = c(0,80), ylim = c(0,2000),
     labels = TRUE)

# A frequência do som durante o experimento tem um distribuição no intervalor
# 0 - 20 Hz uniforme, seguida de uma queda no intervalo seguinte. Se mantendo de
# forma irregular nas medidas de frequência seguintes.

# Boxplot - Frenquecy
boxplot(df$FREQUENCY,
        main = "Boxplot - Frenquência",
        ylab = "Frenquência (Hz)",
        col = "red")

summary(df$FREQUENCY)

# Distance
hist(df$DISTANCE,  
     main = "Distância durante o Experimento", 
     xlab = "Distância (cm)", ylab = "Freq. Absoluta", 
     col = c("blue"), 
     border = FALSE, 
     xlim = c(0,200), ylim = c(0,2000),
     labels = TRUE)

# A única barra de contagem irregular no histograma acima é a primeira que
# Apresentou uma contagem de 1836. As demais seguem uma distrbuição uniforme.
# Assim como vimos nas variáveis anteriores, essa também não apresentou um 
# distrbuição normal.


## 1. O que acontece com o sucesso do experimento a medida que o tamanho do
## recipiente, ou chama aumenta?

# criando tabela cruzada de frenquência entre SIZE e STATUS
tab <- table(df$SIZE, df$STATUS)
addmargins(tab)

## Resposta 1 - Considerando os combustíveis líquidos
## Ao observar a relação entre as variáveis Size que representa o 
## tamanho do recipiente do combustível e o tamanho da chama e Status que 
## representa se o experimento em apagar as chamas foi um sucesso ou não.
## A medida que o tamanho do recipiente aumenta de 1-5, isto é, o tamanho chama
## o número de falhas ao extinguir a chama aumenta. Consequentemente, o número 
## de sucesso de extinção de chamas no experimento proposto reduz.
## Resposta 1 - Considerando os combustível GLP (gás)
## Vemos que a medida que o tamanho da chama aumenta 6-7 as falhas ao extinguir
## as chamas também aumenta, no sentido contrário o número de sucesso reduz.
## É possível observar um padrão nesses dados entre as variáveis Size e Status,
## um padrão inverso, à medida que um aumenta o outro diminui.


# tabela cruzada de frenquência entre SIZE e STATUS
tab_pro <- prop.table(tab) * 100
round(tab_pro, digits = 2) # arredondando para duas casas decimais

## 2. Qual o resultado final do experimento para os direntes tipos de
## combustíveis?

# criando tabela cruzada de frenquência entre FUEL e STATUS
tab1 <- table(df$FUEL, df$STATUS)
tab1

## Resposta 2 - O número observado de sucesso no experimento entre os diferentes
## tipos de combustíveis foi variado. Para a GASOLINA vemos um número maior de
## sucessos no experimento em comparação com as falhas do mesmo combustível.
## Já para a KEROSENE, apresentou um número superior nas falhas ao extinguir as
## chamas. Esse mesmo comportamento se repete com o THINNER. E o, LPG tem
## comportamento semelhante a gasolina, com um número superior de sucesso na
## tentativa em extinguir as chamas.

# tabela cruzada de frenquência entre FUEL e STATUS
tab_pro1 <- prop.table(tab1) * 100
round(tab_pro1, digits = 2) # arredondando para duas casas decimais

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
  ggtitle("Distribuição de Sucesso e Falha por Distância")


plot1

## Resposta 3 - Ao observar o gráfico acima podemos deduzir que a distância
## aumenta o número de sucesso de extinção de chamas reduz. Outro ponto interessante
## observado nesse gráfico é que quando a distância atinge o intervalor de
## 100 - 110 cm o trajeto das linhas de falhas e sucesso se cruzam, isso indica que
## a essa distância as falhas e os sucessos são parelhos.

## 4. Como o Fluxo de Ar afeta a o sucesso ou falha do experimento?

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
  ggtitle("Distribuição de Sucesso e Falha por Fluxo de Ar")

plot2

## Resposta 4 - Ao observar o plot2, em específico as falhas representadas pelas
## barras em vermelho, é visto que em sua grande maioria estão agrupadas nos
## fluxos de ar mais baixo. Por consequência, os fluxos de ar maiores apresentaram
## maior representatividade para sucesso em apagar as chamas.
## Então, fazendo uma simples análise desse gráfico quanto maior o fluxo de ar 
## maiores a chances de sucesso no experimento.

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

## Resposta 5 - Ao análise o resultado do gráfico de densidade no gráfico 3.
## Quando a frequência esta proxima de 6 Hz temos um numero maior de falhas.
## Ao aumentar a frequência para 8 Hz foi visto um aumento no número de sucesso
## em comparação com as falhas esse padrão foi visto até 40 Hz. E de 40 Hz em
## diante o número de falhas foi superior ao sucesso.

# 6.
ggplot(df, aes(x = DESIBEL, fill = STATUS)) +
  geom_density(alpha = 0.3) +  
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

# Calcula a matriz de correlação
matrizcorr <- cor(df[,num])
matriz_melt <- melt(matrizcorr)

# Definir cores personalizadas
colors <- c("#FFFFFF", "#FF0000")  # Branco e Vermelho

# Plotar o heatmap com texto
ggplot(matriz_melt, aes(Var2, Var1, fill = value)) +
  geom_tile(color = "black") +
  geom_text(aes(label = round(value, 2)), color = "black", size = 3) +
  scale_fill_gradientn(colors = colors, limits = c(-1, 1), breaks = seq(-1, 1, by = 0.2)) +
  labs(x = "Variável 2", y = "Variável 1", title = "Heatmap de Correlação") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        plot.title = element_text(size = 14, face = "bold"),
        axis.title = element_text(size = 12),
        legend.title = element_blank(),
        legend.text = element_text(size = 10),
        legend.position = "right")

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

# variáveis importantes de acordo com o RF
modelo <- randomForest(STATUS ~ . ,
                       data = df,
                       ntree = 100, nodesize = 10,
                       importance = TRUE)

varImpPlot(modelo) 

# dividindo dados em treino e teste
set.seed(10)

indice_treinamento <- createDataPartition(df$FUEL, p = 0.7, list = FALSE)
dados_treinamento <- df[indice_treinamento,]
dados_teste <- df[-indice_treinamento,]

# Treinar o modelo de regressão logística
modelo_glm <- train(STATUS ~ ., 
                data = dados_treinamento,
                method = "glm", 
                family = "binomial")

# Fazer previsões nos dados de teste
previsoes <- predict(modelo_glm, newdata = dados_teste)

# Calcular a acurácia
acuracia <- confusionMatrix(previsoes, dados_teste$STATUS)$overall['Accuracy']

# Obter a matriz de confusão
matriz_confusao <- confusionMatrix(previsoes, dados_teste$STATUS)

prop.table(table(df$STATUS))

prop.table(table(dados_treinamento$STATUS))

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
