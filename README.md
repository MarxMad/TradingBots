# VolumeAI Trading Bot - MQL5

## 🚀 Descripción

VolumeAI Trading Bot es un sistema de trading automatizado avanzado para MetaTrader 5 que utiliza inteligencia artificial y análisis de volumen para generar rendimientos mensuales del 30%. El bot combina múltiples estrategias de trading con un sistema de IA que aprende de los patrones de volumen del mercado.

## ✨ Características Principales

### 🤖 Sistema de IA Integrado
- **Análisis de patrones de volumen**: Detecta patrones de acumulación, distribución y breakout
- **Correlación precio-volumen**: Analiza la relación entre movimientos de precio y volumen
- **Predicción de tendencias**: Utiliza algoritmos de machine learning para predecir movimientos futuros
- **Confianza adaptativa**: El sistema ajusta su confianza según las condiciones del mercado

### 📊 Estrategias de Trading Múltiples
1. **Scalping con Volumen**: Trading de alta frecuencia basado en spikes de volumen
2. **Swing Trading**: Posiciones de mediano plazo con confirmación de volumen
3. **Breakout Trading**: Detección de rupturas de consolidación con volumen confirmatorio
4. **Mean Reversion**: Trading contrario basado en desviaciones extremas
5. **Momentum Trading**: Seguimiento de tendencias con confirmación de volumen

### 🛡️ Gestión de Riesgo Avanzada
- **Money Management**: Cálculo automático del tamaño de posición basado en el riesgo
- **Stop Loss Dinámico**: Ajuste automático de stops según la volatilidad
- **Trailing Stop**: Protección de ganancias con stops móviles
- **Control de Drawdown**: Límites automáticos de pérdida máxima

### 📈 Sistema de Backtesting
- **Backtesting Histórico**: Prueba de estrategias con datos históricos
- **Optimización de Parámetros**: Búsqueda automática de la mejor configuración
- **Reportes Detallados**: Análisis completo de rendimiento y estadísticas
- **Validación Cruzada**: Prueba de robustez en diferentes períodos

## 📁 Estructura del Proyecto

```
TradingBot/
├── VolumeAI_TradingBot.mq5          # Bot principal
├── VolumeAI_Strategies.mq5          # Estrategias especializadas
├── VolumeAI_Backtester.mq5          # Sistema de backtesting
├── VolumeAI_Config.mq5              # Archivo de configuración
├── README.md                        # Documentación
└── docs/                           # Documentación adicional
    ├── Installation.md
    ├── Configuration.md
    └── Troubleshooting.md
```

## 🚀 Instalación

### Requisitos Previos
- MetaTrader 5 (versión 5.0 o superior)
- Cuenta de trading con acceso a datos de volumen
- Mínimo $1,000 USD de capital inicial (recomendado $10,000+)

### Pasos de Instalación

1. **Descargar archivos**:
   - Copia todos los archivos `.mq5` a la carpeta `MQL5/Experts/` de MetaTrader 5
   - Copia los archivos de documentación a una carpeta de tu elección

2. **Compilar el bot**:
   - Abre MetaEditor en MetaTrader 5
   - Abre `VolumeAI_TradingBot.mq5`
   - Presiona F7 para compilar
   - Repite para `VolumeAI_Strategies.mq5` y `VolumeAI_Backtester.mq5`

3. **Configurar parámetros**:
   - Abre el bot en MetaTrader 5
   - Ajusta los parámetros según tu cuenta y preferencias
   - Consulta la sección de configuración para más detalles

## ⚙️ Configuración

### Parámetros Principales

#### Configuración General
- **LotSize**: Tamaño del lote (recomendado: 0.1 para cuentas pequeñas)
- **MagicNumber**: Número mágico único para identificar trades
- **MaxTrades**: Máximo número de trades simultáneos (recomendado: 3-5)
- **RiskPercent**: Porcentaje de riesgo por trade (recomendado: 1-2%)

#### Configuración de Volumen
- **VolumePeriod**: Período para análisis de volumen (recomendado: 20)
- **VolumeThreshold**: Umbral de volumen (recomendado: 1.5)
- **VolumeMA_Period**: Período de media móvil de volumen (recomendado: 10)

#### Configuración de IA
- **AI_ConfidenceThreshold**: Umbral de confianza de IA (recomendado: 0.7)
- **LearningPeriod**: Período de aprendizaje de IA (recomendado: 100)

### Configuración Recomendada por Tipo de Cuenta

#### Cuenta Micro ($100 - $1,000)
```
LotSize = 0.01
MaxTrades = 2
RiskPercent = 1.0
StopLoss = 30
TakeProfit = 60
```

#### Cuenta Estándar ($1,000 - $10,000)
```
LotSize = 0.1
MaxTrades = 3
RiskPercent = 1.5
StopLoss = 50
TakeProfit = 100
```

