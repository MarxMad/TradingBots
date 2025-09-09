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
    
    //--- Crear interfaz gráfica
    CreateGUI();
    
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
    
    //--- Eliminar interfaz gráfica
    DeleteGUI();
    
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
    
    //--- Actualizar interfaz gráfica
    UpdateGUI();
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

//+------------------------------------------------------------------+
//| Crear interfaz gráfica                                           |
//+------------------------------------------------------------------+
void CreateGUI()
{
    //--- Crear panel principal
    ObjectCreate(0, "VolumeAI_Panel", OBJ_RECTANGLE_LABEL, 0, 0, 0);
    ObjectSetInteger(0, "VolumeAI_Panel", OBJPROP_CORNER, CORNER_LEFT_UPPER);
    ObjectSetInteger(0, "VolumeAI_Panel", OBJPROP_XDISTANCE, 10);
    ObjectSetInteger(0, "VolumeAI_Panel", OBJPROP_YDISTANCE, 30);
    ObjectSetInteger(0, "VolumeAI_Panel", OBJPROP_XSIZE, 400);
    ObjectSetInteger(0, "VolumeAI_Panel", OBJPROP_YSIZE, 500);
    ObjectSetInteger(0, "VolumeAI_Panel", OBJPROP_BGCOLOR, C'25,25,35');
    ObjectSetInteger(0, "VolumeAI_Panel", OBJPROP_BORDER_COLOR, C'0,150,255');
    ObjectSetInteger(0, "VolumeAI_Panel", OBJPROP_BORDER_TYPE, BORDER_FLAT);
    ObjectSetInteger(0, "VolumeAI_Panel", OBJPROP_WIDTH, 2);
    ObjectSetInteger(0, "VolumeAI_Panel", OBJPROP_BACK, false);
    ObjectSetInteger(0, "VolumeAI_Panel", OBJPROP_SELECTABLE, false);
    ObjectSetInteger(0, "VolumeAI_Panel", OBJPROP_SELECTED, false);
    ObjectSetInteger(0, "VolumeAI_Panel", OBJPROP_HIDDEN, true);
    
    //--- Título principal
    ObjectCreate(0, "VolumeAI_Title", OBJ_LABEL, 0, 0, 0);
    ObjectSetInteger(0, "VolumeAI_Title", OBJPROP_CORNER, CORNER_LEFT_UPPER);
    ObjectSetInteger(0, "VolumeAI_Title", OBJPROP_XDISTANCE, 20);
    ObjectSetInteger(0, "VolumeAI_Title", OBJPROP_YDISTANCE, 40);
    ObjectSetString(0, "VolumeAI_Title", OBJPROP_TEXT, "🤖 VolumeAI Trading Bot");
    ObjectSetString(0, "VolumeAI_Title", OBJPROP_FONT, "Arial Bold");
    ObjectSetInteger(0, "VolumeAI_Title", OBJPROP_FONTSIZE, 14);
    ObjectSetInteger(0, "VolumeAI_Title", OBJPROP_COLOR, C'0,255,255');
    
    //--- Estado del bot
    ObjectCreate(0, "VolumeAI_Status", OBJ_LABEL, 0, 0, 0);
    ObjectSetInteger(0, "VolumeAI_Status", OBJPROP_CORNER, CORNER_LEFT_UPPER);
    ObjectSetInteger(0, "VolumeAI_Status", OBJPROP_XDISTANCE, 20);
    ObjectSetInteger(0, "VolumeAI_Status", OBJPROP_YDISTANCE, 65);
    ObjectSetString(0, "VolumeAI_Status", OBJPROP_TEXT, "Estado: ACTIVO");
    ObjectSetString(0, "VolumeAI_Status", OBJPROP_FONT, "Arial");
    ObjectSetInteger(0, "VolumeAI_Status", OBJPROP_FONTSIZE, 10);
    ObjectSetInteger(0, "VolumeAI_Status", OBJPROP_COLOR, C'0,255,0');
    
    //--- Balance actual
    ObjectCreate(0, "VolumeAI_Balance", OBJ_LABEL, 0, 0, 0);
    ObjectSetInteger(0, "VolumeAI_Balance", OBJPROP_CORNER, CORNER_LEFT_UPPER);
    ObjectSetInteger(0, "VolumeAI_Balance", OBJPROP_XDISTANCE, 20);
    ObjectSetInteger(0, "VolumeAI_Balance", OBJPROP_YDISTANCE, 85);
    ObjectSetString(0, "VolumeAI_Balance", OBJPROP_TEXT, "Balance: $0.00");
    ObjectSetString(0, "VolumeAI_Balance", OBJPROP_FONT, "Arial");
    ObjectSetInteger(0, "VolumeAI_Balance", OBJPROP_FONTSIZE, 10);
    ObjectSetInteger(0, "VolumeAI_Balance", OBJPROP_COLOR, C'255,255,255');
    
    //--- Profit total
    ObjectCreate(0, "VolumeAI_Profit", OBJ_LABEL, 0, 0, 0);
    ObjectSetInteger(0, "VolumeAI_Profit", OBJPROP_CORNER, CORNER_LEFT_UPPER);
    ObjectSetInteger(0, "VolumeAI_Profit", OBJPROP_XDISTANCE, 20);
    ObjectSetInteger(0, "VolumeAI_Profit", OBJPROP_YDISTANCE, 105);
    ObjectSetString(0, "VolumeAI_Profit", OBJPROP_TEXT, "Profit: $0.00");
    ObjectSetString(0, "VolumeAI_Profit", OBJPROP_FONT, "Arial");
    ObjectSetInteger(0, "VolumeAI_Profit", OBJPROP_FONTSIZE, 10);
    ObjectSetInteger(0, "VolumeAI_Profit", OBJPROP_COLOR, C'0,255,0');
    
    //--- Trades abiertos
    ObjectCreate(0, "VolumeAI_Trades", OBJ_LABEL, 0, 0, 0);
    ObjectSetInteger(0, "VolumeAI_Trades", OBJPROP_CORNER, CORNER_LEFT_UPPER);
    ObjectSetInteger(0, "VolumeAI_Trades", OBJPROP_XDISTANCE, 20);
    ObjectSetInteger(0, "VolumeAI_Trades", OBJPROP_YDISTANCE, 125);
    ObjectSetString(0, "VolumeAI_Trades", OBJPROP_TEXT, "Trades Abiertos: 0");
    ObjectSetString(0, "VolumeAI_Trades", OBJPROP_FONT, "Arial");
    ObjectSetInteger(0, "VolumeAI_Trades", OBJPROP_FONTSIZE, 10);
    ObjectSetInteger(0, "VolumeAI_Trades", OBJPROP_COLOR, C'255,255,0');
    
    //--- Tasa de ganancia
    ObjectCreate(0, "VolumeAI_WinRate", OBJ_LABEL, 0, 0, 0);
    ObjectSetInteger(0, "VolumeAI_WinRate", OBJPROP_CORNER, CORNER_LEFT_UPPER);
    ObjectSetInteger(0, "VolumeAI_WinRate", OBJPROP_XDISTANCE, 20);
    ObjectSetInteger(0, "VolumeAI_WinRate", OBJPROP_YDISTANCE, 145);
    ObjectSetString(0, "VolumeAI_WinRate", OBJPROP_TEXT, "Tasa Ganancia: 0%");
    ObjectSetString(0, "VolumeAI_WinRate", OBJPROP_FONT, "Arial");
    ObjectSetInteger(0, "VolumeAI_WinRate", OBJPROP_FONTSIZE, 10);
    ObjectSetInteger(0, "VolumeAI_WinRate", OBJPROP_COLOR, C'255,165,0');
    
    //--- Señal de IA
    ObjectCreate(0, "VolumeAI_AISignal", OBJ_LABEL, 0, 0, 0);
    ObjectSetInteger(0, "VolumeAI_AISignal", OBJPROP_CORNER, CORNER_LEFT_UPPER);
    ObjectSetInteger(0, "VolumeAI_AISignal", OBJPROP_XDISTANCE, 20);
    ObjectSetInteger(0, "VolumeAI_AISignal", OBJPROP_YDISTANCE, 165);
    ObjectSetString(0, "VolumeAI_AISignal", OBJPROP_TEXT, "Señal IA: NEUTRAL");
    ObjectSetString(0, "VolumeAI_AISignal", OBJPROP_FONT, "Arial");
    ObjectSetInteger(0, "VolumeAI_AISignal", OBJPROP_FONTSIZE, 10);
    ObjectSetInteger(0, "VolumeAI_AISignal", OBJPROP_COLOR, C'128,128,128');
    
    //--- Confianza de IA
    ObjectCreate(0, "VolumeAI_AIConfidence", OBJ_LABEL, 0, 0, 0);
    ObjectSetInteger(0, "VolumeAI_AIConfidence", OBJPROP_CORNER, CORNER_LEFT_UPPER);
    ObjectSetInteger(0, "VolumeAI_AIConfidence", OBJPROP_XDISTANCE, 20);
    ObjectSetInteger(0, "VolumeAI_AIConfidence", OBJPROP_YDISTANCE, 185);
    ObjectSetString(0, "VolumeAI_AIConfidence", OBJPROP_TEXT, "Confianza IA: 0%");
    ObjectSetString(0, "VolumeAI_AIConfidence", OBJPROP_FONT, "Arial");
    ObjectSetInteger(0, "VolumeAI_AIConfidence", OBJPROP_FONTSIZE, 10);
    ObjectSetInteger(0, "VolumeAI_AIConfidence", OBJPROP_COLOR, C'255,100,100');
    
    //--- Volumen actual
    ObjectCreate(0, "VolumeAI_Volume", OBJ_LABEL, 0, 0, 0);
    ObjectSetInteger(0, "VolumeAI_Volume", OBJPROP_CORNER, CORNER_LEFT_UPPER);
    ObjectSetInteger(0, "VolumeAI_Volume", OBJPROP_XDISTANCE, 20);
    ObjectSetInteger(0, "VolumeAI_Volume", OBJPROP_YDISTANCE, 205);
    ObjectSetString(0, "VolumeAI_Volume", OBJPROP_TEXT, "Volumen: 0");
    ObjectSetString(0, "VolumeAI_Volume", OBJPROP_FONT, "Arial");
    ObjectSetInteger(0, "VolumeAI_Volume", OBJPROP_FONTSIZE, 10);
    ObjectSetInteger(0, "VolumeAI_Volume", OBJPROP_COLOR, C'100,255,100');
    
    //--- Volumen promedio
    ObjectCreate(0, "VolumeAI_AvgVolume", OBJ_LABEL, 0, 0, 0);
    ObjectSetInteger(0, "VolumeAI_AvgVolume", OBJPROP_CORNER, CORNER_LEFT_UPPER);
    ObjectSetInteger(0, "VolumeAI_AvgVolume", OBJPROP_XDISTANCE, 20);
    ObjectSetInteger(0, "VolumeAI_AvgVolume", OBJPROP_YDISTANCE, 225);
    ObjectSetString(0, "VolumeAI_AvgVolume", OBJPROP_TEXT, "Vol Promedio: 0");
    ObjectSetString(0, "VolumeAI_AvgVolume", OBJPROP_FONT, "Arial");
    ObjectSetInteger(0, "VolumeAI_AvgVolume", OBJPROP_FONTSIZE, 10);
    ObjectSetInteger(0, "VolumeAI_AvgVolume", OBJPROP_COLOR, C'100,255,100');
    
    //--- RSI
    ObjectCreate(0, "VolumeAI_RSI", OBJ_LABEL, 0, 0, 0);
    ObjectSetInteger(0, "VolumeAI_RSI", OBJPROP_CORNER, CORNER_LEFT_UPPER);
    ObjectSetInteger(0, "VolumeAI_RSI", OBJPROP_XDISTANCE, 20);
    ObjectSetInteger(0, "VolumeAI_RSI", OBJPROP_YDISTANCE, 245);
    ObjectSetString(0, "VolumeAI_RSI", OBJPROP_TEXT, "RSI: 0");
    ObjectSetString(0, "VolumeAI_RSI", OBJPROP_FONT, "Arial");
    ObjectSetInteger(0, "VolumeAI_RSI", OBJPROP_FONTSIZE, 10);
    ObjectSetInteger(0, "VolumeAI_RSI", OBJPROP_COLOR, C'255,200,0');
    
    //--- MACD
    ObjectCreate(0, "VolumeAI_MACD", OBJ_LABEL, 0, 0, 0);
    ObjectSetInteger(0, "VolumeAI_MACD", OBJPROP_CORNER, CORNER_LEFT_UPPER);
    ObjectSetInteger(0, "VolumeAI_MACD", OBJPROP_XDISTANCE, 20);
    ObjectSetInteger(0, "VolumeAI_MACD", OBJPROP_YDISTANCE, 265);
    ObjectSetString(0, "VolumeAI_MACD", OBJPROP_TEXT, "MACD: 0");
    ObjectSetString(0, "VolumeAI_MACD", OBJPROP_FONT, "Arial");
    ObjectSetInteger(0, "VolumeAI_MACD", OBJPROP_FONTSIZE, 10);
    ObjectSetInteger(0, "VolumeAI_MACD", OBJPROP_COLOR, C'255,200,0');
    
    //--- Objetivo mensual
    ObjectCreate(0, "VolumeAI_Target", OBJ_LABEL, 0, 0, 0);
    ObjectSetInteger(0, "VolumeAI_Target", OBJPROP_CORNER, CORNER_LEFT_UPPER);
    ObjectSetInteger(0, "VolumeAI_Target", OBJPROP_XDISTANCE, 20);
    ObjectSetInteger(0, "VolumeAI_Target", OBJPROP_YDISTANCE, 285);
    ObjectSetString(0, "VolumeAI_Target", OBJPROP_TEXT, "Objetivo Mensual: $0.00");
    ObjectSetString(0, "VolumeAI_Target", OBJPROP_FONT, "Arial");
    ObjectSetInteger(0, "VolumeAI_Target", OBJPROP_FONTSIZE, 10);
    ObjectSetInteger(0, "VolumeAI_Target", OBJPROP_COLOR, C'0,255,255');
    
    //--- Progreso hacia objetivo
    ObjectCreate(0, "VolumeAI_Progress", OBJ_LABEL, 0, 0, 0);
    ObjectSetInteger(0, "VolumeAI_Progress", OBJPROP_CORNER, CORNER_LEFT_UPPER);
    ObjectSetInteger(0, "VolumeAI_Progress", OBJPROP_XDISTANCE, 20);
    ObjectSetInteger(0, "VolumeAI_Progress", OBJPROP_YDISTANCE, 305);
    ObjectSetString(0, "VolumeAI_Progress", OBJPROP_TEXT, "Progreso: 0%");
    ObjectSetString(0, "VolumeAI_Progress", OBJPROP_FONT, "Arial");
    ObjectSetInteger(0, "VolumeAI_Progress", OBJPROP_FONTSIZE, 10);
    ObjectSetInteger(0, "VolumeAI_Progress", OBJPROP_COLOR, C'0,255,0');
    
    //--- Barra de progreso visual
    ObjectCreate(0, "VolumeAI_ProgressBar", OBJ_RECTANGLE_LABEL, 0, 0, 0);
    ObjectSetInteger(0, "VolumeAI_ProgressBar", OBJPROP_CORNER, CORNER_LEFT_UPPER);
    ObjectSetInteger(0, "VolumeAI_ProgressBar", OBJPROP_XDISTANCE, 20);
    ObjectSetInteger(0, "VolumeAI_ProgressBar", OBJPROP_YDISTANCE, 325);
    ObjectSetInteger(0, "VolumeAI_ProgressBar", OBJPROP_XSIZE, 360);
    ObjectSetInteger(0, "VolumeAI_ProgressBar", OBJPROP_YSIZE, 20);
    ObjectSetInteger(0, "VolumeAI_ProgressBar", OBJPROP_BGCOLOR, C'50,50,50');
    ObjectSetInteger(0, "VolumeAI_ProgressBar", OBJPROP_BORDER_COLOR, C'0,255,0');
    ObjectSetInteger(0, "VolumeAI_ProgressBar", OBJPROP_BORDER_TYPE, BORDER_FLAT);
    ObjectSetInteger(0, "VolumeAI_ProgressBar", OBJPROP_WIDTH, 1);
    ObjectSetInteger(0, "VolumeAI_ProgressBar", OBJPROP_BACK, false);
    ObjectSetInteger(0, "VolumeAI_ProgressBar", OBJPROP_SELECTABLE, false);
    ObjectSetInteger(0, "VolumeAI_ProgressBar", OBJPROP_SELECTED, false);
    ObjectSetInteger(0, "VolumeAI_ProgressBar", OBJPROP_HIDDEN, true);
    
    //--- Barra de progreso interna
    ObjectCreate(0, "VolumeAI_ProgressFill", OBJ_RECTANGLE_LABEL, 0, 0, 0);
    ObjectSetInteger(0, "VolumeAI_ProgressFill", OBJPROP_CORNER, CORNER_LEFT_UPPER);
    ObjectSetInteger(0, "VolumeAI_ProgressFill", OBJPROP_XDISTANCE, 21);
    ObjectSetInteger(0, "VolumeAI_ProgressFill", OBJPROP_YDISTANCE, 326);
    ObjectSetInteger(0, "VolumeAI_ProgressFill", OBJPROP_XSIZE, 0);
    ObjectSetInteger(0, "VolumeAI_ProgressFill", OBJPROP_YSIZE, 18);
    ObjectSetInteger(0, "VolumeAI_ProgressFill", OBJPROP_BGCOLOR, C'0,255,0');
    ObjectSetInteger(0, "VolumeAI_ProgressFill", OBJPROP_BORDER_TYPE, BORDER_FLAT);
    ObjectSetInteger(0, "VolumeAI_ProgressFill", OBJPROP_WIDTH, 0);
    ObjectSetInteger(0, "VolumeAI_ProgressFill", OBJPROP_BACK, false);
    ObjectSetInteger(0, "VolumeAI_ProgressFill", OBJPROP_SELECTABLE, false);
    ObjectSetInteger(0, "VolumeAI_ProgressFill", OBJPROP_SELECTED, false);
    ObjectSetInteger(0, "VolumeAI_ProgressFill", OBJPROP_HIDDEN, true);
    
    //--- Última actualización
    ObjectCreate(0, "VolumeAI_LastUpdate", OBJ_LABEL, 0, 0, 0);
    ObjectSetInteger(0, "VolumeAI_LastUpdate", OBJPROP_CORNER, CORNER_LEFT_UPPER);
    ObjectSetInteger(0, "VolumeAI_LastUpdate", OBJPROP_XDISTANCE, 20);
    ObjectSetInteger(0, "VolumeAI_LastUpdate", OBJPROP_YDISTANCE, 355);
    ObjectSetString(0, "VolumeAI_LastUpdate", OBJPROP_TEXT, "Última Actualización: --");
    ObjectSetString(0, "VolumeAI_LastUpdate", OBJPROP_FONT, "Arial");
    ObjectSetInteger(0, "VolumeAI_LastUpdate", OBJPROP_FONTSIZE, 9);
    ObjectSetInteger(0, "VolumeAI_LastUpdate", OBJPROP_COLOR, C'150,150,150');
    
    //--- Información de estrategias
    ObjectCreate(0, "VolumeAI_Strategies", OBJ_LABEL, 0, 0, 0);
    ObjectSetInteger(0, "VolumeAI_Strategies", OBJPROP_CORNER, CORNER_LEFT_UPPER);
    ObjectSetInteger(0, "VolumeAI_Strategies", OBJPROP_XDISTANCE, 20);
    ObjectSetInteger(0, "VolumeAI_Strategies", OBJPROP_YDISTANCE, 375);
    ObjectSetString(0, "VolumeAI_Strategies", OBJPROP_TEXT, "Estrategias: Scalping, Swing, Breakout");
    ObjectSetString(0, "VolumeAI_Strategies", OBJPROP_FONT, "Arial");
    ObjectSetInteger(0, "VolumeAI_Strategies", OBJPROP_FONTSIZE, 9);
    ObjectSetInteger(0, "VolumeAI_Strategies", OBJPROP_COLOR, C'200,200,200');
    
    //--- Información de configuración
    ObjectCreate(0, "VolumeAI_Config", OBJ_LABEL, 0, 0, 0);
    ObjectSetInteger(0, "VolumeAI_Config", OBJPROP_CORNER, CORNER_LEFT_UPPER);
    ObjectSetInteger(0, "VolumeAI_Config", OBJPROP_XDISTANCE, 20);
    ObjectSetInteger(0, "VolumeAI_Config", OBJPROP_YDISTANCE, 395);
    ObjectSetString(0, "VolumeAI_Config", OBJPROP_TEXT, "Config: Lote=" + DoubleToString(LotSize, 2) + " | SL=" + IntegerToString(StopLoss) + " | TP=" + IntegerToString(TakeProfit));
    ObjectSetString(0, "VolumeAI_Config", OBJPROP_FONT, "Arial");
    ObjectSetInteger(0, "VolumeAI_Config", OBJPROP_FONTSIZE, 9);
    ObjectSetInteger(0, "VolumeAI_Config", OBJPROP_COLOR, C'150,150,150');
    
    //--- Información de IA
    ObjectCreate(0, "VolumeAI_AIInfo", OBJ_LABEL, 0, 0, 0);
    ObjectSetInteger(0, "VolumeAI_AIInfo", OBJPROP_CORNER, CORNER_LEFT_UPPER);
    ObjectSetInteger(0, "VolumeAI_AIInfo", OBJPROP_XDISTANCE, 20);
    ObjectSetInteger(0, "VolumeAI_AIInfo", OBJPROP_YDISTANCE, 415);
    ObjectSetString(0, "VolumeAI_AIInfo", OBJPROP_TEXT, "IA: " + (UseAI ? "ACTIVA" : "INACTIVA") + " | Confianza: " + DoubleToString(AI_ConfidenceThreshold * 100, 0) + "%");
    ObjectSetString(0, "VolumeAI_AIInfo", OBJPROP_FONT, "Arial");
    ObjectSetInteger(0, "VolumeAI_AIInfo", OBJPROP_FONTSIZE, 9);
    ObjectSetInteger(0, "VolumeAI_AIInfo", OBJPROP_COLOR, C'255,100,100');
    
    //--- Información de volumen
    ObjectCreate(0, "VolumeAI_VolumeInfo", OBJ_LABEL, 0, 0, 0);
    ObjectSetInteger(0, "VolumeAI_VolumeInfo", OBJPROP_CORNER, CORNER_LEFT_UPPER);
    ObjectSetInteger(0, "VolumeAI_VolumeInfo", OBJPROP_XDISTANCE, 20);
    ObjectSetInteger(0, "VolumeAI_VolumeInfo", OBJPROP_YDISTANCE, 435);
    ObjectSetString(0, "VolumeAI_VolumeInfo", OBJPROP_TEXT, "Filtro Volumen: " + (UseVolumeFilter ? "ACTIVO" : "INACTIVO") + " | Umbral: " + DoubleToString(VolumeThreshold, 1));
    ObjectSetString(0, "VolumeAI_VolumeInfo", OBJPROP_FONT, "Arial");
    ObjectSetInteger(0, "VolumeAI_VolumeInfo", OBJPROP_FONTSIZE, 9);
    ObjectSetInteger(0, "VolumeAI_VolumeInfo", OBJPROP_COLOR, C'100,255,100');
    
    //--- Información de tiempo
    ObjectCreate(0, "VolumeAI_TimeInfo", OBJ_LABEL, 0, 0, 0);
    ObjectSetInteger(0, "VolumeAI_TimeInfo", OBJPROP_CORNER, CORNER_LEFT_UPPER);
    ObjectSetInteger(0, "VolumeAI_TimeInfo", OBJPROP_XDISTANCE, 20);
    ObjectSetInteger(0, "VolumeAI_TimeInfo", OBJPROP_YDISTANCE, 455);
    ObjectSetString(0, "VolumeAI_TimeInfo", OBJPROP_TEXT, "Horario: " + IntegerToString(StartHour) + ":00 - " + IntegerToString(EndHour) + ":00 | Noticias: " + (TradeOnNews ? "SÍ" : "NO"));
    ObjectSetString(0, "VolumeAI_TimeInfo", OBJPROP_FONT, "Arial");
    ObjectSetInteger(0, "VolumeAI_TimeInfo", OBJPROP_FONTSIZE, 9);
    ObjectSetInteger(0, "VolumeAI_TimeInfo", OBJPROP_COLOR, C'150,150,150');
    
    //--- Información de rendimiento
    ObjectCreate(0, "VolumeAI_Performance", OBJ_LABEL, 0, 0, 0);
    ObjectSetInteger(0, "VolumeAI_Performance", OBJPROP_CORNER, CORNER_LEFT_UPPER);
    ObjectSetInteger(0, "VolumeAI_Performance", OBJPROP_XDISTANCE, 20);
    ObjectSetInteger(0, "VolumeAI_Performance", OBJPROP_YDISTANCE, 475);
    ObjectSetString(0, "VolumeAI_Performance", OBJPROP_TEXT, "Objetivo: 30% Mensual | Factor Profit: 0.00");
    ObjectSetString(0, "VolumeAI_Performance", OBJPROP_FONT, "Arial");
    ObjectSetInteger(0, "VolumeAI_Performance", OBJPROP_FONTSIZE, 9);
    ObjectSetInteger(0, "VolumeAI_Performance", OBJPROP_COLOR, C'0,255,255');
}

