//+------------------------------------------------------------------+
//|                                        VolumeAI_Backtester.mq5 |
//|                        Copyright 2024, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property description "Sistema de Backtesting y Optimización para VolumeAI Bot"

//--- Parámetros de backtesting
input group "=== CONFIGURACIÓN DE BACKTESTING ==="
input datetime StartDate = D'2024.01.01 00:00:00';  // Fecha de inicio
input datetime EndDate = D'2024.12.31 23:59:59';    // Fecha de fin
input double   InitialBalance = 10000.0;            // Balance inicial
input double   Commission = 0.0;                    // Comisión por trade
input double   Spread = 2.0;                        // Spread en pips
input bool     UseRealSpread = true;                // Usar spread real del broker

input group "=== CONFIGURACIÓN DE OPTIMIZACIÓN ==="
input bool     OptimizeParameters = false;         // Activar optimización
input int      OptimizationRuns = 100;             // Número de ejecuciones
input double   MinProfitFactor = 1.5;              // Factor de profit mínimo
input double   MinWinRate = 0.4;                   // Tasa de ganancia mínima

//--- Estructura para almacenar resultados de trades
struct TradeResult
{
    datetime openTime;
    datetime closeTime;
    double openPrice;
    double closePrice;
    double volume;
    int type; // 1 = Buy, -1 = Sell
    double profit;
    double commission;
    double spread;
    string comment;
};

//--- Variables globales para backtesting
TradeResult tradeResults[];
int totalTrades = 0;
double totalProfit = 0.0;
double totalCommission = 0.0;
double maxDrawdown = 0.0;
double maxBalance = 0.0;
double currentBalance = 0.0;
double winRate = 0.0;
double profitFactor = 0.0;
double sharpeRatio = 0.0;

//+------------------------------------------------------------------+
//| Función principal de backtesting                                |
//+------------------------------------------------------------------+
void RunBacktest()
{
    Print("=== INICIANDO BACKTESTING ===");
    Print("Período: ", TimeToString(StartDate), " - ", TimeToString(EndDate));
    Print("Balance inicial: $", DoubleToString(InitialBalance, 2));
    
    currentBalance = InitialBalance;
    maxBalance = InitialBalance;
    ArrayResize(tradeResults, 10000); // Reservar espacio para trades
    
    //--- Obtener datos históricos
    MqlRates rates[];
    int copied = CopyRates(_Symbol, PERIOD_H1, StartDate, EndDate, rates);
    
    if(copied <= 0)
    {
        Print("Error: No se pudieron obtener datos históricos");
        return;
    }
    
    Print("Datos históricos obtenidos: ", copied, " barras");
    
    //--- Simular trading barra por barra
    for(int i = 50; i < copied - 1; i++) // Empezar desde la barra 50 para tener datos suficientes
    {
        datetime currentTime = rates[i].time;
        double open = rates[i].open;
        double high = rates[i].high;
        double low = rates[i].low;
        double close = rates[i].close;
        long volume = rates[i].tick_volume;
        
        //--- Simular lógica de trading
        SimulateTrading(currentTime, open, high, low, close, volume);
        
        //--- Actualizar balance y métricas
        UpdateMetrics();
    }
    
    //--- Calcular estadísticas finales
    CalculateFinalStatistics();
    
    //--- Mostrar resultados
    DisplayResults();
    
    //--- Generar reporte
    GenerateReport();
}

