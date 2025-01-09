# MIQUE - Controla tus Ingresos y Gastos

![Logo de MIQUE](https://media.githubusercontent.com/media/Danny-Quezada/MIQUE/main/android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png)

**MIQUE** es una aplicación diseñada para ayudarte a controlar tus finanzas personales. Podrás registrar, visualizar y gestionar tus ingresos y egresos de manera eficiente. MIQUE también ofrece análisis detallados como balances diarios, proyecciones mensuales y un tablero (dashboard) completo para que tomes decisiones informadas sobre tu dinero.

---

## Características principales

### 1. **Registro y autenticación**
- **Autenticación con Google**: Regístrate o inicia sesión de forma rápida y segura con tu cuenta de Google.
- **Registro manual**: Crea tu cuenta personal proporcionando tu nombre, correo electrónico y contraseña.

<div style="display: flex; justify-content: space-around;">
  <img src="https://media.githubusercontent.com/media/Danny-Quezada/MIQUE/main/Documentation/Screenshots/SignUp.jpg" alt="Pantalla de registro" width="45%">
  <img src="https://media.githubusercontent.com/media/Danny-Quezada/MIQUE/main/Documentation/Screenshots/Login.jpg" alt="Pantalla de inicio de sesión" width="45%">
</div>

### 2. **Gestión de libros financieros**
- Crea libros para organizar tus ingresos y egresos.
- Edita los detalles de los libros según tus necesidades.
- Elimina libros que ya no necesitas.


<div style="display: flex; justify-content: space-around;">
  <img src="https://media.githubusercontent.com/media/Danny-Quezada/MIQUE/main/Documentation/Screenshots/Books.jpg" alt="Mostrar libros" width="45%">
  <img src="https://media.githubusercontent.com/media/Danny-Quezada/MIQUE/main/Documentation/Screenshots/DeleteBooks.jpg" alt="Eliminar libros" width="45%">
</div>

### 3. **Registro de ingresos y egresos**
- Añade ingresos o egresos especificando:
  - Nombre
  - Fecha
  - Cantidad
  - Un icono personalizado o uno por defecto
- Los ingresos y egresos se reflejan automáticamente en el balance total del libro asociado.

<div style="display: flex; justify-content: space-around;">
  <img src="https://media.githubusercontent.com/media/Danny-Quezada/MIQUE/main/Documentation/Screenshots/IncomeForm.jpg" alt="Dashboard" width="45%">
  <img src="https://media.githubusercontent.com/media/Danny-Quezada/MIQUE/main/Documentation/Screenshots/ExpenseForm.jpg" alt="Segunda parte Dashboard" width="45%">
</div>

### 4. **Dashboard intuitivo**
Visualiza tus datos financieros en tiempo real:
- **Balance total**: Muestra la suma de todos los ingresos y egresos.
- **Proyección mensual**: Estima tu balance futuro basado en tus datos actuales.
- **Balance diario**: Analiza el detalle de tus finanzas día a día en el mes actual.

<div style="display: flex; justify-content: space-around;">
  <img src="https://media.githubusercontent.com/media/Danny-Quezada/MIQUE/main/Documentation/Screenshots/Dashboard.jpg" alt="Pantalla de registro" width="45%">
  <img src="https://media.githubusercontent.com/media/Danny-Quezada/MIQUE/main/Documentation/Screenshots/Dashboard2.jpg" alt="Pantalla de inicio de sesión" width="45%">
</div>

### 5. **Eliminación de registros**
- Elimina ingresos o egresos.
- El balance se actualiza automáticamente:
  - Si eliminas un ingreso, se resta del balance total.
  - Si eliminas un egreso, se suma nuevamente al balance.

<div style="display: flex; justify-content: space-around;">
  <img src="https://media.githubusercontent.com/media/Danny-Quezada/MIQUE/main/Documentation/Screenshots/DeleteBooks.jpg" alt="Eliminar libros" width="45%">
  <img src="https://media.githubusercontent.com/media/Danny-Quezada/MIQUE/main/Documentation/Screenshots/TransactionDelete.jpg" alt="Eliminar transacción" width="45%">
</div>

---

## Video de demostración

¡Mira MIQUE en acción! Aprende cómo gestionar tus finanzas con esta increíble aplicación:

[![Video de demostración](https://media.githubusercontent.com/media/Danny-Quezada/MIQUE/main/Documentation/Video.mp4)

---

## Tecnologías utilizadas

- **Flutter**: Desarrollo de la interfaz de usuario multiplataforma.
- **Firebase**:
  - Autenticación de usuarios.
  - Almacenamiento de datos en tiempo real.
  
  
---

## Instalación

1. **Configura Firebase:**
   - Crea un proyecto en Firebase.
   - Activa la autenticación de Google y la de correo electrónico.
   - Conecta el proyecto de Firebase con Flutter siguiendo las instrucciones oficiales de Firebase.

2. **Configura las variables de entorno:**
   - Obtén las credenciales de configuración de Firebase que proporciona Flutter.
   - Crea un archivo `.env` en la carpeta `assets` del proyecto.
   - Añade las variables necesarias en el archivo `.env`. Por ejemplo:
     ```env
     FIREBASE_API_KEY=tu_api_key
     FIREBASE_AUTH_DOMAIN=tu_auth_domain
     FIREBASE_PROJECT_ID=tu_project_id
     FIREBASE_STORAGE_BUCKET=tu_storage_bucket
     FIREBASE_MESSAGING_SENDER_ID=tu_sender_id
     FIREBASE_APP_ID=tu_app_id
     ```

3. Clona este repositorio:
   ```bash
   git clone https://github.com/tu_usuario/mique.git
   ```
4. Navega al directorio del proyecto:
   ```bash
   cd mique
   ```
5. Instala las dependencias:
   ```bash
   flutter pub get
   ```
6. Conecta un dispositivo o emulador y ejecuta:
   ```bash
   flutter run
   ```

---

## Capturas de pantalla

### Pantallas principales
- Registro e inicio de sesión
- Gestión de libros
- Registro de ingresos y egresos
- Dashboard

---

¿Tienes sugerencias o comentarios? ¡Estaré encantado de escucharte!

👨‍💻 **Desarrollador**: [Danny Quezada](https://github.com/Danny-Quezada)

