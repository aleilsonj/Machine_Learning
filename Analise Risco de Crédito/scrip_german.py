
# -*- coding: utf-8 -*-
"""
Created on Mon Sep 30 20:42:06 2024

@author: ALEILSON

PROJETO ANALISE DE RISCO DE CREDITO
"""
# %% 
import os

# Defina o caminho do novo diretório no formato Windows
novo_diretorio = r'C:\Users\ALEILSON\Documents\credit_german'  # Use r'' para evitar problemas de escape

# Altera o diretório de trabalho
os.chdir(novo_diretorio)

# Verifique se o diretório de trabalho foi alterad
print(os.getcwd())


# %% Importações
import pandas as pd
import matplotlib.pyplot as plt


# %% 
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

# %%
print(df['valor_do_credito'].isnull().sum())  # Verifica valores nulos
print(df['valor_do_credito'].dtype)  # Verifica o tipo de dado da coluna

# nova coluna com os valores em dólares (USD)
df['valor_USD'] = (df['valor_do_credito'].astype(float) * 0.55806076).round(2)
# %% Visualizando os dados
df.head(10)


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


