@echo off
setlocal enabledelayedexpansion

for /F %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"

:: Variáveis de controle do personagem
set /a pos_x = 5
set /a pos_y = 1
set /a cidade_atual=1

:: ========================================================================
:: MOTOR DE TEXTO HÍBRIDO (VBScript) - Geração do Arquivo
:: ========================================================================
echo Set objArgs = WScript.Arguments > "%temp%\motor_texto.vbs"
echo texto = objArgs(0) >> "%temp%\motor_texto.vbs"
echo atraso = CInt(objArgs(1)) >> "%temp%\motor_texto.vbs"
echo For i = 1 To Len(texto) >> "%temp%\motor_texto.vbs"
echo WScript.StdOut.Write Mid(texto, i, 1) >> "%temp%\motor_texto.vbs"
echo WScript.Sleep atraso >> "%temp%\motor_texto.vbs"
echo Next >> "%temp%\motor_texto.vbs"

:: 0. THREAD DE ANIMAÇÃO
:: Esta diretriz captura a inicialização da linha secundária e a redireciona.
if "%~1" == "motor_neve" goto :snow_loop_thread
if "%~1" == "motor_prologo" goto :neve_prologo_thread
if "%~1" == "motor_portal" goto :motor_portal_thread

:: 1. VERIFICACAO DE AMBIENTE (Obrigatorio para redimensionamento no Windows moderno)
if "%~1" neq "motor_classico" (
    start "" conhost.exe cmd.exe /c "%~f0" motor_classico
    exit
)

::Configuuração padrão da janela::
title Adventure time
chcp 65001 >nul
mode con: cols=94 lines=35

goto :abertura
goto :eof

:: ========================================================================
:: BESTIÁRIO (FICHAS DOS INIMIGOS)
:: ========================================================================
:spawn_goblin
    set "ini_nome=Goblin Fraco"
    set /a ini_hp=12
    set /a ini_max_hp=12
    set /a ini_agil=10
    :: Dano: 2d6
    set /a ini_dado_qtd=2
    set /a ini_dado_faces=6
    set /a ini_dano_bonus=0
    :: Status
    set /a ini_veneno_dano=0
    set /a ini_veneno_turnos=0
goto :eof

:spawn_goblin_max
    set "ini_nome=Goblin forte"
    set /a ini_hp=48
    set /a ini_max_hp=48
    set /a ini_agil=14
    :: Dano: 2d6
    set /a ini_dado_qtd=3
    set /a ini_dado_faces=8
    set /a ini_dano_bonus=4
    :: Status
    set /a ini_veneno_dano=0
    set /a ini_veneno_turnos=0
goto :eof

:spawn_aranha
    set "ini_nome=Aranha Gigante da Floresta"
    set /a ini_hp=35
    set /a ini_max_hp=35
    set /a ini_agil=14
    :: Dano: 3d8+2
    set /a ini_dado_qtd=3
    set /a ini_dado_faces=8
    set /a ini_dano_bonus=2
    :: Status: Veneno 2 de dano por 3 turnos
    set /a ini_veneno_dano=2
    set /a ini_veneno_turnos=3
goto :eof

:spawn_sucuri
    set "ini_nome=Sucuri"
    set /a ini_hp=40
    set /a ini_max_hp=40
    set /a ini_agil=16
    :: Dano: 3d8+2
    set /a ini_dado_qtd=1
    set /a ini_dado_faces=4
    set /a ini_dano_bonus=2
    :: Status: Veneno 2 de dano por 3 turnos
    set /a ini_veneno_dano=3
    set /a ini_veneno_turnos=3
goto :eof

:spawn_taiven
    set "ini_nome=Taiven (Demonio)"
    set /a ini_hp=150
    set /a ini_max_hp=150
    set /a ini_agil=15
    :: Dano: 4d8+4
    set /a ini_dado_qtd=4
    set /a ini_dado_faces=8
    set /a ini_dano_bonus=4
    :: Especial e Status
    set "ini_especial_nome=Pilar de Fogo"
    set /a ini_esp_dado_qtd=3
    set /a ini_esp_dado_faces=20
    set /a ini_veneno_dano=0
    set /a ini_veneno_turnos=0
goto :eof
:: ========================================================================
:: SISTEMA DE SAVE
:: ========================================================================
:salvar_jogo
    cls
    echo =========================================
    echo         Salvando o progresso...
    echo =========================================
    
    :: 1. DADOS DE MAPA E POSICAO (O primeiro usa > para resetar o arquivo)
    echo set local_atual=%local_atual% > save.bat
    echo set /a cidade_atual=%cidade_atual% >> save.bat
    echo set /a pos_x=%pos_x% >> save.bat
    echo set /a pos_y=%pos_y% >> save.bat
    echo set /a visitou_cidade=1>> save.bat
    
    :: 2. STATUS DO PERSONAGEM (Texto com aspas, Numeros com /a)
    echo set "nome_personagem=%nome_personagem%" >> save.bat
    echo set "classe_personagem=%classe_personagem%" >> save.bat
    echo set /a lvl_jogador=%lvl_jogador% >> save.bat
    echo set /a xp_atual=%xp_atual% >> save.bat
    echo set /a xp_proximo_lvl=%xp_proximo_lvl% >> save.bat
    echo set /a hp_jogador=%hp_jogador% >> save.bat
    echo set /a max_hp=%max_hp% >> save.bat
    echo set /a forca_jogador=%forca_jogador% >> save.bat
    echo set /a agil_jogador=%agil_jogador% >> save.bat
    echo set /a def_jogador=%def_jogador% >> save.bat
    echo set /a mana_jogador=%mana_jogador% >> save.bat
    echo set /a max_mana=%max_mana% >> save.bat

    :: 3. EQUIPAMENTOS
    echo set /a armamento=%armamento% >> save.bat
    echo set /a escudo=%escudo% >> save.bat
    echo set /a armadura=%armadura% >> save.bat
    echo set "nome_arma=%nome_arma%" >> save.bat
    echo set "roupa=%roupa%" >> save.bat

    :: 4. ITENS E INVENTARIO
    echo set /a pocao_hp=%pocao_hp% >> save.bat
    echo set /a pocao_mana=%pocao_mana% >> save.bat
    echo set /a refeicao=%refeicao% >> save.bat
    echo set /a ouro=%ouro% >> save.bat
    echo set /a slot=%slot% >> save.bat
    echo set /a qtd_itens=%qtd_itens% >> save.bat

    :: 5. ATAQUES ESPECIAIS E PADRAO
    echo set "atk_especial_1=%atk_especial_1%" >> save.bat
    echo set "atk_especial_2=%atk_especial_2%" >> save.bat
    echo set "atk_especial_3=%atk_especial_3%" >> save.bat
    echo set "atk_padrao=%atk_padrao%" >> save.bat

    :: 6. SPRITES (Essencial para manter o personagem igual ao salvar)
    echo set "s1=!s1!" >> save.bat
    echo set "s2=!s2!" >> save.bat
    echo set "s3=!s3!" >> save.bat
    echo set "s4=!s4!" >> save.bat
    echo set "s5=!s5!" >> save.bat

    echo set "sp1=!sp1!" >> save.bat
    echo set "sp2=!sp2!" >> save.bat
    echo set "sp3=!sp3!" >> save.bat
    echo set "sp4=!sp4!" >> save.bat
    echo set "sp5=!sp5!" >> save.bat

    echo set "spr1=!spr1!" >> save.bat
    echo set "spr2=!spr2!" >> save.bat
    echo set "spr3=!spr3!" >> save.bat
    echo set "spr4=!spr4!" >> save.bat
    echo set "spr5=!spr5!" >> save.bat

    echo.
    echo Jogo salvo com sucesso!
    pause >nul
    
    :: Devolve o jogador pra tela em que ele estava
    goto %local_atual% 

:: ========================================================================
:: LEVEL CHECK
:: ========================================================================
:level_check
    echo ===========================================
    echo         STATUS DE %nome_personagem% (%classe_personagem%)
    echo ===========================================
    echo  LVL: %lvl_jogador%  ^|  XP: %xp_atual%/%xp_proximo_lvl%
    echo  HP:  %hp_jogador%/%max_hp%
    echo  MANA: %mana_jogador%/%max_mana%
    echo  FOR: %forca_jogador%  ^|  AGI: %agil_jogador%  ^|  DEF: %def_jogador%
    echo ===========================================

:: ========================================================================
:: MOTOR DE COMBATE (ROLA QUALQUER DADO)
:: ========================================================================
:combat_engine
    :: Inicia o dano em 0
    set /a resultado_jogada=0
    
    :: Se a quantidade de dados for 0 (ex: Javali com dano fixo 8), pula o loop
    if %quantidade_dados% equ 0 goto :fim_rolagem

    :while_dados
    if %quantidade_dados% gtr 0 (
        :: %random% gera de 0 a 32767. O %% faces pega o resto da divisão.
        set /a dado=!random! %% faces + 1
        set /a resultado_jogada+=dado
        set /a quantidade_dados-=1
        
        :: Volta para o teste do 'if' (isso cria o loop)
        goto :while_dados
    )

    :fim_rolagem
    :: Adiciona o bônus final (ex: o +2 da Aranha no 2d8+2)
    set /a resultado_jogada+=dano_bonus

    :: O comando goto :eof devolve o jogo para a linha exata que o chamou [11, 12]
    goto :eof

:: ========================================================================
:: SISTEMA DE MERCADO MAGO
:: ========================================================================
:loja_armas_mago
    cls
    echo =====================================================
    echo                  Ferreiro da vila
    echo =====================================================
    echo  Seu Ouro atual: %ouro% moedas
    echo  Arma Equipada: %nome_arma% (Dados: %qd_jogador%d%d%)
    echo  Espaco na Mochila: %qtd_itens% de %slot% slots
    echo =====================================================
    echo.
    echo  [1] Cajado de Carvalho (Rola 1 dado de 8)                 - 30  Ouro
    echo  [2] Tomo do Abismo     (Rola 2 dados de 6)                - 70  Ouro
    echo  [3] Foice da Morte     (Rola 1 dado de 20)                - 120 Ouro
    echo  [4] Manto Celeste      (+ Regeneracao de mana 100%%)      - 200 Ouro
    echo  [5] Sair do Mercado
    echo.

    choice /c 12345 /n /m " Fale logo o que vc quer e suma daqui: "

    if errorlevel 5 goto :local
    if errorlevel 4 goto :compra_manto
    if errorlevel 3 goto :compra_foice
    if errorlevel 2 goto :compra_tomo
    if errorlevel 1 goto :compra_cajado

    :: Lógica de Compra e Buff nos Dados
    :compra_cajado
        if %qtd_itens% geq %slot% (
            echo.
            echo  Sua mochila esta cheia! Voce nao tem espaco para isso.
            pause >nul
            goto :loja_armas_mago
        )
        if %ouro% lss 30 (
            echo.
            echo  Ta achando que sou banco? Ouro insuficiente!
            pause >nul
            goto :loja_armas_mago
        )
        :: Desconta o ouro, ocupa 1 slot e altera a arma
        set /a ouro-=30
        set /a qtd_itens+=1
        set "nome_arma=Cajado de Carvalho"
        set /a qd_jogador=1
        set /a d=8
        echo.
        echo  Equipamento %nome_arma% adquirido! Seus ataques agora rolam %qd_jogador%d%d%.
        pause >nul
    goto :loja_armas_mago

    :compra_tomo
        if %qtd_itens% geq %slot% (
            echo.
            echo  Sua mochila esta cheia! Voce nao tem espaco para isso.
            pause >nul
            goto :loja_armas_mago
        )
        if %ouro% lss 70 (
            echo.
            echo  Falta moeda ai, guerreiro!
            pause >nul
            goto :loja_armas_mago
        )
        set /a ouro-=70
        set /a qtd_itens+=1
        set "nome_arma=Tomo do Abismo"
        set /a qd_jogador=2
        set /a d=6
        echo.
        echo  Equipamento %nome_arma% adquirido! Seus ataques agora rolam %qd_jogador%d%d%.
        pause >nul
    goto :loja_armas_mago

    :compra_foice
        if %qtd_itens% geq %slot% (
            echo.
            echo  Sua mochila esta cheia! Voce nao tem espaco para isso.
            pause >nul
            goto :loja_armas_mago
        )
        if %ouro% lss 120 (
            echo.
            echo  Voce e muito pobre para olhar para esta foice!
            pause >nul
            goto :loja_armas_mago
        )
        set /a ouro-=120
        set /a qtd_itens+=1
        set "nome_arma=Foice da Morte"
        set /a qd_jogador=1
        set /a d=20
        echo.
        echo  Equipamento %nome_arma% adquirido! Seus ataques agora rolam %qd_jogador%d%d%.
        pause >nul
    goto :loja_armas_mago

    :compra_manto
        if %qtd_itens% geq %slot% (
            echo.
            echo  Sua mochila esta cheia! Voce nao tem espaco para isso.
            pause >nul
            goto :loja_armas_mago
        )
        if %ouro% lss 200 (
            echo.
            echo  Voce e muito pobre pra comprar esse manto
            pause >nul
            goto :loja_armas_mago
        )
        set /a ouro-=200
        set /a qtd_itens+=1
        set "roupa=Manto Celeste"
        set /a mana+=40
        set /a recu=12
        echo.
        echo  Equipamento %roupa% adquirido! Agora voce tem +12 de recuperacao de mana.
        pause >nul
    goto :loja_armas_mago

