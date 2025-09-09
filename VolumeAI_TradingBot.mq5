//+------------------------------------------------------------------+
//|                                           VolumeAI_TradingBot.mq5 |
//|                        Copyright 2024, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property description "Bot de Trading con IA basado en Análisis de Volumen"
#property description "Objetivo: 30% rendimiento mensual"

//--- Incluir librerías necesarias
#include <Trade\Trade.mqh>
#include <Math\Stat\Math.mqh>

//--- Parámetros de entrada
input group "=== CONFIGURACIÓN GENERAL ==="
input double   LotSize = 0.1;                    // Tamaño del lote
input int      MagicNumber = 123456;             // Número mágico
input int      MaxTrades = 5;                    // Máximo número de trades simultáneos
input double   RiskPercent = 2.0;                // Porcentaje de riesgo por trade
input int      StopLoss = 50;                    // Stop Loss en pips
input int      TakeProfit = 100;                 // Take Profit en pips

input group "=== CONFIGURACIÓN DE VOLUMEN ==="
input int      VolumePeriod = 20;                // Período para análisis de volumen
input double   VolumeThreshold = 1.5;            // Umbral de volumen (múltiplo del promedio)
input int      VolumeMA_Period = 10;             // Período de media móvil de volumen
input bool     UseVolumeFilter = true;           // Usar filtro de volumen

input group "=== CONFIGURACIÓN DE IA ==="
input int      AI_PredictionPeriod = 10;         // Período para predicción de IA
input double   AI_ConfidenceThreshold = 0.7;     // Umbral de confianza de IA
input bool     UseAI = true;                     // Activar sistema de IA
input int      LearningPeriod = 100;             // Período de aprendizaje de IA

input group "=== CONFIGURACIÓN DE TIEMPO ==="
input int      StartHour = 8;                    // Hora de inicio de trading
input int      EndHour = 18;                     // Hora de fin de trading
input bool     TradeOnNews = false;              // Trading durante noticias
input bool     TradeOnFriday = true;             // Trading los viernes

//--- Variables globales
CTrade trade;
double accountBalance;
double accountEquity;
int totalTrades = 0;
int winningTrades = 0;
double totalProfit = 0.0;
double monthlyTarget = 0.0;
datetime lastTradeTime = 0;

//--- Arrays para IA
double priceHistory[];
double volumeHistory[];
double aiPredictions[];
double aiConfidence[];

