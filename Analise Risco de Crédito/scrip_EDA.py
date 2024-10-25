
# -*- coding: utf-8 -*-
"""
Created on Mon Sep 30 20:42:06 2024

@author: ALEILSON

PROJETO ANALISE DE RISCO DE CREDITO
"""
# %% 
import os

# Definindo o caminho do novo diretório
novo_diretorio = r'C:\Users\ALEILSON\Documents\github\Machine_Learning\Analise Risco de Crédito'  # Use r'' para evitar problemas de escape

# diretório de trabalho
os.chdir(novo_diretorio)

# Verificando diretório
print(os.getcwd())


# %% Bibliotecas
import pandas as pd
import matplotlib.pyplot as plt


# %% Alterando rotulos dos ventores
colunas = (
    'status_da_conta', 'duracao_em_meses', 'historico', 'finalidade',
    'valor_do_credito', 'conta_poup', 'empr_atual','taxa_pct_renda_disp',
    'status_pessoal_sexo','outros_devedores_fiadores','residencia_atual',
    'propriedade', 'Idade', 'outros_parcelamento','habitacao', 
    'num_cred_existentes', 'trabalho', 'pensao_alimenticia','telefone', 
    'trab_estrangeiro', 'alvo'
    )
# %% Carregando os dados
df = pd.read_csv('german.DATA', header=None, names=colunas, delimiter=' ')  # por espaço


# %% Verificando se existe valores nulo e o tipo do vetor
print(df['valor_do_credito'].isnull().sum())  # valores nulos
print(df['valor_do_credito'].dtype)  # tipo de dado da coluna

# nova coluna com os valores em dólares (USD)
df['valor_USD'] = (df['valor_do_credito'].astype(float) * 0.55806076).round(2)
# %% Visualizando os dados
df.head(10)


# %% Análise Univariada
# prep_Plot1 - Status de Contas
# Aplicando o mapeamento
mapping = {
    'A11': 'Saldo negativo',
    'A12': 'Saldo baixo',
    'A13': 'Saldo estável',
    'A14': 'Sem conta corrente'
}

df['status_da_conta'] = df['status_da_conta'].map(mapping)

# Contando valores e criando o gráfico
contagem_status = df['status_da_conta'].value_counts()

# %% Plot1 - Status de Contas
# Configurando o gráfico
plt.figure(figsize=(10, 6))  # Ajuste o tamanho do gráfico
colors = ['#e74c3c', '#f39c12', '#2ecc71', '#3498db']  # Vermelho, Laranja, Verde, Azul
contagem_status.plot(kind='bar', color=colors)  # Define a cor das barras

# Adicionando título e rótulos
plt.title('Distribuição dos Status das Contas', fontsize=16)
# Removendo rótulos e ticks dos eixos
plt.xlabel('')  # Remove o label do eixo x
plt.ylabel('')  # Remove o label do eixo y
plt.xticks(rotation=0, fontsize=12)  # Deixa os rótulos do eixo x visíveis
plt.gca().yaxis.set_visible(False)  # Esconde o eixo y
plt.gca().spines['top'].set_visible(False)  # Remove a borda superior
plt.gca().spines['right'].set_visible(False)  # Remove a borda direita
plt.gca().spines['left'].set_visible(False)  # Remove a borda esquerda
plt.gca().spines['bottom'].set_visible(False)  # Remove a borda inferior

# Adicionando rótulos de contagem nas barras
for index, value in enumerate(contagem_status):
    plt.text(index, value + 1, str(value), ha='center', fontsize=10)

# Mostrando o gráfico
plt.xticks(rotation=0)  # Mantém os rótulos das categorias alinhados
plt.tight_layout()
plt.show()

# %% Prep_Plot 2
# Aplicando o mapeamento
mapping = {
    'A61': 'Saldo baixo',
    'A62': 'Saldo pequeno',
    'A63': 'Saldo moderado',
    'A64': 'Saldo Elevado',
    'A65': 'Sem Conta Poupança'
}

df['conta_poup'] = df['conta_poup'].map(mapping)

# Contando valores e criando o gráfico
contagem_conta_poup = df['conta_poup'].value_counts()
# %% Plot 2 
# Configurando o gráfico
plt.figure(figsize=(10, 6))  # Ajuste o tamanho do gráfico
# Aplicando a paleta de cores personalizada
colors1 = ['#e74c3c', '#f39c12', '#f1c40f', '#2ecc71', '#3498db']
contagem_conta_poup.plot(kind='bar', color=colors1)  # Define a cor das barras

# Adicionando título e rótulos
plt.title('Distrbuição Status Conta Poupança', fontsize=16)
# Removendo rótulos e ticks dos eixos
plt.xlabel('')  # Remove o label do eixo x
plt.ylabel('')  # Remove o label do eixo y
plt.xticks(rotation=0, fontsize=12)  # Deixa os rótulos do eixo x visíveis
plt.gca().yaxis.set_visible(False)  # Esconde o eixo y
plt.gca().spines['top'].set_visible(False)  # Remove a borda superior
plt.gca().spines['right'].set_visible(False)  # Remove a borda direita
plt.gca().spines['left'].set_visible(False)  # Remove a borda esquerda
plt.gca().spines['bottom'].set_visible(False)  # Remove a borda inferior

