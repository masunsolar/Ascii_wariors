@echo off
setlocal enabledelayedexpansion

for /F %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"

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
:: Dados
:: ========================================================================
:combat_engine
    set /a resultado_jogada=0
    set /a quantidade_dados=qd_jogador

    :while_dados
    if %quantidade_dados% gtr 0 (
        :: %random% gera de 0 a 32767. O %% d pega o resto da divisão.
        set /a dado=!random! %% d + 1
        set /a resultado_jogada+=dado
        set /a quantidade_dados-=1
        
        :: Volta para o teste do 'if' (isso cria o loop)
        goto while_dados
    )
    

:abertura
    cls
    color 0B

    for /l %%i in (1,1,8) do echo.

    echo                                                                  ;                           
    echo                 :                                                ED.                   :     
    echo                t#,          .,G:               .          :      E#Wi                 t#,    
    echo   j.          ;##W.        ,WtE#,    :        ;W          Ef     E###G.       t      ;##W.   
    echo   EW,        :#L:WE       i#D.E#t  .GE       f#E GEEEEEEELE#t    E#fD#W;      Ej    :#L:WE   
    echo   E##j      .KG  ,#D     f#f  E#t j#K;     .E#f  ,;;L#K;;.E#t    E#t t##L     E#,  .KG  ,#D  
    echo   E###D.    EE    ;#f  .D#i   E#GK#f      iWW;      t#E   E#t    E#t  .E#K,   E#t  EE    ;#f 
    echo   E#jG#W;  f#.     t#i:KW,    E##D.      L##Lffi    t#E   E#t fi E#t    j##f  E#t f#.     t#i
    echo   E#t t##f :#G     GK t#f     E##Wi     tLLG##L     t#E   E#t L#jE#t    :E#K: E#t :#G     GK 
    echo   E#t  :K#E:;#L   LW.  ;#G    E#jL#D:     ,W#i      t#E   E#t L#LE#t   t##L   E#t  ;#L   LW. 
    echo   E#KDDDD###it#f f#:    :KE.  E#t ,K#j   j#E.       t#E   E#tf#E:E#t .D#W;    E#t   t#f f#:  
    echo   E#f,t#Wi,,, f#D#;      .DW: E#t   jD .D#j         t#E   E###f  E#tiW#G.     E#t    f#D#;   
    echo   E#t  ;#W:    G#t         L#,j#t     ,WK,          t#E   E#K,   E#K##i       E#t     G#t    
    echo   DWi   ,KK:    t           jt ,;     EG.            fE   EL     E##D.        E#t      t     
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
goto tela_selecao_aberto


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
        set "newLine=     "
        for /l %%i in (1,1,17) do (
            set /a "r=!random! %% 15"
            if !r! equ 0 (set "newLine=!newLine!  * ") else (
                if !r! equ 1 (set "newLine=!newLine!  .  ") else (
                    set "newLine=!newLine!     "
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
        for /l %%l in (24,1,35) do echo.!L%%l!

        :: 5. CONTROLE DE VELOCIDADE
        pathping -n -q 1 -p 500 localhost >nul

    goto snow_loop

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
    echo    [1] Tulio - O Mago             [2] Sara - A Guerreira         [3] Soso - A Ladina
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
    echo    [1] Tulio - O Mago             [2] Sara - A Guerreira         [3] Soso - A Ladina
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

    ::Itens::
    set /a pocao_hp=1
    set /a pocao_mana=1
    set /a ouro=50

    ::Dado::
    set /a qd_jogador=atk_mago
    set /a d=dano_mago

    ::Slots de Inventário::
    set slot[6]

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

    ::Itens::
    set /a pocao_hp=0
    set /a pocao_mana=0
    set /a ouro=50

    ::Dado::
    set /a qd_jogador=atk_gue
    set /a d=dano_gue

    ::Slots de Inventário::
    set slot[9]

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

    ::Itens::
    set /a pocao_hp=0
    set /a pocao_mana=0
    set /a ouro=100

    ::Dado::
    set /a qd_jogador=atk_ocul
    set /a d=dano_ocul

    ::Slots de Inventário::
    set slot[12]

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
    set "s1=   /\      "
    set "s2= _/__\_┏┓  "
    set "s3= ( o.o)┃   "
    set "s4= /(__)/┃   "
    set "s5=  /  \ ┃   "
    goto :confirmacao

:sprite_sara
    set "s1=  _/\_  ┳━┓"
    set "s2= ( o¬o)┣┃━┛ "
    set "s3= /^|__^|\_┃ "
    set "s4=  [__]  ┃  "
    set "s5=  /  \     "
    goto :confirmacao

:sprite_soso
    set "s1=      .     "
    set "s2=     /_\   "
    set "s3=    (¬_¬)    "
    set "s4= ━┫╸━}_{━╺┣━"
    set "s5=    _/ \_    "
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

    goto capitulo_um


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
            set "newLine=     "
            for /l %%i in (1,1,17) do (
                set /a "r=!random! %% 15"
                if !r! equ 0 (set "newLine=!newLine!  * ") else (
                    if !r! equ 1 (set "newLine=!newLine!  .  ") else (
                        set "newLine=!newLine!     "
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

        goto neve_prologo_loop


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
        goto cena_vila_frame1

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
            echo   \  \ /_   _\ \  /  \      /     \ /\  /\\ /  /_ _\ \   /\\ /  \ /_    /_    _\ /  \/
            echo    \   /     \  \/    \    /_     _\  \/  ┃/   /   \ _\ /  \/_  _\/     /      \/   /_
            echo     \ /_     _\ /_    _\/\ /       \  /_ / \  /     \ \/_  _\    \  /\ /        \   /
            echo     _\ /\     \ /      \  /  /\     \ / /   \/_     _\ /    \     \/  \         _\ /
            echo     \ /  \    _\       _\/_ /  \    _\ /     \       \/_    _\    /_  _\         \/_
            echo  ____/    \    \        \/ /_  _\    \/_     _\_______/      \____/    \          /
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
            pathping -n -q 1 -p 100 localhost >nul
            goto frame_b

        :frame_b
            if not exist "%temp%\sinal_portal.tmp" exit
            cls
            echo     *   *                  .          ┃       .           *              +             . /
            echo   `  /┃   ´   +    *    /\       *   / \         +     /\      +         .         +    / 
            echo  `  ┃ ┃ - ┃´   .       /  \ .  ┃    /   \   *         /__\  /\    +  /\    /\    *   + /_
            echo  ,/\ \┃  / \     *    /    \  / \  /     \     . ┃/\  /  \ /__\ *   /  \ */  \     +   /
            echo  /  \   /   \/\    /\/      \/   \/      _\* /\ / \ \/    \   /\ /\/    \/    \  */\* /
            echo   \  \ /_   _\ \  /  \      /     \ /\  /\\ /  /_ _\ \   /\\ /  \ /_    /_    _\ /  \/
            echo    \   /     \  \/    \    /_     _\  \/  ┃/   /   \ _\ /  \/_  _\/     /      \/   /_
            echo     \ /_     _\ /_    _\/\ /       \  /_ / \  /     \ \/_  _\    \  /\ /        \   /
            echo     _\ /\     \ /      \  /  /\     \ / /   \/_     _\ /    \     \/  \         _\ /
            echo     \ /  \    _\       _\/_ /  \    _\ /     \       \/_    _\    /_  _\         \/_
            echo  ____/    \    \        \/ /_  _\    \/_     _\_______/      \____/    \          /
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
            pathping -n -q 1 -p 100 localhost >nul
            goto frame_c

        :frame_c
            if not exist "%temp%\sinal_portal.tmp" exit
            cls
            echo     *   *                  .          ┃       .           +              *             . /
            echo   `  /┃   ´   *    *    /\       *   / \         *     /\      *         .         *    / 
            echo  `  ┃ ┃ - ┃´   .       /  \ .  ┃    /   \   +         /__\  /\    *  /\    /\    *   * /_
            echo  ,/\ \┃  / \     +    /    \  / \  /     \     . ┃/\  /  \ /__\ +   /  \ */  \     +   /
            echo  /  \   /   \/\    /\/      \/   \/      _\+ /\ / \ \/    \   /\ /\/    \/    \  +/\+ /
            echo   \  \ /_   _\ \  /  \      /     \ /\  /\\ /  /_ _\ \   /\\ /  \ /_    /_    _\ /  \/
            echo    \   /     \  \/    \    /_     _\  \/  ┃/   /   \ _\ /  \/_  _\/     /      \/   /_
            echo     \ /_     _\ /_    _\/\ /       \  /_ / \  /     \ \/_  _\    \  /\ /        \   /
            echo     _\ /\     \ /      \  /  /\     \ / /   \/_     _\ /    \     \/  \         _\ /
            echo     \ /  \    _\       _\/_ /  \    _\ /     \       \/_    _\    /_  _\         \/_
            echo  ____/    \    \        \/ /_  _\    \/_     _\_______/      \____/    \          /
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
            pathping -n -q 1 -p 100 localhost >nul
            goto frame_d

        :frame_d
            if not exist "%temp%\sinal_portal.tmp" exit
            cls
            echo     *   *                  .          ┃       .           *              +             . /
            echo   `  /┃   ´   +    *    /\       *   / \         +     /\      +                   *    / 
            echo  `  ┃ ┃ - ┃´           /  \    ┃    /   \   *         /__\  /\    +  /\    /\    +   * /_
            echo  ,/\ \┃  / \     +    /    \  / \  /     \       ┃/\  /  \ /__\ *   /  \ */  \     +   /
            echo  /  \   /   \/\    /\/      \/   \/      _\+ /\ / \ \/    \   /\ /\/    \/    \  +/\* /
            echo   \  \ /_   _\ \  /  \      /     \ /\  /\\ /  /_ _\ \   /\\ /  \ /_    /_    _\ /  \/
            echo    \   /     \  \/    \    /_     _\  \/  ┃/   /   \ _\ /  \/_  _\/     /      \/   /_
            echo     \ /_     _\ /_    _\/\ /       \  /_ / \  /     \ \/_  _\    \  /\ /        \   /
            echo     _\ /\     \ /      \  /  /\     \ / /   \/_     _\ /    \     \/  \         _\ /
            echo     \ /  \    _\       _\/_ /  \    _\ /     \       \/_    _\    /_  _\         \/_
            echo  ____/    \    \        \/ /_  _\    \/_     _\_______/      \____/    \          /
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
            pathping -n -q 1 -p 100 localhost >nul
            goto frame_a

    :: ================================================================================================================
    :: CENA: O DESAPARECIMENTO E O BANQUETE MACABRO
    :: ================================================================================================================

    :: Inicializa o contador de ciclos da animacao
    set /a contador_cena=0

    :cena_vila_frame1
        cls
        echo.
        echo   _       /UUUUUUUUUU\    ___________     /UUUUUUUUUU\  __________    ____/UUUUUUUUUU\     ___
        echo   u\   //UUUUUUUUUUUUUU\ /uuuuuuuuuuu\  /UUUUUUUUUUUUUU\uuuuuuu /\  /uuu/UUUUUUUUUUUUUU\\ /uuu
        echo   ┃ /\// ┃  ______    ┃  ┃┃  _  /\  ┃    ┃  ___  ____ ┃ ┃ ___ _/  \  ┃┃  ┃ ____ _____ ┃ \\ ┃ ┃
        echo   ┃/  \ ┃┃  ┃ \o/┃    ┃  ┃┃ ┃_┃/__\ ┃    ┃ ┃___┃ ┃  ┃ ┃ ┃ ┃_┃ ┃/__\  ┃┃  ┃ ┃  ┃ ┃ ┃ ┃ ┃┃   ┃ ┃
        echo  _┃/__\_┃┃  ┃__┃_┃    ┃__\┃_____┃┃__┃____┃       ┃  ┃ ┃_┃_____┃┃┃┃___\┃__┃ ┃  ┃ ┃_┃_┃ ┃┃___\_┃
        echo  ___┃┃__\┃____________┃_________┃┃_______┃_______┃__┃_┃_________┃┃_______┃_┃__┃_______┃/______
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
        echo   _       /UUUUUUUUUU\    ___________     /UUUUUUUUUU\  __________    ____/UUUUUUUUUU\     ___
        echo   u\   //UUUUUUUUUUUUUU\ /uuuuuuuuuuu\  /UUUUUUUUUUUUUU\uuuuuuu /\  /uuu/UUUUUUUUUUUUUU\\ /uuu
        echo   ┃ /\// ┃  ______    ┃  ┃┃  _  /\  ┃    ┃  ___  ____ ┃ ┃ ___ _/  \  ┃┃  ┃ ____ _____ ┃ \\ ┃ ┃
        echo   ┃/  \ ┃┃  ┃ \o/┃    ┃  ┃┃ ┃_┃/__\ ┃    ┃ ┃___┃ ┃  ┃ ┃ ┃ ┃_┃ ┃/__\  ┃┃  ┃ ┃  ┃ ┃ ┃ ┃ ┃┃   ┃ ┃
        echo  _┃/__\_┃┃  ┃__┃_┃    ┃__\┃_____┃┃__┃____┃       ┃  ┃ ┃_┃_____┃┃┃┃___\┃__┃ ┃  ┃ ┃_┃_┃ ┃┃___\_┃
        echo  ___┃┃__\┃____________┃_________┃┃_______┃_______┃__┃_┃_________┃┃_______┃_┃__┃_______┃/______
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
        echo   _       /UUUUUUUUUU\    ___________     /UUUUUUUUUU\  __________    ____/UUUUUUUUUU\     ___
        echo   u\   //UUUUUUUUUUUUUU\ /uuuuuuuuuuu\  /UUUUUUUUUUUUUU\uuuuuuu /\  /uuu/UUUUUUUUUUUUUU\\ /uuu
        echo   ┃ /\// ┃  ______    ┃  ┃┃  _  /\  ┃    ┃  ___  ____ ┃ ┃ ___ _/  \  ┃┃  ┃ ____ _____ ┃ \\ ┃ ┃
        echo   ┃/  \ ┃┃  ┃ \o/┃    ┃  ┃┃ ┃_┃/__\ ┃    ┃ ┃___┃ ┃  ┃ ┃ ┃ ┃_┃ ┃/__\  ┃┃  ┃ ┃  ┃ ┃ ┃ ┃ ┃┃   ┃ ┃
        echo  _┃/__\_┃┃  ┃__┃_┃    ┃__\┃_____┃┃__┃____┃       ┃  ┃ ┃_┃_____┃┃┃┃___\┃__┃ ┃  ┃ ┃_┃_┃ ┃┃___\_┃
        echo  ___┃┃__\┃____________┃_________┃┃_______┃_______┃__┃_┃_________┃┃_______┃_┃__┃_______┃/______
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
        if %contador_cena% lss 25 (
            goto cena_vila_frame1
        ) else (
            goto cena_vila_temp1
        )

    :cena_vila_temp1
        cls
        echo.
        echo   _       /UUUUUUUUUU\    ___________     /UUUUUUUUUU\  __________    ____/UUUUUUUUUU\     ___
        echo   u\   //UUUUUUUUUUUUUU\ /uuuuuuuuuuu\  /UUUUUUUUUUUUUU\uuuuuuu /\  /uuu/UUUUUUUUUUUUUU\\ /uuu
        echo   ┃ /\// ┃  ______    ┃  ┃┃  _  /\  ┃    ┃  ___  ____ ┃ ┃ ___ _/  \  ┃┃  ┃ ____ _____ ┃ \\ ┃ ┃
        echo   ┃/  \ ┃┃  ┃ \*/┃    ┃  ┃┃ ┃_┃/__\ ┃    ┃ ┃___┃ ┃  ┃ ┃ ┃ ┃_┃ ┃/__\  ┃┃  ┃ ┃  ┃ ┃ ┃ ┃ ┃┃   ┃ ┃
        echo  _┃/__\_┃┃  ┃__┃_┃    ┃__\┃_____┃┃__┃____┃       ┃  ┃ ┃_┃_____┃┃┃┃___\┃__┃ ┃  ┃ ┃_┃_┃ ┃┃___\_┃
        echo  ___┃┃__\┃____________┃_________┃┃_______┃_______┃__┃_┃_________┃┃_______┃_┃__┃_______┃/______
        echo                          !             \o/       \┃/
        echo           \┃/           \o/             ┃                         !        \┃/              
        echo                  !       ┃             / \          !            \o/    \┃/          !      
        echo                 \o/     / \                        \o/            ┃                 \o/     
        echo      \┃/         ┃                                  ┃            / \                 ┃       
        echo                 / \                \┃/             / \                      \┃/     / \      
        echo.
        echo  =============================================================================================
        echo.
        echo                [ O vento começa a soprar as primeiras fagulhas de gelo... ]  
        pathping -n -q 1 -p 300 localhost >nul
        goto banquete_macabro

    :banquete_macabro
        cls
        echo.
        echo  ==============================================================================================
        echo                     (  )   (  )                            (  )   (  )
        echo                      )(     )(                              )(     )(
        echo                     (  )   (  )                            (  )   (  )
        echo                     _┃┃_   _┃┃_                            _┃┃_   _┃┃_
        echo                    ┃____┃ ┃____┃                          ┃____┃ ┃____┃
        echo   .......__________┃    ┃_┃    ┃__________......__________┃    ┃_┃    ┃__________.......
        echo         /          ┃    ┃ ┃    ┃          \    /          ┃    ┃ ┃    ┃          \
        echo        /           ┃    ┃ ┃    ┃      o    \  /  o     o  ┃    ┃ ┃    ┃           \
        echo       /            ┃____┃ ┃____┃     ┃┃┃    \/  /┃\   ┃┃┃ ┃____┃ ┃____┃            \
        echo      /                               / \        / \   / \                           \
        echo   __/________________________________________________________________________________\__
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
        echo   Pressione qualquer tecla para prosseguir para o confronto...
        pause >nul



exit