//--- Indicadores
int volumeHandle;
int volumeMAHandle;
int rsiHandle;
int macdHandle;
int bollingerHandle;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
    //--- Configurar trade
    trade.SetExpertMagicNumber(MagicNumber);
    trade.SetDeviationInPoints(10);
    trade.SetTypeFilling(ORDER_FILLING_FOK);
    
    //--- Inicializar indicadores
    volumeHandle = iVolumes(_Symbol, PERIOD_CURRENT);
    volumeMAHandle = iMA(_Symbol, PERIOD_CURRENT, VolumeMA_Period, 0, MODE_SMA, PRICE_VOLUME);
    rsiHandle = iRSI(_Symbol, PERIOD_CURRENT, 14, PRICE_CLOSE);
    macdHandle = iMACD(_Symbol, PERIOD_CURRENT, 12, 26, 9, PRICE_CLOSE);
    bollingerHandle = iBands(_Symbol, PERIOD_CURRENT, 20, 0, 2, PRICE_CLOSE);
    
    if(volumeHandle == INVALID_HANDLE || volumeMAHandle == INVALID_HANDLE)
    {
        Print("Error al inicializar indicadores de volumen");
        return INIT_FAILED;
    }
    
    //--- Inicializar arrays para IA
    ArrayResize(priceHistory, LearningPeriod);
    ArrayResize(volumeHistory, LearningPeriod);
    ArrayResize(aiPredictions, AI_PredictionPeriod);
    ArrayResize(aiConfidence, AI_PredictionPeriod);
    
    //--- Calcular objetivo mensual
    accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
    monthlyTarget = accountBalance * 0.30; // 30% mensual
    
    Print("=== VolumeAI Trading Bot Iniciado ===");
    Print("Balance inicial: $", DoubleToString(accountBalance, 2));
    Print("Objetivo mensual: $", DoubleToString(monthlyTarget, 2));
    Print("Sistema de IA: ", UseAI ? "ACTIVADO" : "DESACTIVADO");
    
    return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
    //--- Liberar handles de indicadores
    if(volumeHandle != INVALID_HANDLE) IndicatorRelease(volumeHandle);
    if(volumeMAHandle != INVALID_HANDLE) IndicatorRelease(volumeMAHandle);
    if(rsiHandle != INVALID_HANDLE) IndicatorRelease(rsiHandle);
    if(macdHandle != INVALID_HANDLE) IndicatorRelease(macdHandle);
    if(bollingerHandle != INVALID_HANDLE) IndicatorRelease(bollingerHandle);
    
    Print("=== VolumeAI Trading Bot Detenido ===");
    Print("Trades totales: ", totalTrades);
    Print("Trades ganadores: ", winningTrades);
    Print("Profit total: $", DoubleToString(totalProfit, 2));
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
    //--- Verificar si es hora de trading
    if(!IsTimeToTrade()) return;
    
    //--- Actualizar datos de cuenta
    accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
    accountEquity = AccountInfoDouble(ACCOUNT_EQUITY);
    
    //--- Verificar si ya tenemos suficientes trades abiertos
    if(CountOpenTrades() >= MaxTrades) return;
    
    //--- Obtener datos de volumen
    double currentVolume = GetCurrentVolume();
    double avgVolume = GetAverageVolume();
    
    //--- Verificar filtro de volumen
    if(UseVolumeFilter && currentVolume < avgVolume * VolumeThreshold) return;
    
    //--- Análisis de IA
    double aiSignal = 0.0;
    double confidence = 0.0;
    
    if(UseAI)
    {
        aiSignal = GetAISignal();
        confidence = GetAIConfidence();
        
        if(confidence < AI_ConfidenceThreshold) return;
    }
    
    //--- Análisis técnico tradicional
    double technicalSignal = GetTechnicalSignal();
    
    //--- Combinar señales
    double finalSignal = CombineSignals(technicalSignal, aiSignal, confidence);
    
    //--- Ejecutar trade si la señal es fuerte
    if(MathAbs(finalSignal) > 0.6)
    {
        if(finalSignal > 0)
            OpenBuyOrder();
        else
            OpenSellOrder();
    }
    
    //--- Gestionar trades existentes
    ManageOpenTrades();
}

//+------------------------------------------------------------------+
//| Verificar si es hora de trading                                  |
//+------------------------------------------------------------------+
bool IsTimeToTrade()
{
    MqlDateTime time_struct;
    TimeToStruct(TimeCurrent(), time_struct);
    
    //--- Verificar horario de trading
    if(time_struct.hour < StartHour || time_struct.hour >= EndHour)
        return false;
    
    //--- Verificar si es viernes (opcional)
    if(!TradeOnFriday && time_struct.day_of_week == 5)
        return false;
    
    //--- Verificar si hay noticias importantes (simplificado)
    if(!TradeOnNews && IsNewsTime())
        return false;
    
    return true;
}

//+------------------------------------------------------------------+
//| Obtener volumen actual                                           |
//+------------------------------------------------------------------+
double GetCurrentVolume()
{
    double volume[];
    if(CopyBuffer(volumeHandle, 0, 0, 1, volume) <= 0)
        return 0.0;
    
    return volume[0];
}

//+------------------------------------------------------------------+
//| Obtener volumen promedio                                         |
//+------------------------------------------------------------------+
double GetAverageVolume()
{
    double volumeMA[];
    if(CopyBuffer(volumeMAHandle, 0, 0, 1, volumeMA) <= 0)
        return 0.0;
    
    return volumeMA[0];
}

//+------------------------------------------------------------------+
//| Obtener señal de IA                                              |
//+------------------------------------------------------------------+
double GetAISignal()
{
    //--- Actualizar historial de precios y volumen
    UpdatePriceVolumeHistory();
    
    //--- Algoritmo de IA simplificado basado en patrones de volumen
    double signal = 0.0;
    
    //--- Análisis de tendencia de volumen
    double volumeTrend = AnalyzeVolumeTrend();
    
    //--- Análisis de correlación precio-volumen
    double priceVolumeCorrelation = AnalyzePriceVolumeCorrelation();
    
    //--- Análisis de patrones de volumen
    double volumePattern = AnalyzeVolumePatterns();
    
    //--- Combinar análisis
    signal = (volumeTrend * 0.4) + (priceVolumeCorrelation * 0.3) + (volumePattern * 0.3);
    
    //--- Normalizar señal entre -1 y 1
    signal = MathMax(-1.0, MathMin(1.0, signal));
    
    return signal;
}

