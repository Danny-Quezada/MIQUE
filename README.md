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

[![Video de demostración](https://media.githubusercontent.com/media/Danny-Quezada/MIQUE/main/Documentation/Video.gif)](https://media.githubusercontent.com/media/Danny-Quezada/MIQUE/main/Documentation/Video.gif)

---

## Tecnologías utilizadas

- **Flutter**: Desarrollo de la interfaz de usuario multiplataforma.
- **Firebase**:
  - Autenticación de usuarios.
  - Almacenamiento de datos en tiempo real.
  
---

## Integración de IA en MIQUE

### Análisis inteligente de finanzas
La versión de MIQUE con inteligencia artificial se encuentra en la rama `AI_MIQUE`, donde se implementa un asistente que analiza:
- **El dashboard completo**, proporcionando insights sobre tus finanzas.
- **Las transacciones completas de un libro**, identificando patrones de ingresos y egresos.
- **Cada transacción individualmente**, ayudándote a tomar mejores decisiones financieras.

### Configuración de IA
Para habilitar la funcionalidad de IA, debes configurar las siguientes variables en el archivo `.env`:
```env
BASE_URL=tu_base_url
ENDPOINT=tu_endpoint
API_KEY=tu_api_key
MODEL=tu_modelo
```
Estas variables permitirán que la aplicación se comunique con el asistente de IA para analizar y brindar recomendaciones personalizadas sobre tus finanzas.

### Video de demostración de IA

¡Descubre cómo la inteligencia artificial de MIQUE puede ayudarte a analizar tus finanzas!

[![Video de demostración de IA](https://media.githubusercontent.com/media/Danny-Quezada/MIQUE/main/Documentation/AIVideo.gif)](https://media.githubusercontent.com/media/Danny-Quezada/MIQUE/main/Documentation/AIVideo.gif)

---

¿Tienes sugerencias o comentarios? ¡Estaré encantado de escucharte!

👨‍💻 **Desarrollador**: [Danny Quezada](https://github.com/Danny-Quezada)