//+------------------------------------------------------------------+
//| Simular lógica de trading para una barra                        |
//+------------------------------------------------------------------+
void SimulateTrading(datetime time, double open, double high, double low, double close, long volume)
{
    //--- Obtener señales de IA (simplificado para backtesting)
    double aiSignal = GetAISignalForBacktest(time);
    double volumeSignal = GetVolumeSignal(volume, time);
    double technicalSignal = GetTechnicalSignalForBacktest(time);
    
    //--- Combinar señales
    double finalSignal = (aiSignal * 0.4) + (volumeSignal * 0.3) + (technicalSignal * 0.3);
    
    //--- Decidir si abrir trade
    if(MathAbs(finalSignal) > 0.6)
    {
        double entryPrice = 0.0;
        double exitPrice = 0.0;
        int tradeType = 0;
        
        if(finalSignal > 0) // Señal de compra
        {
            tradeType = 1;
            entryPrice = open;
            exitPrice = close;
        }
        else // Señal de venta
        {
            tradeType = -1;
            entryPrice = open;
            exitPrice = close;
        }
        
        //--- Calcular profit
        double profit = 0.0;
        if(tradeType == 1)
            profit = (exitPrice - entryPrice) * 100000; // Para lotes estándar
        else
            profit = (entryPrice - exitPrice) * 100000;
        
        //--- Aplicar comisión y spread
        double commission = Commission;
        double spreadCost = UseRealSpread ? GetRealSpread(time) : Spread * _Point * 100000;
        
        profit -= commission + spreadCost;
        
        //--- Registrar trade
        if(totalTrades < ArraySize(tradeResults))
        {
            tradeResults[totalTrades].openTime = time;
            tradeResults[totalTrades].closeTime = time;
            tradeResults[totalTrades].openPrice = entryPrice;
            tradeResults[totalTrades].closePrice = exitPrice;
            tradeResults[totalTrades].volume = 0.1; // Lote fijo para simplicidad
            tradeResults[totalTrades].type = tradeType;
            tradeResults[totalTrades].profit = profit;
            tradeResults[totalTrades].commission = commission;
            tradeResults[totalTrades].spread = spreadCost;
            tradeResults[totalTrades].comment = "Backtest Trade";
            
            totalTrades++;
            totalProfit += profit;
            totalCommission += commission;
            currentBalance += profit;
        }
    }
}

//+------------------------------------------------------------------+
//| Obtener señal de IA para backtesting                            |
//+------------------------------------------------------------------+
double GetAISignalForBacktest(datetime time)
{
    //--- Implementación simplificada para backtesting
    //--- En una implementación real, usarías datos históricos para entrenar el modelo
    
    double signal = 0.0;
    
    //--- Simular análisis de volumen histórico
    MqlRates rates[];
    if(CopyRates(_Symbol, PERIOD_H1, time - 24*3600, time, rates) > 0)
    {
        long totalVolume = 0;
        for(int i = 0; i < ArraySize(rates); i++)
        {
            totalVolume += rates[i].tick_volume;
        }
        
        double avgVolume = totalVolume / ArraySize(rates);
        double currentVolume = rates[ArraySize(rates)-1].tick_volume;
        
        if(currentVolume > avgVolume * 1.5)
            signal += 0.3;
        else if(currentVolume < avgVolume * 0.5)
            signal -= 0.2;
    }
    
    //--- Simular análisis de tendencia
    double prices[];
    if(CopyClose(_Symbol, PERIOD_H1, time - 10*3600, time, prices) > 0)
    {
        if(ArraySize(prices) >= 10)
        {
            double trend = (prices[ArraySize(prices)-1] - prices[0]) / prices[0];
            signal += trend * 0.5;
        }
    }
    
    return MathMax(-1.0, MathMin(1.0, signal));
}

//+------------------------------------------------------------------+
//| Obtener señal de volumen                                         |
//+------------------------------------------------------------------+
double GetVolumeSignal(long volume, datetime time)
{
    //--- Obtener volumen promedio de las últimas 20 barras
    MqlRates rates[];
    if(CopyRates(_Symbol, PERIOD_H1, time - 20*3600, time, rates) <= 0)
        return 0.0;
    
    long totalVolume = 0;
    for(int i = 0; i < ArraySize(rates) - 1; i++)
    {
        totalVolume += rates[i].tick_volume;
    }
    
    double avgVolume = totalVolume / (ArraySize(rates) - 1);
    
    if(avgVolume == 0) return 0.0;
    
    double volumeRatio = (double)volume / avgVolume;
    
    if(volumeRatio > 2.0) return 0.5;
    else if(volumeRatio > 1.5) return 0.3;
    else if(volumeRatio < 0.5) return -0.2;
    
    return 0.0;
}

