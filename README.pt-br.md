# WinLocal Backup Script v4

[Português](README.pt-br.md) | [English](README.md)

<p align="center">
  <img src="terminal-preview.png" alt="WinLocal Backup Script em ação" width="800">
</p>

<p align="center">
  <em>Perda de dados não é uma opção. Automatize seus backups em nuvem com precisão.</em><br>
  <strong>WinLocal Backup Script v4</strong> é uma solução robusta em Windows Batch que se integra perfeitamente ao Google Cloud SDK para espelhar e arquivar seus arquivos locais críticos de forma segura na nuvem.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/OS-Windows-0078D6?style=flat&logo=windows&logoColor=white" alt="Windows">
  <img src="https://img.shields.io/badge/Language-Batch-4EAA25?style=flat&logo=gnubash&logoColor=white" alt="Batch Script">
  <img src="https://img.shields.io/badge/Cloud-Google%20Cloud-4285F4?style=flat&logo=googlecloud&logoColor=white" alt="Google Cloud">
</p>

---

## O Que é Isso?

O **WinLocal Backup Script v4** é uma ferramenta de linha de comando (CLI) construída em Windows Batch que utiliza o poder do `gsutil` (Google Cloud CLI) para automatizar backups locais direto para a nuvem.

Em vez de depender de softwares pesados de terceiros, este script roda silenciosamente em segundo plano, autentica-se via uma conta de serviço segura e sincroniza os diretórios locais selecionados diretamente para um Bucket do Google Cloud Storage.

## Recursos Principais

| Recurso | Descrição |
|---------|-------------|
| ☁️ **Sincronização Direta** | Utiliza `gsutil rsync` para fazer upload apenas de arquivos modificados, economizando banda e tempo. |
| 🛡️ **Suporte a Soft Delete** | Totalmente compatível com as políticas de exclusão reversível do GCP, protegendo contra exclusões acidentais ou ransomware. |
| 📝 **Logs de Execução** | Gera arquivos `.log` detalhados mostrando exatamente quais arquivos foram enviados e o progresso. |
| 📅 **Automação Nativa** | Configurável para rodar de forma 100% autônoma através do Agendador de Tarefas do Windows. |

---

## 🛠️ Guia Completo de Configuração

Siga os passos abaixo para configurar seu ambiente no Google Cloud e preparar sua máquina local.

### 1. Preparando via Web (Google Cloud)

**1.1 Criar um Bucket**
* Acesse **Google Cloud > Cloud Storage > Buckets > Criar Bucket**.
* Escolha o Nome, Região do servidor e a classe de armazenamento (pacote).
* **Importante:** Marque a caixinha *"Aplicar a prevenção do acesso público neste bucket"*.
* **Proteção de Dados:** É altamente recomendável marcar *"Política de exclusão reversível (para recuperação de dados)"* (Soft Delete).

**1.2 Criar uma Conta IAM e Admin**
* Acesse **IAM e admin > Contas de serviço > Criar conta de serviço**.
* Escolha um nome. Nas permissões, pesquise e selecione o papel **"Administrador de armazenamento"**. Finalize.