:: ========================================================================
:: SISTEMA DE MERCADO GUERREIRO
:: ========================================================================
:loja_armas_guerra
    cls
    echo =====================================================
    echo                 Ferreiro da vila
    echo =====================================================
    echo  Seu Ouro atual: %ouro% moedas
    echo  Arma Equipada: %nome_arma% (Dados: %qd_jogador%d%d%)
    echo =====================================================
    echo.
    echo  [1] Espada super longa   (Rola 2 dado de 20 de dano)                - 30  Ouro
    echo  [2] Maça de Espinhos     (Rola 3 dados de 6 de dano)                - 25  Ouro
    echo  [3] Armadura de espinhos (15 def, + retorna 10% dano no inimigo)    - 40  Ouro
    echo  [4] Armadura pesada      (25 def, - 30% agilidade)                  - 60  Ouro
    echo  [5] Escudo anulador      (10 def, 5% chance parry + stun 1 round)   - 25  Ouro
    echo  [6] Escudo cicatrizante  (20 def, 3 dados de 8 de vida)             - 60  Ouro
    echo  [7] Sair do Mercado
    echo.

    choice /c 1234567 /n /m " Fale logo o que vc quer e suma daqui: "

    if errorlevel 7 goto :local
    if errorlevel 6 goto :compra_escudo2
    if errorlevel 5 goto :compra_escudo1
    if errorlevel 4 goto :compra_armadura2
    if errorlevel 3 goto :compra_armadura1
    if errorlevel 2 goto :compra_maça
    if errorlevel 1 goto :compra_espada

    :: Lógica de Compra e Buff nos Dados
    :compra_espada
        if %qtd_itens% geq %slot% (
            echo.
            echo  Sua mochila esta cheia! Voce nao tem espaco para isso.
            pause >nul
            goto :loja_armas_guerra
        )
        if %ouro% lss 30 (
            echo.
            echo  Ta achando que sou banco? Ouro insuficiente!
            pause >nul
            goto :loja_armas_guerra
        )
        :: Desconta o ouro, ocupa 1 slot e altera a arma
        set /a ouro-=30
        set /a qtd_itens+=1
        set "nome_arma=Espada Super Longa"
        set /a qd_jogador=2
        set /a d=20
        echo.
        echo  Equipamento %nome_arma% adquirido! Seus ataques agora rolam %qd_jogador% d%d%.
        pause >nul
    goto :loja_armas_guerra

    :compra_maça
        if %qtd_itens% geq %slot% (
            echo.
            echo  Sua mochila esta cheia! Voce nao tem espaco para isso.
            pause >nul
            goto :loja_armas_guerra
        )
        if %ouro% lss 25 (
            echo.
            echo  Falta moeda ai, guerreiro!
            pause >nul
            goto :loja_armas_guerra
        )
        set /a ouro-=25
        set /a qtd_itens+=1
        set "nome_arma=Maça de Espinhos"
        set /a qd_jogador=3
        set /a d=6
        echo.
        echo  Equipamento %nome_arma% adquirido! Seus ataques agora rolam %qd_jogador%d%d%.
        pause >nul
    goto :loja_armas_guerra

    :compra_armadura1
        if %qtd_itens% geq %slot% (
            echo.
            echo  Sua mochila esta cheia! Voce nao tem espaco para isso.
            pause >nul
            goto :loja_armas_guerra
        )
        if %ouro% lss 40 (
            echo.
            echo  Voce e muito pobre para olhar para esta armadura!
            pause >nul
            goto :loja_armas_guerra
        )
        set /a ouro-=40
        set /a qtd_itens+=1
        set "roupa=Armadura de Espinhos"
        set /a def+=15
        set /a esp=10
        echo.
        echo  Equipamento %roupa% adquirido! Agora voce tem +15 de defesa.
        pause >nul
    goto :loja_armas_guerra

    :compra_armadura2
        if %qtd_itens% geq %slot% (
            echo.
            echo  Sua mochila esta cheia! Voce nao tem espaco para isso.
            pause >nul
            goto :loja_armas_guerra
        )
        if %ouro% lss 60 (
            echo.
            echo  Voce e muito pobre para olhar para esta armadura!
            pause >nul
            goto :loja_armas_guerra
        )
        set /a ouro-=60
        set /a qtd_itens+=1
        set "roupa=Armadura Pesada"
        set /a def+=25
        set /a agi-=10
        echo.
        echo  Equipamento %roupa% adquirido! Agora voce tem +25 de defesa.
        pause >nul
    goto :loja_armas_guerra

    :compra_escudo1
        if %qtd_itens% geq %slot% (
            echo.
            echo  Sua mochila esta cheia! Voce nao tem espaco para isso.
            pause >nul
            goto :loja_armas_guerra
        )
        if %ouro% lss 25 (
            echo.
            echo  Lhe falta dinheiro para ter para este escudo!
            pause >nul
            goto :loja_armas_guerra
        )
        set /a ouro-=25
        set /a qtd_itens+=1
        set "escudo=Escudo Anulador"
        set /a def+=10
        set /a parry=5
        echo.
        echo  Equipamento %escudo% adquirido! Agora voce tem +10 de defesa.
        pause >nul
    goto :loja_armas_guerra

    :compra_escudo2
        if %qtd_itens% geq %slot% (
            echo.
            echo  Sua mochila esta cheia! Voce nao tem espaco para isso.
            pause >nul
            goto :loja_armas_mago
        )
        if %ouro% lss 60 (
            echo.
            echo  Voce e muito pobre pra comprar esse escudo
            pause >nul
            goto :loja_armas_mago
        )
        set /a ouro-=60
        set /a qtd_itens+=1
        set "escudo=Escudo Cicatrizante"
        set /a def+=20
        set /a qd_regen=3
        set /a d=8
        echo.
        echo  Equipamento %escudo% adquirido! Agora voce tem +20 de defesa e %qd_regen%d%d% Regeneração vital.
        pause >nul
    goto :loja_armas_mago

:: ========================================================================
:: SISTEMA DE MERCADO OCULTISTA
:: ========================================================================
:loja_armas_ocult
    cls
    echo =====================================================
    echo                 Ferreiro da vila
    echo =====================================================
    echo  Seu Ouro atual: %ouro% moedas
    echo  Arma Equipada: %nome_arma% (Dados: %qd_jogador%d%d%)
    echo =====================================================
    echo.
    echo  [1] Adaga Vampirica    (Rola 3 dado de 6, regenera 10% dano como vida) - 65  Ouro
    echo  [2] Foice da Morte     (Rola 2 dado de 20)                             - 120 Ouro
    echo  [3] amuleto de escaravelho (+10 defesa, +5 def quando 100% de vida)    - 70  Ouro
    echo  [4] Manto da intangibilidade (15% chance de anular o dano tomado)      - 80  Ouro
    echo  [5] Sair do Mercado
    echo.

    choice /c 12345 /n /m " Fale logo o que vc quer e suma daqui: "

    if errorlevel 5 goto :local
    if errorlevel 4 goto :compra_manto
    if errorlevel 3 goto :compra_amuleto
    if errorlevel 2 goto :compra_foice
    if errorlevel 1 goto :compra_adaga

    :: Lógica de Compra e Buff nos Dados
    :compra_adaga
        if %qtd_itens% geq %slot% (
            echo.
            echo  Sua mochila esta cheia! Voce nao tem espaco para isso.
            pause >nul
            goto :loja_armas_mago
        )
        if %ouro% lss 65 (
            echo.
            echo  Ta achando que sou banco? Ouro insuficiente!
            pause >nul
            goto :loja_armas_mago
        )
        :: Desconta o ouro, ocupa 1 slot e altera a arma
        set /a ouro-=65
        set /a qtd_itens+=1
        set "nome_arma=Adaga Vampirica"
        set /a qd_jogador=3
        set /a d=6
        set /a roubo_vida=10 & :: porcentagem do roubo de vida
        echo.
        echo  Equipamento %nome_arma% adquirido! Seus ataques agora rolam %qd_jogador%d%d%.
        pause >nul
    goto :loja_armas_mago

    :compra_foice
        if %qtd_itens% geq %slot% (
            echo.
            echo  Sua mochila esta cheia! Voce nao tem espaco para isso.
            pause >nul
            goto :loja_armas_mago
        )
        if %ouro% lss 120 (
            echo.
            echo  Voce e muito pobre para olhar para esta foice!
            pause >nul
            goto :loja_armas_mago
        )
        set /a ouro-=120
        set /a qtd_itens+=1
        set "nome_arma=Foice da Morte"
        set /a qd_jogador=1
        set /a d=20
        echo.
        echo  Equipamento %nome_arma% adquirido! Seus ataques agora rolam %qd_jogador%d%d%.
        pause >nul
    goto :loja_armas_mago

    :compra_amuleto
        if %qtd_itens% geq %slot% (
            echo.
            echo  Sua mochila esta cheia! Voce nao tem espaco para isso.
            pause >nul
            goto :loja_armas_mago
        )
        if %ouro% lss 70 (
            echo.
            echo  Falta moeda ai, guerreiro!
            pause >nul
            goto :loja_armas_mago
        )
        set /a ouro-=70
        set /a qtd_itens+=1
        set "amuleto=Amuleto de Escaravelho"
        set /a def+=10
        set /a full_def+=15
        echo.
        echo  Equipamento %amuleto% adquirido! Agora voce tem +10 de defesa, e +15 quando vida cheia.
        pause >nul
    goto :loja_armas_mago

    :compra_manto
        if %qtd_itens% geq %slot% (
            echo.
            echo  Sua mochila esta cheia! Voce nao tem espaco para isso.
            pause >nul
            goto :loja_armas_mago
        )
        if %ouro% lss 80 (
            echo.
            echo  Voce e muito pobre pra comprar esse manto
            pause >nul
            goto :loja_armas_mago
        )
        set /a ouro-=80
        set /a qtd_itens+=1
        set "roupa=Manto da Intangibilidade"
        set /a anular_dano=15 & :: probabilidade em % de anular um atk
        echo.
        echo  Equipamento %roupa% adquirido! Agora voce tem 15% de chance de anular ataques.
        pause >nul
    goto :loja_armas_mago

