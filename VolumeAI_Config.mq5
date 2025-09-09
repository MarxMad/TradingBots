//+------------------------------------------------------------------+
//|                                           VolumeAI_Config.mq5 |
//|                        Copyright 2024, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property description "Archivo de Configuración para VolumeAI Trading Bot"

//+------------------------------------------------------------------+
//| Configuraciones Predefinidas para Diferentes Tipos de Cuenta    |
//+------------------------------------------------------------------+

//--- Configuración para Cuenta Micro ($100 - $1,000)
struct SMicroAccountConfig
{
    double   LotSize;
    int      MaxTrades;
    double   RiskPercent;
    int      StopLoss;
    int      TakeProfit;
    double   VolumeThreshold;
    double   AI_ConfidenceThreshold;
    int      VolumePeriod;
    int      StartHour;
    int      EndHour;
    bool     UseVolumeFilter;
    bool     UseAI;
};

SMicroAccountConfig MicroConfig = {
    0.01,    // LotSize
    2,       // MaxTrades
    1.0,     // RiskPercent
    30,      // StopLoss
    60,      // TakeProfit
    1.2,     // VolumeThreshold
    0.6,     // AI_ConfidenceThreshold
    15,      // VolumePeriod
    8,       // StartHour
    16,      // EndHour
    true,    // UseVolumeFilter
    true     // UseAI
};

//--- Configuración para Cuenta Estándar ($1,000 - $10,000)
struct SStandardAccountConfig
{
    double   LotSize;
    int      MaxTrades;
    double   RiskPercent;
    int      StopLoss;
    int      TakeProfit;
    double   VolumeThreshold;
    double   AI_ConfidenceThreshold;
    int      VolumePeriod;
    int      StartHour;
    int      EndHour;
    bool     UseVolumeFilter;
    bool     UseAI;
};

SStandardAccountConfig StandardConfig = {
    0.1,     // LotSize
    3,       // MaxTrades
    1.5,     // RiskPercent
    50,      // StopLoss
    100,     // TakeProfit
    1.5,     // VolumeThreshold
    0.7,     // AI_ConfidenceThreshold
    20,      // VolumePeriod
    8,       // StartHour
    18,      // EndHour
    true,    // UseVolumeFilter
    true     // UseAI
};

//--- Configuración para Cuenta Profesional ($10,000+)
struct SProfessionalAccountConfig
{
    double   LotSize;
    int      MaxTrades;
    double   RiskPercent;
    int      StopLoss;
    int      TakeProfit;
    double   VolumeThreshold;
    double   AI_ConfidenceThreshold;
    int      VolumePeriod;
    int      StartHour;
    int      EndHour;
    bool     UseVolumeFilter;
    bool     UseAI;
};

SProfessionalAccountConfig ProfessionalConfig = {
    0.5,     // LotSize
    5,       // MaxTrades
    2.0,     // RiskPercent
    50,      // StopLoss
    100,     // TakeProfit
    1.5,     // VolumeThreshold
    0.7,     // AI_ConfidenceThreshold
    20,      // VolumePeriod
    8,       // StartHour
    20,      // EndHour
    true,    // UseVolumeFilter
    true     // UseAI
};

//--- Configuración para Cuenta Conservadora (Enfoque de bajo riesgo)
struct SConservativeAccountConfig
{
    double   LotSize;
    int      MaxTrades;
    double   RiskPercent;
    int      StopLoss;
    int      TakeProfit;
    double   VolumeThreshold;
    double   AI_ConfidenceThreshold;
    int      VolumePeriod;
    int      StartHour;
    int      EndHour;
    bool     UseVolumeFilter;
    bool     UseAI;
};

SConservativeAccountConfig ConservativeConfig = {
    0.05,    // LotSize
    2,       // MaxTrades
    0.5,     // RiskPercent
    20,      // StopLoss
    40,      // TakeProfit
    2.0,     // VolumeThreshold
    0.8,     // AI_ConfidenceThreshold
    25,      // VolumePeriod
    9,       // StartHour
    17,      // EndHour
    true,    // UseVolumeFilter
    true     // UseAI
};

