
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

# Carregando dataset
df <- read_xlsx("Acoustic_Extinguisher_Fire_Dataset.xlsx")

# Verificando a existência de valores NA em df
any(is.na(df)) # Não foi encontrado valores NA em df

# Verificando as classes da variáveis de df 
str(df)

# Vetor com os nomes das variáveis a serem convertidas
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

# histograma - Airflow
ggplot(df, aes(x = AIRFLOW)) +
  geom_histogram(binwidth = 0.5, fill = "lightblue", color = "black") +
  labs(x = "Valores", y = "Frequência") +
  theme_minimal() +
  theme(
    panel.border = element_blank(),
    legend.position = "top",
    legend.title = element_blank(),
    legend.key.size = unit(0.5, "cm"),
    axis.title = element_text(size = 12),
    axis.text = element_text(size = 10),
    plot.title = element_text(size = 14, hjust = 0.5)
  )+ 
  ggtitle("Histograma AirFlow")

# histograma - Desibel
ggplot(df, aes(x = DESIBEL)) +
  geom_histogram(binwidth = 0.5, fill = "lightblue", color = "black") +
  labs(x = "Valores", y = "Frequência") +
  theme_minimal() +
  theme(
    panel.border = element_blank(),
    legend.position = "top",
    legend.title = element_blank(),
    legend.key.size = unit(0.5, "cm"),
    axis.title = element_text(size = 12),
    axis.text = element_text(size = 10),
    plot.title = element_text(size = 14, hjust = 0.5)
  )+ 
  ggtitle("Histograma Desibel")

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



# Plotar gráfico de dispersão entre airflow e distancia


ggplot(df, aes(x = FREQUENCY, y = AIRFLOW, color = FUEL, shape = FUEL)) +
  geom_point(size = 3) +
  scale_size(range = c(1, 10)) +
  labs(x = "Airflow", y = "Distancia", title = "Gráfico de Dispersão")

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