//+------------------------------------------------------------------+
//| Actualizar interfaz gráfica                                      |
//+------------------------------------------------------------------+
void UpdateGUI()
{
    //--- Actualizar balance
    accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
    ObjectSetString(0, "VolumeAI_Balance", OBJPROP_TEXT, "Balance: $" + DoubleToString(accountBalance, 2));
    
    //--- Actualizar profit
    ObjectSetString(0, "VolumeAI_Profit", OBJPROP_TEXT, "Profit: $" + DoubleToString(totalProfit, 2));
    if(totalProfit > 0)
        ObjectSetInteger(0, "VolumeAI_Profit", OBJPROP_COLOR, C'0,255,0');
    else if(totalProfit < 0)
        ObjectSetInteger(0, "VolumeAI_Profit", OBJPROP_COLOR, C'255,0,0');
    else
        ObjectSetInteger(0, "VolumeAI_Profit", OBJPROP_COLOR, C'255,255,255');
    
    //--- Actualizar trades abiertos
    int openTrades = CountOpenTrades();
    ObjectSetString(0, "VolumeAI_Trades", OBJPROP_TEXT, "Trades Abiertos: " + IntegerToString(openTrades));
    if(openTrades >= MaxTrades)
        ObjectSetInteger(0, "VolumeAI_Trades", OBJPROP_COLOR, C'255,0,0');
    else if(openTrades > 0)
        ObjectSetInteger(0, "VolumeAI_Trades", OBJPROP_COLOR, C'255,255,0');
    else
        ObjectSetInteger(0, "VolumeAI_Trades", OBJPROP_COLOR, C'128,128,128');
    
    //--- Actualizar tasa de ganancia
    double winRatePercent = 0.0;
    if(totalTrades > 0)
        winRatePercent = (double)winningTrades / totalTrades * 100.0;
    ObjectSetString(0, "VolumeAI_WinRate", OBJPROP_TEXT, "Tasa Ganancia: " + DoubleToString(winRatePercent, 1) + "%");
    if(winRatePercent >= 60.0)
        ObjectSetInteger(0, "VolumeAI_WinRate", OBJPROP_COLOR, C'0,255,0');
    else if(winRatePercent >= 40.0)
        ObjectSetInteger(0, "VolumeAI_WinRate", OBJPROP_COLOR, C'255,165,0');
    else
        ObjectSetInteger(0, "VolumeAI_WinRate", OBJPROP_COLOR, C'255,0,0');
    
    //--- Actualizar señal de IA
    double aiSignal = GetAISignal();
    string signalText = "NEUTRAL";
    color signalColor = C'128,128,128';
    
    if(aiSignal > 0.3)
    {
        signalText = "COMPRA";
        signalColor = C'0,255,0';
    }
    else if(aiSignal < -0.3)
    {
        signalText = "VENTA";
        signalColor = C'255,0,0';
    }
    
    ObjectSetString(0, "VolumeAI_AISignal", OBJPROP_TEXT, "Señal IA: " + signalText);
    ObjectSetInteger(0, "VolumeAI_AISignal", OBJPROP_COLOR, signalColor);
    
    //--- Actualizar confianza de IA
    double confidence = GetAIConfidence();
    ObjectSetString(0, "VolumeAI_AIConfidence", OBJPROP_TEXT, "Confianza IA: " + DoubleToString(confidence * 100, 1) + "%");
    if(confidence >= 0.8)
        ObjectSetInteger(0, "VolumeAI_AIConfidence", OBJPROP_COLOR, C'0,255,0');
    else if(confidence >= 0.6)
        ObjectSetInteger(0, "VolumeAI_AIConfidence", OBJPROP_COLOR, C'255,165,0');
    else
        ObjectSetInteger(0, "VolumeAI_AIConfidence", OBJPROP_COLOR, C'255,0,0');
    
    //--- Actualizar volumen
    double currentVolume = GetCurrentVolume();
    ObjectSetString(0, "VolumeAI_Volume", OBJPROP_TEXT, "Volumen: " + DoubleToString(currentVolume, 0));
    
    //--- Actualizar volumen promedio
    double avgVolume = GetAverageVolume();
    ObjectSetString(0, "VolumeAI_AvgVolume", OBJPROP_TEXT, "Vol Promedio: " + DoubleToString(avgVolume, 0));
    
    //--- Actualizar RSI
    double rsi[];
    if(CopyBuffer(rsiHandle, 0, 0, 1, rsi) > 0)
    {
        ObjectSetString(0, "VolumeAI_RSI", OBJPROP_TEXT, "RSI: " + DoubleToString(rsi[0], 1));
        if(rsi[0] < 30)
            ObjectSetInteger(0, "VolumeAI_RSI", OBJPROP_COLOR, C'0,255,0');
        else if(rsi[0] > 70)
            ObjectSetInteger(0, "VolumeAI_RSI", OBJPROP_COLOR, C'255,0,0');
        else
            ObjectSetInteger(0, "VolumeAI_RSI", OBJPROP_COLOR, C'255,200,0');
    }
    
    //--- Actualizar MACD
    double macdMain[], macdSignal[];
    if(CopyBuffer(macdHandle, 0, 0, 1, macdMain) > 0 && CopyBuffer(macdHandle, 1, 0, 1, macdSignal) > 0)
    {
        ObjectSetString(0, "VolumeAI_MACD", OBJPROP_TEXT, "MACD: " + DoubleToString(macdMain[0], 5));
        if(macdMain[0] > macdSignal[0])
            ObjectSetInteger(0, "VolumeAI_MACD", OBJPROP_COLOR, C'0,255,0');
        else
            ObjectSetInteger(0, "VolumeAI_MACD", OBJPROP_COLOR, C'255,0,0');
    }
    
    //--- Actualizar objetivo mensual
    ObjectSetString(0, "VolumeAI_Target", OBJPROP_TEXT, "Objetivo Mensual: $" + DoubleToString(monthlyTarget, 2));
    
    //--- Actualizar progreso hacia objetivo
    double progress = 0.0;
    if(monthlyTarget > 0)
        progress = (totalProfit / monthlyTarget) * 100.0;
    
    ObjectSetString(0, "VolumeAI_Progress", OBJPROP_TEXT, "Progreso: " + DoubleToString(progress, 1) + "%");
    
    //--- Actualizar barra de progreso visual
    int progressWidth = (int)(360 * progress / 100.0);
    if(progressWidth > 360) progressWidth = 360;
    if(progressWidth < 0) progressWidth = 0;
    ObjectSetInteger(0, "VolumeAI_ProgressFill", OBJPROP_XSIZE, progressWidth);
    
    if(progress >= 100.0)
        ObjectSetInteger(0, "VolumeAI_ProgressFill", OBJPROP_BGCOLOR, C'0,255,0');
    else if(progress >= 50.0)
        ObjectSetInteger(0, "VolumeAI_ProgressFill", OBJPROP_BGCOLOR, C'255,165,0');
    else
        ObjectSetInteger(0, "VolumeAI_ProgressFill", OBJPROP_BGCOLOR, C'255,0,0');
    
    //--- Actualizar última actualización
    ObjectSetString(0, "VolumeAI_LastUpdate", OBJPROP_TEXT, "Última Actualización: " + TimeToString(TimeCurrent(), TIME_SECONDS));
    
    //--- Actualizar factor de profit
    double profitFactor = 0.0;
    if(totalTrades > 0)
    {
        double totalWins = 0.0;
        double totalLosses = 0.0;
        for(int i = 0; i < totalTrades; i++)
        {
            if(tradeResults[i].profit > 0)
                totalWins += tradeResults[i].profit;
            else
                totalLosses += MathAbs(tradeResults[i].profit);
        }
        if(totalLosses > 0)
            profitFactor = totalWins / totalLosses;
    }
    
    ObjectSetString(0, "VolumeAI_Performance", OBJPROP_TEXT, "Objetivo: 30% Mensual | Factor Profit: " + DoubleToString(profitFactor, 2));
    if(profitFactor >= 2.0)
        ObjectSetInteger(0, "VolumeAI_Performance", OBJPROP_COLOR, C'0,255,0');
    else if(profitFactor >= 1.0)
        ObjectSetInteger(0, "VolumeAI_Performance", OBJPROP_COLOR, C'255,165,0');
    else
        ObjectSetInteger(0, "VolumeAI_Performance", OBJPROP_COLOR, C'255,0,0');
}