//+------------------------------------------------------------------+
//| Obtener señal técnica para backtesting                          |
//+------------------------------------------------------------------+
double GetTechnicalSignalForBacktest(datetime time)
{
    double signal = 0.0;
    
    //--- RSI
    double rsi[];
    int rsiHandle = iRSI(_Symbol, PERIOD_H1, 14, PRICE_CLOSE);
    if(CopyBuffer(rsiHandle, 0, time, 1, rsi) > 0)
    {
        if(rsi[0] < 30) signal += 0.3;
        else if(rsi[0] > 70) signal -= 0.3;
    }
    
    //--- MACD
    double macdMain[], macdSignal[];
    int macdHandle = iMACD(_Symbol, PERIOD_H1, 12, 26, 9, PRICE_CLOSE);
    if(CopyBuffer(macdHandle, 0, time, 1, macdMain) > 0 && CopyBuffer(macdHandle, 1, time, 1, macdSignal) > 0)
    {
        if(macdMain[0] > macdSignal[0]) signal += 0.2;
        else signal -= 0.2;
    }
    
    return MathMax(-1.0, MathMin(1.0, signal));
}

//+------------------------------------------------------------------+
//| Obtener spread real                                              |
//+------------------------------------------------------------------+
double GetRealSpread(datetime time)
{
    //--- Simulación del spread real (en una implementación real, usarías datos históricos)
    return 2.0 * _Point * 100000; // 2 pips
}

//+------------------------------------------------------------------+
//| Actualizar métricas                                              |
//+------------------------------------------------------------------+
void UpdateMetrics()
{
    //--- Actualizar balance máximo
    if(currentBalance > maxBalance)
        maxBalance = currentBalance;
    
    //--- Calcular drawdown
    double drawdown = (maxBalance - currentBalance) / maxBalance;
    if(drawdown > maxDrawdown)
        maxDrawdown = drawdown;
}

//+------------------------------------------------------------------+
//| Calcular estadísticas finales                                   |
//+------------------------------------------------------------------+
void CalculateFinalStatistics()
{
    if(totalTrades == 0) return;
    
    //--- Calcular tasa de ganancia
    int winningTrades = 0;
    double totalWins = 0.0;
    double totalLosses = 0.0;
    
    for(int i = 0; i < totalTrades; i++)
    {
        if(tradeResults[i].profit > 0)
        {
            winningTrades++;
            totalWins += tradeResults[i].profit;
        }
        else
        {
            totalLosses += MathAbs(tradeResults[i].profit);
        }
    }
    
    winRate = (double)winningTrades / totalTrades;
    
    //--- Calcular factor de profit
    if(totalLosses > 0)
        profitFactor = totalWins / totalLosses;
    else
        profitFactor = totalWins > 0 ? 1000.0 : 0.0;
    
    //--- Calcular Sharpe Ratio (simplificado)
    double avgReturn = totalProfit / totalTrades;
    double variance = 0.0;
    
    for(int i = 0; i < totalTrades; i++)
    {
        double diff = tradeResults[i].profit - avgReturn;
        variance += diff * diff;
    }
    
    variance /= totalTrades;
    double stdDev = MathSqrt(variance);
    
    if(stdDev > 0)
        sharpeRatio = avgReturn / stdDev;
    else
        sharpeRatio = 0.0;
}

