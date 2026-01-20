The user manual is in Brazilian Portuguese for when you need to translate it.


1 PREPARANDO VIA WEB
========================

1- CRIAR UM BUCKET
   Google Cloud > Cloud Storage > Buckets > Criar Bucket
   Escolha: 
     - Nome; 
     - Região do servidor; 
     - Escolha o pacote: define valor a se pagar no final do mês;
     - Escolha se o servidor será público ou não (MARQUE A CAIXINHA "Aplicar a prevenção do acesso público neste bucket")
     - Proteger os dados do objeto: Recomendável marcar "Política de exclusão reversível (para recuperação de dados)" para Soft Delete

2- CRIAR UMA CONTA IAM E ADMIN
   IAM e admin > Contas de serviço > Criar conta de serviço
   Escolha:
     - Nome da conta;
     - Permissões: selecione o papel "Administrador de armazenamento" (pesquisa na barra);
     - Finaliza

3- CRIAR A CHAVE DE ACESSO DO GOOGLE CLOUD
   Volte para a página IAM e admin > Contas de serviço
     - Clique em "Ações" nos 3 potinhos da conta desejada
     - Clique em "Gerenciar Chaves > Adicionar chave > Criar nova chave"
     - Selecione "JSON" e clique em criar
     - Baixe a chave em alguma pasta da máquina
   OBS: essa chave serve como acesso único com permissão para modificar o Bucket. Guarde ela no computador que irá executar o comando. Essa chave pode ser renomeada e salva em qualquer pasta (o diretório onde a chave vai estar, não pode conter ACENTO em nenhuma das palavras. Exemplo: "C:\Users\Laboratório\Downloads\chave.json")

========================
2 PREPARANDO A MÁQUINA
========================

4- INSTALAR NO GOOGLE CLOUD CLI
     - Acesse: https://docs.cloud.google.com/sdk/docs/install-sdk?hl=pt-br
     - Baixe o instalador do Google Cloud CLI e execute
     - Selecione "All Users"
     - Em "Destination Folder", anote o caminho onde você irá instalar o Cloud SDK, vai precisar no Passo 6
     OBS: não instale o Google Cloud CLI em um diretório COM ACENTO para evitar retrabalho. O executável não aceita buscar em nenhuma pasta raíz dos comandos que tenha ascento.
   - Selecione "Next" até o final e finaliza

===========================
3 EDITANDO O EXECUTÁVEL
===========================

5- EDITAR PATHING DO EXECUTÁVEL
     - Baixe o executável "backup-winlocal-script-v4.bat"
     - Clique com o botão direito nele e em "Editar"
   Verifique que após o cabeçalho, nos primeiros comandos, você terá que editar algumas informações simples como Nome do Bucket, local da pasta alvo da qual você quer fazer backup e outros (Segue abaixo quais informações são). EDITE E NÃO FECHE O EXECUTÁVEL.

      > SET KEY_FILE={C:\Pasta\chave.json}
      > SET BUCKET_NAME={nome-do-bucket}
      > SET SOURCE_FOLDER={C:\Pasta\Pasta-Alvo-Para-Backup}
      > SET DESTINATION_PATH={Nome da Pasta que irá criar no Google Cloud}

OBS: não esqueça de remover os colchetes

6- ACHANDO O GOOGLE CLOUD CLI
    - Abra o CMD em Modo Administrador
    - Digite "where gcloud" e dá enter
    - Copie o caminho até a pasta antes do arquivo final e cole no "GCLOUD_PATH", como tá escrito dentro dos colchetes

     > SET GCLOUD_PATH={C:\Program Files (x86)\Google\Cloud SDK\google-cloud-sdk\bin}

    - Nessa mesma pasta, você irá encontrar também o arquivo Python para editar no executável em "...\google-cloud-sdk\plataform\bundlepython\python.exe" como segue no exemplo abaixo (retire os colchetes sempre):

     > SET CLOUDSDK_PYTHON={C:\Program Files (x86)\Google\Cloud SDK\google-cloud-sdk\platform\bundledpython\python.exe}