:: ========================================================================
:: TABERNA - MERCADO DE CONSUMIVEIS
:: ========================================================================
:menu_taberna
    cls
    echo ==========================================================================================
    echo                                     Menu da Taberna
    echo ==========================================================================================
    echo  Seu Ouro atual: %ouro% moedas.
    echo  Inventario: %qtd_itens%/%slot% slots.
    echo  Itens: %pocao_hp% Pocao HP ^| %pocao_mana% Pocao Mana ^| %refeicao% Refeicoes
    echo ==========================================================================================
    echo.
    echo  [1] Pocao de HP       (Recupera 10 de HP)            - 30  Ouro
    echo  [2] Pocao de Mana     (Recupera 10 de Mana)          - 40  Ouro
    echo  [3] Refeicao          (Recupera 20 de HP)            - 20  Ouro
    echo  [4] Sair do balcão
    echo.

    choice /c 1234 /n /m " Escolha sua compra: "

    if errorlevel 4 goto :taverna_padrao
    if errorlevel 3 goto :tab_compra_refeicao
    if errorlevel 2 goto :tab_compra_mana
    if errorlevel 1 goto :tab_compra_hp
    goto :menu_taberna

    :tab_compra_hp
        cls
        if %qtd_itens% geq %slot% (echo. & echo Mochila cheia! & pause >nul & goto :menu_taberna)
        if %ouro% lss 30 (echo. & echo Até parece, você precisa de muito mais ouro pra isso parceiro! & pause >nul & goto :menu_taberna)
        set /a ouro-=30
        set /a pocao_hp+=1
        set /a qtd_itens+=1
        echo. & echo Voce comprou uma Pocao de HP!
        pause >nul
    goto :menu_taberna

    :tab_compra_mana
        cls
        if %qtd_itens% geq %slot% (echo. & echo Mochila cheia! & pause >nul & goto :menu_taberna)
        if %ouro% lss 40 (echo. & echo Só nos seus sonhos! Volte quando tiver dinheiro o suficiente! & pause >nul & goto :menu_taberna)
        set /a ouro-=40
        set /a pocao_mana+=1
        set /a qtd_itens+=1
        echo. & echo Voce comprou uma Pocao de Mana!
        pause >nul
    goto :menu_taberna

    :tab_compra_refeicao
        cls
        if %qtd_itens% geq %slot% (echo. & echo Cara, acho que não consigo carregar mais nada! & pause >nul & goto :menu_taberna)
        if %ouro% lss 20 (echo. & echo Ta me achando com cara de banco? Volte quando tiver mais grana! & pause >nul & goto :menu_taberna)
        set /a ouro-=20
        set /a refeicao+=1
        set /a qtd_itens+=1
        echo. & echo Voce comprou uma Refeicao!
        pause >nul
    goto :menu_taberna

:: =====================================================================================================
:: TELA DE ABERTURA
:: =====================================================================================================
:abertura
    cls
    color 0B

    for /l %%i in (1,1,8) do echo.

    echo                                                                  ;                           
    echo                 :                                                 ED.                   :     
    echo                t#,          .,G:                .          :      E#Wi                 t#,    
    echo  j.          ;##W.        ,WtE#,    :         ;W          Ef     E###G.       t      ;##W.   
    echo  EW,        :#L:WE       i#D.E#t  .GE        f#E GEEEEEEELE#t    E#fD#W;      Ej    :#L:WE   
    echo  E##j      .KG  ,#D     f#f  E#t j#K;      .E#f  ,;;L#K;;.E#t    E#t t##L     E#,  .KG  ,#D  
    echo  E###D.    EE    ;#f  .D#i   E#GK#f       iWW;      t#E   E#t    E#t  .E#K,   E#t  EE    ;#f 
    echo  E#jG#W;  f#.     t#i:KW,    E##D.       L##Lffi    t#E   E#t fi E#t    j##f  E#t f#.     t#i
    echo  E#t t##f :#G     GK t#f     E##Wi      tLLG##L     t#E   E#t L#jE#t    :E#K: E#t :#G     GK 
    echo  E#t  :K#E:;#L   LW.  ;#G    E#jL#D:      ,W#i      t#E   E#t L#LE#t   t##L   E#t  ;#L   LW. 
    echo  E#KDDDD###it#f f#:    :KE.  E#t ,K#j    j#E.       t#E   E#tf#E:E#t .D#W;    E#t   t#f f#:  
    echo  E#f,t#Wi,,, f#D#;      .DW: E#t   jD  .D#j         t#E   E###f  E#tiW#G.     E#t    f#D#;   
    echo  E#t  ;#W:    G#t         L#,j#t      ,WK,          t#E   E#K,   E#K##i       E#t     G#t    
    echo  DWi   ,KK:    t           jt ,;      EG.            fE   EL     E##D.        E#t      t     
    echo                                       ,               :   :      E#t          ,;.            
    echo                                                                  L:                          
    echo.
    cscript //nologo "%temp%\motor_texto.vbs" "         [É ROCK STUDIO] A P R E S E N T A   U M   J O G O   F E I T O   P O R..." 30

    timeout /t 3 >nul
    cls

    for /l %%i in (1,1,13) do echo.
    cscript //nologo "%temp%\motor_texto.vbs" "==============================================================================================" 1
    echo.
    cscript //nologo "%temp%\motor_texto.vbs" "                                      Natan S. Rodrigues                                      " 10
    cscript //nologo "%temp%\motor_texto.vbs" "                                       João A.A. Blanco                                       " 10
    cscript //nologo "%temp%\motor_texto.vbs" "                                     Geovani Sa. de Brito                                     " 10
    echo.
    cscript //nologo "%temp%\motor_texto.vbs" "==============================================================================================" 1

    timeout /t 5 >nul

    color 0F

:: ========================================================================
:: MOTOR DE FLUXO PRINCIPAL (TELA DE TÍTULO ASSÍNCRONA)
:: ========================================================================
:: Criar um arquivo temporário que servirá como sinal para a neve.
echo executando > "%temp%\sinal_neve.tmp"

:: Iniciar o motor de neve em segundo plano compartilhando a mesma janela.
start /b "" cmd.exe /c "%~f0" motor_neve

:: A linha primária pausa aqui e aguarda a tecla do usuário silenciosamente.
pause > nul

:: Assim que a tecla é pressionada, deletamos o sinal vital.
del "%temp%\sinal_neve.tmp" >nul 2>nul

:: Avançar diretamente para o menu de heróis.
goto :verificar_save

:: ========================================================================
:: VERIFICA SAVE
:: ========================================================================
:verificar_save
    cls
    echo =========================================
    echo             INICIANDO O JOGO...
    echo =========================================
        
    :: Verifica se o arquivo save.bat existe na pasta [2, 4]
    if exist save.bat (
        echo.
        echo Save encontrado! Carregando o seu progresso...
            
        :: Aguarda 2 segundos para o jogador ler a mensagem
        ping 127.0.0.1 -n 3 >nul
            
        :: Executa o save para restaurar as variáveis
        call save.bat
        
        :: Pula direto para a cena em que o jogador estava
        goto !local_atual!
    ) else (
        echo.
        echo Nenhum save encontrado. Iniciando uma nova jornada...
        ping 127.0.0.1 -n 3 >nul
            
        :: Vai para a rotina que cria o personagem nível 1
        goto :tela_selecao_aberto
    )

:: ========================================================================
:: MOTOR DE NEVE (LINHA SECUNDÁRIA)
:: ========================================================================
:snow_loop_thread
    :: Inicializar variáveis de linha
    for /l %%i in (1,1,35) do set "L%%i=                                                                                          "

    :snow_loop
        :: O ciclo verifica a integridade do sinal vital. Se destruído, a animação cessa.
        if not exist "%temp%\sinal_neve.tmp" exit

        cls

        :: 1. GERAR NOVA LINHA (O TOPO)
        set "newLine= "
        for /l %%i in (1,1,46) do (
            set /a "r=!random! %% 25"
            if !r! equ 0 (set "newLine=!newLine! *") else (
                if !r! equ 1 (set "newLine=!newLine! .") else (
                    set "newLine=!newLine!  "
                )
            )
        )

        :: 2. DESLOCAMENTO
        for /l %%i in (35,-1,2) do (
            set /a "prev=%%i-1"
            for %%p in (!prev!) do set "L%%i=!L%%p!"
        )
        set "L1=!newLine!"

        :: 3. RENDERIZAÇÃO DA PARTE SUPERIOR (Linhas 1 a 12)
        for /l %%l in (1,1,12) do echo.!L%%l!

        echo =============================================================================================
        echo.
        echo      ▄████▄ ▄▄▄▄  ▄▄ ▄▄ ▄▄▄▄▄ ▄▄  ▄▄ ▄▄▄▄▄▄ ▄▄ ▄▄ ▄▄▄▄  ▄▄▄▄▄    ██████ ▄▄ ▄▄   ▄▄ ▄▄▄▄▄ 
        echo      ██▄▄██ ██▀██ ██▄██ ██▄▄  ███▄██   ██   ██ ██ ██▄█▄ ██▄▄       ██   ██ ██▀▄▀██ ██▄▄  
        echo      ██  ██ ████▀  ▀█▀  ██▄▄▄ ██ ▀██   ██   ▀███▀ ██ ██ ██▄▄▄      ██   ██ ██   ██ ██▄▄▄ 
        echo.
        echo =============================================================================================
        echo.
        echo.
        echo                                   Press any key to start...                                  

        :: 4. RENDERIZAÇÃO DA PARTE INFERIOR (Linhas 24 a 35)
        for /l %%l in (24,1,34) do echo.!L%%l!

        :: 5. CONTROLE DE VELOCIDADE
        pathping -n -q 1 -p 500 localhost >nul

    goto :snow_loop


