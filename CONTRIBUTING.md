# Contributing to RSInfinity

¡Gracias por tu interés en contribuir a RSInfinity! 🎉

## 🌟 Cómo Contribuir

### Reportar Bugs
1. Verifica que el bug no haya sido reportado previamente
2. Abre un [nuevo issue](https://github.com/Zaikonurami/RSInfinity/issues/new)
3. Incluye:
   - Descripción clara del problema
   - Pasos para reproducir
   - Sistema operativo y versión
   - Versión de Roblox
   - Logs del instalador (ubicados en `%TEMP%\rsinfinity`)

### Sugerir Mejoras
1. Abre un [issue](https://github.com/Zaikonurami/RSInfinity/issues/new) describiendo tu sugerencia
2. Explica por qué sería útil
3. Proporciona ejemplos de uso si es posible

### Pull Requests

#### Preparación
1. Fork el repositorio
2. Crea una rama desde `main`:
   ```bash
   git checkout -b feature/tu-caracteristica
   ```
3. Realiza tus cambios
4. Asegúrate de que el código compila sin errores:
   ```bash
   makensis Setup\Setup.nsi
   ```

#### Estándares de Código
- **NSIS Scripts**: Usa indentación de 4 espacios
- **Comentarios**: Documenta código complejo
- **Nombres**: Usa nombres descriptivos para variables y funciones
- **Macros**: Documenta cada macro con su propósito

#### Commit Messages
Usa commits descriptivos siguiendo este formato:
```
tipo: descripción breve

Descripción detallada si es necesario
```

Tipos de commit:
- `feat`: Nueva característica
- `fix`: Corrección de bug
- `docs`: Cambios en documentación
- `style`: Cambios de formato (no afectan el código)
- `refactor`: Refactorización de código
- `test`: Añadir o modificar tests
- `chore`: Tareas de mantenimiento

Ejemplo:
```
feat: añadir preset para modo oscuro

Agrega un nuevo preset optimizado para juegos con
ambientes oscuros, mejorando la visibilidad.
```

#### Enviar el Pull Request
1. Actualiza la rama con los últimos cambios de main:
   ```bash
   git pull origin main
   ```
2. Push a tu fork:
   ```bash
   git push origin feature/tu-caracteristica
   ```
3. Abre un Pull Request desde GitHub
4. Describe claramente los cambios realizados
5. Enlaza issues relacionados si los hay

## 📋 Checklist para Pull Requests

- [ ] El código compila sin errores
- [ ] Los cambios están documentados
- [ ] Se actualizó el CHANGELOG.md si es necesario
- [ ] Se probó el instalador en un ambiente limpio
- [ ] Los commits tienen mensajes descriptivos
- [ ] No hay conflictos con la rama main

## 🔧 Estructura del Proyecto

```
RoShadeInfinity/
├── Files/              # Archivos de instalación
│   ├── Preset/         # Presets de Reshade
│   ├── Reshade/        # Core de Reshade
│   ├── RSInfinity/     # Recursos personalizados
│   └── Textures/       # Texturas de shaders
├── Setup/              # Scripts NSIS
│   ├── *.nsh           # Archivos de configuración
│   ├── Graphics/       # Recursos gráficos
│   ├── CustomDlg/      # Diálogos personalizados
│   └── Util/           # Utilidades
└── .github/            # CI/CD
```

## 🧪 Testing

Antes de enviar un PR:
1. Compila el instalador
2. Prueba la instalación en una máquina limpia
3. Verifica que todos los presets funcionen
4. Comprueba que la desinstalación funcione correctamente
5. Revisa los logs en `%TEMP%\rsinfinity`

## 📞 Contacto

- 💬 [Discord](https://rsinfinity.software/go/discord)
- 🐛 [Issues](https://github.com/Zaikonurami/RSInfinity/issues)
- 🌐 [Website](https://rsinfinity.software/)

## 📄 Código de Conducta

- Sé respetuoso con todos los colaboradores
- Acepta críticas constructivas
- Enfócate en lo mejor para el proyecto
- Mantén un ambiente profesional y amigable

## ⚖️ Licencia

Al contribuir, aceptas que tus contribuciones serán licenciadas bajo la misma licencia del proyecto.

---

¡Gracias por contribuir a RSInfinity! 🚀