OBS: tudo que está dentro das colchetes edite e remova os colchetes

===============================
4 TESTE DE PUSH MANUAL 
===============================

1- PROCURANDO ALGUMAS INFORMAÇÕES
   - Primeiramente abra o CMD em modo administrador, você colocará os comandos abaixo em sequência (1 por vez)
   - Lembra dos caminhos que fomos Editando no executável? Serão utilizados aqui também. Vou marcar os passos onde estão cada um para que fique mais fácil de procurar, se você fez os passos anteriores certinho, esse primeiro Backup irá dar certo.
   - Não altere nada do primeiro comando, apenas digite no CMD:

     > set CLOUDSDK_CONFIG=C:\config-gcloud-lls\.gcloud

   - No passo 6 você usou o "where gcloud" no CMD e achou o caminho de instalação do Google Cloud SDK, cole no comando abaixo no local dentro dos colchetes. Remova os colchetes e dá enter no CMD:

     > set PATH={C:\Program Files (x86)\Google\Cloud SDK\google-cloud-sdk\bin};%PATH%

   - No passo 3, você criou uma chave de autenticação .JSON e baixou no seu computador. Substitua no comando abaixo o caminho de onde está este arquivo e remova os colchetes.

     > gcloud auth activate-service-account --key-file="{C:\Pasta\chave.json}"

   - No passo 5 você definiu o caminho na sua máquina da Pasta-Alvo-Para-Backup, Nome-Do-Bucket e Nome da Pasta que irá criar no Google Cloud, copie essas informações, cole no comando abaixo, RETIRE OS COLCHETES e dá enter no CMD

     > gsutil -m rsync -r -d "{C:\Pasta\Pasta-Alvo-Para-Backup}" "gs://{nome-do-bucket}/{Nome da Pasta que irá criar no Google Cloud}"

   - Após os comandos, você executou um Backup Manual dos arquivos para teste! Você pode verificar os arquivos de duas formas:
     1. Acessando o site do Google Cloud, entre no seu Bucket e Atualize a página para verificar os arquivos lá
     2. Digitando no CMD "gcloud ls gs://{nome-do-bucket}/{Nome da Pasta que irá criar no Google Cloud}" para que ele liste todos os arquivos dentro do Bucket

===============================
5 TESTE DE PUSH COM EXECUTÁVEL 
===============================

1- TERMINOU DE EDITAR TODAS AS INFORMAÇÕES DO EXECUTÁVEL
   - Salve as alterações e feche o arquivo
   - Execute em Modo Administrador
   Como saber de funcionou?
     - Ele gera na mesma pasta que está o executável, um arquivo de "backup_log" que mostra se funcionou. Se o arquivo de log parar na autenticação de conta ou na seleção de caminho, o problema está no passo 5, verifique se está sem Ascento no diretório, verifique se está sem colchetes...
     - Caso o "backup_log" mostre os arquivos sendo Upados com as porcentagens, está funcionando. Segue o exemplo abaixo:
"
- [1/14 files][ 48.8 KiB/ 48.8 KiB]  99% Done                                   
- [2/14 files][ 48.8 KiB/ 48.8 KiB]  99% Done                                   
- [3/14 files][ 48.8 KiB/ 48.8 KiB]  99% Done                                   
- [4/14 files][ 48.8 KiB/ 48.8 KiB]  99% Done                                   
- [5/14 files][ 48.8 KiB/ 48.8 KiB]  99% Done                                   
- [6/14 files][ 48.8 KiB/ 48.8 KiB]  99% Done                                   
- [7/14 files][ 48.8 KiB/ 48.8 KiB]  99% Done   
"
2- TUDO CERTO? PODE PROSSEGUIR PARA O BACKUP AUTOMÁTICO CASO NÃO QUEIRA FICAR FAZENDO MANUALMENTE

==============================================
6 CONFIGURANDO PARA EXECUTAR AUTOMATICAMENTE 
==============================================

