@echo off
setlocal enabledelayedexpansion

:: 0. THREAD DE ANIMAÇÃO
:: Esta diretriz captura a inicialização da linha secundária e a redireciona.
if "%~1" == "motor_neve" goto :snow_loop_thread
if "%~1" == "motor_prologo" goto :neve_prologo_thread

:: 1. VERIFICACAO DE AMBIENTE (Obrigatorio para redimensionamento no Windows moderno)
if "%~1" neq "motor_classico" (
    start "" conhost.exe cmd.exe /c "%~f0" motor_classico
    exit
)

title Adventure time
chcp 65001 >nul
mode con: cols=94 lines=35
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
for /l %%i in (1,1,35) do set "L%%i=          "

:snow_loop
:: O ciclo verifica a integridade do sinal vital. Se destruído, a animação cessa.
if not exist "%temp%\sinal_neve.tmp" exit

cls
echo.
echo.

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
echo      ▄████▄ ▄▄▄▄   ▄▄ ▄▄ ▄▄▄▄▄ ▄▄  ▄▄ ▄▄▄▄▄▄ ▄▄ ▄▄ ▄▄▄▄  ▄▄▄▄▄   ██████ ▄▄ ▄▄   ▄▄ ▄▄▄▄▄ 
echo      ██▄▄██ ██▀██  ██▄██ ██▄▄  ███▄██   ██   ██ ██ ██▄█▄ ██▄▄      ██   ██ ██▀▄▀██ ██▄▄  
echo      ██  ██ ████▀   ▀█▀  ██▄▄▄ ██ ▀██   ██   ▀███▀ ██ ██ ██▄▄▄     ██   ██ ██   ██ ██▄▄▄ 
echo.
echo =============================================================================================
echo.
echo.
echo                                    Press any key to start...

:: 4. RENDERIZAÇÃO DA PARTE INFERIOR (Linhas 24 a 35)
for /l %%l in (24,1,35) do echo.!L%%l!

:: 5. CONTROLE DE VELOCIDADE
pathping -n -q 1 -p 500 localhost >nul

goto snow_loop

:: ========================================================================
:: CONTINUAÇÃO DO PROGRAMA
:: ========================================================================

:tela_selecao_aberto
cls
echo =============================================================================================
echo.
echo 	     ┏━╸┏━┓┏━╸┏━┓╻  ╻ ╻┏━┓   ┏━┓┏━╸╻ ╻   ┏━┓┏━╸┏━┓┏━┓┏━┓┏┓╻┏━┓┏━╸┏━╸┏┳┓
echo 	     ┣╸ ┗━┓┃  ┃ ┃┃  ┣━┫┣━┫   ┗━┓┣╸ ┃ ┃   ┣━┛┣╸ ┣┳┛┗━┓┃ ┃┃┗┫┣━┫┃╺┓┣╸ ┃┃┃
echo 	     ┗━╸┗━┛┗━╸┗━┛┗━╸╹ ╹╹ ╹   ┗━┛┗━╸┗━┛   ╹  ┗━╸╹┗╸┗━┛┗━┛╹ ╹╹ ╹┗━┛┗━╸╹ ╹
echo.
echo =============================================================================================
echo.
echo            /\                              _/\_  ┳━┓                          
echo          _/__\_┏┓                         ( o_o)┣┃━┛                      .=.
echo          ( o.o)┃                          /^|__^|\_┃                       (º_º)
echo          /(__)/┃                           [__]  ┃                    ━┫╸━(_)━╺┣━
echo           /  \ ┃                           /  \                          _/ \_ 
echo.
echo    [1] Tulio - O Mago             [2] Sara - A Guerreira         [3] Soso - A Ladina
echo.
echo =============================================================================================
echo.
echo  Atributos Base em Memoria:
echo  [1] Alta Forca Magica (HP: 10 ^| Forca: 5)
echo  [2] Combate Corpo-a-Corpo (HP: 25 ^| Forca: 25)
echo  [3] Evasao e Artes das Trevas (HP: 10 ^| Forca: 10)
echo.

:: Aguarda 2 segundos. Se nada for digitado, aciona a opcao '0' (piscar)
choice /c 1230 /n /t 2 /d 0 /m " Pressione o digito correspondente: "

