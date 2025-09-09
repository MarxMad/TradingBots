//+------------------------------------------------------------------+
//|                                        VolumeAI_Strategies.mq5 |
//|                        Copyright 2024, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property description "Estrategias de Trading Especializadas con IA y Volumen"

//--- Estrategias especializadas para diferentes estilos de trading
//--- Incluir en el bot principal para mayor flexibilidad

//+------------------------------------------------------------------+
//| Estrategia de Scalping con Volumen                              |
//+------------------------------------------------------------------+
class CVolumeScalpingStrategy
{
private:
    int m_period;
    double m_volumeThreshold;
    double m_profitTarget;
    int m_stopLoss;
    
public:
    CVolumeScalpingStrategy(int period = 5, double volumeThreshold = 2.0, double profitTarget = 0.5, int stopLoss = 10)
    {
        m_period = period;
        m_volumeThreshold = volumeThreshold;
        m_profitTarget = profitTarget;
        m_stopLoss = stopLoss;
    }
    
    double GetSignal()
    {
        double signal = 0.0;
        
        //--- Análisis de volumen en timeframe corto
        double currentVolume = GetVolume(0);
        double avgVolume = GetAverageVolume(m_period);
        
        if(currentVolume < avgVolume * m_volumeThreshold) return 0.0;
        
        //--- Análisis de momentum
        double momentum = GetMomentum(3);
        
        //--- Análisis de spread
        double spread = GetCurrentSpread();
        if(spread > 2.0) return 0.0; // Spread muy alto para scalping
        
        //--- Señal basada en volumen y momentum
        if(momentum > 0.001 && currentVolume > avgVolume * m_volumeThreshold)
            signal = 1.0;
        else if(momentum < -0.001 && currentVolume > avgVolume * m_volumeThreshold)
            signal = -1.0;
        
        return signal;
    }
    
    double GetProfitTarget() { return m_profitTarget; }
    int GetStopLoss() { return m_stopLoss; }
    
private:
    double GetVolume(int shift)
    {
        double volume[];
        if(CopyBuffer(iVolumes(_Symbol, PERIOD_M1), 0, shift, 1, volume) <= 0)
            return 0.0;
        return volume[0];
    }
    
    double GetAverageVolume(int period)
    {
        double volume[];
        if(CopyBuffer(iVolumes(_Symbol, PERIOD_M1), 0, 0, period, volume) <= 0)
            return 0.0;
        
        double sum = 0.0;
        for(int i = 0; i < period; i++)
            sum += volume[i];
        
        return sum / period;
    }
    
    double GetMomentum(int period)
    {
        double prices[];
        if(CopyClose(_Symbol, PERIOD_M1, 0, period + 1, prices) <= 0)
            return 0.0;
        
        return (prices[0] - prices[period]) / prices[period];
    }
    
    double GetCurrentSpread()
    {
        double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
        double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
        return (ask - bid) / _Point;
    }
};

//+------------------------------------------------------------------+
//| Estrategia de Swing Trading con Volumen                         |
//+------------------------------------------------------------------+
class CVolumeSwingStrategy
{
private:
    int m_volumePeriod;
    int m_trendPeriod;
    double m_volumeThreshold;
    double m_trendThreshold;
    
public:
    CVolumeSwingStrategy(int volumePeriod = 20, int trendPeriod = 50, double volumeThreshold = 1.5, double trendThreshold = 0.02)
    {
        m_volumePeriod = volumePeriod;
        m_trendPeriod = trendPeriod;
        m_volumeThreshold = volumeThreshold;
        m_trendThreshold = trendThreshold;
    }
    