:: ========================================================================
:: TELA DE SELEÇÃO DE PERSONAGEM
:: ========================================================================
:tela_selecao_aberto
    cls
    for /l %%i in (1,1,5) do echo.
    echo =============================================================================================
    echo.
    echo 	     ┏━╸┏━┓┏━╸┏━┓╻  ╻ ╻┏━┓   ┏━┓┏━╸╻ ╻   ┏━┓┏━╸┏━┓┏━┓┏━┓┏┓╻┏━┓┏━╸┏━╸┏┳┓
    echo 	     ┣╸ ┗━┓┃  ┃ ┃┃  ┣━┫┣━┫   ┗━┓┣╸ ┃ ┃   ┣━┛┣╸ ┣┳┛┗━┓┃ ┃┃┗┫┣━┫┃╺┓┣╸ ┃┃┃
    echo 	     ┗━╸┗━┛┗━╸┗━┛┗━╸╹ ╹╹ ╹   ┗━┛┗━╸┗━┛   ╹  ┗━╸╹┗╸┗━┛┗━┛╹ ╹╹ ╹┗━┛┗━╸╹ ╹
    echo.
    echo =============================================================================================
    echo.
    echo            /\                              _/\_  ┳━┓                       .        
    echo          _/__\_┏┓                         ( o¬o)┣┃━┛                      /_\
    echo          ( o.o)┃                          /^|__^|\_┃                       (¬_¬)
    echo          /(__)/┃                           [__]  ┃                    ━┫╸━}_{━╺┣━
    echo           /  \ ┃                           /  \                          _/ \_ 
    echo.
    echo    [1] Tulio - O Mago             [2] Sara - A Guerreira         [3] Soso - A Ocultista
    echo.
    echo =============================================================================================
    echo.
    echo  Atributos Base em Memoria:
    echo.
    echo                          [1] Alta Força Magica (HP: 10 ^| Forca: 5)
    echo                        [2] Combate Corpo-a-Corpo (HP: 25 ^| Forca: 25)
    echo                      [3] Evasão e Artes das Trevas (HP: 10 ^| Forca: 10)
    echo.

    :: Aguarda 2 segundos. Se nada for digitado, aciona a opcao '0' (piscar)
    choice /c 1230 /n /t 2 /d 0 /m " Pressione o dígito correspondente: "

    :: A LINHA ABAIXO FOI RESTAURADA PARA GARANTIR O CICLO
    if errorlevel 4 goto :tela_selecao_fechado
    if errorlevel 3 goto :set_soso
    if errorlevel 2 goto :set_sara
    if errorlevel 1 goto :set_tulio

:tela_selecao_fechado
    cls
    for /l %%i in (1,1,5) do echo.
    echo =============================================================================================
    echo.
    echo 	     ┏━╸┏━┓┏━╸┏━┓╻  ╻ ╻┏━┓   ┏━┓┏━╸╻ ╻   ┏━┓┏━╸┏━┓┏━┓┏━┓┏┓╻┏━┓┏━╸┏━╸┏┳┓
    echo 	     ┣╸ ┗━┓┃  ┃ ┃┃  ┣━┫┣━┫   ┗━┓┣╸ ┃ ┃   ┣━┛┣╸ ┣┳┛┗━┓┃ ┃┃┗┫┣━┫┃╺┓┣╸ ┃┃┃
    echo 	     ┗━╸┗━┛┗━╸┗━┛┗━╸╹ ╹╹ ╹   ┗━┛┗━╸┗━┛   ╹  ┗━╸╹┗╸┗━┛┗━┛╹ ╹╹ ╹┗━┛┗━╸╹ ╹
    echo.
    echo =============================================================================================
    echo.
    echo            /\                              _/\_  ┳━┓                       .                 
    echo          _/__\_┏┓                         ( -¬-)┣┃━┛                      /_\
    echo          ( -.-)┃                          /^|__^|\_┃                       (-_-)
    echo          /(__)/┃                           [__]  ┃                    ━┫╸━}_{━╺┣━
    echo           /  \ ┃                           /  \                          _/ \_ 
    echo.
    echo    [1] Tulio - O Mago             [2] Sara - A Guerreira         [3] Soso - A Ocultista
    echo.
    echo =============================================================================================
    echo.
    echo  Atributos Base em Memoria:
    echo.
    echo                          [1] Alta Força Magica (HP: 10 ^| Forca: 5)
    echo                        [2] Combate Corpo-a-Corpo (HP: 25 ^| Forca: 25)
    echo                      [3] Evasão e Artes das Trevas (HP: 10 ^| Forca: 10)
    echo.

    :: Aguarda 1 segundo. Se nada for digitado, aciona a opcao '0' (abrir olhos)
    choice /c 1230 /n /t 1 /d 0 /m " Pressione o dígito correspondente: "

    :: A LINHA ABAIXO FOI RESTAURADA PARA GARANTIR O CICLO
    if errorlevel 4 goto :tela_selecao_aberto
    if errorlevel 3 goto :set_soso
    if errorlevel 2 goto :set_sara
    if errorlevel 1 goto :set_tulio

:: ==========================================
:: ALOCACAO DE ATRIBUTOS (VARIAVEIS DE JOGADOR)
:: ==========================================
:set_tulio
    set "nome_personagem=Tulio"
    set "classe_personagem=O Mago"
    set /a lvl_jogador=1
    set /a xp_atual=0
    set /a xp_proximo_lvl=50
    set /a hp_jogador=10
    set /a max_hp=10
    set /a forca_jogador=5
    set /a agil_jogador=15
    set /a def_jogador=15
    set /a mana_jogador=30
    set /a max_mana=30

    ::Equipamentos::
    set /a armamento=0
    set /a escudo=0
    set /a armadura=0

    set "nome_arma= Graveto"
    set "roupa="

    ::Itens::
    set /a pocao_hp=1
    set /a pocao_mana=1
    set /a refeicao=0
    set /a ouro=50

    ::Dado::
    set /a qd_jogador=0
    set /a d=0

    ::Slots de Inventário::
    set /a slot=6
    set /a qtd_itens=2

    ::Ataques Especiais::
        ::Dano de fogo em area que causa 120% da força do jogador e tem 30% de chance de causar queimadura, que causa dano adicional de 10% da força do jogador por 3 turnos.
    set "atk_especial_1=Bola de Fogo"
        ::Congela o inimigo por 1 turno e causa dano igual a 100% da força do jogador, mas reduz a agilidade do inimigo em 10% por 2 turnos.
    set "atk_especial_2=Raio Congelante"
        ::Causa dano de eletricidade em área igual a 150% da força do jogador, tem 20% de chance de paralisar o inimigo por 1 turno, mas reduz a defesa do jogador em 15% por 3 turnos.
    set "atk_especial_3=Tempestade de Raios"

    ::Ataque padrão::
    set "atk_padrao=Ataque com Cajado"

    goto :set_sprites

:set_sara
    set "nome_personagem=Sara"
    set "classe_personagem=A Guerreira"
    set /a lvl_jogador=1
    set /a xp_atual=0
    set /a xp_proximo_lvl=50
    set /a hp_jogador=25
    set /a max_hp=25
    set /a forca_jogador=25
    set /a agil_jogador=10
    set /a def_jogador=15
    set /a mana_jogador=0
    set /a max_mana=0

    ::Equipamentos::
    set /a armamento=0
    set /a escudo=0
    set /a armadura=0

    set "nome_arma= Graveto"

    ::Itens::
    set /a pocao_hp=0
    set /a pocao_mana=0
    set /a refeicao=0
    set /a ouro=50

    ::Dado::
    set /a qd_jogador=0
    set /a d=0

    ::Slots de Inventário::
    set /a slot=10
    set /a qtd_itens=0

    ::Ataques Especiais::
        ::Atordoa o inimigo por 1 turno e causa dano igual a 150% da força do jogador, mas reduz a defesa do jogador em 10% por 2 turnos.
    set "atk_especial_1=Investida"
        ::Aumenta a força da equipe no próximo ataque em 30% e tem 20% de chance de atordoar o inimigo por 1 turno.
    set "atk_especial_2=Grito de Guerra"
        ::Aumenta a próxima jogada de ataque em 50% e ignora a defesa do inimigo, mas reduz a defesa do jogador em 20% por 3 turnos.
    set "atk_especial_3=Fúria Desenfreada" 

    ::Ataque padrão::
    set "atk_padrao=Ataque com Espada"
    
    goto :set_sprites

:set_soso
    set "nome_personagem=Soso"
    set "classe_personagem=A Ocultista"
    set /a lvl_jogador=1
    set /a xp_atual=0
    set /a xp_proximo_lvl=50
    set /a hp_jogador=12
    set /a max_hp=12
    set /a forca_jogador=10
    set /a agil_jogador=28
    set /a def_jogador=15
    set /a mana_jogador=10
    set /a max_mana=10

    ::Equipamentos::
    set /a armamento=0
    set /a escudo=0
    set /a armadura=0

    set "nome_arma= Graveto"

    ::Itens::
    set /a pocao_hp=0
    set /a pocao_mana=0
    set /a refeicao=0
    set /a ouro=100

    ::Dado::
    set /a qd_jogador=0
    set /a d=0

    ::Slots de Inventário::
    set /a slot=16
    set /a qtd_itens=0

    ::Ataques Especiais::
        ::Causa dano igual a 120% da força do jogador e tem 25% de chance de causar sangramento, que causa dano adicional de 5% da força do jogador por 4 turnos.
    set "atk_especial_1=Golpe Soturno"
        ::Causa dano de veneno igual a 100% da força do jogador e tem 30% de chance de envenenar o inimigo, causando dano adicional de 15% da força do jogador por 3 turnos, mas reduz a defesa do jogador em 10% por 2 turnos.
    set "atk_especial_2=Flecha Sombria"
        ::Causa dano de maldição igual a 150% da força do jogador e tem 20% de chance de amaldiçoar o inimigo, reduzindo sua força em 20% por 3 turnos, mas reduz a agilidade do jogador em 15% por 2 turnos.
    set "atk_especial_3=Invocação de Sombra"

    ::Ataque padrão::
    set "atk_padrao=Ataque com Adaga"
    
    goto :set_sprites

:: ==========================================
:: DEFINIÇÃO DOS SPRITES
:: ==========================================
:set_sprites
    if "%nome_personagem%"=="Tulio" goto :sprite_tulio
    if "%nome_personagem%"=="Sara"  goto :sprite_sara
    if "%nome_personagem%"=="Soso"  goto :sprite_soso
    goto :confirmacao

:sprite_tulio
    set /a visitou_cidade=0
    set "s1=   /\      "
    set "s2= _/__\_┏┓  "
    set "s3= ( o.o)┃   "
    set "s4= /(__)/┃   "
    set "s5=  /  \ ┃   "
    set "sp1=    /\      "
    set "sp2=┏┓_/__\_  "
    set "sp3= ┃(o.o )   "
    set "sp4= ┃\(__)\   "
    set "sp5= ┃ /  \    "

    set "spr1=%s1%"
    set "spr2=%s2%"
    set "spr3=%s3%"
    set "spr4=%s4%"
    set "spr5=%s5%"
    goto :confirmacao

:sprite_sara
    set /a visitou_cidade=0
    set "s1=  _/\_  ┳━┓"
    set "s2= ( o¬o)┣┃━┛ "
    set "s3= /^|__^|\_┃ "
    set "s4=  [__]  ┃  "
    set "s5=  /  \     "

    set "spr1=%s1%"
    set "spr2=%s2%"
    set "spr3=%s3%"
    set "spr4=%s4%"
    set "spr5=%s5%"
    goto :confirmacao

:sprite_soso
    set /a visitou_cidade=0
    set "s1=      .     "
    set "s2=     /_\   "
    set "s3=    (¬_¬)    "
    set "s4= ━┫╸━}_{━╺┣━"
    set "s5=    _/ \_    "

    set "spr1=%s1%"
    set "spr2=%s2%"
    set "spr3=%s3%"
    set "spr4=%s4%"
    set "spr5=%s5%"
    goto :confirmacao

:: ==========================================
:: TELA DE CONFIRMAÇÃO DE PERSONAGEM
:: ==========================================
:confirmacao
    cls
    for /l %%i in (1,1,11) do echo.                           
    echo                                                                                %s1%
    echo                 ┏━┓┏━╸┏━┓┏━┓┏━┓┏┓╻┏━┓┏━╸┏━╸┏┳┓   ┏━╸┏━┓┏━╸┏━┓╻  ╻ ╻╻╺┳┓┏━┓     %s2%
    echo                 ┣━┛┣╸ ┣┳┛┗━┓┃ ┃┃┗┫┣━┫┃╺┓┣╸ ┃┃┃   ┣╸ ┗━┓┃  ┃ ┃┃  ┣━┫┃ ┃┃┃ ┃╹    %s3%
    echo                 ╹  ┗━╸╹┗╸┗━┛┗━┛╹ ╹╹ ╹┗━┛┗━╸╹ ╹   ┗━╸┗━┛┗━╸┗━┛┗━╸╹ ╹╹╺┻┛┗━┛╹    %s4%
    echo                                                                                %s5%
    echo.
    echo                          Entidade selecionada: %nome_personagem% - %classe_personagem%
    echo                            Carga de Atributos: %hp_jogador% HP ^| %forca_jogador% FOR
    echo.
    echo                         [Y] Confirmar Inserção    [N] Retornar a Seleção
    echo.

    choice /c YN /n /m " Pressione a tecla correspondente: "

    if errorlevel 2 goto :tela_selecao_aberto
    if errorlevel 1 goto :prologo

:: ================================================================================================================
:: INICIO - PRÓLOGO
:: ================================================================================================================
:prologo
    cls
    color 0A
    for /l %%i in (1,1,14) do echo.
    echo =============================================================================================

    :: Execução do efeito máquina de escrever utilizando o Motor VBScript
    :: Sintaxe: cscript //nologo "%temp%\motor_texto.vbs" "Texto entre aspas" Milissegundos

    cscript //nologo "%temp%\motor_texto.vbs" " Dados gravados na memoria com sucesso." 40
    echo.
    cscript //nologo "%temp%\motor_texto.vbs" " Preparando para iniciar a historia..." 40
    echo.

    echo =============================================================================================
    pathping -n -q 1 -p 1100 localhost >nul

    :: ==========================================
    :: INÍCIO DO PRÓLOGO (NEVE)
    :: ==========================================
    echo executando > "%temp%\sinal_prologo.tmp"
    start /b "" cmd.exe /c "%~f0" motor_prologo
    pause > nul
    del "%temp%\sinal_prologo.tmp" >nul 2>nul

    goto :capitulo_um


    :: ================================================================================================================
    :: MOTOR SECUNDÁRIO - RENDERIZAÇÃO DE NEVE PRÓLOGO
    :: ================================================================================================================
    :neve_prologo_thread
        color 0B

        :: Reduzi o céu para 11 linhas para evitar o transbordo (flickering)
        for /l %%i in (1,1,11) do set "L%%i=                                                                                          "

        :neve_prologo_loop
            if not exist "%temp%\sinal_prologo.tmp" exit

            :: O comando CLS é o ponto zero. Não deve haver "echo." acima dele.
            cls

            :: 1. GERAR NOVA LINHA DE NEVE
            set "newLine= "
            for /l %%i in (1,1,47) do (
                set /a "r=!random! %% 25"
                if !r! equ 0 (set "newLine=!newLine!  *") else (
                    if !r! equ 1 (set "newLine=!newLine! .") else (
                        set "newLine=!newLine!  "
                    )
                )
            )

            :: 2. DESLOCAMENTO
            for /l %%i in (14,-1,2) do (
                set /a "prev=%%i-1"
                for %%p in (!prev!) do set "L%%i=!L%%p!"
            )
            set "L1=!newLine!"

            :: 3. RENDERIZAÇÃO DO CÉU 
            for /l %%l in (1,1,14) do echo.!L%%l!

        :: 4. RENDERIZAÇÃO DA PAISAGEM
        echo        * ´ *
        echo      `  /┃  ´                                        /\
        echo      ,  \┃  ,                      /\               /  \
        echo        * . *                      /  \      /\     /\ /V\                    /\
        echo ~-**-~-...    .-*-./\ .-~-**-~-. /____\-**~/  \***/  V   \~~~~/\.-~-**-~*-~-/  \         ..~~~
        echo           ``~-**-~/vv\   /\               /____\ /        \  /  \/\ -**-   /____\**-~-~´´
        echo     /\           /____\ /**\     -~****~-       /          \/___/WV\   _.~~~~._
        echo    /\/\   .-~-**-~-.   /    \            /\    /            \  /    \            -~****~-
        echo   /    \              /______\          /VV\  /              \/      \               /\
        echo  /     .-~-**-~-.       -~****~-       /    \/                \       \             /\/\
        echo / ,,-~´           `~-,,        ,.-~-**-~-.,,/                  \       \    .-~****~-.  \
        echo  ´                     ``~_-~´´             `~-.__              \    _.-~´´            ``~-.__
        echo                  ..-~-==-~-..                                    \..-~-==-~-..
        echo           _..-~´´            ``~-.._      _.~~~~._        _..-~´´              ``~-.._
        echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        echo.
        echo      O inverno chegou como uma sentenca de morte, cobrindo o reino com um manto de neve
        echo      implacavel e isolando os poucos vilarejos que ousam resistir a sua furia glacial.
        echo.
        echo                                                     (Pressione qualquer tecla para continuar)

        :: 6. CONTROLE DE VELOCIDADE
        pathping -n -q 1 -p 300 localhost >nul

        goto :neve_prologo_loop
    :: ================================================================================================================
    :: MOTOR PARA QUE FIQUE EM LOOP ATÉ QUE CLIQUE EM ALGO PARA AVANÇAR A HISTÓRIA (PORTAL REDONDO NA FLORESTA)
    :: ================================================================================================================
    :capitulo_um
        cls
        color 0C

        :: Criar o sinal para a animação começar
        echo executando > "%temp%\sinal_portal.tmp"

        :: DISPARAR A ANIMAÇÃO EM SEGUNDO PLANO
        start /b "" cmd.exe /c "%~f0" motor_portal

        :: O SCRIPT PRINCIPAL PARA AQUI E ESPERA O JOGADOR
        pause > nul

        :: QUANDO O JOGADOR APERTA UMA TECLA:
        :: Deletamos o sinal para parar a animação
        del "%temp%\sinal_portal.tmp" >nul 2>nul

        :: Limpa a tela e segue para a próxima parte (ex: o encontro com o monstro)
        cls
        goto :cena_vila_frame1
    :: ================================================================================================================
    :: THREAD SECUNDÁRIA - MOTOR DE ANIMAÇÃO DO PORTAL REDONDO NA FLORESTA
    :: ================================================================================================================
    :motor_portal_thread
        :: Certifique-se de que o comando 'chcp 65001' foi executado no início do script para suportar Unicode.

        :frame_a
            if not exist "%temp%\sinal_portal.tmp" exit
            cls
            echo     *   *                  .          ┃       .           *              +             . /
            echo   `  /┃   ´   +    *    /\       *   / \         +     /\      +         .         *    / 
            echo  `  ┃ ┃ - ┃´   .       /  \ .  ┃    /   \   *         /__\  /\    +  /\    /\    +   * /_
            echo  ,/\ \┃  / \     +    /    \  / \  /     \     . ┃/\  /  \ /__\ *   /  \ */  \     +   /
            echo  /  \   /   \/\    /\/      \/   \/      _\+ /\ / \ \/    \   /\ /\/    \/    \  +/\* /
            echo / \  \ /_   _\ \  /  \      /     \ /\  /\\ /  /_ _\ \   /\\ /  \ /_    /_    _\ /  \/
            echo    \   /     \  \/    \    /_     _\  \/  ┃/   /   \ _\ /  \/_  _\/     /      \/   /_
            echo     \ /_     _\ /_    _\/\ /       \  /_ / \  /     \ \/_  _\    \  /\ /        \   /
            echo     _\ /\     \ /      \  /  /\     \ / /   \/_     _\ /    \     \/  \         _\ /
            echo     \ /  \    _\       _\/_ /  \    _\ /     \       \/_    _\    /_  _\         \/_
            echo _____/    \    \        \/ /_  _\    \/_     _\_______/      \____/    \          /
            echo  ┃┃┃/_    _\   _\  .-----------.\_____/       \┃_┃┃__/________\ ┃/______\        /
            echo  ┃┃┃/______\   \ .'  *          `. _ /         \ ┃┃__┃___┃┃_┃┃  ┃┃ /┃┃          /_____________
            echo  ┃┃┃   ┃┃ ┃_____/   .  +  * +     \ /___________\┃┃_\┃   ┃┃ ┃┃  ┃┃/_┃┃______________\  ┃  ┃  ┃
            echo  ┃┃┃   ┃┃ ┃ ┃┃ ┃   *    *      *   ┃ ┃┃  ┃┃  ┃┃┃ ┃┃  ┃   ┃┃ ┃┃  ┃┃  ┃┃  ┃  ┃┃  ┃  ┃┃   ┃  ┃  ┃
            echo  ┃┃┃___┃┃ ┃ ┃┃ ┃     *      *   *  ┃ ┃┃  ┃┃__┃┃┃_┃┃  ┃___┃┃ ┃┃  ┃┃  ┃┃  ┃  ┃┃  ┃  ┃┃   ┃  ┃  ┃
            echo  ┃┃┃ ┃ ┃┃ ┃ ┃┃ ┃  * +  ( ┃ )  +  * ┃ ┃┃  ┃┃  ┃┃┃ ┃┃  ┃ ┃ ┃┃ ┃┃  ┃┃  ┃┃  ┃  ┃┃  ┃  ┃┃   ┃  ┃  ┃
            echo  ┃┃┃ ┃ ┃┃ ┃ ┃┃ ┃   *       *   *   ┃ ┃┃  ┃┃  ┃┃┃ ┃┃  ┃ ┃ ┃┃ ┃┃  ┃┃  ┃┃  ┃  ┃┃  ┃  ┃┃   ┃  ┃  ┃
            echo  ┃┃┃ ┃ ┃┃ ┃ ┃┃ ┃   *    *      *   ┃ ┃┃  ┃┃  ┃┃┃ ┃┃  ┃ ┃ ┃┃ ┃┃  ┃┃  ┃┃  ┃  ┃┃  ┃  ┃┃   ┃  ┃  ┃
            echo  ┃┃┃ ┃ ┃┃ ┃ ┃┃  \   .  +  * +     /  ┃┃  ┃┃  ┃┃┃ ┃┃  ┃ ┃ ┃┃ ┃┃  ┃┃  ┃┃  ┃  ┃┃  ┃  ┃┃   ┃  ┃  ┃
            echo  ┃┃┃ ┃ ┃┃ ┃ ┃┃   `.      *      .'   ┃┃  ┃┃  ┃┃┃ ┃┃  ┃ ┃ ┃┃ ┃┃  ┃┃  ┃┃  ┃  ┃┃  ┃  ┃┃   ┃  ┃  ┃
            echo  ┃┃┃ ┃ ┃┃ ┃ ┃┃  ┃  `-----------'   ┃ ┃┃  ┃┃  ┃┃┃ ┃┃  ┃ ┃ ┃┃ ┃┃  ┃┃  ┃┃  ┃  ┃┃  ┃  ┃┃   ┃  ┃  ┃
            echo  ┃┃┃ ┃ ┃┃ ┃ ┃┃  ┃   ┃   ┃┃┃     ┃  ┃ ┃┃  ┃┃  ┃┃┃ ┃┃  ┃ ┃ ┃┃ ┃┃  ┃┃  ┃┃  ┃  ┃┃  ┃  ┃┃   ┃  ┃  ┃
            echo  ┃┃┃ ┃ ┃┃ ┃ ┃┃  ┃    *      v   o  ┃ ┃┃  ┃┃  ┃┃┃/┃┃\ ┃ ┃ ┃┃ ┃┃  ┃┃  ┃┃  ┃  ┃┃  ┃  ┃┃   ┃  ┃  ┃
            echo  ┃┃┃ ┃ ┃┃   ┃┃        v              v  /┃┃\ /┃┃\   /┃ ┃\┃┃ ┃┃ /┃┃\ ┃┃  ┃  ┃┃  ┃  ┃┃   ┃  ┃  ┃
            echo /┃┃\┃┃┃      v    *     o      v    *        ┃┃┃┃  \/    ┃┃    ┃┃┃┃ ┃┃ /┃\/┃┃\/┃\ ┃┃   ┃  ┃ /┃
            echo ┃┃┃┃    o   *       v         *      v     *      o     /┃┃\       ┃┃┃┃   ┃┃┃┃┃┃┃ ┃┃  ┃┃  ┃┃┃┃ 
            echo ==============================================================================================
            echo.
            echo             No coração da Floresta Sombria, uma sombra seita está concluindo um 
            echo           portal profano para liberar o caos do abismo sobre o mundo dos mortais.
            echo.
            echo                                                     (Pressione qualquer tecla para continuar)
            pathping -n -q 1 -p 80 localhost >nul
        goto :frame_b

        :frame_b
            if not exist "%temp%\sinal_portal.tmp" exit
            cls
            echo     *   *                  .          ┃       .           *              +             . /
            echo   `  /┃   ´   +    *    /\       *   / \         +     /\      +         .         +    / 
            echo  `  ┃ ┃ - ┃´   .       /  \ .  ┃    /   \   *         /__\  /\    +  /\    /\    *   + /_
            echo  ,/\ \┃  / \     *    /    \  / \  /     \     . ┃/\  /  \ /__\ *   /  \ */  \     +   /
            echo  /  \   /   \/\    /\/      \/   \/      _\* /\ / \ \/    \   /\ /\/    \/    \  */\* /
            echo / \  \ /_   _\ \  /  \      /     \ /\  /\\ /  /_ _\ \   /\\ /  \ /_    /_    _\ /  \/
            echo    \   /     \  \/    \    /_     _\  \/  ┃/   /   \ _\ /  \/_  _\/     /      \/   /_
            echo     \ /_     _\ /_    _\/\ /       \  /_ / \  /     \ \/_  _\    \  /\ /        \   /
            echo     _\ /\     \ /      \  /  /\     \ / /   \/_     _\ /    \     \/  \         _\ /
            echo     \ /  \    _\       _\/_ /  \    _\ /     \       \/_    _\    /_  _\         \/_
            echo _____/    \    \        \/ /_  _\    \/_     _\_______/      \____/    \          /
            echo  ┃┃┃/_    _\   _\  .-----------.\_____/       \┃_┃┃__/________\ ┃/______\        /
            echo  ┃┃┃/______\   \ .'     *       `. _ /         \ ┃┃__┃___┃┃_┃┃  ┃┃ /┃┃          /_____________
            echo  ┃┃┃   ┃┃ ┃_____/   .  +     *   *\ /___________\┃┃_\┃   ┃┃ ┃┃  ┃┃/_┃┃______________\  ┃  ┃  ┃
            echo  ┃┃┃   ┃┃ ┃ ┃┃ ┃      *    *  +    ┃ ┃┃  ┃┃  ┃┃┃ ┃┃  ┃   ┃┃ ┃┃  ┃┃  ┃┃  ┃  ┃┃  ┃  ┃┃   ┃  ┃  ┃
            echo  ┃┃┃___┃┃ ┃ ┃┃ ┃     +  *    *     ┃ ┃┃  ┃┃__┃┃┃_┃┃  ┃___┃┃ ┃┃  ┃┃  ┃┃  ┃  ┃┃  ┃  ┃┃   ┃  ┃  ┃
            echo  ┃┃┃ ┃ ┃┃ ┃ ┃┃ ┃  * +  ( / ) + *   ┃ ┃┃  ┃┃  ┃┃┃ ┃┃  ┃ ┃ ┃┃ ┃┃  ┃┃  ┃┃  ┃  ┃┃  ┃  ┃┃   ┃  ┃  ┃
            echo  ┃┃┃ ┃ ┃┃ ┃ ┃┃ ┃   *  +   * *    * ┃ ┃┃  ┃┃  ┃┃┃ ┃┃  ┃ ┃ ┃┃ ┃┃  ┃┃  ┃┃  ┃  ┃┃  ┃  ┃┃   ┃  ┃  ┃
            echo  ┃┃┃ ┃ ┃┃ ┃ ┃┃ ┃   *    *      *   ┃ ┃┃  ┃┃  ┃┃┃ ┃┃  ┃ ┃ ┃┃ ┃┃  ┃┃  ┃┃  ┃  ┃┃  ┃  ┃┃   ┃  ┃  ┃
            echo  ┃┃┃ ┃ ┃┃ ┃ ┃┃  \   +  * +      * /  ┃┃  ┃┃  ┃┃┃ ┃┃  ┃ ┃ ┃┃ ┃┃  ┃┃  ┃┃  ┃  ┃┃  ┃  ┃┃   ┃  ┃  ┃
            echo  ┃┃┃ ┃ ┃┃ ┃ ┃┃   `.      *      .'   ┃┃  ┃┃  ┃┃┃ ┃┃  ┃ ┃ ┃┃ ┃┃  ┃┃  ┃┃  ┃  ┃┃  ┃  ┃┃   ┃  ┃  ┃
            echo  ┃┃┃ ┃ ┃┃ ┃ ┃┃  ┃  `-----------'   ┃ ┃┃  ┃┃  ┃┃┃ ┃┃  ┃ ┃ ┃┃ ┃┃  ┃┃  ┃┃  ┃  ┃┃  ┃  ┃┃   ┃  ┃  ┃
            echo  ┃┃┃ ┃ ┃┃ ┃ ┃┃  ┃   ┃   ┃┃┃     ┃  ┃ ┃┃  ┃┃  ┃┃┃ ┃┃  ┃ ┃ ┃┃ ┃┃  ┃┃  ┃┃  ┃  ┃┃  ┃  ┃┃   ┃  ┃  ┃
            echo  ┃┃┃ ┃ ┃┃ ┃ ┃┃  ┃    *      v   o  ┃ ┃┃  ┃┃  ┃┃┃/┃┃\ ┃ ┃ ┃┃ ┃┃  ┃┃  ┃┃  ┃  ┃┃  ┃  ┃┃   ┃  ┃  ┃
            echo  ┃┃┃ ┃ ┃┃   ┃┃        v              v  /┃┃\ /┃┃\   /┃ ┃\┃┃ ┃┃ /┃┃\ ┃┃  ┃  ┃┃  ┃  ┃┃   ┃  ┃  ┃
            echo /┃┃\┃┃┃      v    *     o      v    *        ┃┃┃┃  \/    ┃┃    ┃┃┃┃ ┃┃ /┃\/┃┃\/┃\ ┃┃   ┃  ┃ /┃
            echo ┃┃┃┃    o   *       v         *      v     *      o     /┃┃\       ┃┃┃┃   ┃┃┃┃┃┃┃ ┃┃  ┃┃  ┃┃┃┃ 
            echo ==============================================================================================
            echo.
            echo             No coração da Floresta Sombria, uma sombra seita está concluindo um 
            echo           portal profano para liberar o caos do abismo sobre o mundo dos mortais.
            echo.
            echo                                                     (Pressione qualquer tecla para continuar)
            pathping -n -q 1 -p 80 localhost >nul
        goto :frame_c

        :frame_c
            if not exist "%temp%\sinal_portal.tmp" exit
            cls
            echo     *   *                  .          ┃       .           +              *             . /
            echo   `  /┃   ´   *    *    /\       *   / \         *     /\      *         .         *    / 
            echo  `  ┃ ┃ - ┃´   .       /  \ .  ┃    /   \   +         /__\  /\    *  /\    /\    *   * /_
            echo  ,/\ \┃  / \     +    /    \  / \  /     \     . ┃/\  /  \ /__\ +   /  \ */  \     +   /
            echo  /  \   /   \/\    /\/      \/   \/      _\+ /\ / \ \/    \   /\ /\/    \/    \  +/\+ /
            echo / \  \ /_   _\ \  /  \      /     \ /\  /\\ /  /_ _\ \   /\\ /  \ /_    /_    _\ /  \/
            echo    \   /     \  \/    \    /_     _\  \/  ┃/   /   \ _\ /  \/_  _\/     /      \/   /_
            echo     \ /_     _\ /_    _\/\ /       \  /_ / \  /     \ \/_  _\    \  /\ /        \   /
            echo     _\ /\     \ /      \  /  /\     \ / /   \/_     _\ /    \     \/  \         _\ /
            echo     \ /  \    _\       _\/_ /  \    _\ /     \       \/_    _\    /_  _\         \/_
            echo _____/    \    \        \/ /_  _\    \/_     _\_______/      \____/    \          /
            echo  ┃┃┃/_    _\   _\  .-----------.\_____/       \┃_┃┃__/________\ ┃/______\        /
            echo  ┃┃┃/______\   \ .'        *    `. _ /         \ ┃┃__┃___┃┃_┃┃  ┃┃ /┃┃          /_____________
            echo  ┃┃┃   ┃┃ ┃_____/          +      \ /___________\┃┃_\┃   ┃┃ ┃┃  ┃┃/_┃┃______________\  ┃  ┃  ┃
            echo  ┃┃┃   ┃┃ ┃ ┃┃ ┃    *    * .  +  * ┃ ┃┃  ┃┃  ┃┃┃ ┃┃  ┃   ┃┃ ┃┃  ┃┃  ┃┃  ┃  ┃┃  ┃  ┃┃   ┃  ┃  ┃
            echo  ┃┃┃___┃┃ ┃ ┃┃ ┃+    +  *    *     ┃ ┃┃  ┃┃__┃┃┃_┃┃  ┃___┃┃ ┃┃  ┃┃  ┃┃  ┃  ┃┃  ┃  ┃┃   ┃  ┃  ┃
            echo  ┃┃┃ ┃ ┃┃ ┃ ┃┃ ┃    * +( - ) + *   ┃ ┃┃  ┃┃  ┃┃┃ ┃┃  ┃ ┃ ┃┃ ┃┃  ┃┃  ┃┃  ┃  ┃┃  ┃  ┃┃   ┃  ┃  ┃
            echo  ┃┃┃ ┃ ┃┃ ┃ ┃┃ ┃ *  +   * *    *   ┃ ┃┃  ┃┃  ┃┃┃ ┃┃  ┃ ┃ ┃┃ ┃┃  ┃┃  ┃┃  ┃  ┃┃  ┃  ┃┃   ┃  ┃  ┃
            echo  ┃┃┃ ┃ ┃┃ ┃ ┃┃ ┃   *   *      *    ┃ ┃┃  ┃┃  ┃┃┃ ┃┃  ┃ ┃ ┃┃ ┃┃  ┃┃  ┃┃  ┃  ┃┃  ┃  ┃┃   ┃  ┃  ┃
            echo  ┃┃┃ ┃ ┃┃ ┃ ┃┃  \   + * +    *    /  ┃┃  ┃┃  ┃┃┃ ┃┃  ┃ ┃ ┃┃ ┃┃  ┃┃  ┃┃  ┃  ┃┃  ┃  ┃┃   ┃  ┃  ┃
            echo  ┃┃┃ ┃ ┃┃ ┃ ┃┃   `.    *        .'   ┃┃  ┃┃  ┃┃┃ ┃┃  ┃ ┃ ┃┃ ┃┃  ┃┃  ┃┃  ┃  ┃┃  ┃  ┃┃   ┃  ┃  ┃
            echo  ┃┃┃ ┃ ┃┃ ┃ ┃┃  ┃  `-----------'   ┃ ┃┃  ┃┃  ┃┃┃ ┃┃  ┃ ┃ ┃┃ ┃┃  ┃┃  ┃┃  ┃  ┃┃  ┃  ┃┃   ┃  ┃  ┃
            echo  ┃┃┃ ┃ ┃┃ ┃ ┃┃  ┃   ┃   ┃┃┃     ┃  ┃ ┃┃  ┃┃  ┃┃┃ ┃┃  ┃ ┃ ┃┃ ┃┃  ┃┃  ┃┃  ┃  ┃┃  ┃  ┃┃   ┃  ┃  ┃
            echo  ┃┃┃ ┃ ┃┃ ┃ ┃┃  ┃    *      v   o  ┃ ┃┃  ┃┃  ┃┃┃/┃┃\ ┃ ┃ ┃┃ ┃┃  ┃┃  ┃┃  ┃  ┃┃  ┃  ┃┃   ┃  ┃  ┃
            echo  ┃┃┃ ┃ ┃┃   ┃┃        v              v  /┃┃\ /┃┃\   /┃ ┃\┃┃ ┃┃ /┃┃\ ┃┃  ┃  ┃┃  ┃  ┃┃   ┃  ┃  ┃
            echo /┃┃\┃┃┃      v    *     o      v    *        ┃┃┃┃  \/    ┃┃    ┃┃┃┃ ┃┃ /┃\/┃┃\/┃\ ┃┃   ┃  ┃ /┃
            echo ┃┃┃┃    o   *       v         *      v     *      o     /┃┃\       ┃┃┃┃   ┃┃┃┃┃┃┃ ┃┃  ┃┃  ┃┃┃┃ 
            echo ==============================================================================================
            echo.
            echo             No coração da Floresta Sombria, uma sombra seita está concluindo um 
            echo           portal profano para liberar o caos do abismo sobre o mundo dos mortais.
            echo.
            echo                                                     (Pressione qualquer tecla para continuar)
            pathping -n -q 1 -p 80 localhost >nul
        goto :frame_d

        :frame_d
            if not exist "%temp%\sinal_portal.tmp" exit
            cls
            echo     *   *                  .          ┃       .           *              +             . /
            echo   `  /┃   ´   +    *    /\       *   / \         +     /\      +                   *    / 
            echo  `  ┃ ┃ - ┃´           /  \    ┃    /   \   *         /__\  /\    +  /\    /\    +   * /_
            echo  ,/\ \┃  / \     +    /    \  / \  /     \       ┃/\  /  \ /__\ *   /  \ */  \     +   /
            echo  /  \   /   \/\    /\/      \/   \/      _\+ /\ / \ \/    \   /\ /\/    \/    \  +/\* /
            echo / \  \ /_   _\ \  /  \      /     \ /\  /\\ /  /_ _\ \   /\\ /  \ /_    /_    _\ /  \/
            echo    \   /     \  \/    \    /_     _\  \/  ┃/   /   \ _\ /  \/_  _\/     /      \/   /_
            echo     \ /_     _\ /_    _\/\ /       \  /_ / \  /     \ \/_  _\    \  /\ /        \   /
            echo     _\ /\     \ /      \  /  /\     \ / /   \/_     _\ /    \     \/  \         _\ /
            echo     \ /  \    _\       _\/_ /  \    _\ /     \       \/_    _\    /_  _\         \/_
            echo _____/    \    \        \/ /_  _\    \/_     _\_______/      \____/    \          /
            echo  ┃┃┃/_    _\   _\  .-----------.\_____/       \┃_┃┃__/________\ ┃/______\        /
            echo  ┃┃┃/______\   \ .'        *    `. _ /         \ ┃┃__┃___┃┃_┃┃  ┃┃ /┃┃          /_____________
            echo  ┃┃┃   ┃┃ ┃_____/     .    +   *  \ /___________\┃┃_\┃   ┃┃ ┃┃  ┃┃/_┃┃______________\  ┃  ┃  ┃
            echo  ┃┃┃   ┃┃ ┃ ┃┃ ┃    *    *  +    * ┃ ┃┃  ┃┃  ┃┃┃ ┃┃  ┃   ┃┃ ┃┃  ┃┃  ┃┃  ┃  ┃┃  ┃  ┃┃   ┃  ┃  ┃
            echo  ┃┃┃___┃┃ ┃ ┃┃ ┃+    +  *    *     ┃ ┃┃  ┃┃__┃┃┃_┃┃  ┃___┃┃ ┃┃  ┃┃  ┃┃  ┃  ┃┃  ┃  ┃┃   ┃  ┃  ┃
            echo  ┃┃┃ ┃ ┃┃ ┃ ┃┃ ┃    *  ( - ) + *   ┃ ┃┃  ┃┃  ┃┃┃ ┃┃  ┃ ┃ ┃┃ ┃┃  ┃┃  ┃┃  ┃  ┃┃  ┃  ┃┃   ┃  ┃  ┃
            echo  ┃┃┃ ┃ ┃┃ ┃ ┃┃ ┃ *  +          *   ┃ ┃┃  ┃┃  ┃┃┃ ┃┃  ┃ ┃ ┃┃ ┃┃  ┃┃  ┃┃  ┃  ┃┃  ┃  ┃┃   ┃  ┃  ┃
            echo  ┃┃┃ ┃ ┃┃ ┃ ┃┃ ┃       *      *    ┃ ┃┃  ┃┃  ┃┃┃ ┃┃  ┃ ┃ ┃┃ ┃┃  ┃┃  ┃┃  ┃  ┃┃  ┃  ┃┃   ┃  ┃  ┃
            echo  ┃┃┃ ┃ ┃┃ ┃ ┃┃  \   + * +    *    /  ┃┃  ┃┃  ┃┃┃ ┃┃  ┃ ┃ ┃┃ ┃┃  ┃┃  ┃┃  ┃  ┃┃  ┃  ┃┃   ┃  ┃  ┃
            echo  ┃┃┃ ┃ ┃┃ ┃ ┃┃   `.    *        .'   ┃┃  ┃┃  ┃┃┃ ┃┃  ┃ ┃ ┃┃ ┃┃  ┃┃  ┃┃  ┃  ┃┃  ┃  ┃┃   ┃  ┃  ┃
            echo  ┃┃┃ ┃ ┃┃ ┃ ┃┃  ┃  `-----------'   ┃ ┃┃  ┃┃  ┃┃┃ ┃┃  ┃ ┃ ┃┃ ┃┃  ┃┃  ┃┃  ┃  ┃┃  ┃  ┃┃   ┃  ┃  ┃
            echo  ┃┃┃ ┃ ┃┃ ┃ ┃┃  ┃   ┃   ┃┃┃     ┃  ┃ ┃┃  ┃┃  ┃┃┃ ┃┃  ┃ ┃ ┃┃ ┃┃  ┃┃  ┃┃  ┃  ┃┃  ┃  ┃┃   ┃  ┃  ┃
            echo  ┃┃┃ ┃ ┃┃ ┃ ┃┃  ┃    *      v   o  ┃ ┃┃  ┃┃  ┃┃┃/┃┃\ ┃ ┃ ┃┃ ┃┃  ┃┃  ┃┃  ┃  ┃┃  ┃  ┃┃   ┃  ┃  ┃
            echo  ┃┃┃ ┃ ┃┃   ┃┃        v              v  /┃┃\ /┃┃\   /┃ ┃\┃┃ ┃┃ /┃┃\ ┃┃  ┃  ┃┃  ┃  ┃┃   ┃  ┃  ┃
            echo /┃┃\┃┃┃      v    *     o      v    *        ┃┃┃┃  \/    ┃┃    ┃┃┃┃ ┃┃ /┃\/┃┃\/┃\ ┃┃   ┃  ┃ /┃
            echo ┃┃┃┃    o   *       v         *      v     *      o     /┃┃\       ┃┃┃┃   ┃┃┃┃┃┃┃ ┃┃  ┃┃  ┃┃┃┃ 
            echo ==============================================================================================
            echo.
            echo             No coração da Floresta Sombria, uma sombra seita está concluindo um 
            echo           portal profano para liberar o caos do abismo sobre o mundo dos mortais.
            echo.
            echo                                                     (Pressione qualquer tecla para continuar)
            pathping -n -q 1 -p 80 localhost >nul
        goto :frame_a

    :: ================================================================================================================
    :: CENA: O DESAPARECIMENTO E O BANQUETE MACABRO
    :: ================================================================================================================

    :: Inicializa o contador de ciclos da animacao
    set /a contador_cena=0

    :cena_vila_frame1
        cls
        echo.
        echo ___       /UUUUUUUUUU\    ___________     /UUUUUUUUUU\  __________    ____/UUUUUUUUUU\     ___
        echo uuu\   //UUUUUUUUUUUUUU\ /uuuuuuuuuuu\  /UUUUUUUUUUUUUU\uuuuuuu /\  /uuu/UUUUUUUUUUUUUU\\ /uuu
        echo   ┃ /\// ┃  ______    ┃  ┃┃  _  /\  ┃    ┃  ___  ____ ┃ ┃ ___ _/  \  ┃┃  ┃ ____ _____ ┃ \\ ┃ ┃
        echo   ┃/  \ ┃┃  ┃ \o/┃    ┃  ┃┃ ┃_┃/__\ ┃    ┃ ┃___┃ ┃  ┃ ┃ ┃ ┃_┃ ┃/__\  ┃┃  ┃ ┃  ┃ ┃ ┃ ┃ ┃┃   ┃ ┃
        echo __┃/__\_┃┃  ┃__┃_┃    ┃__\┃_____┃┃__┃____┃       ┃  ┃ ┃_┃_____┃┃┃┃___\┃__┃ ┃  ┃ ┃_┃_┃ ┃┃___\_┃
        echo ____┃┃__\┃____________┃_________┃┃_______┃_______┃__┃_┃_________┃┃_______┃_┃__┃_______┃/______
        echo                                         o        \┃/
        echo           \┃/           \o             /┃\                                 \┃/    
        echo                          ┃\            / \                        o     \┃/
        echo                 \o\     / \                         o            /┃\                 o 
        echo      \┃/         ┃                                 /┃\           / \                /┃\
        echo                 / \                \┃/             / \                      \┃/     / \
        echo.
        echo  =============================================================================================
        echo.
        echo   Civis estão desaparecendo, arrancados de suas casas para servirem como o banquete macabro  
        echo                           que celebrará a conclusão do rito.
        pathping -n -q 1 -p 300 localhost >nul

    :cena_vila_frame2
        cls
        echo.
        echo ___       /UUUUUUUUUU\    ___________     /UUUUUUUUUU\  __________    ____/UUUUUUUUUU\     ___
        echo uuu\   //UUUUUUUUUUUUUU\ /uuuuuuuuuuu\  /UUUUUUUUUUUUUU\uuuuuuu /\  /uuu/UUUUUUUUUUUUUU\\ /uuu
        echo   ┃ /\// ┃  ______    ┃  ┃┃  _  /\  ┃    ┃  ___  ____ ┃ ┃ ___ _/  \  ┃┃  ┃ ____ _____ ┃ \\ ┃ ┃
        echo   ┃/  \ ┃┃  ┃ \o/┃    ┃  ┃┃ ┃_┃/__\ ┃    ┃ ┃___┃ ┃  ┃ ┃ ┃ ┃_┃ ┃/__\  ┃┃  ┃ ┃  ┃ ┃ ┃ ┃ ┃┃   ┃ ┃
        echo __┃/__\_┃┃  ┃__┃_┃    ┃__\┃_____┃┃__┃____┃       ┃  ┃ ┃_┃_____┃┃┃┃___\┃__┃ ┃  ┃ ┃_┃_┃ ┃┃___\_┃
        echo ____┃┃__\┃____________┃_________┃┃_______┃_______┃__┃_┃_________┃┃_______┃_┃__┃_______┃/______
        echo                                       __o__      \┃/
        echo           \┃/            o/             ┃                                  \┃/    
        echo                         /┃             / \                        o     \┃/       
        echo                 /o/     / \                        \o/           /┃\                \o/
        echo      \┃/         ┃                                  ┃            / \                 ┃
        echo                 / \                \┃/             / \                      \┃/     / \
        echo.
        echo  =============================================================================================
        echo.
        echo   Civis estão desaparecendo, arrancados de suas casas para servirem como o banquete macabro  
        echo                           que celebrará a conclusão do rito.
        pathping -n -q 1 -p 300 localhost >nul

    :cena_vila_frame3
        cls
        echo.
        echo ___       /UUUUUUUUUU\    ___________     /UUUUUUUUUU\  __________    ____/UUUUUUUUUU\     ___
        echo uuu\   //UUUUUUUUUUUUUU\ /uuuuuuuuuuu\  /UUUUUUUUUUUUUU\uuuuuuu /\  /uuu/UUUUUUUUUUUUUU\\ /uuu
        echo   ┃ /\// ┃  ______    ┃  ┃┃  _  /\  ┃    ┃  ___  ____ ┃ ┃ ___ _/  \  ┃┃  ┃ ____ _____ ┃ \\ ┃ ┃
        echo   ┃/  \ ┃┃  ┃ \o/┃    ┃  ┃┃ ┃_┃/__\ ┃    ┃ ┃___┃ ┃  ┃ ┃ ┃ ┃_┃ ┃/__\  ┃┃  ┃ ┃  ┃ ┃ ┃ ┃ ┃┃   ┃ ┃
        echo __┃/__\_┃┃  ┃__┃_┃    ┃__\┃_____┃┃__┃____┃       ┃  ┃ ┃_┃_____┃┃┃┃___\┃__┃ ┃  ┃ ┃_┃_┃ ┃┃___\_┃
        echo ____┃┃__\┃____________┃_________┃┃_______┃_______┃__┃_┃_________┃┃_______┃_┃__┃_______┃/______
        echo                                         o        \┃/
        echo           \┃/           \o             /┃\                                 \┃/ 
        echo                          ┃\            / \                       \o/    \┃/
        echo                 \o\     / \                         o             ┃                  o 
        echo      \┃/         ┃                                 /┃\           / \                /┃\
        echo                 / \                \┃/             / \                      \┃/     / \
        echo.
        echo  =============================================================================================
        echo.
        echo   Civis estão desaparecendo, arrancados de suas casas para servirem como o banquete macabro  
        echo                           que celebrará a conclusão do rito.
        pathping -n -q 1 -p 300 localhost >nul

        :: Mecanismo de contagem e verificacao do loop
        set /a contador_cena+=1
        if %contador_cena% lss 20 (
            goto :cena_vila_frame1
        ) else (
            goto :cena_vila_temp1
        )

    :cena_vila_temp1
        cls
        echo.
        echo ___       /UUUUUUUUUU\    ___________     /UUUUUUUUUU\  __________    ____/UUUUUUUUUU\     ___
        echo uuu\   //UUUUUUUUUUUUUU\ /uuuuuuuuuuu\  /UUUUUUUUUUUUUU\uuuuuuu /\  /uuu/UUUUUUUUUUUUUU\\ /uuu
        echo   ┃ /\// ┃  ______    ┃  ┃┃  _  /\  ┃    ┃  ___  ____ ┃ ┃ ___ _/  \  ┃┃  ┃ ____ _____ ┃ \\ ┃ ┃
        echo   ┃/  \ ┃┃  ┃ \*/┃    ┃  ┃┃ ┃_┃/__\ ┃    ┃ ┃___┃ ┃  ┃ ┃ ┃ ┃_┃ ┃/__\  ┃┃  ┃ ┃  ┃ ┃ ┃ ┃ ┃┃   ┃ ┃
        echo __┃/__\_┃┃  ┃__┃_┃    ┃__\┃_____┃┃__┃____┃       ┃  ┃ ┃_┃_____┃┃┃┃___\┃__┃ ┃  ┃ ┃_┃_┃ ┃┃___\_┃
        echo ____┃┃__\┃____________┃_________┃┃_______┃_______┃__┃_┃_________┃┃_______┃_┃__┃_______┃/______
        echo                          !             \o/       \┃/
        echo           \┃/           \o/             ┃                         !        \┃/              
        echo                  !       ┃             / \          !            \o/    \┃/          !      
        echo                 \o/     / \                        \o/            ┃                 \o/     
        echo      \┃/         ┃                                  ┃            / \                 ┃       
        echo                 / \                \┃/             / \                      \┃/     / \      
        echo.
        echo ==============================================================================================
        echo.
        echo                [ O vento começa a soprar as primeiras fagulhas de gelo... ]  
        pathping -n -q 1 -p 300 localhost >nul
        goto :banquete_macabro

    :banquete_macabro
        cls
        echo.
        echo ==============================================================================================
        echo                     (  )   (  )                            (  )   (  )
        echo                      )(     )(                              )(     )(
        echo                     (  )   (  )                            (  )   (  )
        echo                     _┃┃_   _┃┃_                            _┃┃_   _┃┃_
        echo                    ┃____┃ ┃____┃                          ┃____┃ ┃____┃
        echo .........__________┃    ┃_┃    ┃__________......__________┃    ┃_┃    ┃__________.......
        echo         /          ┃    ┃ ┃    ┃          \    /          ┃    ┃ ┃    ┃          \
        echo        /           ┃    ┃ ┃    ┃      o    \  /  o     o  ┃    ┃ ┃    ┃           \
        echo       /            ┃____┃ ┃____┃     ┃┃┃    \/  /┃\   ┃┃┃ ┃____┃ ┃____┃            \
        echo      /                               / \        / \   / \                           \
        echo ____/________________________________________________________________________________\__
        echo    /                                                                                  \
        echo   /     [====]             [====]               [====]               [====]            \
        echo   ┃                                                                                    ┃
        echo   ┃____________________________________________________________________________________┃
        echo   ┃====================================================================================┃
        echo   ┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃
        echo.
        echo   Civis estão desaparecendo, arrancados de suas casas para servirem como o banquete macabro  
        echo                           que celebrará a conclusão do rito.
        echo.
        echo   Pressione qualquer tecla para continuar...
        pause >nul
    goto :taverna_cidade

    :taverna_cidade
        cls
        ::desenho da taberna aqui
        echo.
        echo  Você entra na taberna da vila, um local de descanso e socialização para os aventureiros. 
        echo       O ambiente é acolhedor, com uma lareira crepitante e mesas de madeira rústica. 
        echo                O aroma de comida caseira e cerveja artesanal preenche o ar, 
        echo        convidando os visitantes a relaxar e compartilhar histórias de suas jornadas.
        echo.
        echo                                                     (Pressione qualquer tecla para continuar)
        pause >nul
        cls
        ::desenho do taberneiro aqui
        echo.
        echo                    O taberneiro, um homem robusto com um sorriso amigável, 
        echo                cumprimenta você e oferece uma variedade de bebidas e refeições.
        echo                                                     (Pressione qualquer tecla para continuar)
        pause >nul
        goto :menu_taberna

    :taverna_padrao
        cls
        ::desenho da taberna aqui
        echo.
        echo  O que você quer fazer?
        echo.
        echo  [1] Falar com o taberneiro
        echo  [2] Comprar itens
        echo  [3] Buscar informações sobre a floresta
        echo  [4] Investigar os desaparecimentos
        echo  [5] Buscar missões

        if not exist save.bat (
            echo  [6] Sair da taberna
            echo.

            set local_atual=:cidade

            choice /c 123456 /n /m " Fale logo o que vc quer e suma daqui: "

            if errorlevel 6 goto :salvar_jogo
            if errorlevel 5 goto :missao
            if errorlevel 4 goto :investigacao
            if errorlevel 3 goto :informacao
            if errorlevel 2 goto :menu_taberna
            if errorlevel 1 goto :taverna_conversa
            goto :taverna_padrao
        ) else (
            echo  [6] Salvar o jogo
            echo  [7] Sair da taberna
            echo.

            set local_atual=:taverna_padrao

            choice /c 1234567 /n /m " Fale logo o que vc quer e suma daqui: "

            if errorlevel 7 goto :sair_taverna
            if errorlevel 6 goto :salvar_jogo
            if errorlevel 5 goto :missao
            if errorlevel 4 goto :investigacao
            if errorlevel 3 goto :informacao
            if errorlevel 2 goto :menu_taberna
            if errorlevel 1 goto :taverna_conversa
            goto :taverna_padrao
            
            
        )
        
    :missao
            echo Em breve...
            pause
            goto :taverna_padrao

    :investigacao
            echo Voce olha em volta... nada ainda.
            pause
            goto :taverna_padrao

    :informacao
            cls
            ::desenho de uma mesa com um cara sentado aqui
            echo.
            echo  Você se aproxima de uma mesa onde um homem idoso está sentado, parecendo ser um frequentador regular da taberna.
            echo  Ele tem uma expressão cansada, mas seus olhos brilham com um conhecimento profundo sobre a floresta sombria e os eventos recentes na vila.
            echo  Você se senta e começa a conversar com ele, buscando informações sobre os desaparecimentos misteriosos e os rumores de uma seita sombria na floresta.
            echo.
            echo                                                     (Pressione qualquer tecla para continuar)
            pause >nul
            cls
            ::o mesmo desenho da mesa
            echo.
            echo O homem idoso compartilha histórias de desaparecimentos misteriosos, sussurros sobre uma seita sombria e rumores de um portal profano sendo construído na floresta.
            echo Ele menciona que os civis estão sendo levados para um banquete macabro, onde serão sacrificados para completar um ritual sombrio.
            echo.
            echo                                                     (Pressione qualquer tecla para continuar)
            pause >nul
            cls
            ::desenho da taberna aqui
            echo.
            echo Você agradece ao homem idoso pelas informações e se levanta para explorar outras áreas da taberna.
            echo.
            echo                                                     (Pressione qualquer tecla para continuar)
            pause >nul
            goto :taverna_padrao

    :taverna_conversa
            cls
            ::desenho de uma mesa com um cara sentado aqui
            echo.
            echo  Você se senta em uma mesa e começa a conversar com o taberneiro, buscando informações sobre a floresta sombria e os eventos recentes na vila. 
            echo  O taberneiro compartilha histórias de desaparecimentos misteriosos, sussurros sobre uma seita sombria e rumores de um portal profano sendo construído na floresta.
            echo.
            echo                                                     (Pressione qualquer tecla para continuar)
            pause >nul
            cls
            ::desenho do taberneiro
            echo  Ele menciona que os civis estão sendo levados para um banquete macabro, onde serão sacrificados para completar um ritual sombrio. 
            echo  O taberneiro expressa preocupação com a segurança da vila e sugere que você investigue a floresta para descobrir a verdade por trás desses eventos.
            echo.
            echo                                                     (Pressione qualquer tecla para continuar)
            pause >nul
            goto :taverna_padrao

    :sair_taverna
        :: Empurra o jogador uma casa para baixo para sair da porta
        set /a pos_y=2
        goto :tela_cidade

    :cidade
        if "%visitou_cidade%" equ "1" (
            set local_atual=:tela_cidade
            goto :tela_cidade
        )
        cls
        set /a visitou_cidade=1
        ::desenho da cidade aqui
        echo.
        echo  Você chega à cidade, um local pacífico cercado por uma floresta densa e misteriosa. 
        echo  As ruas estão tranquilas até demais, devido aos desaparecimentos está tudo meio vazio. 
        echo  Os moradores que restaram parecem preocupados e evitam falar sobre o assunto, 
        echo  mas você pode sentir que algo sinistro está acontecendo.
        echo.
        echo                                                     (Pressione qualquer tecla para continuar)
        pause >nul
    goto :tela_cidade

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
        if %pos_y% geq 0 if %pos_y% leq 6 (
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

    echo !espacos!   !spr1!
    echo !espacos!   !spr2! 
    echo !espacos!   !spr3!
    echo !espacos!   !spr4!
    echo !espacos!   !spr5!

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
    set "spr1=!s1!"
    set "spr2=!s2!"
    set "spr3=!s3!"
    set "spr4=!s4!"
    set "spr5=!s5!"
    if %pos_x% LSS 51 set /a pos_x += 1
goto :tela_cidade

:mover_esquerda
    set "spr1=!sp1!"
    set "spr2=!sp2!"
    set "spr3=!sp3!" 
    set "spr4=!sp4!"
    set "spr5=!sp5!"
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

exit