# Flutter CRUD with Golang Backend

A robust Flutter mobile application demonstrating a complete CRUD (Create, Read, Update, Delete) system. This project is designed to work with a Golang backend API, featuring user authentication, product management, and admin-level user management.

## ✨ Features

- **Authentication**:
  - User Login with JWT-based session management.
  - Secure token storage on the device.
  - Logout functionality.
  - Forgot/Reset Password flow via email.
- **Product Management**:
  - View a list of all products.
  - Create new products.
  - Update existing product details.
  - Delete products.
- **User Management (Admin-only)**:
  - View a list of all registered users.
  - Create new users with specific roles.
  - Update user information.
  - Delete users.
- **State Management**: Clean and scalable state management using `provider`.
- **Project Structure**: Well-organized codebase following a feature-first approach with a shared component library (Atoms and Molecules).

## 🛠️ Tech Stack

- **Frontend**:
  - Flutter (v3.x)
  - Dart
  - provider for State Management
  - dio for HTTP requests with interceptors
  - flutter_secure_storage for secure JWT storage

- **Backend**:
  - Golang (Assumed)

## 📂 Project Structure

The project follows a clean architecture to separate concerns and improve maintainability.

```
lib/
├── components/         # Reusable UI widgets (Atoms, Molecules)
│   ├── atoms/          # Basic building blocks (e.g., PrimaryButton)
│   └── molecules/      # Complex widgets (e.g., InputFormField)
│
├── config/             # Application configuration (e.g., API URL)
│   └── app_config.dart
│
├── data/               # Core business logic
│   ├── http_client.dart  # Centralized Dio client with interceptors
│   ├── models/         # Data models (User, Product)
│   ├── providers/      # State management (AuthProvider, ProductProvider)
│   └── services/       # API communication layer (AuthService, ProductService)
│
├── features/           # Application screens grouped by feature
│   ├── auth/           # Login, Forgot Password screens
│   ├── home/           # Home screen
│   └── ...             # Other feature screens
│
└── main.dart           # Application entry point
```

## 🚀 Getting Started

Follow these instructions to get a copy of the project up and running on your local machine.

### Prerequisites

- Flutter SDK installed.
- A running instance of the corresponding Golang backend API.

### Installation

1.  **Clone the repository:**
    ```sh
    git clone <your-repository-url>
    cd stack_crud_flutter
    ```

2.  **Install dependencies:**
    ```sh
    flutter pub get
    ```

3.  **Configure the API endpoint:**
    Open `lib/config/app_config.dart` and set the `baseUrl` to your local backend address.
    ```dart
    class AppConfig {
      static const String baseUrl = 'http://<your-local-ip>:8080';
    }
    ```

4.  **Run the app:**
    ```sh
    flutter run
    ```

## 🌐 API Endpoints

This application is designed to interact with the following backend API endpoints:

### Authentication (`/auth`)
- `POST /auth/login`: Authenticate a user and receive a JWT.
- `POST /auth/forgot-password`: Initiate the password reset process.

### Products (`/products`)
- `GET /products`: Fetch all products.
- `POST /products`: Create a new product.
- `PUT /products/:id`: Update an existing product.
- `DELETE /products/:id`: Delete a product.

### User Management (`/admin/users`)
- `GET /admin/users`: Fetch all users (Admin only).
- `POST /admin/users`: Create a new user (Admin only).
- `PUT /admin/users/:id`: Update a user (Admin only).
- `DELETE /admin/users/:id`: Delete a user (Admin only).

---

*This README was generated based on the project's source code.*