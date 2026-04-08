@echo off
:: Ativa a Expansao Atrasada (Obrigatorio para Arrays e Loops no Batch)
setlocal EnableDelayedExpansion
title Teste de Batalha RPG - MODO DEBUG
color 0F

goto :inicio

:: ========================================================================
:: FICHA DO JOGADOR
:: ========================================================================
:set_tulio
    set "nome_personagem=Tulio"
    set "classe_personagem=O Mago"
    set /a lvl_jogador=3
    set /a hp_jogador=15
    set /a max_hp=15
    set /a forca_jogador=5
    set /a agil_jogador=15
    set /a def_jogador=15
    set /a mana_jogador=30
    set /a max_mana=30
    set /a pocao_hp=2

    set "atk_especial_1=Bola de Fogo"
    set /a unlock_esp1=3 
    set "atk_especial_2=Raio Congelante" 
    set /a unlock_esp2=5 
    set "atk_padrao=Ataque com Cajado"
goto :eof

:: ========================================================================
:: BESTIARIO
:: ==========================================
:spawn_goblin
    set /a qtd_inimigos+=1
    set /a i=qtd_inimigos
    set "ini_nome[!i!]=Goblin Fraco"
    set /a ini_hp[!i!]=12
    set /a ini_max_hp[!i!]=12
    set /a ini_agil[!i!]=10
    set /a ini_qd[!i!]=2
    set /a ini_faces[!i!]=6
    set /a ini_bonus[!i!]=0
goto :eof

:spawn_javali
    set /a qtd_inimigos+=1
    set /a i=qtd_inimigos
    set "ini_nome[!i!]=Javali de Gelo"
    set /a ini_hp[!i!]=12
    set /a ini_max_hp[!i!]=20
    set /a ini_agil[!i!]=12
    set /a ini_qd[!i!]=4
    set /a ini_faces[!i!]=4
    set /a ini_bonus[!i!]=0
goto :eof

:: ========================================================================
:: MOTOR DE DADOS (PLANO E COM DEBUG)
:: ========================================================================
:dice_engine
    echo.
    echo =======================================================
    echo [DEBUG ENGINE] Valores recebidos para rolar o dado:
    echo Quantidade de Dados : !quantidade_dados!
    echo Faces do Dado       : !faces!
    echo Bonus de Dano       : !dano_bonus!
    echo =======================================================
    echo Se algum dos valores acima estiver VAZIO, o jogo vai fechar
    echo por tentar fazer uma conta matematica com o NADA!
    pause

    set /a resultado_jogada=0

    :while_dados
    if !quantidade_dados! LEQ 0 goto :fim_rolagem

    set /a dado=(!random! %% faces) + 1
    set /a resultado_jogada+=dado
    set /a quantidade_dados-=1
    goto :while_dados

    :fim_rolagem
    set /a resultado_jogada+=dano_bonus
goto :eof

:: ========================================================================
:: INICIO DO EVENTO
:: ========================================================================
:inicio
    call :set_tulio
    set /a qtd_inimigos=0
    call :spawn_goblin
    call :spawn_javali
    call :combat_engine
goto :eof

:: ========================================================================
:: MOTOR DE COMBATE
:: ========================================================================
:combat_engine
    set /a turno_atual=1

:combat_loop
    cls
    color 0F
    echo =======================================================
    echo                     TURNO !turno_atual!
    echo =======================================================
    
    set /a inimigos_vivos=0
    for /L %%i in (1, 1, !qtd_inimigos!) do (
        if !ini_hp[%%i]! GTR 0 (
            set /a inimigos_vivos+=1
            echo  [%%i] !ini_nome[%%i]! - HP: !ini_hp[%%i]! / !ini_max_hp[%%i]!
        ) else (
            echo  [%%i] !ini_nome[%%i]! - [ MORTO ]
        )
    )
    echo =======================================================
    
    if !inimigos_vivos! equ 0 goto :vitoria
    if !hp_jogador! leq 0 goto :game_over

    echo  !nome_personagem! Nv.!lvl_jogador! (!classe_personagem!)
    echo  HP: !hp_jogador! / !max_hp!   ^|   MANA: !mana_jogador! / !max_mana!
    echo =======================================================
    echo.
    echo 1 Lutar
    echo 2 Mochila (Item)
    echo 3 Fugir
    echo.
    
    choice /c 123 /n /m "Escolha uma acao: "
    if !errorlevel! equ 3 goto :tentar_fugir
    if !errorlevel! equ 2 goto :menu_item
    if !errorlevel! equ 1 goto :menu_lutar