    double GetSignal()
    {
        double signal = 0.0;
        
        //--- Análisis de tendencia
        double trend = GetTrendStrength();
        if(MathAbs(trend) < m_trendThreshold) return 0.0;
        
        //--- Análisis de volumen
        double volumeConfirmation = GetVolumeConfirmation();
        if(volumeConfirmation < m_volumeThreshold) return 0.0;
        
        //--- Análisis de soporte y resistencia
        double supportResistance = GetSupportResistanceSignal();
        
        //--- Combinar señales
        signal = (trend * 0.4) + (volumeConfirmation * 0.3) + (supportResistance * 0.3);
        
        return MathMax(-1.0, MathMin(1.0, signal));
    }
    
private:
    double GetTrendStrength()
    {
        double prices[];
        if(CopyClose(_Symbol, PERIOD_H1, 0, m_trendPeriod, prices) <= 0)
            return 0.0;
        
        //--- Calcular pendiente de la línea de tendencia
        double sumX = 0.0, sumY = 0.0, sumXY = 0.0, sumX2 = 0.0;
        
        for(int i = 0; i < m_trendPeriod; i++)
        {
            sumX += i;
            sumY += prices[i];
            sumXY += i * prices[i];
            sumX2 += i * i;
        }
        
        double n = m_trendPeriod;
        double slope = (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX);
        
        return slope / prices[0]; // Normalizar
    }
    
    double GetVolumeConfirmation()
    {
        double volumes[];
        if(CopyBuffer(iVolumes(_Symbol, PERIOD_H1), 0, 0, m_volumePeriod, volumes) <= 0)
            return 0.0;
        
        double recentVolume = 0.0;
        double avgVolume = 0.0;
        
        for(int i = 0; i < 5; i++)
            recentVolume += volumes[i];
        recentVolume /= 5.0;
        
        for(int i = 5; i < m_volumePeriod; i++)
            avgVolume += volumes[i];
        avgVolume /= (m_volumePeriod - 5);
        
        if(avgVolume == 0) return 0.0;
        
        return recentVolume / avgVolume;
    }
    
    double GetSupportResistanceSignal()
    {
        double prices[];
        if(CopyClose(_Symbol, PERIOD_H1, 0, 20, prices) <= 0)
            return 0.0;
        
        double currentPrice = prices[0];
        double high = prices[ArrayMaximum(prices, 0, 20)];
        double low = prices[ArrayMinimum(prices, 0, 20)];
        
        //--- Si el precio está cerca de la resistencia, señal de venta
        if(currentPrice > high * 0.98)
            return -0.5;
        
        //--- Si el precio está cerca del soporte, señal de compra
        if(currentPrice < low * 1.02)
            return 0.5;
        
        return 0.0;
    }
};

//+------------------------------------------------------------------+
//| Estrategia de Breakout con Volumen                              |
//+------------------------------------------------------------------+
class CVolumeBreakoutStrategy
{
private:
    int m_consolidationPeriod;
    double m_breakoutThreshold;
    double m_volumeMultiplier;
    
public:
    CVolumeBreakoutStrategy(int consolidationPeriod = 20, double breakoutThreshold = 0.005, double volumeMultiplier = 2.0)
    {
        m_consolidationPeriod = consolidationPeriod;
        m_breakoutThreshold = breakoutThreshold;
        m_volumeMultiplier = volumeMultiplier;
    }
    
    double GetSignal()
    {
        double signal = 0.0;
        
        //--- Detectar consolidación
        if(!IsConsolidating()) return 0.0;
        
        //--- Detectar breakout
        double breakoutDirection = GetBreakoutDirection();
        if(MathAbs(breakoutDirection) < m_breakoutThreshold) return 0.0;
        
        //--- Confirmar con volumen
        if(!IsVolumeConfirming()) return 0.0;
        
        signal = breakoutDirection > 0 ? 1.0 : -1.0;
        
        return signal;
    }
    
private:
    bool IsConsolidating()
    {
        double prices[];
        if(CopyClose(_Symbol, PERIOD_H1, 0, m_consolidationPeriod, prices) <= 0)
            return false;
        
        double high = prices[ArrayMaximum(prices, 0, m_consolidationPeriod)];
        double low = prices[ArrayMinimum(prices, 0, m_consolidationPeriod)];
        
        double range = (high - low) / low;
        
        return range < 0.02; // Rango de consolidación menor al 2%
    }
    
