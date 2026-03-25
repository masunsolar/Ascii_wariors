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
set /a cidade_atual=1

:: =======================================================================
:: LOOP PRINCIPAL DO JOGO
:: =======================================================================
:tela_cidade
    :: 0. VERIFICA EVENTOS E TRANSIÇÕES DE MAPA
    if "%cidade_atual%" equ "2" (
        if "%pos_x%-%pos_y%" equ "25-0" goto :taverna_padrao
        if "%pos_x%-%pos_y%" equ "26-0" goto :taverna_padrao
    )
    if "%cidade_atual%" equ "4" (
        if "%pos_x%-%pos_y%" equ "25-0" goto :ferreiro
        if "%pos_x%-%pos_y%" equ "26-0" goto :ferreiro
    )
    if "%cidade_atual%" equ "6" (
        :: CIDADE 6: Se o jogador chegar na posição (25,0), ele entra na loja de poções
        if "%pos_x%-%pos_y%" equ "25-0" goto :loja_pocoes
        if "%pos_x%-%pos_y%" equ "26-0" goto :loja_pocoes
    )

    :: IR PARA A PRÓXIMA CIDADE 
    if %pos_x% equ 51 (
        if %pos_y% geq 1 if %pos_y% leq 5 (
            set /a cidade_atual += 1
            set /a pos_x = 1
            goto :tela_cidade
        )
    )

    :: VOLTAR PARA A CIDADE ANTERIOR 
    if %pos_x% equ 0 (
        if %cidade_atual% gtr 1 (
            if %pos_y% geq 1 if %pos_y% leq 5 (
                set /a cidade_atual -= 1
                set /a pos_x = 50
                goto :tela_cidade
            )
        )
    )

    :: =======================================================================
    :: RENDERIZAÇÃO DA TELA
    :: =======================================================================
    cls    
    echo =================================================================
    echo  Use [W] Cima, [S] Baixo, [A] Esquerda, [D] Direita
    echo  [ HUD ] Local: Cidade !cidade_atual!  ^|  X:!pos_x! Y:!pos_y!
    echo =================================================================
    echo.
    
    :: A MÁGICA ACONTECE AQUI: Ele vai lá no fundo do código, desenha e volta!
    call :desenho_cidade_!cidade_atual!

    if %pos_y% GTR 0 (
        for /l %%i in (1,1,%pos_y%) do echo.
    )

    set "espacos="
    if %pos_x% GTR 0 (
        for /l %%i in (1,1,%pos_x%) do (
            set "espacos=!espacos! "
        )
    )

    echo !espacos!   !s1!
    echo !espacos!   !s2! 
    echo !espacos!   !s3!
    echo !espacos!   !s4!
    echo !espacos!   !s5!

    set /a chao = 6 - pos_y
    if !chao! GTR 0 (
        for /l %%i in (1,1,!chao!) do echo.
    )
    echo =================================================================
    choice /c WASD /n /m " Acao: "

    if errorlevel 4 goto :mover_direita
    if errorlevel 3 goto :mover_baixo
    if errorlevel 2 goto :mover_esquerda
    if errorlevel 1 goto :mover_cima

:: (Rotinas de movimento)
:mover_cima
    if %pos_y% GTR 0 set /a pos_y -= 1
goto :tela_cidade

:mover_baixo
    if %pos_y% LSS 5 set /a pos_y += 1
goto :tela_cidade

:mover_direita
    if %pos_x% LSS 51 set /a pos_x += 1
goto :tela_cidade

:mover_esquerda
    if %pos_x% GTR 0 set /a pos_x -= 1
goto :tela_cidade

exit

:: ==============================================
:: BANCO DE CENÁRIOS DAS CIDADES (SEMPRE NO FINAL DO ARQUIVO)
:: ==============================================

:desenho_cidade_1
    :: O desenho da primeira cidade (Vila Inicial)
    echo        /\                 _^\^|/_
    echo       /  \      /\         / \
    echo      /____\    /  \        (25, 0)
    echo      ^|    ^|   /____\     Taberna [ ] 
    goto :eof

:desenho_cidade_2
    :: O desenho da segunda cidade (Capital)
    echo     /\/\/\                 _^\^|/_
    echo    /      \      /\         / \
    echo   /        \    /  \      (25, 0)
    echo  /__________\  /____\   Ferreiro [ ]
    goto :eof