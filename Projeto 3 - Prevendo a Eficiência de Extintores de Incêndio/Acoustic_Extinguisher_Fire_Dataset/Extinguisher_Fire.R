
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

# criando tabela cruzada de frenquência entre SIZE e STATUS
tab <- table(df$SIZE, df$STATUS)

addmargins(tab)

# tabela cruzada de frenquência entre SIZE e STATUS
tab_pro <- prop.table(tab) * 100
round(tab_pro, digits = 2) # arredondando para duas casas decimais

# criando tabela cruzada de frenquência entre FUEL e STATUS
tab1 <- table(df$FUEL, df$STATUS)

# tabela cruzada de frenquência entre FUEL e STATUS
tab_pro1 <- prop.table(tab1) * 100
round(tab_pro1, digits = 2) # arredondando para duas casas decimais


# Plotar gráfico de dispersão entre airflow e distancia
library("ggplot2")

ggplot(df, aes(x = FREQUENCY, y = AIRFLOW, color = FUEL, shape = FUEL)) +
  geom_point(size = 3) +
  scale_size(range = c(1, 10)) +
  labs(x = "Airflow", y = "Distancia", title = "Gráfico de Dispersão")

# Calcula a matriz de correlação
library(reshape2)
matrizcorr <- cor(df[,num])
matriz_melt <- melt(matrizcorr)

library(ggplot2)

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

