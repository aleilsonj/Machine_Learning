# Definindo Diretório de Trabalho
setwd("C:/Users/ALEILSON/Documents/github/R_Projeto_Sup/Proj1")
getwd()

# Pacotes Necessários
library(readxl)
library(ggplot2)
library(reshape2)
library(corrplot)
library(dplyr)
library(hrbrthemes)
library(randomForest)
library(gmodels)
library(lattice)
library(caret)

# Carregando dataset
dataset <- read_excel("FEV-data-Excel.xlsx")
str(dataset)

# Renomenado Variáveis
names(dataset) <- c("nome","marca","modelo","preco_min","forca_motor","maximo_torque","tipo_freio",
                    "tipo_tracao","capacidade_carga","distancia_max_perco","distancia_eixo","comprimento",
                    "largura","altura","peso_vazio_min","peso_aceito","peso_max","assentos","portas",
                    "tamanho_pneu","vel_max","cap_carga","acel_s","pot_max_carre","media_consener" 
                    ) 
# preco_min [PLN], forca_motor(KM), Maximum torque (newton metros), capacidade_carga (kwh),
# distancia_max_perco ((WLTP) [km]), vel_max [kph], tamanho_pneu [in], cap_carga (L), acel_ 0-100 kph [s]
# pot_max_carre [kW], media_consu-energ [kWh/100 km]

            ###############################################
            #     Análise dos Exploratória dos Dados      #
            ############################################### 


# Verificando se Existe Valores NA no dataset
any(is.na(dataset))
sum(is.na(dataset)) # Foram detectados 30 valores NA
colSums(is.na(dataset))

# Substituindo valores NA das variáveis num por média
cols <- c("peso_max", "media_consener", "peso_aceito",
          "cap_carga", "acel_s")
dataset[cols] <- lapply(dataset[cols], function(x) {
  meanx <- mean(x, na.rm = TRUE)
  x[is.na(x)] <- meanx
  return(x)
})

# Removendo valor NA de Var categorica
dataset <- na.omit(dataset)
sum(is.na(dataset))

                       #########################                           
                       ##Variáveis Catégoricas##
                       #########################

# Selecioando variáveis catégoricas para Subset.
var_cat <- c("nome","marca","modelo","tipo_freio","tipo_tracao")

# subset variaveis categoricas
subset_cat <- dataset %>% 
  select(var_cat)

## table de cont - freio e tração
model_table <- table(subset_cat$tipo_freio, subset_cat$tipo_tracao)
model_table <- prop.table(model_table) * 100
round(model_table, digits = 1)

# Analisando essa tabela é observado que aproximadamente 40% do carros que tem tração
# frontal possuem discos a freio frontal e traseiro e aproximadamente 35% do que possuem
# tração nas quatro rodas tem frios a discos frontais e traseiros.
# Das 52 observações cerca de 13,04% possuem freio a disco frontal e tambor transeiro.

## table de cont - marca e freio
model_table1 <- table(subset_cat$marca, subset_cat$tipo_freio)
model_table1 <- prop.table(model_table1) * 100
round(model_table1, digits = 1)

# Apenas as marcas Volkswagen, Smart, Skoda utilizam o tipo de freio a disco frontal
# e tambor traseiro. As demais marcas utilizam frios a disco frontal e trazeiro.

## Engenharia de atributos
# Primeiro: tomei a decisão de segui apenas com as variáveis marca, tipo_frio e
# Freio a dicos. acreido que o nome do carro e o seu modelo não sejam essenciais
# para o modelo e passam um informação semelhante a variável nome.

# Atribuindo valores numericos as variáveis categoricas.
dataset$tipo_tracao <- as.numeric(as.factor(dataset$tipo_tracao))
dataset$tipo_freio <- as.numeric(as.factor(dataset$tipo_freio))
dataset$marca <- as.numeric(as.factor(dataset$marca))

# Variáveis numéricas
# Variáveis numéricas
var_num <- c ("preco_min","forca_motor","maximo_torque","capacidade_carga","distancia_max_perco","distancia_eixo","comprimento",
            "largura","altura","peso_vazio_min","peso_aceito","peso_max","assentos","portas",
            "tamanho_pneu","vel_max","cap_carga","acel_s","pot_max_carre", "media_consener" 
)

# subset variáveis numéricas
subset_num <- dataset %>% 
  select(var_num)

# Criando o layout
nf <- layout( matrix(c(1,2), ncol=2) )

# plots - hist e boxplot
hist(subset_num$capacidade_carga , breaks=20 , border=F , col=rgb(1,0,0,0.5) , xlab="Distruição - Capacidade de Carga " , main="")
title(main = "Histograma")
boxplot(subset_num$capacidade_carga , xlab="Capacidade de Carga" , col=rgb(0,0,1,0.5) , las=2)
title(main = "Boxplot")

# plots
cols <- c("peso_max", "media_consener", "peso_aceito",
          "cap_carga", "acel_s")
mapply(function(x,col) {
  nf <- layout( matrix(c(1,2), ncol=2) )
  hist(x , breaks=20 , border=F , col=rgb(1,0,0,0.5), main="", xlab=col)
  title(main = "Histograma")
  boxplot(x , col=rgb(0,0,1,0.5) , las=2, xlab=col)
  title(main = "Boxplot")
}, subset_num[cols], cols)

