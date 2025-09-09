//+------------------------------------------------------------------+
//|                                    VolumeAI_Example_Config.mq5 |
//|                        Copyright 2024, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property description "Configuraciones de Ejemplo para VolumeAI Trading Bot"

//+------------------------------------------------------------------+
//| EJEMPLO 1: Configuración para Principiantes                      |
//+------------------------------------------------------------------+
/*
OBJETIVO: 15% rendimiento mensual con bajo riesgo
CUENTA: $1,000 - $5,000
ESTILO: Conservador
TIEMPO: 2-4 horas al día
*/

void SetupBeginnerConfig()
{
    //--- Parámetros principales
    double LotSize = 0.01;
    int MaxTrades = 2;
    double RiskPercent = 1.0;
    int StopLoss = 40;
    int TakeProfit = 80;
    
    //--- Parámetros de volumen
    double VolumeThreshold = 1.8;
    int VolumePeriod = 25;
    int VolumeMA_Period = 15;
    bool UseVolumeFilter = true;
    
    //--- Parámetros de IA
    double AI_ConfidenceThreshold = 0.8;
    int AI_PredictionPeriod = 15;
    bool UseAI = true;
    int LearningPeriod = 150;
    
    //--- Parámetros de tiempo
    int StartHour = 9;
    int EndHour = 17;
    bool TradeOnNews = false;
    bool TradeOnFriday = true;
    
    Print("=== CONFIGURACIÓN PRINCIPIANTE ===");
    Print("LotSize: ", LotSize);
    Print("MaxTrades: ", MaxTrades);
    Print("RiskPercent: ", RiskPercent, "%");
    Print("StopLoss: ", StopLoss, " pips");
    Print("TakeProfit: ", TakeProfit, " pips");
    Print("VolumeThreshold: ", VolumeThreshold);
    Print("AI_ConfidenceThreshold: ", AI_ConfidenceThreshold);
}

//+------------------------------------------------------------------+
//| EJEMPLO 2: Configuración para Intermedios                       |
//+------------------------------------------------------------------+
/*
OBJETIVO: 25% rendimiento mensual con riesgo moderado
CUENTA: $5,000 - $25,000
ESTILO: Moderado
TIEMPO: 4-6 horas al día
*/

void SetupIntermediateConfig()
{
    //--- Parámetros principales
    double LotSize = 0.1;
    int MaxTrades = 3;
    double RiskPercent = 1.5;
    int StopLoss = 50;
    int TakeProfit = 100;
    
    //--- Parámetros de volumen
    double VolumeThreshold = 1.5;
    int VolumePeriod = 20;
    int VolumeMA_Period = 10;
    bool UseVolumeFilter = true;
    
    //--- Parámetros de IA
    double AI_ConfidenceThreshold = 0.7;
    int AI_PredictionPeriod = 10;
    bool UseAI = true;
    int LearningPeriod = 100;
    
    //--- Parámetros de tiempo
    int StartHour = 8;
    int EndHour = 18;
    bool TradeOnNews = false;
    bool TradeOnFriday = true;
    
    Print("=== CONFIGURACIÓN INTERMEDIO ===");
    Print("LotSize: ", LotSize);
    Print("MaxTrades: ", MaxTrades);
    Print("RiskPercent: ", RiskPercent, "%");
    Print("StopLoss: ", StopLoss, " pips");
    Print("TakeProfit: ", TakeProfit, " pips");
    Print("VolumeThreshold: ", VolumeThreshold);
    Print("AI_ConfidenceThreshold: ", AI_ConfidenceThreshold);
}

//+------------------------------------------------------------------+
//| EJEMPLO 3: Configuración para Avanzados                         |
//+------------------------------------------------------------------+
/*
OBJETIVO: 30% rendimiento mensual con riesgo controlado
CUENTA: $25,000+
ESTILO: Agresivo
TIEMPO: 6-8 horas al día
*/

void SetupAdvancedConfig()
{
    //--- Parámetros principales
    double LotSize = 0.5;
    int MaxTrades = 5;
    double RiskPercent = 2.0;
    int StopLoss = 50;
    int TakeProfit = 100;
    
    //--- Parámetros de volumen
    double VolumeThreshold = 1.5;
    int VolumePeriod = 20;
    int VolumeMA_Period = 10;
    bool UseVolumeFilter = true;
    
    //--- Parámetros de IA
    double AI_ConfidenceThreshold = 0.7;
    int AI_PredictionPeriod = 10;
    bool UseAI = true;
    int LearningPeriod = 100;
    
    //--- Parámetros de tiempo
    int StartHour = 8;
    int EndHour = 20;
    bool TradeOnNews = false;
    bool TradeOnFriday = true;
    
    Print("=== CONFIGURACIÓN AVANZADO ===");
    Print("LotSize: ", LotSize);
    Print("MaxTrades: ", MaxTrades);
    Print("RiskPercent: ", RiskPercent, "%");
    Print("StopLoss: ", StopLoss, " pips");
    Print("TakeProfit: ", TakeProfit, " pips");
    Print("VolumeThreshold: ", VolumeThreshold);
    Print("AI_ConfidenceThreshold: ", AI_ConfidenceThreshold);
}