//+------------------------------------------------------------------+
//| Obtener confianza de IA                                          |
//+------------------------------------------------------------------+
double GetAIConfidence()
{
    //--- Calcular confianza basada en consistencia de señales
    double confidence = 0.5; // Base
    
    //--- Añadir confianza basada en volumen
    double currentVolume = GetCurrentVolume();
    double avgVolume = GetAverageVolume();
    
    if(currentVolume > avgVolume * 2.0)
        confidence += 0.2;
    else if(currentVolume > avgVolume * 1.5)
        confidence += 0.1;
    
    //--- Añadir confianza basada en volatilidad
    double volatility = GetCurrentVolatility();
    if(volatility > 0.01) // 1% de volatilidad
        confidence += 0.1;
    
    return MathMin(1.0, confidence);
}

//+------------------------------------------------------------------+
//| Actualizar historial de precios y volumen                       |
//+------------------------------------------------------------------+
void UpdatePriceVolumeHistory()
{
    double prices[];
    double volumes[];
    
    if(CopyClose(_Symbol, PERIOD_CURRENT, 0, LearningPeriod, prices) <= 0) return;
    if(CopyBuffer(volumeHandle, 0, 0, LearningPeriod, volumes) <= 0) return;
    
    ArrayCopy(priceHistory, prices);
    ArrayCopy(volumeHistory, volumes);
}

//+------------------------------------------------------------------+
//| Analizar tendencia de volumen                                   |
//+------------------------------------------------------------------+
double AnalyzeVolumeTrend()
{
    if(ArraySize(volumeHistory) < 10) return 0.0;
    
    double sum = 0.0;
    for(int i = 0; i < 10; i++)
    {
        sum += volumeHistory[i];
    }
    double recentAvg = sum / 10.0;
    
    sum = 0.0;
    for(int i = 10; i < 20; i++)
    {
        sum += volumeHistory[i];
    }
    double olderAvg = sum / 10.0;
    
    if(olderAvg == 0) return 0.0;
    
    return (recentAvg - olderAvg) / olderAvg;
}

//+------------------------------------------------------------------+
//| Analizar correlación precio-volumen                             |
//+------------------------------------------------------------------+
double AnalyzePriceVolumeCorrelation()
{
    if(ArraySize(priceHistory) < 20 || ArraySize(volumeHistory) < 20) return 0.0;
    
    double priceChanges[];
    double volumeChanges[];
    ArrayResize(priceChanges, 19);
    ArrayResize(volumeChanges, 19);
    
    for(int i = 0; i < 19; i++)
    {
        priceChanges[i] = (priceHistory[i] - priceHistory[i+1]) / priceHistory[i+1];
        volumeChanges[i] = (volumeHistory[i] - volumeHistory[i+1]) / volumeHistory[i+1];
    }
    
    //--- Calcular correlación simple
    double correlation = 0.0;
    double sumXY = 0.0, sumX = 0.0, sumY = 0.0, sumX2 = 0.0, sumY2 = 0.0;
    
    for(int i = 0; i < 19; i++)
    {
        sumXY += priceChanges[i] * volumeChanges[i];
        sumX += priceChanges[i];
        sumY += volumeChanges[i];
        sumX2 += priceChanges[i] * priceChanges[i];
        sumY2 += volumeChanges[i] * volumeChanges[i];
    }
    
    double n = 19.0;
    double numerator = n * sumXY - sumX * sumY;
    double denominator = MathSqrt((n * sumX2 - sumX * sumX) * (n * sumY2 - sumY * sumY));
    
    if(denominator != 0)
        correlation = numerator / denominator;
    
    return correlation;
}