    double GetBreakoutDirection()
    {
        double prices[];
        if(CopyClose(_Symbol, PERIOD_H1, 0, m_consolidationPeriod + 5, prices) <= 0)
            return 0.0;
        
        double consolidationHigh = 0.0;
        double consolidationLow = 1000000.0;
        
        for(int i = 5; i < m_consolidationPeriod + 5; i++)
        {
            if(prices[i] > consolidationHigh) consolidationHigh = prices[i];
            if(prices[i] < consolidationLow) consolidationLow = prices[i];
        }
        
        double currentPrice = prices[0];
        double range = consolidationHigh - consolidationLow;
        
        if(currentPrice > consolidationHigh + range * 0.1)
            return 1.0; // Breakout alcista
        else if(currentPrice < consolidationLow - range * 0.1)
            return -1.0; // Breakout bajista
        
        return 0.0;
    }
    
    bool IsVolumeConfirming()
    {
        double volumes[];
        if(CopyBuffer(iVolumes(_Symbol, PERIOD_H1), 0, 0, 10, volumes) <= 0)
            return false;
        
        double recentVolume = 0.0;
        double avgVolume = 0.0;
        
        for(int i = 0; i < 3; i++)
            recentVolume += volumes[i];
        recentVolume /= 3.0;
        
        for(int i = 3; i < 10; i++)
            avgVolume += volumes[i];
        avgVolume /= 7.0;
        
        return recentVolume > avgVolume * m_volumeMultiplier;
    }
};

//+------------------------------------------------------------------+
//| Estrategia de Mean Reversion con Volumen                        |
//+------------------------------------------------------------------+
class CVolumeMeanReversionStrategy
{
private:
    int m_period;
    double m_deviationThreshold;
    double m_volumeThreshold;
    
public:
    CVolumeMeanReversionStrategy(int period = 20, double deviationThreshold = 2.0, double volumeThreshold = 1.2)
    {
        m_period = period;
        m_deviationThreshold = deviationThreshold;
        m_volumeThreshold = volumeThreshold;
    }
    
    double GetSignal()
    {
        double signal = 0.0;
        
        //--- Calcular desviación del precio respecto a la media
        double deviation = GetPriceDeviation();
        if(MathAbs(deviation) < m_deviationThreshold) return 0.0;
        
        //--- Verificar volumen de confirmación
        if(!IsVolumeConfirming()) return 0.0;
        
        //--- Señal contraria a la desviación
        signal = deviation > 0 ? -1.0 : 1.0;
        
        return signal;
    }
    
private:
    double GetPriceDeviation()
    {
        double prices[];
        if(CopyClose(_Symbol, PERIOD_H1, 0, m_period, prices) <= 0)
            return 0.0;
        
        double sum = 0.0;
        for(int i = 0; i < m_period; i++)
            sum += prices[i];
        
        double mean = sum / m_period;
        double currentPrice = prices[0];
        
        return (currentPrice - mean) / mean;
    }
    
    bool IsVolumeConfirming()
    {
        double volumes[];
        if(CopyBuffer(iVolumes(_Symbol, PERIOD_H1), 0, 0, 10, volumes) <= 0)
            return false;
        
        double recentVolume = 0.0;
        double avgVolume = 0.0;
        
        for(int i = 0; i < 3; i++)
            recentVolume += volumes[i];
        recentVolume /= 3.0;
        
        for(int i = 3; i < 10; i++)
            avgVolume += volumes[i];
        avgVolume /= 7.0;
        
        return recentVolume > avgVolume * m_volumeThreshold;
    }
};

//+------------------------------------------------------------------+
//| Estrategia de Momentum con Volumen                              |
//+------------------------------------------------------------------+
class CVolumeMomentumStrategy
{
private:
    int m_momentumPeriod;
    int m_volumePeriod;
    double m_momentumThreshold;
    double m_volumeThreshold;
    
public:
    CVolumeMomentumStrategy(int momentumPeriod = 10, int volumePeriod = 15, double momentumThreshold = 0.01, double volumeThreshold = 1.3)
    {
        m_momentumPeriod = momentumPeriod;
        m_volumePeriod = volumePeriod;
        m_momentumThreshold = momentumThreshold;
        m_volumeThreshold = volumeThreshold;
    }
    