//+------------------------------------------------------------------+
//| EJEMPLO 4: Configuración para Scalping                          |
//+------------------------------------------------------------------+
/*
OBJETIVO: 40% rendimiento mensual con trading de alta frecuencia
CUENTA: $10,000+
ESTILO: Scalping
TIEMPO: Trading activo durante sesiones principales
*/

void SetupScalpingConfig()
{
    //--- Parámetros principales
    double LotSize = 0.1;
    int MaxTrades = 5;
    double RiskPercent = 1.0;
    int StopLoss = 15;
    int TakeProfit = 30;
    
    //--- Parámetros de volumen
    double VolumeThreshold = 2.0;
    int VolumePeriod = 10;
    int VolumeMA_Period = 5;
    bool UseVolumeFilter = true;
    
    //--- Parámetros de IA
    double AI_ConfidenceThreshold = 0.6;
    int AI_PredictionPeriod = 5;
    bool UseAI = true;
    int LearningPeriod = 50;
    
    //--- Parámetros de tiempo
    int StartHour = 8;
    int EndHour = 18;
    bool TradeOnNews = false;
    bool TradeOnFriday = true;
    
    Print("=== CONFIGURACIÓN SCALPING ===");
    Print("LotSize: ", LotSize);
    Print("MaxTrades: ", MaxTrades);
    Print("RiskPercent: ", RiskPercent, "%");
    Print("StopLoss: ", StopLoss, " pips");
    Print("TakeProfit: ", TakeProfit, " pips");
    Print("VolumeThreshold: ", VolumeThreshold);
    Print("AI_ConfidenceThreshold: ", AI_ConfidenceThreshold);
}

//+------------------------------------------------------------------+
//| EJEMPLO 5: Configuración para Swing Trading                     |
//+------------------------------------------------------------------+
/*
OBJETIVO: 20% rendimiento mensual con posiciones de mediano plazo
CUENTA: $5,000+
ESTILO: Swing Trading
TIEMPO: 1-2 horas al día
*/

void SetupSwingConfig()
{
    //--- Parámetros principales
    double LotSize = 0.2;
    int MaxTrades = 2;
    double RiskPercent = 2.0;
    int StopLoss = 100;
    int TakeProfit = 200;
    
    //--- Parámetros de volumen
    double VolumeThreshold = 1.8;
    int VolumePeriod = 30;
    int VolumeMA_Period = 15;
    bool UseVolumeFilter = true;
    
    //--- Parámetros de IA
    double AI_ConfidenceThreshold = 0.8;
    int AI_PredictionPeriod = 20;
    bool UseAI = true;
    int LearningPeriod = 200;
    
    //--- Parámetros de tiempo
    int StartHour = 9;
    int EndHour = 17;
    bool TradeOnNews = false;
    bool TradeOnFriday = true;
    
    Print("=== CONFIGURACIÓN SWING TRADING ===");
    Print("LotSize: ", LotSize);
    Print("MaxTrades: ", MaxTrades);
    Print("RiskPercent: ", RiskPercent, "%");
    Print("StopLoss: ", StopLoss, " pips");
    Print("TakeProfit: ", TakeProfit, " pips");
    Print("VolumeThreshold: ", VolumeThreshold);
    Print("AI_ConfidenceThreshold: ", AI_ConfidenceThreshold);
}

//+------------------------------------------------------------------+
//| EJEMPLO 6: Configuración para Trading 24/7 (VPS)               |
//+------------------------------------------------------------------+
/*
OBJETIVO: 35% rendimiento mensual con trading continuo
CUENTA: $50,000+
ESTILO: Trading 24/7
TIEMPO: Automático en VPS
*/

void Setup24_7Config()
{
    //--- Parámetros principales
    double LotSize = 0.3;
    int MaxTrades = 4;
    double RiskPercent = 1.5;
    int StopLoss = 60;
    int TakeProfit = 120;
    
    //--- Parámetros de volumen
    double VolumeThreshold = 1.5;
    int VolumePeriod = 20;
    int VolumeMA_Period = 10;
    bool UseVolumeFilter = true;
    
    //--- Parámetros de IA
    double AI_ConfidenceThreshold = 0.7;
    int AI_PredictionPeriod = 10;
    bool UseAI = true;
    int LearningPeriod = 100;
    
    //--- Parámetros de tiempo
    int StartHour = 0;
    int EndHour = 23;
    bool TradeOnNews = false;
    bool TradeOnFriday = true;
    
    Print("=== CONFIGURACIÓN 24/7 ===");
    Print("LotSize: ", LotSize);
    Print("MaxTrades: ", MaxTrades);
    Print("RiskPercent: ", RiskPercent, "%");
    Print("StopLoss: ", StopLoss, " pips");
    Print("TakeProfit: ", TakeProfit, " pips");
    Print("VolumeThreshold: ", VolumeThreshold);
    Print("AI_ConfidenceThreshold: ", AI_ConfidenceThreshold);
}