#### Cuenta Profesional ($10,000+)
```
LotSize = 0.5
MaxTrades = 5
RiskPercent = 2.0
StopLoss = 50
TakeProfit = 100
```

## 📊 Uso del Sistema

### 1. Iniciar el Bot
1. Abre MetaTrader 5
2. Ve a la pestaña "Expert Advisors"
3. Arrastra `VolumeAI_TradingBot` al gráfico
4. Configura los parámetros
5. Activa "Auto Trading"

### 2. Monitorear el Rendimiento
- El bot mostrará información en tiempo real en la pestaña "Experts"
- Revisa los logs para ver las decisiones de trading
- Monitorea el balance y equity en tiempo real

### 3. Backtesting
1. Abre `VolumeAI_Backtester.mq5` como script
2. Configura las fechas de inicio y fin
3. Ejecuta el script
4. Revisa el reporte generado

## 📈 Estrategias Implementadas

### 1. Scalping con Volumen
- **Timeframe**: M1, M5
- **Objetivo**: 5-15 pips por trade
- **Características**: Entrada rápida, salida rápida, alta frecuencia

### 2. Swing Trading
- **Timeframe**: H1, H4
- **Objetivo**: 50-200 pips por trade
- **Características**: Posiciones de 1-3 días, confirmación de volumen

### 3. Breakout Trading
- **Timeframe**: H1, H4, D1
- **Objetivo**: 100-500 pips por trade
- **Características**: Detección de rupturas, confirmación de volumen

### 4. Mean Reversion
- **Timeframe**: H1, H4
- **Objetivo**: 30-100 pips por trade
- **Características**: Trading contrario, reversión a la media

### 5. Momentum Trading
- **Timeframe**: H1, H4, D1
- **Objetivo**: 100-300 pips por trade
- **Características**: Seguimiento de tendencias, confirmación de volumen

## 🛡️ Gestión de Riesgo

### Principios Fundamentales
1. **Nunca arriesgar más del 2% del capital por trade**
2. **Máximo 5 trades simultáneos**
3. **Stop Loss obligatorio en cada trade**
4. **Trailing Stop para proteger ganancias**

### Configuración de Riesgo
- **Stop Loss**: 30-100 pips según la estrategia
- **Take Profit**: 1:2 o 1:3 ratio de riesgo/recompensa
- **Drawdown Máximo**: 10% del capital
- **Pausa de Trading**: Después de 3 pérdidas consecutivas

## 📊 Métricas de Rendimiento

### Objetivos Mensuales
- **Rendimiento Objetivo**: 30% mensual
- **Tasa de Ganancia**: 60%+
- **Factor de Profit**: 2.0+
- **Drawdown Máximo**: 10%

### Métricas Clave
- **Sharpe Ratio**: > 1.5
- **Sortino Ratio**: > 2.0
- **Calmar Ratio**: > 3.0
- **Máximo Drawdown**: < 10%

## 🔧 Solución de Problemas

### Problemas Comunes

#### El bot no abre trades
- Verificar que "Auto Trading" esté activado
- Revisar los parámetros de volumen
- Comprobar que el spread no sea muy alto
- Verificar el horario de trading

#### Trades con pérdidas frecuentes
- Ajustar el umbral de confianza de IA
- Revisar los parámetros de volumen
- Considerar cambiar de estrategia
- Verificar las condiciones del mercado

#### Errores de compilación
- Verificar que todas las librerías estén incluidas
- Comprobar la sintaxis del código
- Actualizar MetaTrader 5 a la última versión

## 📞 Soporte

### Recursos de Ayuda
- **Documentación**: Consulta los archivos en la carpeta `docs/`
- **Logs**: Revisa los logs en MetaTrader 5
- **Backtesting**: Usa el sistema de backtesting para probar configuraciones

### Contacto
Para soporte técnico o preguntas sobre el bot, consulta la documentación o revisa los logs del sistema.

## ⚠️ Disclaimer

**ADVERTENCIA**: El trading de divisas conlleva un alto nivel de riesgo y puede no ser adecuado para todos los inversores. El alto grado de apalancamiento puede actuar en contra del inversor y a su favor. Antes de decidir operar en el mercado de divisas, debe considerar cuidadosamente sus objetivos de inversión, nivel de experiencia y tolerancia al riesgo. Existe la posibilidad de que pierda parte o la totalidad de su inversión inicial y, por lo tanto, no debe invertir dinero que no puede permitirse perder.

Los resultados pasados no garantizan resultados futuros. El bot de trading es una herramienta de asistencia y no garantiza ganancias. Siempre opere con responsabilidad y dentro de sus posibilidades financieras.

## 📄 Licencia

Copyright © 2024 VolumeAI Trading Bot. Todos los derechos reservados.

---

**¡Buena suerte con tu trading! 🚀📈**