# Adicionando rótulos de contagem nas barras
for index, value in enumerate(contagem_status):
    plt.text(index, value + 1, str(value), ha='center', fontsize=10)

# Mostrando o gráfico
plt.xticks(rotation=0)  # Mantém os rótulos das categorias alinhados
plt.tight_layout()
plt.show()


# %% Plot 3
# Aplicando o mapeamento
mapping = {
    'A71': 'desempregado',
    'A72': 'menos de 1 ano',
    'A73': 'entre 1 e 4 anos',
    'A74': 'entre 4 e 7 anos',
    'A75': '7 anos ou mais'
}


df['empr_atual'] = df['empr_atual'].map(mapping)

# Contando valores e criando o gráfico
contagem_empr_atual = df['empr_atual'].value_counts()

# %% 
# Configurando o gráfico
plt.figure(figsize=(10, 6))  # Ajuste o tamanho do gráfico
# Aplicando a paleta de cores personalizada
colors2 = ['#7f8c8d', '#e74c3c', '#f39c12', '#2ecc71', '#27ae60']
contagem_empr_atual.plot(kind='bar', color=colors2)  # Define a cor das barras

# Adicionando título e rótulos
plt.title('Distrbuição Emprego Atual', fontsize=16)
# Removendo rótulos e ticks dos eixos
plt.xlabel('')  # Remove o label do eixo x
plt.ylabel('')  # Remove o label do eixo y
plt.xticks(rotation=0, fontsize=12)  # Deixa os rótulos do eixo x visíveis
plt.gca().yaxis.set_visible(False)  # Esconde o eixo y
plt.gca().spines['top'].set_visible(False)  # Remove a borda superior
plt.gca().spines['right'].set_visible(False)  # Remove a borda direita
plt.gca().spines['left'].set_visible(False)  # Remove a borda esquerda
plt.gca().spines['bottom'].set_visible(False)  # Remove a borda inferior

# Adicionando rótulos de contagem nas barras
for index, value in enumerate(contagem_status):
    plt.text(index, value + 1, str(value), ha='center', fontsize=10)

# Mostrando o gráfico
plt.xticks(rotation=0)  # Mantém os rótulos das categorias alinhados
plt.tight_layout()
plt.show()

# %% plot 4 
# Aplicando o mapeamento
mapping = {
    'A151' : 'Alugado',
    'A152' : 'Próprio',
    'A153' : 'Cedido'
}

df['habitacao'] = df['habitacao'].map(mapping)

# Contando valores e criando o gráfico
contagem_status = df['habitacao'].value_counts()

# Configurando o gráfico
plt.figure(figsize=(10, 6))  # Ajuste o tamanho do gráfico
contagem_status.plot(kind='bar', color='skyblue')  # Define a cor das barras

# Adicionando título e rótulos
plt.title('Habitação', fontsize=16)
plt.xlabel('Situação', fontsize=12)
plt.ylabel('Frequência', fontsize=12)

# Adicionando rótulos de contagem nas barras
for index, value in enumerate(contagem_status):
    plt.text(index, value + 1, str(value), ha='center', fontsize=10)

# Mostrando o gráfico
plt.xticks(rotation=0)  # Mantém os rótulos das categorias alinhados
plt.tight_layout()
plt.show()

# %% Plot 5
import seaborn as sns
# Configurar o estilo do gráfico
sns.set(style="whitegrid")

# Criar o boxplot da variável numérica 'Salário'
plt.figure(figsize=(8, 6))
sns.boxplot(y='valor_USD', data=df)

# Adicionar título e rótulos
plt.title('Boxplot do Valor do Crédito')
plt.ylabel('Crédito')

# Exibir o gráfico
plt.show()

# %% Plot 6
# Criar o histograma da variável numérica 'Salário'
plt.figure(figsize=(8, 6))
sns.histplot(df['valor_USD'], bins=15, kde=True)

# Adicionar título e rótulos
plt.title('Histograma do Valor do Crédito')
plt.xlabel('Crédito')
plt.ylabel('Frequência')

# Exibir o gráfico
plt.show()
# %% Plot 7
# Criar o histograma da variável numérica 'Salário'
plt.figure(figsize=(8, 6))
sns.histplot(df['Idade'], bins=15, kde=True)

# Adicionar título e rótulos
plt.title('Histograma do Valor do Crédito')
plt.xlabel('Crédito')
plt.ylabel('Frequência')

# Exibir o gráfico
plt.show()
# %% Valor de credito concedido para bons e maus pagadores
cred_alvo = df.groupby('alvo')['valor_USD'].sum()
# Transformar em DataFrame para facilitar a manipulação
cred_alvo_df = cred_alvo.reset_index()
# Renomear colunas, se necessário
cred_alvo_df.columns = ['Alvo', 'Valor do Crédito']
# Substituir os valores 1 e 2 na coluna 'alvo' por 'mal pagador' e 'bom pagador'
cred_alvo_df['Alvo'] = cred_alvo_df['Alvo'].replace({1: 'bom pagador', 2: 'mal pagador'})