# Análise bivariada - análise de correlação
# plot 1
subset_num %>% 
  ggplot() +
  aes(peso_vazio_min, peso_aceito) +
  geom_point() +
  labs( title = "Peso vazio min x Peso Aceito") +
  xlab("Peso Vazio min") + 
  ylab("Peso Aceito") + 
  theme_ipsum()

cor(subset_num$peso_vazio_min, subset_num$peso_aceito)

# Plot 2
subset_num %>% 
  ggplot() +
  aes(acel_s, maximo_torque) +
  geom_point() +
  labs( title = "Aceleração 0-100 kph (s) x Maximo Torque") +
  xlab("Aceleração (s)") + 
  ylab("Torque (L)") + 
  theme_ipsum()

cor(subset_num$acel_s, subset_num$maximo_torque)

# plot 3
subset_num %>% 
  ggplot() +
  aes(vel_max, forca_motor) +
  geom_point() +
  labs( title = "Velocidade Máximo x Força do Motor") +
  xlab("Velocidade") + 
  ylab("Força do Motor") + 
  theme_ipsum()

cor(subset_num$vel_max, subset_num$forca_motor)

#plot 4
var_num1 <- c("forca_motor","maximo_torque","vel_max","acel_s","peso_max",
              "peso_aceito","peso_vazio_min","cap_carga",
              "distancia_max_perco","distancia_eixo","comprimento")

matriz <- dataset  %>%
  select(var_num1)


matrizcorr <- (cor(matriz))
matriz_melt <- melt(matrizcorr)

ggplot(matriz_melt, aes(Var2, Var1, fill = value)) + 
  geom_tile() + 
  geom_text(aes(label = round(value, 2)), color = "black", size = 3) +
  scale_fill_gradient2(low = "white", high = "red", midpoint = 0) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


# 1- as variáveis vel_s, vel_max, maximo_torque e Forca_motor apresentam alta correlação
# e podem causa problemas de multicolinearidade futuramenta pois passam informções semelhantes.

# Feature Selection
# variaveis siginificantes
df <- dataset %>% select(-c("nome", "modelo"))

vars_df_normalize <- c("marca","preco_min","forca_motor","maximo_torque","tipo_freio",
                       "tipo_tracao","capacidade_carga","distancia_max_perco","distancia_eixo","comprimento",
                       "largura","altura","peso_vazio_min","peso_aceito","peso_max","assentos","portas",
                       "tamanho_pneu","vel_max","cap_carga","acel_s","pot_max_carre" 
) 

# padronização dos dados
df[, vars_df_normalize] <- scale(df[, vars_df_normalize])

# variáveis importantes de acordo com o RF
modelo <- randomForest(media_consener ~ . ,
                       data = df,
                       ntree = 100, nodesize = 10,
                       importance = TRUE)

varImpPlot(modelo) 

# Irei selecionar as 15 variaveis mais importantes de acordo com MSE do
# Modelo RandomForest
var_fs <- c ("peso_max","peso_aceito","comprimento","distancia_eixo","cap_carga",
             "vel_max","tamanho_pneu","largura","marca","preco_min","peso_vazio_min",
             "distancia_max_perco","maximo_torque","capacidade_carga","pot_max_carre",
             "media_consener"
              )

# Feature selection
df_fs <- df %>% 
  select(all_of(var_fs))

colSums(is.na(df_fs))

summary(df_fs)

# dividindo dados em treino e teste
set.seed(1998)

indice_treinamento <- createDataPartition(df_fs$peso_max, p = 0.7, list = FALSE)
dados_treinamento <- df_fs[indice_treinamento,]
dados_teste <- df_fs[-indice_treinamento,]

# Modelo de Regressão 1
model1 <- lm(media_consener ~ ., data = dados_treinamento)
summary(model1)  

# Predict
previsao1 <- predict(model1)
View(previsao1)

# Prevendo com Dados de teste
previsaot1 <- predict(model1, dados_teste)
View(previsaot1)

# Modelo de Regressão 2
# Feature Selection - Como foi visto na análise exploratória algumas variavéis preditoras
# apresentaram um alta correlação. Agora, irei excluir algumas desses vetores do modelo
# com o objetivo de reduzir problemas de multicolinearidade.

var2 <- (media_consener ~ peso_max + peso_aceito + capacidade_carga + vel_max +
           distancia_max_perco + pot_max_carre + largura + marca + 
           + tamanho_pneu)

#treino
model2 <- lm(var2, data = dados_treinamento)
summary(model2) 

previsao2 <- predict(model2, dados_teste)
View(previsao2)

#teste
previsaot2 <- predict(model2, dados_teste)
View(previsaot2)

# Modelo de Regressão 3
# Tomei a decisão de remover as variáveis marca, largura, peso_max e pot_max_carre
# pois apresentram um baixo nível de siginificância no modelo.

var3 <- (media_consener ~ peso_aceito + vel_max + tamanho_pneu +
           distancia_max_perco + capacidade_carga
)

# Treino
model3 <- lm(var3, data = dados_treinamento)
summary(model3)

previsao3 <- predict(model3, dados_teste)
View(previsao3)

# Prevendo com Dados de teste
previsaot3 <- predict(model3, dados_teste)
View(previsaot3)





  