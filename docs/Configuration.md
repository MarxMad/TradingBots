# Guía de Configuración - VolumeAI Trading Bot

## 🎯 Configuración por Objetivos

### Objetivo: 30% Rendimiento Mensual

Para alcanzar el objetivo de 30% mensual, necesitas configurar el bot de manera agresiva pero controlada:

```
LotSize = 0.5 (para cuentas de $10,000+)
MaxTrades = 5
RiskPercent = 2.0
StopLoss = 50
TakeProfit = 100
VolumeThreshold = 1.5
AI_ConfidenceThreshold = 0.7
```

### Objetivo: 15% Rendimiento Mensual (Conservador)

Para un enfoque más conservador:

```
LotSize = 0.2
MaxTrades = 3
RiskPercent = 1.5
StopLoss = 40
TakeProfit = 80
VolumeThreshold = 1.8
AI_ConfidenceThreshold = 0.8
```

### Objetivo: 50% Rendimiento Mensual (Agresivo)

Para traders experimentados que buscan máximo rendimiento:

```
LotSize = 1.0
MaxTrades = 8
RiskPercent = 3.0
StopLoss = 30
TakeProfit = 90
VolumeThreshold = 1.2
AI_ConfidenceThreshold = 0.6
```

## 📊 Configuración por Símbolo

### EURUSD (Recomendado para Principiantes)

**Características**:
- Spread bajo (1-2 pips)
- Alta liquidez
- Volatilidad moderada
- Datos de volumen confiables

**Configuración Óptima**:
```
LotSize = 0.1
StopLoss = 50
TakeProfit = 100
VolumeThreshold = 1.5
VolumePeriod = 20
StartHour = 8
EndHour = 18
```

### GBPUSD (Para Traders Experimentados)

**Características**:
- Spread medio (2-3 pips)
- Alta volatilidad
- Movimientos fuertes
- Requiere gestión de riesgo estricta

**Configuración Óptima**:
```
LotSize = 0.1
StopLoss = 60
TakeProfit = 120
VolumeThreshold = 1.8
VolumePeriod = 25
StartHour = 8
EndHour = 18
```

### USDJPY (Para Trading Asiático)

**Características**:
- Spread bajo (1-2 pips)
- Volatilidad moderada
- Mejor rendimiento en sesión asiática
- Movimientos suaves

**Configuración Óptima**:
```
LotSize = 0.1
StopLoss = 40
TakeProfit = 80
VolumeThreshold = 1.3
VolumePeriod = 18
StartHour = 0
EndHour = 8
```

## ⏰ Configuración por Horario

### Sesión Europea (8:00 - 16:00 GMT)

**Mejor para**: EURUSD, GBPUSD, EURJPY
**Configuración**:
```
StartHour = 8
EndHour = 16
VolumeThreshold = 1.5
AI_ConfidenceThreshold = 0.7
```

### Sesión Americana (13:00 - 21:00 GMT)

**Mejor para**: USDJPY, USDCHF, USDCAD
**Configuración**:
```
StartHour = 13
EndHour = 21
VolumeThreshold = 1.3
AI_ConfidenceThreshold = 0.6
```

### Sesión Asiática (0:00 - 8:00 GMT)

**Mejor para**: USDJPY, AUDUSD, NZDUSD
**Configuración**:
```
StartHour = 0
EndHour = 8
VolumeThreshold = 1.2
AI_ConfidenceThreshold = 0.8
```

### Trading 24/7 (Solo para VPS)

**Configuración**:
```
StartHour = 0
EndHour = 23
VolumeThreshold = 1.5
AI_ConfidenceThreshold = 0.7
TradeOnNews = false
```

## 🧠 Configuración de IA

### IA Conservadora (Alta Confianza)

**Para traders que prefieren menos trades pero más precisos**:
```
AI_ConfidenceThreshold = 0.8
LearningPeriod = 150
UseAI = true
VolumeThreshold = 2.0
```

### IA Moderada (Confianza Media)

**Para el equilibrio entre frecuencia y precisión**:
```
AI_ConfidenceThreshold = 0.7
LearningPeriod = 100
UseAI = true
VolumeThreshold = 1.5
```

### IA Agresiva (Baja Confianza)

**Para traders que buscan máxima frecuencia**:
```
AI_ConfidenceThreshold = 0.6
LearningPeriod = 50
UseAI = true
VolumeThreshold = 1.2
```

## 📈 Configuración de Estrategias

### Scalping (M1, M5)

**Configuración**:
```
Timeframe = M1
LotSize = 0.01
StopLoss = 10
TakeProfit = 20
VolumeThreshold = 2.0
MaxTrades = 3
UseSpreadFilter = true
MaxSpread = 2.0
```

### Swing Trading (H1, H4)

**Configuración**:
```
Timeframe = H1
LotSize = 0.1
StopLoss = 100
TakeProfit = 200
VolumeThreshold = 1.5
MaxTrades = 2
TrendPeriod = 50
```

### Breakout Trading (H1, H4, D1)

**Configuración**:
```
Timeframe = H1
LotSize = 0.1
StopLoss = 80
TakeProfit = 160
VolumeThreshold = 1.8
MaxTrades = 2
ConsolidationPeriod = 20
```

## 🛡️ Configuración de Gestión de Riesgo

### Gestión de Riesgo Conservadora

