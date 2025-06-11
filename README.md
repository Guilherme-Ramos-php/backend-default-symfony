# API RESTful com Symfony 7

Este é um projeto de API RESTful construído com Symfony 7, utilizando autenticação JWT, PostgreSQL e otimizado com Swoole para alta performance.

## Requisitos

- Docker
- Docker Compose
- PHP 8.4
- PostgreSQL 16

## Estrutura do Projeto

```
.
├── config/                 # Configurações do Symfony
├── src/                    # Código fonte da aplicação
│   ├── Controller/        # Controladores da API
│   ├── Entity/           # Entidades do Doctrine
│   └── Repository/       # Repositórios do Doctrine
├── Dockerfile            # Configuração do container PHP
├── docker-compose.yml    # Configuração do ambiente de desenvolvimento
└── docker-compose.prod.yml # Configuração do ambiente de produção
```

## Instalação

1. Clone o repositório:
```bash
git clone <seu-repositorio>
cd <seu-repositorio>
```

2. Configure as variáveis de ambiente:
```bash
cp .env.example .env
```

3. Gere as chaves JWT:
```bash
php bin/console lexik:jwt:generate-keypair
```

4. Inicie os containers de desenvolvimento:
```bash
docker-compose up -d
```

5. Instale as dependências:
```bash
docker-compose exec php composer install
```

6. Execute as migrações:
```bash
docker-compose exec php php bin/console doctrine:migrations:migrate
```

## Ambiente de Desenvolvimento

O ambiente de desenvolvimento inclui:
- Servidor PHP com Swoole na porta 9501
- PostgreSQL na porta 5432
- Serviço auxiliar do Composer

Para iniciar o servidor de desenvolvimento:
```bash
docker-compose exec php php bin/console swoole:server:start
```

## Ambiente de Produção

Para implantar em produção:
```bash
docker-compose -f docker-compose.prod.yml up -d
```

## Endpoints da API

### Registro de Usuário
```http
POST /api/register
Content-Type: application/json

{
    "email": "usuario@exemplo.com",
    "password": "senha123"
}
```

### Login
```http
POST /api/login_check
Content-Type: application/json

{
    "username": "usuario@exemplo.com",
    "password": "senha123"
}
```

### Refresh Token
```http
POST /api/token/refresh
Content-Type: application/json

{
    "refresh_token": "seu-refresh-token"
}
```

### Dados do Usuário
```http
GET /api/me
Authorization: Bearer seu-jwt-token
```

## Segurança

- Todas as rotas sob `/api/` são protegidas por JWT, exceto:
  - `/api/register`
  - `/api/login_check`
  - `/api/token/refresh`
- Tokens JWT expiram em 1 hora
- Refresh tokens expiram em 7 dias
- Senhas são hasheadas usando o algoritmo mais seguro disponível
- Usuários são identificados por UUID

## Performance

O projeto utiliza:
- Swoole para servidor HTTP assíncrono
- PostgreSQL para banco de dados
- Cache de configuração em produção
- Otimização de autoloader do Composer
- Multi-stage build no Docker para imagens menores

## Testes

Para executar os testes:
```bash
docker-compose exec php php bin/phpunit
``` 