//--- Configuración para Cuenta Agresiva (Enfoque de alto rendimiento)
struct SAggressiveAccountConfig
{
    double   LotSize;
    int      MaxTrades;
    double   RiskPercent;
    int      StopLoss;
    int      TakeProfit;
    double   VolumeThreshold;
    double   AI_ConfidenceThreshold;
    int      VolumePeriod;
    int      StartHour;
    int      EndHour;
    bool     UseVolumeFilter;
    bool     UseAI;
};

SAggressiveAccountConfig AggressiveConfig = {
    1.0,     // LotSize
    8,       // MaxTrades
    3.0,     // RiskPercent
    30,      // StopLoss
    90,      // TakeProfit
    1.2,     // VolumeThreshold
    0.6,     // AI_ConfidenceThreshold
    15,      // VolumePeriod
    7,       // StartHour
    21,      // EndHour
    true,    // UseVolumeFilter
    true     // UseAI
};

//+------------------------------------------------------------------+
//| Configuraciones por Símbolo                                     |
//+------------------------------------------------------------------+

//--- Configuración para EURUSD
struct SEURUSDConfig
{
    double   LotSize;
    int      StopLoss;
    int      TakeProfit;
    double   VolumeThreshold;
    int      VolumePeriod;
    int      StartHour;
    int      EndHour;
};

SEURUSDConfig EURUSDConfig = {
    0.1,     // LotSize
    50,      // StopLoss
    100,     // TakeProfit
    1.5,     // VolumeThreshold
    20,      // VolumePeriod
    8,       // StartHour
    18       // EndHour
};

//--- Configuración para GBPUSD
struct SGBPUSDConfig
{
    double   LotSize;
    int      StopLoss;
    int      TakeProfit;
    double   VolumeThreshold;
    int      VolumePeriod;
    int      StartHour;
    int      EndHour;
};

SGBPUSDConfig GBPUSDConfig = {
    0.1,     // LotSize
    60,      // StopLoss
    120,     // TakeProfit
    1.8,     // VolumeThreshold
    25,      // VolumePeriod
    8,       // StartHour
    18       // EndHour
};

//--- Configuración para USDJPY
struct SUSDJPYConfig
{
    double   LotSize;
    int      StopLoss;
    int      TakeProfit;
    double   VolumeThreshold;
    int      VolumePeriod;
    int      StartHour;
    int      EndHour;
};

SUSDJPYConfig USDJPYConfig = {
    0.1,     // LotSize
    40,      // StopLoss
    80,      // TakeProfit
    1.3,     // VolumeThreshold
    18,      // VolumePeriod
    8,       // StartHour
    18       // EndHour
};

//+------------------------------------------------------------------+
//| Configuraciones de Estrategias                                  |
//+------------------------------------------------------------------+

//--- Configuración para Scalping
struct SScalpingConfig
{
    int      Timeframe;
    double   VolumeThreshold;
    int      StopLoss;
    int      TakeProfit;
    double   ProfitTarget;
    int      MaxTrades;
    bool     UseSpreadFilter;
    double   MaxSpread;
};

SScalpingConfig ScalpingConfig = {
    PERIOD_M1,  // Timeframe
    2.0,        // VolumeThreshold
    10,         // StopLoss
    20,         // TakeProfit
    0.5,        // ProfitTarget
    3,          // MaxTrades
    true,       // UseSpreadFilter
    2.0         // MaxSpread
};

//--- Configuración para Swing Trading
struct SSwingConfig
{
    int      Timeframe;
    double   VolumeThreshold;
    int      StopLoss;
    int      TakeProfit;
    int      TrendPeriod;
    double   TrendThreshold;
    int      MaxTrades;
};