1- RETIRANDO CAIXA DE DIÁLOGO COM PERMISSÃO DE ADMINISTRADOR

   * Win+R > secpol.msc > Políticas Locais > Opções de segurança > Controle de Conta de Usuário: executar todos os adminitradores no Modo de Aprovação de Administrador > Desabilitada

   Isso irá fazer com que a caixa de diálogo pedindo permissão de administrador não apareça em Usuários que já são administradores. Sem fazer este passo, toda vez que for executar automaticamente, irá aparecer na tela "Deseja permitir que este aplicativo faça alterações no seu dispositivo?" portanto, vai deixar de ser automático e você precisará clicar nessa caixa de diálogo. Faça este passo para prosseguir

2- AGENDANDO A TAREFA PARA O WINDOWS EXECUTAR AUTOMATICAMENTE

   * Win+R > taskschd.msc > Criar tarefa...

   1. Na aba GERAL:
     - Dê um nome qualquer como "Backup Diário 1"
     - Selecione a opção "Executar estando o usuário conectado ou não"
     - Marque a checkbox "Executar com privilégios mais altos"
   2. Na aba DISPARADORES:
     - Clique em "Novo"
     - Selecione "Em um agendamento"
     - Selecione "Diário" e modifque o relógio para definir em qual horário você quer que faça o backup (você pode definir um intervalo de tempo maior ou criar mais agendamentos para que faça backup mais de uma vez no dia)
     - Marque a checkbox "Habilitado"
     - Dê "OK"
   3. Na aba AÇÕES:
     - Clique em "Novo"
     - Selecione "Iniciar um programa"
     - Em "Programa/script:" escreva "cmd.exe" (retire as aspas, deixe só o cmd.exe)
     - Em "Adicione argumentos (opcional):" coloque:

          /c "{Caminho-de-onde-está-o-arquivo-executável-e-nome-do-arquivo-executável}"

     Exemplo: /c "C:\Users\Laboratório\Downloads\backup-winlocal-script-v4"

     OBS: tire os colchetes mas não tire as aspas do comando, que vai identificar em qualquer pasta do dispositivo

     - Em "Iniciar em (opcional):" escreva apenas o caminho do qual você já tinha escrito mas sem o nome do arquivo, sem o "/c" e sem as aspas
     
      Exemplo: C:\Users\Laboratório\Downloads

   4. Na aba CONDIÇÕES
     - Ative as opções de acordo com a preferência do usuário

     OBS: provavelmente a tarefa não funcionará com o computador desligado, mesmo marcando a opção de "Reativar o computador para executar esta tarefa" (tem uma série de permissões e impecílios para que isso aconteceça)
   5. Na aba CONFIGURAÇÕES
     - Marque o checkbox "Permitir que a tarefa seja executada por demanda"
     - Marque o checkbox "Se ocorrer falha na tarefa, reiniciar a cada" e deixe a configuração padrão (pode mudar de acordo com a preferência do usuário)

   6. CLIQUE "OK" PARA FINALIZAR

===========================================================
7 COMO RECUPERAR ARQUIVOS COM SOFT DELETE NO GOOGLE CLOUD
===========================================================

1. ACESSE SEU BUCKET
   - Acesse seu diretório principal
   - Clique em "Mostrar" e selecione "Apenas objetos excluídos de forma reversível" (essa opção fica no canto direito na mesma barra que os "Filtro" e "Filtrar apenas...")
   - Escolha o arquivo que você quer recuperar e clique nele
   - Vá novamente no canto direito em "Mostrar" e selecione "Exclusão reversível"
   - Na mesma linha do arquivo que você selecionou está escrito no final da linha "Restore"
   - Clique em "Restore" e Confirme

========================================================
8 BAIXANDO ARQUIVO DO GOOGLE CLOUD PARA MÁQUINA LOCAL
========================================================

1. ACESSE SEU BUCKET
   - No final da linha do arquivo que você quer baixar, tem um símbolo de "Download" (setinha pra baixo com meio retângulo)
   - Clique com o botão direito em cima do ícone e clique em "Salvar link como..."
   - Escolha as pasta local e baixe o arquivo
   OBS: caso você só clique no ícone de download, será redirecionado ao documento aberto no navegador, mas não irá baixar
