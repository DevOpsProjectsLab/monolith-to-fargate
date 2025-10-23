# monolith-to-fargate

Modernização de aplicações monolíticas para arquitetura conteinerizada serverless com ECS Fargate.

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