    double GetSignal()
    {
        double signal = 0.0;
        
        //--- Calcular momentum
        double momentum = GetMomentum();
        if(MathAbs(momentum) < m_momentumThreshold) return 0.0;
        
        //--- Verificar volumen
        if(!IsVolumeConfirming()) return 0.0;
        
        //--- Señal en dirección del momentum
        signal = momentum > 0 ? 1.0 : -1.0;
        
        return signal;
    }
    
private:
    double GetMomentum()
    {
        double prices[];
        if(CopyClose(_Symbol, PERIOD_H1, 0, m_momentumPeriod + 1, prices) <= 0)
            return 0.0;
        
        return (prices[0] - prices[m_momentumPeriod]) / prices[m_momentumPeriod];
    }
    
    bool IsVolumeConfirming()
    {
        double volumes[];
        if(CopyBuffer(iVolumes(_Symbol, PERIOD_H1), 0, 0, m_volumePeriod, volumes) <= 0)
            return false;
        
        double recentVolume = 0.0;
        double avgVolume = 0.0;
        
        for(int i = 0; i < 5; i++)
            recentVolume += volumes[i];
        recentVolume /= 5.0;
        
        for(int i = 5; i < m_volumePeriod; i++)
            avgVolume += volumes[i];
        avgVolume /= (m_volumePeriod - 5);
        
        return recentVolume > avgVolume * m_volumeThreshold;
    }
};

//+------------------------------------------------------------------+
//| Gestor de Estrategias Múltiples                                 |
//+------------------------------------------------------------------+
class CStrategyManager
{
private:
    CVolumeScalpingStrategy* m_scalping;
    CVolumeSwingStrategy* m_swing;
    CVolumeBreakoutStrategy* m_breakout;
    CVolumeMeanReversionStrategy* m_meanReversion;
    CVolumeMomentumStrategy* m_momentum;
    
    double m_weights[5];
    
public:
    CStrategyManager()
    {
        m_scalping = new CVolumeScalpingStrategy();
        m_swing = new CVolumeSwingStrategy();
        m_breakout = new CVolumeBreakoutStrategy();
        m_meanReversion = new CVolumeMeanReversionStrategy();
        m_momentum = new CVolumeMomentumStrategy();
        
        //--- Pesos de las estrategias (suman 1.0)
        m_weights[0] = 0.20; // Scalping
        m_weights[1] = 0.25; // Swing
        m_weights[2] = 0.20; // Breakout
        m_weights[3] = 0.15; // Mean Reversion
        m_weights[4] = 0.20; // Momentum
    }
    
    ~CStrategyManager()
    {
        delete m_scalping;
        delete m_swing;
        delete m_breakout;
        delete m_meanReversion;
        delete m_momentum;
    }
    
    double GetCombinedSignal()
    {
        double signals[5];
        signals[0] = m_scalping->GetSignal();
        signals[1] = m_swing->GetSignal();
        signals[2] = m_breakout->GetSignal();
        signals[3] = m_meanReversion->GetSignal();
        signals[4] = m_momentum->GetSignal();
        
        double combinedSignal = 0.0;
        for(int i = 0; i < 5; i++)
        {
            combinedSignal += signals[i] * m_weights[i];
        }
        
        return MathMax(-1.0, MathMin(1.0, combinedSignal));
    }
    
    void UpdateWeights(double newWeights[5])
    {
        double sum = 0.0;
        for(int i = 0; i < 5; i++)
        {
            m_weights[i] = newWeights[i];
            sum += newWeights[i];
        }
        
        //--- Normalizar pesos
        if(sum > 0)
        {
            for(int i = 0; i < 5; i++)
            {
                m_weights[i] /= sum;
            }
        }
    }
    
    string GetStrategyStatus()
    {
        string status = "=== ESTADO DE ESTRATEGIAS ===\n";
        status += "Scalping: " + DoubleToString(m_scalping->GetSignal(), 2) + "\n";
        status += "Swing: " + DoubleToString(m_swing->GetSignal(), 2) + "\n";
        status += "Breakout: " + DoubleToString(m_breakout->GetSignal(), 2) + "\n";
        status += "Mean Reversion: " + DoubleToString(m_meanReversion->GetSignal(), 2) + "\n";
        status += "Momentum: " + DoubleToString(m_momentum->GetSignal(), 2) + "\n";
        status += "Señal Combinada: " + DoubleToString(GetCombinedSignal(), 2);
        
        return status;
    }
};