:: A LINHA ABAIXO FOI RESTAURADA PARA GARANTIR O CICLO
if errorlevel 4 goto :tela_selecao_fechado
if errorlevel 3 goto :set_soso
if errorlevel 2 goto :set_sara
if errorlevel 1 goto :set_tulio

:tela_selecao_fechado
cls
echo =============================================================================================
echo.
echo 	     ┏━╸┏━┓┏━╸┏━┓╻  ╻ ╻┏━┓   ┏━┓┏━╸╻ ╻   ┏━┓┏━╸┏━┓┏━┓┏━┓┏┓╻┏━┓┏━╸┏━╸┏┳┓
echo 	     ┣╸ ┗━┓┃  ┃ ┃┃  ┣━┫┣━┫   ┗━┓┣╸ ┃ ┃   ┣━┛┣╸ ┣┳┛┗━┓┃ ┃┃┗┫┣━┫┃╺┓┣╸ ┃┃┃
echo 	     ┗━╸┗━┛┗━╸┗━┛┗━╸╹ ╹╹ ╹   ┗━┛┗━╸┗━┛   ╹  ┗━╸╹┗╸┗━┛┗━┛╹ ╹╹ ╹┗━┛┗━╸╹ ╹
echo.
echo =============================================================================================
echo.
echo            /\                              _/\_  ┳━┓                          
echo          _/__\_┏┓                         ( -_-)┣┃━┛                      .=.
echo          ( -.-)┃                          /^|__^|\_┃                       (=_=)
echo          /(__)/┃                           [__]  ┃                    ━┫╸━(_)━╺┣━
echo           /  \ ┃                           /  \                          _/ \_ 
echo.
echo    [1] Tulio - O Mago             [2] Sara - A Guerreira         [3] Soso - A Ladina
echo.
echo =============================================================================================
echo.
echo  Atributos Base em Memoria:
echo  [1] Alta Forca Magica (HP: 10 ^| Forca: 5)
echo  [2] Combate Corpo-a-Corpo (HP: 25 ^| Forca: 25)
echo  [3] Evasao e Artes das Trevas (HP: 10 ^| Forca: 10)
echo.

:: Aguarda 1 segundo. Se nada for digitado, aciona a opcao '0' (abrir olhos)
choice /c 1230 /n /t 1 /d 0 /m " Pressione o digito correspondente: "

:: A LINHA ABAIXO FOI RESTAURADA PARA GARANTIR O CICLO
if errorlevel 4 goto :tela_selecao_aberto
if errorlevel 3 goto :set_soso
if errorlevel 2 goto :set_sara
if errorlevel 1 goto :set_tulio

:: ==========================================
:: ALOCACAO DE ATRIBUTOS (INICIALIZACAO)
:: ==========================================
:set_tulio
set "nome_personagem=Tulio"
set "classe_personagem=O Mago"
set /a hp_jogador=10
set /a forca_jogador=5
set /a agil_jogador=15
set /a def_jogador=15
set /a mana_jogador=30
goto :confirmacao

:set_sara
set "nome_personagem=Sara"
set "classe_personagem=A Guerreira"
set /a hp_jogador=25
set /a forca_jogador=25
set /a agil_jogador=10
set /a def_jogador=15
set /a mana_jogador=0
goto :confirmacao

:set_soso
set "nome_personagem=Soso"
set "classe_personagem=A Ocultista"
set /a hp_jogador=12
set /a forca_jogador=10
set /a agil_jogador=28
set /a def_jogador=15
set /a mana_jogador=10
goto :confirmacao