# %% Plot 1
# gráfico de barras 
plt.figure(figsize=(12,8))
plt.bar(cred_alvo_df['Alvo'], cred_alvo_df['Valor do Crédito'], 
        color=['#4CAF50', '#F44336'])

# Título e rótulos dos eixos
plt.title('Crédito: Bom e Mal Pagador', fontsize=16)
plt.xlabel('Classificação', fontsize=12)
plt.ylabel('Valor do Crédito milhões (USD)', fontsize=12)

# Colocando e formatando os valores em cada barra
for i, v in enumerate(cred_alvo_df['Valor do Crédito']):
    valor_formatado = f'{v:,.2f}'.replace(",", "X").replace(".", ",").replace("X", ".")
    plt.text(i, v + v*0.013, valor_formatado, ha='center', fontsize=10)

# Salvar o gráfico em formato SVG
plt.savefig("grafico_exemplo.svg", format="svg")
# Exibir o gráfico
plt.show()

# %% Valores de crédito por 'finalidade' e 'alvo' (bom ou mal pagador)

cred_finalidade = df.groupby(['finalidade', 'alvo'])['valor_USD'].sum().unstack().fillna(0)


cred_finalidade = cred_finalidade.reset_index()
cred_finalidade.columns = ['finalidade', 'bom pagador', 'mal pagador']

cred_finalidade['finalidade'] = cred_finalidade['finalidade'].replace({
    'A40': 'carro (novo)',
    'A41': 'carro (usado)',
    'A410': 'outros',
    'A42': 'móveis/equipamentos',
    'A43': 'rádio/televisão',
    'A44': 'eletrodomésticos',
    'A45': 'reparações',
    'A46': 'educação',
    'A48': 'reciclagem',
    'A49': 'negócios'
})


# %% plot 2 
# Configurações do gráfico
cred_finalidade.set_index('finalidade').plot(kind='bar', figsize=(10, 6),
                                             color=['#4CAF50', '#F44336'])

# Adicionando título e rótulos
plt.title('Valores de Crédito por Finalidade: Bom e Mal Pagador')
plt.xlabel('Finalidade', fontsize=12)
plt.ylabel('Valor do Crédito (USD)', fontsize=12)
plt.xticks(rotation=25)
plt.legend(title='Tipo de Pagador')
plt.grid(axis='y')

# Mostrar o gráfico
plt.tight_layout()
plt.show()
# %%empr_atual
cred_empr_atual = df.groupby(['empr_atual', 'alvo'])['valor_USD'].sum().unstack().fillna(0)
cred_empr_atual = cred_empr_atual.reset_index()
cred_empr_atual.columns = ['tempo_empr_atual', 'bom pagador', 'mal pagador']

cred_empr_atual['tempo_empr_atual'] = cred_empr_atual['tempo_empr_atual'].replace({
    'A71': 'desempregado',
    'A72': 'menos de 1 ano',
    'A73': 'até 4 anos',
    'A74': 'até 7 anos',
    'A75': 'maior de 7 anos',
})

# %% plot 2 
# Configurações do gráfico
cred_empr_atual.set_index('tempo_empr_atual').plot(kind='bar', figsize=(10, 6),
                                             color=['#4CAF50', '#F44336'])

# Adicionando título e rótulos
plt.title('Valores de Crédito por tempo de emprego atual: Bom e Mal Pagador')
plt.xlabel('Tempo Emprego Atual', fontsize=12)
plt.ylabel('Valor do Crédito (USD)', fontsize=12)
plt.xticks(rotation=25)
plt.legend(title='Tipo de Pagador')
plt.grid(axis='y')

# Mostrar o gráfico
plt.tight_layout()
plt.show()
# %%
pd.crosstab(df['habitacao'], df['alvo'])

# %%
tabela = pd.crosstab(df['empr_atual'], df['alvo'])


from scipy.stats import chi2_contingency

# Calculando o teste qui-quadrado
chi2, p, dof, expected = chi2_contingency(tabela)

# Resultados
print(f'Estatística Qui-Quadrado: {chi2}')
print(f'Valor-p: {p}')
print(f'Degrees of Freedom: {dof}')
print(f'Frequências Esperadas: {expected}')

import seaborn as sns


# Criar uma tabela de contingência (frequências observadas)
table = pd.crosstab(df['habitacao'], df['alvo'])

# Criar o heatmap
sns.heatmap(table, annot=True, cmap='Blues', fmt='g')
plt.title('Mapa de Calor da Tabela de Contingência')
plt.show()

# %% Scarter
# Criando o scatter plot
plt.scatter(df['taxa_pct_renda_disp'], df['Idade'] , color='green', label='Alvo vs Idade')

df.dtypes