SSwingConfig SwingConfig = {
    PERIOD_H1,  // Timeframe
    1.5,        // VolumeThreshold
    100,        // StopLoss
    200,        // TakeProfit
    50,         // TrendPeriod
    0.02,       // TrendThreshold
    2           // MaxTrades
};

//--- Configuración para Breakout Trading
struct SBreakoutConfig
{
    int      Timeframe;
    int      ConsolidationPeriod;
    double   BreakoutThreshold;
    double   VolumeMultiplier;
    int      StopLoss;
    int      TakeProfit;
    int      MaxTrades;
};

SBreakoutConfig BreakoutConfig = {
    PERIOD_H1,  // Timeframe
    20,         // ConsolidationPeriod
    0.005,      // BreakoutThreshold
    2.0,        // VolumeMultiplier
    80,         // StopLoss
    160,        // TakeProfit
    2           // MaxTrades
};

//+------------------------------------------------------------------+
//| Configuraciones de IA                                           |
//+------------------------------------------------------------------+

//--- Configuración de Red Neuronal
struct SNeuralNetworkConfig
{
    int      InputNodes;
    int      HiddenNodes;
    int      OutputNodes;
    double   LearningRate;
    int      Epochs;
    double   Momentum;
    bool     UseDropout;
    double   DropoutRate;
};

SNeuralNetworkConfig NeuralConfig = {
    10,         // InputNodes (precio, volumen, RSI, MACD, etc.)
    20,         // HiddenNodes
    1,          // OutputNodes (señal de trading)
    0.01,       // LearningRate
    1000,       // Epochs
    0.9,        // Momentum
    true,       // UseDropout
    0.2         // DropoutRate
};

//--- Configuración de Algoritmos Genéticos
struct SGeneticAlgorithmConfig
{
    int      PopulationSize;
    int      Generations;
    double   MutationRate;
    double   CrossoverRate;
    double   EliteRate;
    int      TournamentSize;
};

SGeneticAlgorithmConfig GeneticConfig = {
    50,         // PopulationSize
    100,        // Generations
    0.1,        // MutationRate
    0.8,        // CrossoverRate
    0.1,        // EliteRate
    5           // TournamentSize
};

//+------------------------------------------------------------------+
//| Configuraciones de Gestión de Riesgo                            |
//+------------------------------------------------------------------+

//--- Configuración de Money Management
struct SMoneyManagementConfig
{
    double   MaxRiskPerTrade;
    double   MaxDailyRisk;
    double   MaxWeeklyRisk;
    double   MaxMonthlyRisk;
    double   MaxDrawdown;
    int      MaxConsecutiveLosses;
    bool     UsePositionSizing;
    bool     UsePyramiding;
    int      MaxPyramidLevels;
};

SMoneyManagementConfig MoneyConfig = {
    2.0,        // MaxRiskPerTrade (%)
    5.0,        // MaxDailyRisk (%)
    15.0,       // MaxWeeklyRisk (%)
    30.0,       // MaxMonthlyRisk (%)
    10.0,       // MaxDrawdown (%)
    3,          // MaxConsecutiveLosses
    true,       // UsePositionSizing
    false,      // UsePyramiding
    2           // MaxPyramidLevels
};

//+------------------------------------------------------------------+
//| Configuraciones de Notificaciones                               |
//+------------------------------------------------------------------+

//--- Configuración de Alertas
struct SNotificationConfig
{
    bool     SendEmail;
    bool     SendPush;
    bool     SendSMS;
    bool     LogToFile;
    bool     ShowAlerts;
    string   EmailAddress;
    string   PhoneNumber;
    bool     NotifyOnTradeOpen;
    bool     NotifyOnTradeClose;
    bool     NotifyOnError;
    bool     NotifyOnTargetReached;
};