//+------------------------------------------------------------------+
//| Analizar patrones de volumen                                    |
//+------------------------------------------------------------------+
double AnalyzeVolumePatterns()
{
    if(ArraySize(volumeHistory) < 10) return 0.0;
    
    double signal = 0.0;
    
    //--- Patrón de acumulación (volumen creciente con precios estables)
    double volumeGrowth = 0.0;
    double priceStability = 0.0;
    
    for(int i = 0; i < 5; i++)
    {
        volumeGrowth += (volumeHistory[i] - volumeHistory[i+5]) / volumeHistory[i+5];
        priceStability += MathAbs(priceHistory[i] - priceHistory[i+5]) / priceHistory[i+5];
    }
    
    volumeGrowth /= 5.0;
    priceStability /= 5.0;
    
    if(volumeGrowth > 0.2 && priceStability < 0.05) // 20% crecimiento de volumen, 5% estabilidad de precio
        signal += 0.5;
    
    //--- Patrón de distribución (volumen alto con precios bajando)
    double recentVolume = 0.0;
    double recentPriceChange = 0.0;
    
    for(int i = 0; i < 3; i++)
    {
        recentVolume += volumeHistory[i];
        recentPriceChange += (priceHistory[i] - priceHistory[i+1]) / priceHistory[i+1];
    }
    
    recentVolume /= 3.0;
    recentPriceChange /= 3.0;
    
    double avgVolume = 0.0;
    for(int i = 3; i < 10; i++)
    {
        avgVolume += volumeHistory[i];
    }
    avgVolume /= 7.0;
    
    if(recentVolume > avgVolume * 1.5 && recentPriceChange < -0.01) // 50% más volumen, precio bajando 1%
        signal -= 0.5;
    
    return signal;
}

//+------------------------------------------------------------------+
//| Obtener volatilidad actual                                       |
//+------------------------------------------------------------------+
double GetCurrentVolatility()
{
    double prices[];
    if(CopyClose(_Symbol, PERIOD_CURRENT, 0, 20, prices) <= 0) return 0.0;
    
    double sum = 0.0;
    for(int i = 1; i < 20; i++)
    {
        double change = MathAbs(prices[i-1] - prices[i]) / prices[i];
        sum += change;
    }
    
    return sum / 19.0;
}

//+------------------------------------------------------------------+
//| Obtener señal técnica                                            |
//+------------------------------------------------------------------+
double GetTechnicalSignal()
{
    double signal = 0.0;
    
    //--- RSI
    double rsi[];
    if(CopyBuffer(rsiHandle, 0, 0, 1, rsi) > 0)
    {
        if(rsi[0] < 30) signal += 0.3;      // Sobreventa
        else if(rsi[0] > 70) signal -= 0.3; // Sobrecompra
    }
    
    //--- MACD
    double macdMain[], macdSignal[];
    if(CopyBuffer(macdHandle, 0, 0, 1, macdMain) > 0 && CopyBuffer(macdHandle, 1, 0, 1, macdSignal) > 0)
    {
        if(macdMain[0] > macdSignal[0]) signal += 0.2;
        else signal -= 0.2;
    }
    
    //--- Bollinger Bands
    double bbUpper[], bbLower[], bbMiddle[];
    if(CopyBuffer(bollingerHandle, 1, 0, 1, bbUpper) > 0 && 
       CopyBuffer(bollingerHandle, 2, 0, 1, bbLower) > 0 &&
       CopyBuffer(bollingerHandle, 0, 0, 1, bbMiddle) > 0)
    {
        double currentPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
        if(currentPrice < bbLower[0]) signal += 0.3;      // Precio cerca de banda inferior
        else if(currentPrice > bbUpper[0]) signal -= 0.3; // Precio cerca de banda superior
    }
    
    return MathMax(-1.0, MathMin(1.0, signal));
}

//+------------------------------------------------------------------+
//| Combinar señales                                                 |
//+------------------------------------------------------------------+
double CombineSignals(double technical, double ai, double confidence)
{
    if(!UseAI) return technical;
    
    //--- Ponderar señales según confianza
    double combined = (technical * (1.0 - confidence)) + (ai * confidence);
    
    return MathMax(-1.0, MathMin(1.0, combined));
}

//+------------------------------------------------------------------+
//| Abrir orden de compra                                            |
//+------------------------------------------------------------------+
void OpenBuyOrder()
{
    double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
    double sl = ask - StopLoss * _Point * 10;
    double tp = ask + TakeProfit * _Point * 10;
    
    double lotSize = CalculateLotSize();
    
    if(trade.Buy(lotSize, _Symbol, ask, sl, tp, "VolumeAI Buy"))
    {
        totalTrades++;
        lastTradeTime = TimeCurrent();
        Print("Orden de COMPRA abierta - Lote: ", lotSize, " Precio: ", ask);
    }
}

//+------------------------------------------------------------------+
//| Abrir orden de venta                                             |
//+------------------------------------------------------------------+
void OpenSellOrder()
{
    double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
    double sl = bid + StopLoss * _Point * 10;
    double tp = bid - TakeProfit * _Point * 10;
    
    double lotSize = CalculateLotSize();
    
    if(trade.Sell(lotSize, _Symbol, bid, sl, tp, "VolumeAI Sell"))
    {
        totalTrades++;
        lastTradeTime = TimeCurrent();
        Print("Orden de VENTA abierta - Lote: ", lotSize, " Precio: ", bid);
    }
}

