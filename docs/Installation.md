# Guía de Instalación - VolumeAI Trading Bot

## 📋 Requisitos del Sistema

### Requisitos Mínimos
- **MetaTrader 5**: Versión 5.0 o superior
- **Sistema Operativo**: Windows 7/8/10/11, macOS, Linux
- **Memoria RAM**: Mínimo 4GB (recomendado 8GB+)
- **Espacio en Disco**: 100MB libres
- **Conexión a Internet**: Estable para datos en tiempo real

### Requisitos Recomendados
- **MetaTrader 5**: Última versión disponible
- **Memoria RAM**: 8GB o más
- **Procesador**: Intel i5 o AMD equivalente o superior
- **Conexión a Internet**: Fibra óptica o cable de alta velocidad
- **VPS**: Para trading 24/7 (opcional pero recomendado)

## 🚀 Instalación Paso a Paso

### Paso 1: Descargar MetaTrader 5

1. **Visita el sitio oficial**: [https://www.metatrader5.com](https://www.metatrader5.com)
2. **Descarga la versión para tu sistema operativo**
3. **Instala MetaTrader 5** siguiendo las instrucciones del instalador
4. **Abre MetaTrader 5** y configura tu cuenta de trading

### Paso 2: Preparar los Archivos del Bot

1. **Crea una carpeta** llamada `VolumeAI_Bot` en tu escritorio
2. **Descarga todos los archivos** del bot:
   - `VolumeAI_TradingBot.mq5`
   - `VolumeAI_Strategies.mq5`
   - `VolumeAI_Backtester.mq5`
   - `VolumeAI_Config.mq5`
   - `README.md`
   - Carpeta `docs/`

### Paso 3: Instalar el Bot en MetaTrader 5

#### Para Windows:
1. **Abre MetaTrader 5**
2. **Presiona Ctrl+Shift+D** para abrir la carpeta de datos
3. **Navega a**: `MQL5/Experts/`
4. **Copia los archivos** `.mq5` a esta carpeta
5. **Cierra y reabre MetaTrader 5**

#### Para macOS:
1. **Abre MetaTrader 5**
2. **Ve a**: `Archivo > Abrir carpeta de datos`
3. **Navega a**: `MQL5/Experts/`
4. **Copia los archivos** `.mq5` a esta carpeta
5. **Reinicia MetaTrader 5**

#### Para Linux:
1. **Abre MetaTrader 5**
2. **Navega a la carpeta de datos** (generalmente en `~/.wine/drive_c/Users/[usuario]/AppData/Roaming/MetaQuotes/Terminal/`)
3. **Copia los archivos** a `MQL5/Experts/`
4. **Reinicia MetaTrader 5**

### Paso 4: Compilar el Bot

1. **Abre MetaEditor** (F4 en MetaTrader 5)
2. **Abre el archivo** `VolumeAI_TradingBot.mq5`
3. **Presiona F7** para compilar
4. **Verifica que no hay errores** en la pestaña "Errores"
5. **Repite el proceso** para todos los archivos `.mq5`

### Paso 5: Configurar el Bot

1. **Abre MetaTrader 5**
2. **Ve a la pestaña "Expert Advisors"**
3. **Arrastra** `VolumeAI_TradingBot` al gráfico
4. **Configura los parámetros** según tu tipo de cuenta
5. **Activa "Auto Trading"** en la barra de herramientas

## ⚙️ Configuración Inicial

### Configuración Básica

1. **Selecciona el símbolo**: EURUSD, GBPUSD, USDJPY, etc.
2. **Elige el timeframe**: H1 (recomendado para principiantes)
3. **Configura los parámetros**:
   - **LotSize**: 0.1 (para cuentas de $1,000+)
   - **MaxTrades**: 3
   - **RiskPercent**: 1.5
   - **StopLoss**: 50
   - **TakeProfit**: 100

### Configuración por Tipo de Cuenta

#### Cuenta Micro ($100 - $1,000)
```
LotSize = 0.01
MaxTrades = 2
RiskPercent = 1.0
StopLoss = 30
TakeProfit = 60
VolumeThreshold = 1.2
AI_ConfidenceThreshold = 0.6
```

#### Cuenta Estándar ($1,000 - $10,000)
```
LotSize = 0.1
MaxTrades = 3
RiskPercent = 1.5
StopLoss = 50
TakeProfit = 100
VolumeThreshold = 1.5
AI_ConfidenceThreshold = 0.7
```

#### Cuenta Profesional ($10,000+)
```
LotSize = 0.5
MaxTrades = 5
RiskPercent = 2.0
StopLoss = 50
TakeProfit = 100
VolumeThreshold = 1.5
AI_ConfidenceThreshold = 0.7
```

## 🔧 Solución de Problemas Comunes

### Error: "No se puede compilar"
**Solución**:
1. Verifica que MetaTrader 5 esté actualizado
2. Asegúrate de que todos los archivos estén en la carpeta correcta
3. Revisa la sintaxis del código
4. Reinicia MetaTrader 5

### Error: "Auto Trading no está permitido"
**Solución**:
1. Ve a `Herramientas > Opciones > Expert Advisors`
2. Marca "Permitir trading automático"
3. Marca "Permitir importación de DLL"
4. Reinicia MetaTrader 5

### Error: "No hay datos de volumen"
**Solución**:
1. Verifica que tu broker proporcione datos de volumen
2. Cambia a un símbolo con datos de volumen disponibles
3. Verifica tu conexión a internet
4. Contacta a tu broker para confirmar disponibilidad de datos

### El bot no abre trades
**Solución**:
1. Verifica que "Auto Trading" esté activado
2. Revisa los parámetros de volumen
3. Asegúrate de que el horario de trading esté configurado correctamente
4. Verifica que el spread no sea muy alto

## 📊 Verificación de la Instalación

### Lista de Verificación

- [ ] MetaTrader 5 instalado y funcionando
- [ ] Archivos del bot copiados a la carpeta correcta
- [ ] Bot compilado sin errores
- [ ] Auto Trading activado
- [ ] Parámetros configurados según el tipo de cuenta
- [ ] Conexión a internet estable
- [ ] Datos de volumen disponibles

### Prueba Básica

1. **Abre el bot** en un gráfico de EURUSD H1
2. **Configura parámetros conservadores**:
   - LotSize: 0.01
   - MaxTrades: 1
   - RiskPercent: 0.5
3. **Activa el bot** y observa los logs
4. **Verifica** que aparezcan mensajes de inicialización
5. **Espera** a que el bot analice el mercado

## 🚨 Advertencias Importantes

### Antes de Usar el Bot

1. **NUNCA** uses el bot con dinero real sin haberlo probado primero
2. **SIEMPRE** haz backtesting antes de trading en vivo
3. **CONFIGURA** stops de pérdida apropiados
4. **MONITOREA** el bot regularmente
5. **MANTÉN** un registro de todos los trades

### Configuración de Seguridad

1. **Usa cuentas demo** para pruebas iniciales
2. **Configura límites** de pérdida diaria
3. **No arriesgues** más del 2% de tu capital por trade
4. **Mantén** copias de seguridad de tu configuración
5. **Actualiza** regularmente el bot

## 📞 Soporte Técnico

### Si Necesitas Ayuda

1. **Revisa** esta documentación primero
2. **Consulta** los logs del bot en MetaTrader 5
3. **Verifica** la configuración de tu cuenta
4. **Contacta** a tu broker si hay problemas de datos
5. **Busca** en foros de trading para problemas similares

### Recursos Adicionales

- **Documentación oficial** de MetaTrader 5
- **Foros de trading** en MQL5.com
- **Tutoriales** de trading automatizado
- **Guías** de gestión de riesgo

---

**¡Instalación completada! 🎉**

Ahora puedes proceder con la configuración avanzada del bot. Recuerda siempre probar primero en cuenta demo antes de usar dinero real.