:: ========================================================================
:: SUBMENU 1: LUTAR
:: ========================================================================
:menu_lutar
    set /a alvo=1
    if !qtd_inimigos! GTR 1 (
        echo.
        set /p alvo="Qual inimigo atacar (1 a !qtd_inimigos!)? "
    )
    
    if !ini_hp[%alvo%]! LEQ 0 (
        echo Este inimigo ja esta morto.
        pause >nul
        goto :combat_loop
    )

    cls
    echo =======================================================
    echo                 ATAQUES DISPONIVEIS
    echo =======================================================
    echo 1 !atk_padrao!
    if !lvl_jogador! GEQ !unlock_esp1! ( echo 2 !atk_especial_1! ) else ( echo 2 ??? [Bloqueado] )
    if !lvl_jogador! GEQ !unlock_esp2! ( echo 3 !atk_especial_2! ) else ( echo 3 ??? [Bloqueado] )
    echo 4 Voltar
    echo =======================================================
    
    choice /c 1234 /n /m "Escolha seu ataque: "
    set /a acao=!errorlevel!
    
    if !acao! equ 4 goto :combat_loop
    
    if !acao! equ 3 if !lvl_jogador! LSS !unlock_esp2! ( echo Bloqueado. & pause >nul & goto :menu_lutar )
    if !acao! equ 2 if !lvl_jogador! LSS !unlock_esp1! ( echo Bloqueado. & pause >nul & goto :menu_lutar )

    echo.
    if !acao! equ 1 (
        echo !nome_personagem! usa !atk_padrao! contra !ini_nome[%alvo%]!
        set /a quantidade_dados=1
        set /a faces=6
        set /a dano_bonus=!forca_jogador!
    )
    if !acao! equ 2 (
        echo !nome_personagem! conjura !atk_especial_1! contra !ini_nome[%alvo%]!
        set /a quantidade_dados=2
        set /a faces=8
        set /a dano_bonus=!forca_jogador!
    )
    if !acao! equ 3 (
        echo !nome_personagem! conjura !atk_especial_2! contra !ini_nome[%alvo%]!
        set /a quantidade_dados=2
        set /a faces=10
        set /a dano_bonus=!forca_jogador!
    )
    
    call :dice_engine
    
    :: CORREÇÃO: Removidos os pontos de exclamação de pontuação
    echo Acerto em cheio. Causou !resultado_jogada! de dano.
    set /a ini_hp[%alvo%] -= resultado_jogada
    
    if !ini_hp[%alvo%]! LEQ 0 echo !ini_nome[%alvo%]! caiu.
    pause >nul
goto :turno_inimigo

:: ------------------------------------------------------------------------
:: SUBMENU 2: MOCHILA
:: ------------------------------------------------------------------------
:menu_item
    cls
    echo =======================================================
    echo                       MOCHILA
    echo =======================================================
    echo [1] Pocao de HP   (Qtd: !pocao_hp!)
    echo [2] Pocao de Mana (Qtd: !pocao_mana!)
    echo [3] Voltar
    echo =======================================================
    choice /c 123 /n /m "Escolha o item: "
    set /a escolha_item=!errorlevel!
    
    if !escolha_item! equ 3 goto :combat_loop
    
    if !escolha_item! equ 1 (
        if !pocao_hp! GTR 0 (
            rem 1. Gasta a pocao do inventario
            set /a pocao_hp -= 1
            
            rem 2. Adiciona a cura (Ex: 15 de HP)
            set /a hp_jogador += 15
            
            rem 3. TRAVA DE HP: Se o HP ficar maior que o Maximo, ele corta e iguala ao Maximo
            if !hp_jogador! GTR !max_hp! set /a hp_jogador=max_hp
            
            echo.
            echo Voce bebeu uma Pocao de HP e recuperou sua vida!
            pause >nul
            goto :turno_inimigo
        ) else ( 
            echo.
            echo Voce nao tem Pocoes de HP! 
            pause >nul 
            goto :menu_item 
        )
    )
