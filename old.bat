set ouro=50
set pocao=0
set armamento=0
set escudo=0
set armadura=0

:Taverna
cls
echo ====================================
echo          BEM-VINDO A TAVERNA
echo ====================================
echo 1. Ver Inventario
echo 2. Explorar (Achar uma pocao)
echo 3. Comprar Espada (Custa 30 de Ouro)
echo 4. Sair do Jogo
echo ====================================
set /p acao="O que voce quer fazer? "

if "%acao%"=="1" goto inventario
if "%acao%"=="2" goto achar_pocao
if "%acao%"=="3" goto comprar_espada
if "%acao%"=="4" goto descansar
if "%acao%"=="5" exit
goto menu_principal

:: --- FUNÇÃO DE INVENTÁRIO ---
:inventario
    cls
    echo ====================================
    echo             SEU INVENTARIO
    echo ====================================
    echo Ouro: %ouro% moedas
    echo Pocoes de Vida: %pocao%
    echo.
    :: Verifica se o jogador tem a espada
    if %espada%==1 (
        echo Equipamento: Espada de Ferro
    ) else (
        echo Equipamento: Maos vazias
    )
    echo ====================================
pause
goto menu_principal

:: --- EVENTOS QUE ALTERAM O INVENTÁRIO ---
:achar_pocao
    cls
    echo Voce explorou os arredores e encontrou uma Pocao de Vida!
    :: O comando 'set /a' serve para fazer contas matematicas
    set /a pocao=%pocao% + 1
pause
goto menu_principal

:comprar_espada
    cls
    :: Checa se ja tem a espada
    if %espada%==1 (
        echo Voce ja possui uma espada! Nao precisa de outra.
        pause
        goto menu_principal
    )

    :: Checa se tem ouro suficiente (GEQ significa Greater or EQual - Maior ou Igual)
    if %ouro% GEQ 30 (
        set /a ouro=%ouro% - 30
        set espada=1
        echo Voce comprou a Espada de Ferro por 30 moedas de ouro!
    ) else (
        echo Voce nao tem ouro suficiente... Pobre.
    )
pause

:descansar
    cls
    echo Voce decide descansar e recuperar suas energias...
    echo.
    hp_jogador=max_hp
    mana_jogador=max_mana
    echo Voce se sente revigorado e pronto para novas aventuras!
pause
goto menu_principal