**1.3 Criar a Chave de Acesso**
* Volte para a lista de Contas de Serviço. Clique em **Ações** (3 pontinhos) > **Gerenciar Chaves > Adicionar chave > Criar nova chave**.
* Selecione **JSON** e baixe o arquivo para a sua máquina.
> ⚠️ **CRÍTICO:** Essa chave é o seu acesso direto. Guarde-a em uma pasta segura. **O diretório onde a chave estiver NÃO PODE conter ACENTOS em nenhuma palavra** (Exemplo ruim: `C:\Usuários\Laboratório\`).

### 2. Preparando a Máquina

**2.1 Instalar o Google Cloud CLI**
* Acesse a [documentação oficial](https://docs.cloud.google.com/sdk/docs/install-sdk?hl=pt-br) e baixe o instalador.
* Execute e selecione **"All Users"**.
* Anote o caminho em "Destination Folder" (você usará isso no Passo 3.2).
> ⚠️ **CRÍTICO:** Não instale o Google Cloud CLI em um diretório COM ACENTO para evitar retrabalho com os comandos via script.

### 3. Editando o Executável

**3.1 Editar Variáveis do Executável**
* Baixe/Abra o arquivo `backup-winlocal-script-v4.bat`, clique com o botão direito e selecione **Editar**.
* No início do arquivo, substitua as informações entre colchetes `{ }` pelos seus dados reais. **ATENÇÃO: Remova os colchetes após preencher.**

```bat
SET KEY_FILE=C:\Pasta\chave.json
SET BUCKET_NAME=nome-do-bucket
SET SOURCE_FOLDER=C:\Pasta\Pasta-Alvo-Para-Backup
SET DESTINATION_PATH=Nome-da-Pasta-Criada-no-Google-Cloud
```

**3.2 Achando o Caminho do Google Cloud CLI**
* Abra o **CMD em Modo Administrador**, digite `where gcloud` e dê enter.
* Copie o caminho (excluindo a parte final do arquivo) e cole na variável `GCLOUD_PATH`.
* Na mesma pasta, encontre o executável do Python e cole em `CLOUDSDK_PYTHON`:

```bat
SET GCLOUD_PATH=C:\Program Files (x86)\Google\Cloud SDK\google-cloud-sdk\bin
SET CLOUDSDK_PYTHON=C:\Program Files (x86)\Google\Cloud SDK\google-cloud-sdk\platform\bundledpython\python.exe
```
*(Salve e feche o arquivo após as edições).*

### 4. Teste de Execução (Push)

* Execute o arquivo `.bat` em **Modo Administrador**.
* **Como saber se funcionou?** O script gera um arquivo `backup_log.txt` na mesma pasta. Se parar na autenticação, o problema está nos caminhos definidos no Passo 3 (verifique acentos ou colchetes esquecidos).
* Se estiver tudo certo, o log mostrará as porcentagens de upload:
```text
- [1/14 files][ 48.8 KiB/ 48.8 KiB]  99% Done                                   
- [2/14 files][ 48.8 KiB/ 48.8 KiB]  99% Done 
```

### 5. Configurando para Executar Automaticamente

**5.1 Retirando Caixa de Diálogo do Administrador (UAC)**
* `Win+R` > digite `secpol.msc` > enter.
* Vá em **Políticas Locais > Opções de segurança**.
* Encontre *Controle de Conta de Usuário: executar todos os administradores no Modo de Aprovação de Administrador* e defina como **Desabilitada**. *(Isso impede que o prompt de permissão trave a automação).*

**5.2 Agendando a Tarefa no Windows**
* `Win+R` > digite `taskschd.msc` > enter. Clique em **Criar tarefa...**
* **Aba GERAL:** Dê um nome (ex: "Backup Diário"). Marque *Executar estando o usuário conectado ou não* e *Executar com privilégios mais altos*.
* **Aba DISPARADORES:** Novo > *Em um agendamento* > *Diário* (defina o horário desejado).
* **Aba AÇÕES:** Novo > *Iniciar um programa*.
  * Programa/script: `cmd.exe`
  * Adicione argumentos: `/c "C:\Caminho\Para\O\backup-winlocal-script-v4.bat"` *(mantenha as aspas)*.
  * Iniciar em: `C:\Caminho\Para\O\` *(apenas o caminho, sem aspas)*.
* Finalize clicando em **OK**.

### 6. Gerenciamento na Nuvem (Google Cloud)

**Como Recuperar Arquivos com Soft Delete:**
1. Acesse seu Bucket.
2. Clique em **Mostrar** e selecione *"Apenas objetos excluídos de forma reversível"*.
3. Clique no arquivo desejado. Vá novamente em **Mostrar** e selecione *"Exclusão reversível"*.
4. Clique em **Restore** no final da linha e confirme.

**Como Baixar do Google Cloud para a Máquina:**
1. Acesse seu Bucket. No final da linha do arquivo, encontre o ícone de Download (seta para baixo).
2. **Clique com o botão direito** em cima do ícone e selecione *"Salvar link como..."*. *(Clicar com o botão esquerdo apenas abrirá o arquivo no navegador).*

---

## Estrutura do Projeto

```text
backup-winlocal-script-v4/
├── backup-winlocal-script-v4.bat  # Script principal de execução
├── backup_log.txt                 # Log gerado automaticamente
└── README.md
```

## Sobre o Autor

Sou o **Samuel**, Analista de TI apaixonado por infraestrutura confiável e automação. Após projetar arquiteturas de backup para cumprir rigorosas regulamentações de conformidade em ambientes profissionais, criei este script para trazer esse mesmo nível de confiabilidade (com ferramentas cloud enterprise) para máquinas Windows locais.

Se quiser conversar sobre tecnologia, infraestrutura ou desenvolvimento, vamos nos conectar.

## Vamos nos Conectar

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/samu-lls/)
[![Behance](https://img.shields.io/badge/Behance-1769FF?style=for-the-badge&logo=behance&logoColor=white)](https://www.behance.net/samuellelles)
[![Email](https://img.shields.io/badge/Email-0078D4?style=for-the-badge&logo=microsoft-outlook&logoColor=white)](mailto:samu.lls@outlook.com)
[![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/samu-lls)