//+------------------------------------------------------------------+
//| Mostrar resultados                                               |
//+------------------------------------------------------------------+
void DisplayResults()
{
    Print("\n=== RESULTADOS DEL BACKTESTING ===");
    Print("Período de prueba: ", TimeToString(StartDate), " - ", TimeToString(EndDate));
    Print("Balance inicial: $", DoubleToString(InitialBalance, 2));
    Print("Balance final: $", DoubleToString(currentBalance, 2));
    Print("Profit total: $", DoubleToString(totalProfit, 2));
    Print("Comisión total: $", DoubleToString(totalCommission, 2));
    Print("Trades totales: ", totalTrades);
    Print("Tasa de ganancia: ", DoubleToString(winRate * 100, 2), "%");
    Print("Factor de profit: ", DoubleToString(profitFactor, 2));
    Print("Drawdown máximo: ", DoubleToString(maxDrawdown * 100, 2), "%");
    Print("Sharpe Ratio: ", DoubleToString(sharpeRatio, 2));
    
    double monthlyReturn = (currentBalance - InitialBalance) / InitialBalance * 100;
    Print("Retorno total: ", DoubleToString(monthlyReturn, 2), "%");
    
    if(monthlyReturn >= 30.0)
        Print("¡OBJETIVO DE 30% MENSUAL ALCANZADO!");
    else
        Print("Objetivo de 30% mensual NO alcanzado");
}

//+------------------------------------------------------------------+
//| Generar reporte detallado                                        |
//+------------------------------------------------------------------+
void GenerateReport()
{
    string filename = "VolumeAI_Backtest_Report_" + TimeToString(TimeCurrent(), TIME_DATE) + ".txt";
    int fileHandle = FileOpen(filename, FILE_WRITE | FILE_TXT);
    
    if(fileHandle != INVALID_HANDLE)
    {
        FileWriteString(fileHandle, "=== REPORTE DE BACKTESTING VOLUMEA AI BOT ===\n");
        FileWriteString(fileHandle, "Fecha de generación: " + TimeToString(TimeCurrent()) + "\n");
        FileWriteString(fileHandle, "Período de prueba: " + TimeToString(StartDate) + " - " + TimeToString(EndDate) + "\n");
        FileWriteString(fileHandle, "Símbolo: " + _Symbol + "\n");
        FileWriteString(fileHandle, "Timeframe: H1\n\n");
        
        FileWriteString(fileHandle, "=== RESULTADOS FINANCIEROS ===\n");
        FileWriteString(fileHandle, "Balance inicial: $" + DoubleToString(InitialBalance, 2) + "\n");
        FileWriteString(fileHandle, "Balance final: $" + DoubleToString(currentBalance, 2) + "\n");
        FileWriteString(fileHandle, "Profit total: $" + DoubleToString(totalProfit, 2) + "\n");
        FileWriteString(fileHandle, "Comisión total: $" + DoubleToString(totalCommission, 2) + "\n");
        FileWriteString(fileHandle, "Retorno total: " + DoubleToString((currentBalance - InitialBalance) / InitialBalance * 100, 2) + "%\n\n");
        
        FileWriteString(fileHandle, "=== ESTADÍSTICAS DE TRADING ===\n");
        FileWriteString(fileHandle, "Trades totales: " + IntegerToString(totalTrades) + "\n");
        FileWriteString(fileHandle, "Tasa de ganancia: " + DoubleToString(winRate * 100, 2) + "%\n");
        FileWriteString(fileHandle, "Factor de profit: " + DoubleToString(profitFactor, 2) + "\n");
        FileWriteString(fileHandle, "Drawdown máximo: " + DoubleToString(maxDrawdown * 100, 2) + "%\n");
        FileWriteString(fileHandle, "Sharpe Ratio: " + DoubleToString(sharpeRatio, 2) + "\n\n");
        
        FileWriteString(fileHandle, "=== DETALLES DE TRADES ===\n");
        FileWriteString(fileHandle, "Fecha Apertura, Precio Apertura, Precio Cierre, Tipo, Profit, Comisión\n");
        
        for(int i = 0; i < totalTrades; i++)
        {
            string tradeLine = TimeToString(tradeResults[i].openTime) + "," +
                              DoubleToString(tradeResults[i].openPrice, 5) + "," +
                              DoubleToString(tradeResults[i].closePrice, 5) + "," +
                              IntegerToString(tradeResults[i].type) + "," +
                              DoubleToString(tradeResults[i].profit, 2) + "," +
                              DoubleToString(tradeResults[i].commission, 2) + "\n";
            FileWriteString(fileHandle, tradeLine);
        }
        
        FileClose(fileHandle);
        Print("Reporte guardado en: ", filename);
    }
}