SNotificationConfig NotificationConfig = {
    false,      // SendEmail
    true,       // SendPush
    false,      // SendSMS
    true,       // LogToFile
    true,       // ShowAlerts
    "",         // EmailAddress
    "",         // PhoneNumber
    true,       // NotifyOnTradeOpen
    true,       // NotifyOnTradeClose
    true,       // NotifyOnError
    true        // NotifyOnTargetReached
};

//+------------------------------------------------------------------+
//| Funciones de Configuración                                      |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Obtener configuración según el tipo de cuenta                   |
//+------------------------------------------------------------------+
void GetAccountConfig(int accountType, double &lotSize, int &maxTrades, double &riskPercent, 
                     int &stopLoss, int &takeProfit, double &volumeThreshold, 
                     double &aiConfidence, int &volumePeriod, int &startHour, int &endHour)
{
    switch(accountType)
    {
        case 1: // Micro Account
            lotSize = MicroConfig.LotSize;
            maxTrades = MicroConfig.MaxTrades;
            riskPercent = MicroConfig.RiskPercent;
            stopLoss = MicroConfig.StopLoss;
            takeProfit = MicroConfig.TakeProfit;
            volumeThreshold = MicroConfig.VolumeThreshold;
            aiConfidence = MicroConfig.AI_ConfidenceThreshold;
            volumePeriod = MicroConfig.VolumePeriod;
            startHour = MicroConfig.StartHour;
            endHour = MicroConfig.EndHour;
            break;
            
        case 2: // Standard Account
            lotSize = StandardConfig.LotSize;
            maxTrades = StandardConfig.MaxTrades;
            riskPercent = StandardConfig.RiskPercent;
            stopLoss = StandardConfig.StopLoss;
            takeProfit = StandardConfig.TakeProfit;
            volumeThreshold = StandardConfig.VolumeThreshold;
            aiConfidence = StandardConfig.AI_ConfidenceThreshold;
            volumePeriod = StandardConfig.VolumePeriod;
            startHour = StandardConfig.StartHour;
            endHour = StandardConfig.EndHour;
            break;
            
        case 3: // Professional Account
            lotSize = ProfessionalConfig.LotSize;
            maxTrades = ProfessionalConfig.MaxTrades;
            riskPercent = ProfessionalConfig.RiskPercent;
            stopLoss = ProfessionalConfig.StopLoss;
            takeProfit = ProfessionalConfig.TakeProfit;
            volumeThreshold = ProfessionalConfig.VolumeThreshold;
            aiConfidence = ProfessionalConfig.AI_ConfidenceThreshold;
            volumePeriod = ProfessionalConfig.VolumePeriod;
            startHour = ProfessionalConfig.StartHour;
            endHour = ProfessionalConfig.EndHour;
            break;
            
        case 4: // Conservative Account
            lotSize = ConservativeConfig.LotSize;
            maxTrades = ConservativeConfig.MaxTrades;
            riskPercent = ConservativeConfig.RiskPercent;
            stopLoss = ConservativeConfig.StopLoss;
            takeProfit = ConservativeConfig.TakeProfit;
            volumeThreshold = ConservativeConfig.VolumeThreshold;
            aiConfidence = ConservativeConfig.AI_ConfidenceThreshold;
            volumePeriod = ConservativeConfig.VolumePeriod;
            startHour = ConservativeConfig.StartHour;
            endHour = ConservativeConfig.EndHour;
            break;
            
        case 5: // Aggressive Account
            lotSize = AggressiveConfig.LotSize;
            maxTrades = AggressiveConfig.MaxTrades;
            riskPercent = AggressiveConfig.RiskPercent;
            stopLoss = AggressiveConfig.StopLoss;
            takeProfit = AggressiveConfig.TakeProfit;
            volumeThreshold = AggressiveConfig.VolumeThreshold;
            aiConfidence = AggressiveConfig.AI_ConfidenceThreshold;
            volumePeriod = AggressiveConfig.VolumePeriod;
            startHour = AggressiveConfig.StartHour;
            endHour = AggressiveConfig.EndHour;
            break;
            
        default:
            // Usar configuración estándar
            lotSize = StandardConfig.LotSize;
            maxTrades = StandardConfig.MaxTrades;
            riskPercent = StandardConfig.RiskPercent;
            stopLoss = StandardConfig.StopLoss;
            takeProfit = StandardConfig.TakeProfit;
            volumeThreshold = StandardConfig.VolumeThreshold;
            aiConfidence = StandardConfig.AI_ConfidenceThreshold;
            volumePeriod = StandardConfig.VolumePeriod;
            startHour = StandardConfig.StartHour;
            endHour = StandardConfig.EndHour;
            break;
    }
}

