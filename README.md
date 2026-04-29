# Ascii_wariors - RPG Engine (Batch)

Este projeto é um RPG de aventura desenvolvido inteiramente em **Batch Script**, utilizando técnicas avançadas de threads secundárias para animações e um motor de texto híbrido com VBScript.

---

## 👥 Equipe de Desenvolvimento
* **Natan S. Rodrigues:** Programador e Animador
* **João A.A. Blanco:** Coescritor e Animador
* **Geovani Sa. de Brito:** Escritor

---

## ✅ O que já está feito

### ⚙️ Motores e Sistema
* **Motor de Texto Híbrido:** Uso de VBScript para gerar o efeito de "máquina de escrever" com controle preciso de milissegundos.
* **Animações Assíncronas (Multithreading):** Sistema inovador de threads usando `start /b` e arquivos de sinalização (`.tmp`) para rodar animações (neve, portal) enquanto o script principal processa inputs.
* **Renderização Dinâmica:** Troca automática de sprites ASCII conforme a classe selecionada.

### 🎭 Gameplay Inicial
* **Seleção de Heróis:** Três classes (Mago, Guerreira, Ocultista) com atributos distintos já configurados na memória.
* **Prólogo Narrativo:** Introdução com ambientação visual, transição de cores e cenas animadas (Floresta Sombria e Banquete Macabro).
* **Mecânica de Dados (Core):** Motor de cálculo de dano funcional baseado em `!random!`, quantidade de dados (`qd`) e faces (`d`).

---

## 🛠 O que falta implementar (Roadmap)

### 📈 Sistema de Progressão
- [x] ~~**Lógica de Level Up:** Implementar a função que verifica se o XP atual atingiu o limite para subir de nível.~~
- [x] ~~**Upagem de Atributos:** Criar interface para o jogador distribuir pontos ganhos ao subir de nível.~~
- [x] ~~**Habilidades Desbloqueáveis:** Condicionar o acesso a novos ataques baseando-se no nível do jogador.~~

### ⚔️ Sistema de Batalha (Inspirado em Pokémon/Retro)
- [ ] **Menu de Combate:** Opções de [1] Lutar (escolher entre 4 ataques - 1 normal e 3 especiais), [2] Mochila (itens), [3] Fugir.
- [ ] **Status de Efeitos:** Adicionar condições como "Congelado" ou "Queimado".
- [ ] **IA de Turnos:** O inimigo deve esperar o jogador agir para realizar sua jogada.

### 🛡️ Sistema de Civis & Destino
- [ ] **Contador de Resgate:** Variável `civis_salvos` para rastrear o impacto do jogador no mundo.
- [ ] **Finais Múltiplos:** Lógica de encerramento baseada na quantidade de pessoas salvas durante a campanha.

### 💰 Economia e Itens
- [x] ~~**Sistema de Inventário:** Menu para visualizar ouro, poções e equipamentos.~~
- [x] ~~**Mercado (Loja):** Rótulo `:mercado` com lógica de compra (verificação de saldo e adição de itens ao inventário).~~

### 📖 História e Conteúdo
- [ ] **Continuidade do Roteiro:** Implementar os eventos descritos no [Google Docs](https://docs.google.com/document/d/1vbjkA0dLJjwNukCCbBl1jCxax6QmqbZ6pmW3w3SdZYs/edit).
- [ ] **Melhoria de Cenas:** Refinar as animações finais do prólogo para evitar flickering em resoluções maiores.

---

## 🚀 Como Rodar
1. Execute o arquivo `.bat` no Windows.
2. O sistema abrirá automaticamente o `conhost.exe` para garantir a compatibilidade de redimensionamento.
3. Certifique-se de que o terminal suporte caracteres `UTF-8` (configurado automaticamente via `chcp 65001`).