//+------------------------------------------------------------------+
//| Calcular tamaño del lote                                         |
//+------------------------------------------------------------------+
double CalculateLotSize()
{
    double balance = AccountInfoDouble(ACCOUNT_BALANCE);
    double riskAmount = balance * (RiskPercent / 100.0);
    double tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
    double tickSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
    
    double lotSize = (riskAmount / (StopLoss * 10)) * (tickSize / tickValue);
    
    //--- Ajustar según límites del broker
    double minLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
    double maxLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
    double lotStep = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
    
    lotSize = MathMax(minLot, MathMin(maxLot, lotSize));
    lotSize = MathFloor(lotSize / lotStep) * lotStep;
    
    return lotSize;
}

//+------------------------------------------------------------------+
//| Contar trades abiertos                                           |
//+------------------------------------------------------------------+
int CountOpenTrades()
{
    int count = 0;
    for(int i = 0; i < PositionsTotal(); i++)
    {
        if(PositionGetSymbol(i) == _Symbol && PositionGetInteger(POSITION_MAGIC) == MagicNumber)
            count++;
    }
    return count;
}

//+------------------------------------------------------------------+
//| Gestionar trades abiertos                                        |
//+------------------------------------------------------------------+
void ManageOpenTrades()
{
    for(int i = PositionsTotal() - 1; i >= 0; i--)
    {
        if(PositionGetSymbol(i) == _Symbol && PositionGetInteger(POSITION_MAGIC) == MagicNumber)
        {
            ulong ticket = PositionGetInteger(POSITION_TICKET);
            double profit = PositionGetDouble(POSITION_PROFIT);
            double openPrice = PositionGetDouble(POSITION_PRICE_OPEN);
            double currentPrice = PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY ? 
                                 SymbolInfoDouble(_Symbol, SYMBOL_BID) : 
                                 SymbolInfoDouble(_Symbol, SYMBOL_ASK);
            
            //--- Trailing Stop
            if(profit > 0)
            {
                double newSL = 0.0;
                if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
                {
                    newSL = currentPrice - StopLoss * _Point * 10;
                    if(newSL > PositionGetDouble(POSITION_SL))
                    {
                        trade.PositionModify(ticket, newSL, PositionGetDouble(POSITION_TP));
                    }
                }
                else
                {
                    newSL = currentPrice + StopLoss * _Point * 10;
                    if(newSL < PositionGetDouble(POSITION_SL) || PositionGetDouble(POSITION_SL) == 0)
                    {
                        trade.PositionModify(ticket, newSL, PositionGetDouble(POSITION_TP));
                    }
                }
            }
        }
    }
}

//+------------------------------------------------------------------+
//| Verificar si es hora de noticias                                 |
//+------------------------------------------------------------------+
bool IsNewsTime()
{
    //--- Implementación simplificada
    //--- En una implementación real, conectarías con un feed de noticias
    MqlDateTime time_struct;
    TimeToStruct(TimeCurrent(), time_struct);
    
    //--- Simular noticias importantes a las 8:30 y 14:30
    if((time_struct.hour == 8 && time_struct.min >= 25 && time_struct.min <= 35) ||
       (time_struct.hour == 14 && time_struct.min >= 25 && time_struct.min <= 35))
    {
        return true;
    }
    
    return false;
}

//+------------------------------------------------------------------+
//| Función de trade cerrado                                         |
//+------------------------------------------------------------------+
void OnTradeTransaction(const MqlTradeTransaction& trans,
                       const MqlTradeRequest& request,
                       const MqlTradeResult& result)
{
    if(trans.type == TRADE_TRANSACTION_DEAL_ADD)
    {
        if(trans.symbol == _Symbol)
        {
            double profit = trans.profit;
            totalProfit += profit;
            
            if(profit > 0)
                winningTrades++;
            
            Print("Trade cerrado - Profit: $", DoubleToString(profit, 2), 
                  " - Total Profit: $", DoubleToString(totalProfit, 2));
            
            //--- Verificar objetivo mensual
            if(totalProfit >= monthlyTarget)
            {
                Print("¡OBJETIVO MENSUAL ALCANZADO! Profit: $", DoubleToString(totalProfit, 2));
            }
        }
    }
}
