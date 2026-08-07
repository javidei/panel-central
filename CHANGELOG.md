# Historial de versiones de Project Hub

Project Hub utiliza versionado semántico `MAJOR.MINOR.PATCH`.

## 0.2.3 — 07/08/2026

- Corrige la visualización simultánea de estados incompatibles de sesión.
- Hace que el atributo HTML `hidden` tenga prioridad sobre estilos `display:flex` e `inline-flex`.
- Oculta correctamente `Cerrar sesión` cuando no existe una sesión activa.
- Oculta correctamente la tarjeta de configuración cuando Supabase ya está configurado.
- Muestra el formulario de acceso únicamente cuando realmente falta iniciar sesión.

## 0.2.2 — 07/08/2026

- Corrige el botón de sincronización para que no quede bloqueado cuando falta una sesión de Supabase.
- Al pulsar sincronizar sin sesión, lleva directamente al formulario de acceso.
- Añade una comprobación previa de las tablas de Project Hub antes de importar repositorios.
- Mejora los mensajes de error para distinguir tablas inexistentes, problemas RLS y errores de GitHub.
- Amplía el tiempo visible de los avisos para que puedan leerse con claridad.

## 0.2.1 — 07/08/2026

- Actualiza la configuración para la nueva `Publishable key` de Supabase.
- Mantiene compatibilidad con la antigua `anon key`.
- Mejora la validación y los mensajes de error de la conexión.
- Aclara que nunca deben introducirse claves `Secret`, `service_role` ni contraseñas de base de datos.

## 0.2.0 — 07/08/2026

- Conecta el panel con la API pública de GitHub.
- Sincroniza nombres, descripciones, lenguajes, enlaces y metadatos de los repositorios.
- Persiste los proyectos sincronizados en Supabase.
- Permite añadir y mantener proyectos externos a GitHub.
- Añade autenticación mediante Supabase Auth.
- Incorpora tablas separadas para proyectos y tareas.
- Añade políticas RLS para aislar los datos por usuario.
- Mantiene información personalizada sin sobrescribirla en sincronizaciones posteriores.
- Sustituye `localStorage` como almacén de proyectos por Supabase; solo conserva la configuración pública de conexión.

## 0.1.0 — 07/08/2026

- Primera versión funcional del panel central de proyectos.
- Añade resumen, CRUD local, tareas, filtros y copias JSON.
- Guarda inicialmente la información en `localStorage`.
