Registro de Compras Online 📋💼

Registro de Compras Online é uma solução intuitiva para gerenciar registros de compras, fornecendo recursos de autenticação, visualização de estatísticas e armazenamento seguro em Firebase. Ideal para usuários que buscam praticidade e controle ao registrar e organizar suas compras.


🌟 Visão Geral
O Registro de Compras Online é um aplicativo desenvolvido em Flutter com integração ao Firebase. Ele oferece uma interface amigável para que os usuários possam registrar, visualizar, editar e excluir compras, além de acessar relatórios de estatísticas para análise dos gastos. Este aplicativo foi criado com uma arquitetura baseada no gerenciamento de estado Provider, proporcionando um código organizado e de fácil manutenção.

⚙️ Funcionalidades
Autenticação de Usuários: Registro e login usando Firebase Authentication.
Gerenciamento de Compras: Funções completas de CRUD (Create, Read, Update, Delete) para compras.
Visualização de Estatísticas: Exibição de gráficos e análises das compras registradas.
Exportação CSV: (Funcionalidade desativada) Exportação de registros de compras para um arquivo CSV.
Design Responsivo e Acessível: Experiência de usuário aprimorada com interface moderna e responsiva.

🛠 Pré-requisitos
Flutter SDK: Versão mais recente. Instalar Flutter
Firebase CLI: Para configuração de Firebase. Instalar Firebase CLI


🖥️ Uso
Login/Registro: Utilize a tela inicial para criar uma nova conta ou fazer login.
Gerenciamento de Compras: Adicione, visualize, edite e exclua compras a partir da tela principal.
Estatísticas: Clique no ícone de gráficos para visualizar as estatísticas detalhadas das compras.

🏗️ Arquitetura do Projeto
O projeto segue uma arquitetura MVVM com gerenciamento de estado via Provider. A estrutura das pastas é organizada da seguinte forma:

plaintext
Copiar código
lib/
├── models/               # Modelos de dados (ex.: Compra)
├── providers/            # Providers para gerenciamento de estado
├── screens/              # Telas do aplicativo (ex.: Tela Principal, Tela de Estatísticas)
├── services/             # Serviços (ex.: Firebase)
├── utils/                # Constantes e temas (ex.: Cores e Configurações)
└── widgets/              # Widgets personalizados e reutilizáveis
Cada camada tem responsabilidades bem definidas, o que torna o projeto modular, testável e fácil de expandir.

📲 Tecnologias Utilizadas
Flutter: Framework para desenvolvimento de aplicações cross-platform.
Firebase: Backend-as-a-Service, utilizado para autenticação e armazenamento de dados.
Provider: Biblioteca para gerenciamento de estado em Flutter.
Intl: Para formatação de datas.
Path Provider: Para manipulação de diretórios e arquivos.

🎨 Paleta de Cores e Design
  static const Color primary = Color(0xFF0A4F70); // Azul Petróleo
  static const Color accent = Color(0xFFFF7F11);  // Laranja Escuro
  static const Color surface = Color(0xFFF5F5F5); // Cinza Claro
  static const Color background = Color(0xFFFFFFFF); // Branco
  static const Color text = Color(0xFF333333); // Cinza Escuro
  static const Color cardBackground = Color(0xFFE0E0E0); // Cinza Médio

📂 Estrutura do Banco de Dados Firebase
O banco de dados foi estruturado de forma a manter os dados organizados e de fácil acesso:
Coleção: compras
Documento: Cada compra registrada no app.
Campos:
id: Identificador único.
titulo: Título da compra.
valorTotal: Valor total da compra.
dataCompra: Data da compra.
statusEntrega: Status da entrega.
categoria: Categoria associada à compra.
A estrutura é otimizada para leitura e escrita, garantindo uma rápida recuperação de dados para exibição na interface.

🧩 Explicação Detalhada do Código

1. Autenticação de Usuários
A classe AuthProvider gerencia o login e registro de usuários usando o Firebase Authentication. A função signIn autentica o usuário e signUp registra um novo usuário.
dart
Copiar código
await authProvider.signIn(_email, _password);
2. CRUD de Compras
Adição e Edição: Utilizamos o CompraFormScreen, onde o usuário pode adicionar e editar detalhes das compras. Os dados são enviados para o Firestore usando CompraProvider.
dart
Provider.of<CompraProvider>(context, listen: false).addCompra(novaCompra);
Leitura: As compras são recuperadas em CompraListScreen e exibidas com o uso do widget CompraItem.
Exclusão: A função _confirmarDelecao permite a exclusão de uma compra específica com uma confirmação do usuário.
3. Estatísticas
A tela EstatisticasScreen mostra gráficos interativos, representando o valor e a categoria das compras.
4. Estrutura do Firebase
O Firebase foi configurado no arquivo firebase_options.dart, e a estrutura de dados foi planejada para otimizar o acesso aos dados e facilitar a expansão do app.