//+------------------------------------------------------------------+
//| Función de optimización de parámetros                           |
//+------------------------------------------------------------------+
void OptimizeParameters()
{
    Print("=== INICIANDO OPTIMIZACIÓN DE PARÁMETROS ===");
    
    double bestProfit = -999999.0;
    double bestParams[10];
    
    for(int run = 0; run < OptimizationRuns; run++)
    {
        //--- Generar parámetros aleatorios
        double testParams[10];
        GenerateRandomParameters(testParams);
        
        //--- Ejecutar backtest con parámetros de prueba
        double profit = RunBacktestWithParams(testParams);
        
        //--- Verificar si es el mejor resultado
        if(profit > bestProfit && IsValidResult())
        {
            bestProfit = profit;
            ArrayCopy(bestParams, testParams);
            
            Print("Nueva mejor configuración encontrada - Profit: $", DoubleToString(profit, 2));
        }
    }
    
    Print("=== OPTIMIZACIÓN COMPLETADA ===");
    Print("Mejor profit: $", DoubleToString(bestProfit, 2));
    Print("Mejores parámetros encontrados");
}

//+------------------------------------------------------------------+
//| Generar parámetros aleatorios                                   |
//+------------------------------------------------------------------+
void GenerateRandomParameters(double params[])
{
    params[0] = 0.05 + MathRand() * 0.15 / 32767.0; // LotSize: 0.05 - 0.20
    params[1] = 1.0 + MathRand() * 3.0 / 32767.0;   // RiskPercent: 1.0 - 4.0
    params[2] = 20 + MathRand() * 80 / 32767.0;     // StopLoss: 20 - 100
    params[3] = 40 + MathRand() * 160 / 32767.0;    // TakeProfit: 40 - 200
    params[4] = 1.2 + MathRand() * 1.8 / 32767.0;   // VolumeThreshold: 1.2 - 3.0
    params[5] = 0.5 + MathRand() * 0.5 / 32767.0;   // AI_ConfidenceThreshold: 0.5 - 1.0
    params[6] = 10 + MathRand() * 20 / 32767.0;     // VolumePeriod: 10 - 30
    params[7] = 5 + MathRand() * 15 / 32767.0;      // VolumeMA_Period: 5 - 20
    params[8] = 8 + MathRand() * 4 / 32767.0;       // StartHour: 8 - 12
    params[9] = 16 + MathRand() * 4 / 32767.0;      // EndHour: 16 - 20
}

//+------------------------------------------------------------------+
//| Ejecutar backtest con parámetros específicos                    |
//+------------------------------------------------------------------+
double RunBacktestWithParams(double params[])
{
    //--- Implementación simplificada
    //--- En una implementación real, modificarías los parámetros del bot y ejecutarías el backtest
    
    //--- Resetear variables
    totalTrades = 0;
    totalProfit = 0.0;
    currentBalance = InitialBalance;
    maxBalance = InitialBalance;
    maxDrawdown = 0.0;
    
    //--- Ejecutar lógica de backtesting con parámetros dados
    //--- (Implementación simplificada)
    
    return totalProfit;
}

//+------------------------------------------------------------------+
//| Verificar si el resultado es válido                             |
//+------------------------------------------------------------------+
bool IsValidResult()
{
    return (winRate >= MinWinRate) && (profitFactor >= MinProfitFactor) && (maxDrawdown < 0.5);
}

//+------------------------------------------------------------------+
//| Script de inicio                                                |
//+------------------------------------------------------------------+
void OnStart()
{
    if(OptimizeParameters)
        OptimizeParameters();
    else
        RunBacktest();
}
