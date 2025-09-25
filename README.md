# Rails on ECS Terraform

## 概要

このリポジトリは、Rails アプリケーションを AWS 上に構築するための Terraform コードを管理します。
ECS Fargate を使用してコンテナ化されたアプリケーションを実行し、ALB、RDS、ECR などのサービスと連携します。

## アーキテクチャ

この Terraform プロジェクトで構築される AWS アーキテクチャは以下の通りです。

- **VPC**: アプリケーションのネットワーク分離のための Virtual Private Cloud
- **ECS (Elastic Container Service)**: Fargate 起動タイプでコンテナを実行
- **ECR (Elastic Container Registry)**: Docker コンテナイメージの保存場所
- **ALB (Application Load Balancer)**: コンテナへの HTTP/HTTPS トラフィックの分散
- **RDS (Relational Database Service)**: アプリケーションの永続データストア (PostgreSQL など)
- **SSM (Systems Manager)**: パラメータストアによる設定値やシークレットの管理

## ディレクトリ構成

```
.
├── .github/workflows/ci.yml  # GitHub ActionsによるCI設定
├── environments/prod/        # 本番環境用のTerraformコード
└── modules/                  # 各AWSリソースを定義するTerraformモジュール
    ├── alb/
    ├── ecr/
    ├── ecs/
    ├── network/
    ├── rds/
    └── ssm/
```

- **environments**: `prod`, `stg` などの環境ごとのルートモジュールを配置します。各環境の tfstate はこちらで管理されます。
- **modules**: VPC、ECS、RDS など、再利用可能なインフラコンポーネントをモジュールとして定義します。

## 使い方

### 前提条件

- Terraform (バージョンは `.tool-versions` を参照)
- AWS アカウントおよびクレデンシャル設定

### デプロイ手順 (prod ディレクトリを対象とする場合)

1.  Terraform を初期化します。

    ```bash
    terraform -chdir=./environments/prod init
    ```

2.  変更内容を確認します。

    ```bash
    terraform -chdir=./environments/prod plan
    ```

3.  変更を適用します。
    ```bash
    terraform -chdir=./environments/prod apply
    ```

## CI/CD

このリポジトリでは、GitHub Actions を使用して CI（継続的インテグレーション）を導入しています。
Pull Request が作成されると、以下のチェックが自動的に実行されます。

- **`terraform fmt -check`**: Terraform コードのフォーマットが規約に沿っているかを確認します。
- **`terraform validate`**: Terraform コードの構文が正しいかを確認します。