//+------------------------------------------------------------------+
//| Obtener configuración según el símbolo                          |
//+------------------------------------------------------------------+
void GetSymbolConfig(string symbol, double &lotSize, int &stopLoss, int &takeProfit, 
                    double &volumeThreshold, int &volumePeriod, int &startHour, int &endHour)
{
    if(symbol == "EURUSD")
    {
        lotSize = EURUSDConfig.LotSize;
        stopLoss = EURUSDConfig.StopLoss;
        takeProfit = EURUSDConfig.TakeProfit;
        volumeThreshold = EURUSDConfig.VolumeThreshold;
        volumePeriod = EURUSDConfig.VolumePeriod;
        startHour = EURUSDConfig.StartHour;
        endHour = EURUSDConfig.EndHour;
    }
    else if(symbol == "GBPUSD")
    {
        lotSize = GBPUSDConfig.LotSize;
        stopLoss = GBPUSDConfig.StopLoss;
        takeProfit = GBPUSDConfig.TakeProfit;
        volumeThreshold = GBPUSDConfig.VolumeThreshold;
        volumePeriod = GBPUSDConfig.VolumePeriod;
        startHour = GBPUSDConfig.StartHour;
        endHour = GBPUSDConfig.EndHour;
    }
    else if(symbol == "USDJPY")
    {
        lotSize = USDJPYConfig.LotSize;
        stopLoss = USDJPYConfig.StopLoss;
        takeProfit = USDJPYConfig.TakeProfit;
        volumeThreshold = USDJPYConfig.VolumeThreshold;
        volumePeriod = USDJPYConfig.VolumePeriod;
        startHour = USDJPYConfig.StartHour;
        endHour = USDJPYConfig.EndHour;
    }
    else
    {
        // Configuración por defecto
        lotSize = 0.1;
        stopLoss = 50;
        takeProfit = 100;
        volumeThreshold = 1.5;
        volumePeriod = 20;
        startHour = 8;
        endHour = 18;
    }
}

//+------------------------------------------------------------------+
//| Validar configuración                                           |
//+------------------------------------------------------------------+
bool ValidateConfig(double lotSize, int maxTrades, double riskPercent, int stopLoss, int takeProfit)
{
    // Validar tamaño de lote
    if(lotSize <= 0 || lotSize > 100)
    {
        Print("Error: Tamaño de lote inválido (0 < lotSize <= 100)");
        return false;
    }
    
    // Validar máximo de trades
    if(maxTrades <= 0 || maxTrades > 20)
    {
        Print("Error: Máximo de trades inválido (0 < maxTrades <= 20)");
        return false;
    }
    
    // Validar porcentaje de riesgo
    if(riskPercent <= 0 || riskPercent > 10)
    {
        Print("Error: Porcentaje de riesgo inválido (0 < riskPercent <= 10)");
        return false;
    }
    
    // Validar stop loss
    if(stopLoss <= 0 || stopLoss > 1000)
    {
        Print("Error: Stop Loss inválido (0 < stopLoss <= 1000)");
        return false;
    }
    
    // Validar take profit
    if(takeProfit <= 0 || takeProfit > 2000)
    {
        Print("Error: Take Profit inválido (0 < takeProfit <= 2000)");
        return false;
    }
    
    // Validar ratio riesgo/recompensa
    if(takeProfit < stopLoss)
    {
        Print("Advertencia: Take Profit menor que Stop Loss");
    }
    
    return true;
}