//+------------------------------------------------------------------+
//| EJEMPLO 7: Configuración para Recuperación de Pérdidas          |
//+------------------------------------------------------------------+
/*
OBJETIVO: Recuperar pérdidas con configuración ultra-conservadora
CUENTA: Cualquier tamaño
ESTILO: Ultra-conservador
TIEMPO: 1-2 horas al día
*/

void SetupRecoveryConfig()
{
    //--- Parámetros principales
    double LotSize = 0.01;
    int MaxTrades = 1;
    double RiskPercent = 0.5;
    int StopLoss = 20;
    int TakeProfit = 40;
    
    //--- Parámetros de volumen
    double VolumeThreshold = 2.5;
    int VolumePeriod = 30;
    int VolumeMA_Period = 20;
    bool UseVolumeFilter = true;
    
    //--- Parámetros de IA
    double AI_ConfidenceThreshold = 0.9;
    int AI_PredictionPeriod = 20;
    bool UseAI = true;
    int LearningPeriod = 300;
    
    //--- Parámetros de tiempo
    int StartHour = 10;
    int EndHour = 16;
    bool TradeOnNews = false;
    bool TradeOnFriday = false;
    
    Print("=== CONFIGURACIÓN RECUPERACIÓN ===");
    Print("LotSize: ", LotSize);
    Print("MaxTrades: ", MaxTrades);
    Print("RiskPercent: ", RiskPercent, "%");
    Print("StopLoss: ", StopLoss, " pips");
    Print("TakeProfit: ", TakeProfit, " pips");
    Print("VolumeThreshold: ", VolumeThreshold);
    Print("AI_ConfidenceThreshold: ", AI_ConfidenceThreshold);
}

//+------------------------------------------------------------------+
//| EJEMPLO 8: Configuración para Trading de Noticias               |
//+------------------------------------------------------------------+
/*
OBJETIVO: 50% rendimiento mensual aprovechando movimientos de noticias
CUENTA: $25,000+
ESTILO: Trading de noticias
TIEMPO: Durante anuncios importantes
*/

void SetupNewsConfig()
{
    //--- Parámetros principales
    double LotSize = 0.2;
    int MaxTrades = 3;
    double RiskPercent = 2.5;
    int StopLoss = 30;
    int TakeProfit = 90;
    
    //--- Parámetros de volumen
    double VolumeThreshold = 3.0;
    int VolumePeriod = 15;
    int VolumeMA_Period = 8;
    bool UseVolumeFilter = true;
    
    //--- Parámetros de IA
    double AI_ConfidenceThreshold = 0.5;
    int AI_PredictionPeriod = 5;
    bool UseAI = true;
    int LearningPeriod = 50;
    
    //--- Parámetros de tiempo
    int StartHour = 8;
    int EndHour = 18;
    bool TradeOnNews = true;
    bool TradeOnFriday = true;
    
    Print("=== CONFIGURACIÓN TRADING DE NOTICIAS ===");
    Print("LotSize: ", LotSize);
    Print("MaxTrades: ", MaxTrades);
    Print("RiskPercent: ", RiskPercent, "%");
    Print("StopLoss: ", StopLoss, " pips");
    Print("TakeProfit: ", TakeProfit, " pips");
    Print("VolumeThreshold: ", VolumeThreshold);
    Print("AI_ConfidenceThreshold: ", AI_ConfidenceThreshold);
}

//+------------------------------------------------------------------+
//| Función principal para mostrar todas las configuraciones         |
//+------------------------------------------------------------------+
void OnStart()
{
    Print("=== CONFIGURACIONES DE EJEMPLO VOLUMEA AI BOT ===");
    Print("Selecciona la configuración que mejor se adapte a tu estilo de trading:");
    Print("");
    
    SetupBeginnerConfig();
    Print("");
    SetupIntermediateConfig();
    Print("");
    SetupAdvancedConfig();
    Print("");
    SetupScalpingConfig();
    Print("");
    SetupSwingConfig();
    Print("");
    Setup24_7Config();
    Print("");
    SetupRecoveryConfig();
    Print("");
    SetupNewsConfig();
    
    Print("=== FIN DE CONFIGURACIONES ===");
    Print("Copia los parámetros de la configuración que prefieras");
    Print("y pégalos en el bot principal VolumeAI_TradingBot.mq5");
}