//+------------------------------------------------------------------+
//| Eliminar interfaz gráfica                                        |
//+------------------------------------------------------------------+
void DeleteGUI()
{
    ObjectDelete(0, "VolumeAI_Panel");
    ObjectDelete(0, "VolumeAI_Title");
    ObjectDelete(0, "VolumeAI_Status");
    ObjectDelete(0, "VolumeAI_Balance");
    ObjectDelete(0, "VolumeAI_Profit");
    ObjectDelete(0, "VolumeAI_Trades");
    ObjectDelete(0, "VolumeAI_WinRate");
    ObjectDelete(0, "VolumeAI_AISignal");
    ObjectDelete(0, "VolumeAI_AIConfidence");
    ObjectDelete(0, "VolumeAI_Volume");
    ObjectDelete(0, "VolumeAI_AvgVolume");
    ObjectDelete(0, "VolumeAI_RSI");
    ObjectDelete(0, "VolumeAI_MACD");
    ObjectDelete(0, "VolumeAI_Target");
    ObjectDelete(0, "VolumeAI_Progress");
    ObjectDelete(0, "VolumeAI_LastUpdate");
    ObjectDelete(0, "VolumeAI_ProgressBar");
    ObjectDelete(0, "VolumeAI_ProgressFill");
    ObjectDelete(0, "VolumeAI_Strategies");
    ObjectDelete(0, "VolumeAI_Config");
    ObjectDelete(0, "VolumeAI_AIInfo");
    ObjectDelete(0, "VolumeAI_VolumeInfo");
    ObjectDelete(0, "VolumeAI_TimeInfo");
    ObjectDelete(0, "VolumeAI_Performance");
}