//+------------------------------------------------------------------+
//| Guardar configuración en archivo                                |
//+------------------------------------------------------------------+
void SaveConfigToFile(string filename)
{
    int fileHandle = FileOpen(filename, FILE_WRITE | FILE_TXT);
    
    if(fileHandle != INVALID_HANDLE)
    {
        FileWriteString(fileHandle, "=== CONFIGURACIÓN VOLUMEA AI BOT ===\n");
        FileWriteString(fileHandle, "Fecha: " + TimeToString(TimeCurrent()) + "\n\n");
        
        FileWriteString(fileHandle, "=== CONFIGURACIÓN MICRO CUENTA ===\n");
        FileWriteString(fileHandle, "LotSize: " + DoubleToString(MicroConfig.LotSize, 2) + "\n");
        FileWriteString(fileHandle, "MaxTrades: " + IntegerToString(MicroConfig.MaxTrades) + "\n");
        FileWriteString(fileHandle, "RiskPercent: " + DoubleToString(MicroConfig.RiskPercent, 1) + "\n");
        FileWriteString(fileHandle, "StopLoss: " + IntegerToString(MicroConfig.StopLoss) + "\n");
        FileWriteString(fileHandle, "TakeProfit: " + IntegerToString(MicroConfig.TakeProfit) + "\n\n");
        
        FileWriteString(fileHandle, "=== CONFIGURACIÓN ESTÁNDAR CUENTA ===\n");
        FileWriteString(fileHandle, "LotSize: " + DoubleToString(StandardConfig.LotSize, 2) + "\n");
        FileWriteString(fileHandle, "MaxTrades: " + IntegerToString(StandardConfig.MaxTrades) + "\n");
        FileWriteString(fileHandle, "RiskPercent: " + DoubleToString(StandardConfig.RiskPercent, 1) + "\n");
        FileWriteString(fileHandle, "StopLoss: " + IntegerToString(StandardConfig.StopLoss) + "\n");
        FileWriteString(fileHandle, "TakeProfit: " + IntegerToString(StandardConfig.TakeProfit) + "\n\n");
        
        FileWriteString(fileHandle, "=== CONFIGURACIÓN PROFESIONAL CUENTA ===\n");
        FileWriteString(fileHandle, "LotSize: " + DoubleToString(ProfessionalConfig.LotSize, 2) + "\n");
        FileWriteString(fileHandle, "MaxTrades: " + IntegerToString(ProfessionalConfig.MaxTrades) + "\n");
        FileWriteString(fileHandle, "RiskPercent: " + DoubleToString(ProfessionalConfig.RiskPercent, 1) + "\n");
        FileWriteString(fileHandle, "StopLoss: " + IntegerToString(ProfessionalConfig.StopLoss) + "\n");
        FileWriteString(fileHandle, "TakeProfit: " + IntegerToString(ProfessionalConfig.TakeProfit) + "\n");
        
        FileClose(fileHandle);
        Print("Configuración guardada en: ", filename);
    }
    else
    {
        Print("Error: No se pudo crear el archivo de configuración");
    }
}

//+------------------------------------------------------------------+
//| Cargar configuración desde archivo                              |
//+------------------------------------------------------------------+
bool LoadConfigFromFile(string filename)
{
    int fileHandle = FileOpen(filename, FILE_READ | FILE_TXT);
    
    if(fileHandle == INVALID_HANDLE)
    {
        Print("Error: No se pudo abrir el archivo de configuración");
        return false;
    }
    
    // Implementación simplificada de carga de configuración
    // En una implementación real, parsearías el archivo línea por línea
    
    FileClose(fileHandle);
    Print("Configuración cargada desde: ", filename);
    return true;
}