goto :combat_loop

:: ------------------------------------------------------------------------
:: SUBMENU 3: FUGIR (SISTEMA RNG DE DADOS E MODIFICADORES)
:: ------------------------------------------------------------------------
:tentar_fugir
    cls
    echo !nome_personagem! tenta escapar correndo da batalha...
    ping 127.0.0.1 -n 2 >nul
    
    rem 1. CRIANDO MODIFICADORES (Divide a agilidade por 2 para balancear o d20)
    set /a mod_fuga = agil_jogador / 2
    set /a mod_inimigo = !ini_agil[1]! / 2
    
    rem 2. ROLAGEM: 1d20 + Modificador do Jogador
    set /a fuga_roll = (!random! %% 20) + 1
    set /a fuga_total = fuga_roll + mod_fuga
    
    rem 3. DIFICULDADE: Base 10 + Modificador do Inimigo 1
    set /a dificuldade = 10 + mod_inimigo
    
    echo [D20 Rolagem: !fuga_total! vs Dificuldade: !dificuldade!]
    
    if !fuga_total! GEQ !dificuldade! (
        echo Voce encontrou uma brecha e fugiu com sucesso!
        pause >nul
        rem Retorna ao mapa
        goto :eof
    ) else (
        echo Falhou! O inimigo e muito rapido e cortou seu caminho. Voce perdeu o turno!
        pause >nul
        goto :turno_inimigo
    )

:: ========================================================================
:: TURNO DO INIMIGO (COM CHANCE DE ERRO)
:: ========================================================================
:turno_inimigo
    cls
    color 0C
    echo =======================================================
    echo                TURNO DOS INIMIGOS
    echo =======================================================
    
    for /L %%i in (1, 1, !qtd_inimigos!) do (
        if !ini_hp[%%i]! GTR 0 (
            echo.
            echo O !ini_nome[%%i]! avanca contra !nome_personagem!
            ping 127.0.0.1 -n 2 >nul
            
            rem 1. TESTE DE ACERTO DO INIMIGO (Sem parenteses para evitar CRASH)
            set /a acerto_roll = !random! %% 20 + 1
            set /a acerto_inimigo = acerto_roll + !ini_agil[%%i]! / 2
            
            echo [Acerto do Inimigo: !acerto_inimigo! vs Sua Defesa: !def_jogador!]
            
            rem 2. COMPARA COM A DEFESA DO JOGADOR
            if !acerto_inimigo! LSS !def_jogador! (
                echo O ataque falhou. A sua defesa permitiu que voce desviasse do golpe.
                pause >nul
            ) else (
                rem 3. SE ACERTOU, ROLA O DANO NORMAL
                set /a quantidade_dados = !ini_qd[%%i]!
                set /a faces = !ini_faces[%%i]!
                set /a dano_bonus = !ini_bonus[%%i]!
                
                call :dice_engine
                
                echo O golpe te atingiu em cheio. Voce sofre !resultado_jogada! de dano.
                set /a hp_jogador -= resultado_jogada
                pause >nul
                
                if !hp_jogador! LEQ 0 goto :game_over
            )
        )
    )
    
    set /a turno_atual += 1
goto :combat_loop

:vitoria
    cls
    color 0A
    echo VITORIA!
    pause >nul
goto :eof

:game_over
    cls
    color 4F
    echo VOCE MORREU
    pause >nul
goto :eof