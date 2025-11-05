# monolith-to-fargate

Modernização de aplicações monolíticas para arquitetura conteinerizada serverless com ECS Fargate..

---
## 🚀 Containerização da Aplicação

### 🎯 Objetivo:
Transformar a aplicação monolítica (que hoje roda em uma EC2) em um contêiner Docker pronto para rodar no ECS Fargate.

Esse passo é o alicerce de toda a migração, pois:
- Define o ambiente runtime da app (linguagem, libs, variáveis, portas).
- Garante que a app rode de forma idêntica em qualquer ambiente (local, CI, ECS).
- Permite o build da imagem que será enviada ao ECR no passo seguinte.

### 🧪 Testando localmente

Acesse o diretório da aplicação:

```bash
cd app
````

Gere o package-lock.json:

```bash
npm install
```

Construa a imagem:

```bash
docker build -t monolith-fargate .
```

Execute o contêiner:
```bash
docker run -d -p 3000:3000 monolith-fargate
```

Teste o funcionamento:
```bash
curl http://localhost:3000
curl http://localhost:3000/health
```

### ✅ Resultado esperado
A aplicação Node.js roda localmente via Docker.

🚀 Aplicação Monolítica rodando em contêiner ECS Fargate!
OK

---

## 🚀 Integração com o Amazon ECR (Elastic Container Registry) e CI/CD com GitHub Actions

### 🎯 Objetivo

Publicar a imagem Docker da aplicação no Amazon ECR, para que o ECS Fargate possa utilizá-la durante o deploy.

Além disso, será necessário configurar uma pipeline de CI/CD no GitHub Actions para automatizar esse processo (build → push → deploy).

### 🧪 Testando localmente

Acesse o diretório infra/terraform/ecr/:

```bash
cd infra/terraform/ecr/
```

Configure sua conta da aws:

```bash
aws configure

# - Informe suas credenciais
AWS Access Key ID [****************ACVS]: 
AWS Secret Access Key [****************Yh4Z]: 
Default region name [us-east-1]: 
Default output format [json]: 
```

Execute os comandos na sequência:

```bash
terraform init
terraform fmt
terraform validate
terraform apply -auto-approve
```

O resultado será:

```text
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

ecr_repository_name = "meu-app-backend"
ecr_repository_url = "675344342862.dkr.ecr.us-east-1.amazonaws.com/meu-app-backend"
```

> **Observação**:  
   Para que o script Terraform funcione corretamente, se faz necessário adicionar a permissão "_AmazonEC2ContainerRegistryFullAccess_" na conta de serviço que o Terraform está utilizando.  
   Esse procedimento não cabe nesse projeto.

Para destruir o recurso, execute o comando abaixo:
```bash
terraform destroy -auto-aprove
```

Faça o login no ECR:

```bash
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 675344342862.dkr.ecr.us-east-1.amazonaws.com
```

Efetue o build e envie a imagem para o Registry ECR:
```bash
cd ../../../app
docker build -t monolith-fargate .

docker tag monolith-fargate:latest 675344342862.dkr.ecr.us-east-1.amazonaws.com/monolith-fargate:latest

docker push 675344342862.dkr.ecr.us-east-1.amazonaws.com/monolith-fargate:1.0
```

Verifique se a imagem foi enviada ao Registry ECR:

```bash

aws ecr describe-images \
    --repository-name monolith-fargate-repo \
    --query 'imageDetails' \
    --output json \
| jq -r 'sort_by(.imagePushedAt) | reverse[] | [
    (.imageTags[0] // .imageDigest),
    (.imagePushedAt | tostring),
    ((.imageSizeInBytes / 1048576) | round),
    .imageDigest
] | @tsv' \
| (echo -e "Tag\tPushedAt\tSize_MB\tDigest"; cat)
```

Resultado esperado:

```text
Tag     PushedAt        Size_MB Digest
1.0     2025-10-23T20:00:02.287000-03:00        43      sha256:f31ff512186b23aa252bb696827998077c63603421c38cb1543d0eab424e3f1c
```

Acesse o diretório **infra/terraform/role** e crie a role na AWS para ser utilizada pelo GitHub OIDC:
```bash
cd ../role

terraform init
terraform fmt
terraform validate
terraform apply -auto-approve
```

O resultado será:

```text
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

ecr_repository_name = "meu-app-backend"
ecr_repository_url = "675344342862.dkr.ecr.us-east-1.amazonaws.com/meu-app-backend"
```

> **Observação**:  
   Para que o script Terraform funcione corretamente, se faz necessário criar um police customizada e anexá-la ao grupo do usuário que você está usando para executar os scripts do Terraform. Para isso, efetue os seguintes passos: 
   1 - Acesse a console da  AWS > IAM > Políticas.
   2 - Crie uma nova Política (ou edite a política do grupo Terraform se for customizada).
   3 - Adicione as seguintes ações na seção Statement:
   ```json
   {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowIAMReadForTerraformDataSources",
            "Effect": "Allow",
            "Action": [
                "iam:ListOpenIDConnectProviders",
                "iam:GetGroup"
            ],
            "Resource": "*"
        }
    ]
}
   ```

Após adicionar esta política ao Grupo, o usuário terá as permissões necessárias para que os data sources sejam lidos com sucesso.

