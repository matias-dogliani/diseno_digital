# Trabajo Práctico Nº 5: 

Implementación y simulación de alto y bajo nivel de sistema de comunicación simple 

![Imagen Sistema de Com](https://github.com/matias-dogliani/diseno_digital/blob/master/Tp5/imgs/diagrama_bloques_sistema.png)

## Ejercicio  1 

   En este ejercicio se implementan los bloques secuencialmente en alto nivel utilizando Python 3. 
   * [Cuaderno de Resolución](https://github.com/matias-dogliani/diseno_digital/blob/master/Tp5/Ej1.ipynb)
    
   Los símbolos transmitidos con conformación de pulso son los de la imagen 
    
   ![Señal S(t)](https://github.com/matias-dogliani/diseno_digital/blob/master/Tp5/imgs/txSymbFlP.png)
       
   La **BER** obtenida es 0, como era de esperarse ya que no se simula algùn canal que pueda agregar ruidos a los símbolos transmistidos o cualquier otra fuente de ruido. 
    

 
 ## Ejercicio 2
  
   En este ejercicio se realiza la implementación del mismo sistema y utilizando también Python aunque con un paradigma enfocado a la implementación en hardware, considerando resolución **Fixed Point** 
    

 ### LFSR 
   
   
   A diferencia del anterior, la secuencia aleatorio de símbolos se realiza con una **LFSR** de orden 9 implementada con flip flops de la clase *ff_model* 
    ![LFSR generica](https://github.com/matias-dogliani/diseno_digital/blob/master/Tp5/imgs/LFSR9.png)
        
    ``` 
    lfsrI.i = lfsrISeed
    lfsrQ.i = lfsrQSeed
    lfsrI.run_clock()
    lfsrQ.run_clock()
    PRBSeqI.append(lfsrI[8].o)
    PRBSeqQ.append(lfsrQ[8].o)
    for clkPulse in range(int(Nsymb-1)):
        lfsrI[0].i =  lfsrI[4].o ^ lfsrI[8].o       #Suma - XOR 
        lfsrQ[0].i =  lfsrQ[4].o ^ lfsrQ[8].o       
    
    for p in range(1,PRBSn):                    #Desplazamiento
        lfsrI[p].i = lfsrI[p-1].o
        lfsrQ[p].i = lfsrQ[p-1].o
    
    lfsrI.run_clock()
    lfsrQ.run_clock()
    
    PRBSeqI.append(lfsrI[8].o)
    PRBSeqQ.append(lfsrQ[8].o)
    
    ```
    
### Filtro de convolución 

   Este filtro se implementación mediante registros de desplazamiento y multiplicadores que multiplican los correspondientes filtr
    ![FIR Filter](https://github.com/matias-dogliani/diseno_digital/blob/master/Tp5/imgs/FIRFilter.png)
    
    
``` 
for validPulse in range(int(Nsymb)): 
    k=k+1
    #Seq input - Uso directamente la PRBSeq mapeada a Baud Rate (sin Os)
    ConvRegI[0].i = akIFp[k].fValue
    ConvRegQ[0].i = akQFp[k].fValue
    #Shift register a Baud Rate 
    for z in range(1,lFilt): 
        ConvRegI[z].i = ConvRegI[z-1].o 
        ConvRegQ[z].i = ConvRegQ[z-1].o 
      
    #Mux de coeficientes - fase de 1 a 4 
    #A frecuencia de clk (en 1 validPulse hago 4 mult)
   
    for clkPulse in range(N):
        SumI = 0
        SumQ = 0
        print("y[{}]".format(len(txSymbI)))
        for Reg in range(lFilt):
            numCoef = clkPulse +Reg*N
            SumI = SumI + (ConvRegI[Reg].o * hFp[numCoef])
            SumQ = SumQ + (ConvRegQ[Reg].o * hFp[numCoef])
            print("Término {} = ConvReg[{}] ({}) * hFp[{}] ({})".
               format(Reg,Reg,ConvRegI[Reg].o,numCoef,hFp[numCoef]))
       
        txSymbI.append(SumI) 
        txSymbQ.append(SumQ)
    
    #Nuevo pulso de clk/4  = Baud Rate 
    #Desplazamiento de registros 
    ConvRegI.run_clock()
    ConvRegQ.run_clock()
    print("------------Shift-----------")
```

Los símbolos transmitidos en punto fijo, y supuerpuesta a la de punto flotante se observan en la imagen 

![Simbolos transmitidos FP](![image.png](attachment:image.png))
   
## Ejercicio 3 

Implementación del sistema en Verilog. 

 ### Modulos 
 
 #### LFSR9 
 
 * [Descripción HDL](https://github.com/matias-dogliani/diseno_digital/blob/master/Tp5/Verilog/modulos/lfsr.v)
 
 Este módulo está compuesto de un registro de desplazamiento de orden 9 realimentando la salida y el término 5 a la entrada mediante una XOR.  
 
 ![Diagrama LFSR9](https://github.com/matias-dogliani/diseno_digital/blob/master/Tp5/imgs/LFSR9.png)
 
 #### Mapper 

 * [Descripción HDL]https://github.com/matias-dogliani/diseno_digital/blob/master/Tp5/Verilog/modulos/mapper.v)
 
 Este módulo es un multiplexor que se encarga de transformar la secuencia aleatoria generado por la LSFR a los símbolos correspondientes
 
 ![Diagrama Mapper](https://github.com/matias-dogliani/diseno_digital/blob/master/Tp5/imgs/mapper.png)
 
 #### FIR filter 
 
  * [Descripción HDL](https://github.com/matias-dogliani/diseno_digital/blob/master/Tp5/Verilog/modulos/FIRfilter.v)
 
 Este módulo está compuesto por NBaudios * WordLenght registros de desplazamientos que se desplazan cada WordLenght bits (2 bits para el caso de PAM2). Cada 2bits se toma una salida conectada a un multiplicador  y luego conectado a un árbol de sumas. 
 
 La multiplicación se realiza a Full Resolutión y al igual que la suma, aunque la salida posee una resolución de S(8.7) con *overflow* y *truncado* 
 
 ![Diagrama FIR filter](https://github.com/matias-dogliani/diseno_digital/blob/master/Tp5/imgs/FIRfilter.png)
 
 ##### Creacion de LUT 
Para generar los coeficientes del filtro y precargarlos en la descripción en Verilog se utilizó un script en Python 

* [Cuaderno de Resolución](https://github.com/matias-dogliani/diseno_digital/blob/master/Tp5/CoeficientesRc.ipynb)
 
 #### Downsampler 
 
 Básicamente este módulo consta de un valid (para retardar la fase indicada)  para habilitar un contador que controla que cada la tasa de muestreo el símbolo de entrada sea el de salida. 
 
 * [Descripción HDL](https://github.com/matias-dogliani/diseno_digital/blob/master/Tp5/Verilog/modulos/downsampler.v)
 
 ![Diagrama Decimador](https://github.com/matias-dogliani/diseno_digital/blob/master/Tp5/imgs/downsampler.png)

#### Slicer 

 * [Descripción HDL](https://github.com/matias-dogliani/diseno_digital/blob/master/Tp5/Verilog/modulos/PAM2slicer.v)
 
 ![Diagrama Decimador](https://github.com/matias-dogliani/diseno_digital/blob/master/Tp5/imgs/slicer.png)


 #### BER checker 
 
 **Otorgada por la cátedra** 
 
 * [Descripción HDL](https://github.com/matias-dogliani/diseno_digital/blob/master/Tp5/Verilog/modulos/prbs_checker.v) 
 
 ![Diagrama Decimador](https://github.com/matias-dogliani/diseno_digital/blob/master/Tp5/imgs/BERChecker.png)
 
 ### Vector Matching

* [Cuaderno de Resolución](https://github.com/matias-dogliani/diseno_digital/blob/master/Tp5/VectorMatching.ipynb)
 