**Para preservar el capital**:
```
MaxRiskPerTrade = 1.0%
MaxDailyRisk = 3.0%
MaxWeeklyRisk = 10.0%
MaxDrawdown = 5.0%
MaxConsecutiveLosses = 2
```

### Gestión de Riesgo Moderada

**Para crecimiento sostenido**:
```
MaxRiskPerTrade = 2.0%
MaxDailyRisk = 5.0%
MaxWeeklyRisk = 15.0%
MaxDrawdown = 10.0%
MaxConsecutiveLosses = 3
```

### Gestión de Riesgo Agresiva

**Para máximo crecimiento**:
```
MaxRiskPerTrade = 3.0%
MaxDailyRisk = 8.0%
MaxWeeklyRisk = 25.0%
MaxDrawdown = 15.0%
MaxConsecutiveLosses = 5
```

## 🔧 Configuración Avanzada

### Optimización de Parámetros

1. **Usa el backtester** para probar diferentes configuraciones
2. **Optimiza** un parámetro a la vez
3. **Valida** los resultados con datos out-of-sample
4. **Documenta** las mejores configuraciones

### Configuración por Condiciones de Mercado

#### Mercado Trending (Tendencia Fuerte)
```
VolumeThreshold = 1.2
AI_ConfidenceThreshold = 0.6
StopLoss = 40
TakeProfit = 120
```

#### Mercado Ranging (Lateral)
```
VolumeThreshold = 1.8
AI_ConfidenceThreshold = 0.8
StopLoss = 30
TakeProfit = 60
```

#### Mercado Volátil (Alta Volatilidad)
```
VolumeThreshold = 2.0
AI_ConfidenceThreshold = 0.9
StopLoss = 60
TakeProfit = 180
```

## 📊 Monitoreo y Ajustes

### Métricas a Monitorear

1. **Tasa de Ganancia**: Debe ser > 60%
2. **Factor de Profit**: Debe ser > 2.0
3. **Drawdown Máximo**: Debe ser < 10%
4. **Sharpe Ratio**: Debe ser > 1.5

### Ajustes Basados en Rendimiento

#### Si la Tasa de Ganancia < 50%
- Aumentar `AI_ConfidenceThreshold` a 0.8
- Aumentar `VolumeThreshold` a 2.0
- Reducir `MaxTrades` a 2

#### Si el Drawdown > 15%
- Reducir `RiskPercent` a 1.0
- Reducir `LotSize` a la mitad
- Aumentar `StopLoss` en 20%

#### Si el Factor de Profit < 1.5
- Aumentar `TakeProfit` en 50%
- Reducir `StopLoss` en 25%
- Aumentar `AI_ConfidenceThreshold` a 0.8

## 🚨 Configuraciones de Emergencia

### Parada de Emergencia

Si el bot está perdiendo dinero consistentemente:

1. **Detén el bot** inmediatamente
2. **Cierra todas las posiciones** manualmente
3. **Revisa la configuración** y ajusta los parámetros
4. **Haz backtesting** con la nueva configuración
5. **Reinicia** solo después de validar

### Configuración de Recuperación

Para recuperar pérdidas:

```
LotSize = 0.05 (reducido)
MaxTrades = 1
RiskPercent = 0.5
StopLoss = 30
TakeProfit = 60
AI_ConfidenceThreshold = 0.9
```

## 📝 Plantillas de Configuración

### Plantilla para Principiantes

```
// Configuración Conservadora
LotSize = 0.01
MaxTrades = 2
RiskPercent = 1.0
StopLoss = 40
TakeProfit = 80
VolumeThreshold = 1.8
AI_ConfidenceThreshold = 0.8
VolumePeriod = 25
StartHour = 9
EndHour = 17
UseVolumeFilter = true
UseAI = true
```

### Plantilla para Intermedios

```
// Configuración Moderada
LotSize = 0.1
MaxTrades = 3
RiskPercent = 1.5
StopLoss = 50
TakeProfit = 100
VolumeThreshold = 1.5
AI_ConfidenceThreshold = 0.7
VolumePeriod = 20
StartHour = 8
EndHour = 18
UseVolumeFilter = true
UseAI = true
```

### Plantilla para Avanzados

```
// Configuración Agresiva
LotSize = 0.5
MaxTrades = 5
RiskPercent = 2.0
StopLoss = 50
TakeProfit = 100
VolumeThreshold = 1.5
AI_ConfidenceThreshold = 0.7
VolumePeriod = 20
StartHour = 8
EndHour = 20
UseVolumeFilter = true
UseAI = true
```

## 🔄 Proceso de Optimización

### Paso 1: Backtesting Inicial
1. Ejecuta backtesting con configuración por defecto
2. Analiza los resultados
3. Identifica áreas de mejora

### Paso 2: Optimización Iterativa
1. Ajusta un parámetro a la vez
2. Ejecuta backtesting con el nuevo parámetro
3. Compara resultados
4. Mantén la mejor configuración

### Paso 3: Validación
1. Prueba en cuenta demo
2. Monitorea por 1-2 semanas
3. Ajusta según sea necesario
4. Implementa en cuenta real

---

**¡Configuración completada! 🎯**

Recuerda que la configuración óptima depende de tu estilo de trading, tolerancia al riesgo y condiciones del mercado. Siempre prueba primero en cuenta demo antes de usar dinero real.
