@echo off
setlocal enabledelayedexpansion

:: Força o terminal a ler os caracteres Unicode e Box Drawings perfeitamente
chcp 65001 >nul

set "s1=   /\      "
set "s2= _/__\_┏┓  "
set "s3= ( o.o)┃   "
set "s4= /(__)/┃   "
set "s5=  /  \ ┃   "

:: Posição inicial do personagem
set /a pos_x = 5
set /a pos_y = 1

:tela_jogo
    :: 0. VERIFICA EVENTOS DE POSIÇÃO (As portas do seu mapa)
    :: Visualmente, a Taberna está na altura do X=27 ou 29, e Y=1
    if "%pos_x%-%pos_y%" equ "27-1" goto :dentro_da_taberna
    if "%pos_x%-%pos_y%" equ "29-1" goto :dentro_da_taberna
    if "%pos_x%-%pos_y%" equ "0-1" goto :fim_jogo

    cls
    
    :: 1. DESENHA O TETO E O CENÁRIO DE FUNDO
    echo =================================================================
    echo  Use [W] Cima, [S] Baixo, [A] Esquerda, [D] Direita ou [X] Sair
    :: DICA DE OURO: Este rastreador no HUD vai te ajudar a mapear as portas!
    echo  Posicao Atual: X=!pos_x! ^| Y=!pos_y!
    echo =================================================================
    echo.
    echo        /\                 _^\^|/_
    echo       /  \      /\         / \
    :: Atualizei a plaquinha para a nova coordenada
    echo      /____\    /  \        (29, 1)
    echo      ^|    ^|   /____\     Taberna [ ] 
    echo =================================================================

    :: 2. GERA AS LINHAS EM BRANCO (EIXO Y)
    if %pos_y% GTR 0 (
        for /l %%i in (1,1,%pos_y%) do echo.
    )

    :: 3. GERA OS ESPAÇOS EM BRANCO (EIXO X)
    set "espacos="
    if %pos_x% GTR 0 (
        for /l %%i in (1,1,%pos_x%) do (
            set "espacos=!espacos! "
        )
    )

    :: 4. DESENHA O PERSONAGEM (Agora 100% imune a quebras)
    echo !espacos!   !s1!
    echo !espacos!   !s2!
    echo !espacos!   !s3!
    echo !espacos!   !s4!
    echo !espacos!   !s5!
    
    :: 5. DESENHA O CHÃO INFERIOR
    set /a chao = 6 - pos_y
    if !chao! GTR 0 (
        for /l %%i in (1,1,!chao!) do echo.
    )
    echo =================================================================
    
    :: 6. AGUARDA O INPUT DO JOGADOR
    choice /c WASDX /n /m " Acao: "

    :: 7. LÓGICA DE MOVIMENTAÇÃO
    if errorlevel 5 goto :fim_jogo
    if errorlevel 4 goto :mover_direita
    if errorlevel 3 goto :mover_baixo
    if errorlevel 2 goto :mover_esquerda
    if errorlevel 1 goto :mover_cima

:: (Rotinas de Mover permanecem iguais aqui...)
:mover_cima
    if %pos_y% GTR 0 set /a pos_y -= 1
    goto :tela_jogo
:mover_baixo
    if %pos_y% LSS 5 set /a pos_y += 1
    goto :tela_jogo
:mover_direita
    if %pos_x% LSS 50 set /a pos_x += 2
    goto :tela_jogo
:mover_esquerda
    if %pos_x% GTR 0 set /a pos_x -= 2
    goto :tela_jogo

:: ==============================================
:: NOVOS CENÁRIOS
:: ==============================================
:dentro_da_taberna
    cls
    echo =================================================================
    echo Voce entrou na Taberna! O cheiro de ensopado preenche o ar.
    echo =================================================================
    echo.
    echo [1] Falar com Taberneiro
    echo [2] Sair da Taberna (Voltar para o mapa)
    echo.
    choice /c 12 /n /m "Escolha: "
    if errorlevel 2 (
        :: CORREÇÃO: Colocamos ele saindo no Y=2 para ele estar 1 passo 
        :: abaixo da porta, caso contrário ele entraria em loop!
        set /a pos_x = 29
        set /a pos_y = 2
        goto :tela_jogo
    )
    if errorlevel 1 (
        echo O Taberneiro te ignora por enquanto.
        pause >nul
        goto :dentro_da_taberna
    )