:: ==========================================
:: TELA DE VALIDACAO FINAL
:: ==========================================
:confirmacao
cls
echo.
echo ┏━┓┏━╸┏━┓┏━┓┏━┓┏┓╻┏━┓┏━╸┏━╸┏┳┓   ┏━╸┏━┓┏━╸┏━┓╻  ╻ ╻╻╺┳┓┏━┓ 
echo ┣━┛┣╸ ┣┳┛┗━┓┃ ┃┃┗┫┣━┫┃╺┓┣╸ ┃┃┃   ┣╸ ┗━┓┃  ┃ ┃┃  ┣━┫┃ ┃┃┃ ┃╹
echo ╹  ┗━╸╹┗╸┗━┛┗━┛╹ ╹╹ ╹┗━┛┗━╸╹ ╹   ┗━╸┗━┛┗━╸┗━┛┗━╸╹ ╹╹╺┻┛┗━┛╹
echo.
:: Integracao das duas variaveis para criar o titulo completo
echo  Entidade selecionada: %nome_personagem% - %classe_personagem%
echo  Carga de Atributos: %hp_jogador% HP ^| %forca_jogador% FOR
echo.
echo  Os parametros estao corretos?
echo  [Y] Confirmar Insercao    [N] Retornar a Selecao
echo.

choice /c YN /n /m " Pressione a tecla correspondente: "

:: O ROTULO DE DESTINO FOI CORRIGIDO
if errorlevel 2 goto :tela_selecao_aberto
if errorlevel 1 goto :prologo

:: ================================================================================================================
:: INICIO - PRÓLOGO
:: ================================================================================================================

:prologo
cls
color 0A
echo =============================================================================================
echo  Dados gravados na memoria com sucesso. 
echo  Preparando a transferencia para a arena de combate...
echo =============================================================================================
pause > nul

:: Criar o arquivo de sinalização específico para a neve do prólogo
echo executando > "%temp%\sinal_prologo.tmp"

:: Iniciar a renderização do cenário em segundo plano
start /b "" cmd.exe /c "%~f0" motor_prologo

:: A linha primária pausa aqui, permitindo que o usuário leia a narrativa em seu próprio tempo
pause > nul

:: Ao toque de uma tecla, o sinal é destruído e a thread secundária é encerrada
del "%temp%\sinal_prologo.tmp" >nul 2>nul

:: Breve pausa de estabilização
ping -n 2 127.0.0.1 >nul

goto capitulo_um


:: ================================================================================================================
:: MOTOR SECUNDÁRIO - RENDERIZAÇÃO DO PRÓLOGO
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

:: 2. DESLOCAMENTO (Calibrado para 11 linhas)
for /l %%i in (15,-1,2) do (
    set /a "prev=%%i-1"
    for %%p in (!prev!) do set "L%%i=!L%%p!"
)
set "L1=!newLine!"

:: 3. RENDERIZAÇÃO DO CÉU (15 linhas)
for /l %%l in (1,1,15) do echo.!L%%l!

:: 4. RENDERIZAÇÃO DA PAISAGEM (15 linhas totais)
echo                                                      /\
echo                                    /\               /  \
echo                                   /  \      /\     /\ /V\                    /\
echo                    /\            /____\    /  \   /  V   \    /\            /  \
echo                   /  \   /\               /____\ /        \  /  \/\        /____\
echo     /\           /____\ /  \                    /          \/___/WV\
echo    /  \                /    \            /\    /            \  /    \
echo   /    \              /______\          /VV\  /              \/      \               /\
echo  /     .-~-**-~-.                      /    \/                \       \             /  \
echo / ,,-~´           `~-,,        ,.-~-**-~-.,,/                  \       \    .-~****~-.  \
echo  ´                     ``~_-~´´             `~-.__              \    _.-~´´            ``~-.__
echo                  ..-~-==-~-..                                    \..-~-==-~-..
echo           _..-~´´            ``~-.._      _.~~~~._        _..-~´´              ``~-.._
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:: 5. RENDERIZAÇÃO DA NARRATIVA (7 linhas totais entre texto e espaços)
echo.
echo      O inverno chegou como uma sentenca de morte, cobrindo o reino com um manto de neve
echo      implacavel e isolando os poucos vilarejos que ousam resistir a sua furia glacial.
echo.
echo                                                     (Pressione qualquer tecla para continuar)

:: 6. CONTROLE DE VELOCIDADE
pathping -n -q 1 -p 300 localhost >nul

goto neve_prologo_loop


:: ================================================================================================================
:: PRIMEIRO ATO
:: ================================================================================================================
:capitulo_um
cls
color 0F
echo.
echo  A jornada na Floresta Sombria se inicia...
pause > nul
exit