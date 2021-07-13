# Trabajo práctico N°4 

Aplicación de conceptos de Aritmética de Punto Fijo 


## Ejercicio 1 

En este ejercicio se puede observar el efecto que cuasa la cuantización de los coeficientes de un filtro del tipo *raised cosine* utilizado para una transmisión QAM-4. 

 * [Cuaderno de Resolución](https://github.com/matias-dogliani/diseno_digital/blob/master/Tp4/Tp4.ipynb). 
 
 
 Se pudo observar que el truncado, para todos los casos, genera tal deformación en la señal del filtro que la detección de símbolos ya no es adecuada. Y en el caso especial de S(3,2) no se puede hacer una diferenciación de los símbolos detectados observando su constelación. 
 
Los formatos S(8,7) y S(6,4) si bien presentan defermorciones en su respeusta en frecuencia y tiempo, aún son aceptables y cuidando otros aspectos del recepctor y transmisor se pueden utilizar para la transmisión y recepción de símbolos. Por otro lado, el formato S(3,2) altera de tal forma la señal que ya no es posible la correcta tranmisión y recepción. 


## Ejercicio 2 

### Sumador en Fixed Point

Como se observó en el ejercicio anterior, la cuantización con redondeo es, para todos los casos, la que menor altera a la señal ideal de coeficientes de punto flotante. Sin embargo, este operación es notablemente más costosa en términos de hardware. 


Se implementa un módulo sumador que posee 4 salidas con diferentes cuantizaciones. 

![Sumador Fixed Point](https://github.com/matias-dogliani/diseno_digital/blob/master/Tp4/img/FpSum.png)

Para dos entradas de punto fijo, una suma en **full resolution** es simplemente un sumador primitivo 

![Sumador Full Resolution](https://github.com/matias-dogliani/diseno_digital/blob/master/Tp4/img/sumFR.png)


De la misma forma, se requiere el mismo hardware para una suma con formato S(12.11) con **overflow y truncado**, solo se desconectan los bits no requeridos en exceso de la suma full resolution. 

![Overflow y truncado](https://github.com/matias-dogliani/diseno_digital/blob/master/Tp4/img/trunc_ovf.png)


Para realizar **saturación y truncado** el hardware ya no es el mismo y adquiere cierta complejidad comparados con los anteriores módulos

![Saturación y truncado](https://github.com/matias-dogliani/diseno_digital/blob/master/Tp4/img/sat_trunc.png)

La saturación consiste básicamente en comprobar el valor de los N+1 bits más significativos, siendo N la cantidad de bits a truncar. Si estos bits tienen todos el mismo valor se recorta de la misma forma que con el hardware anterior, desconectando los bits determinados. Por otro lado, si alguno de ellos difiere se debe realizar una comparación extra para comprobar el signo del número en punto fijo. Según el signo el número pasará a su valor máximo positivo (se satura a su valor máximo positivo) o su valor mínimo (máximo valor del módulo de sus valores negativos) 


A esto, se agrega hardware adicional para poder realizar la operación de suma con **saturación y redondeo**. 

![Saturación y redondeo](https://github.com/matias-dogliani/diseno_digital/blob/master/Tp4/img/sat_round.png)

El redondeo consiste en sumar un bit `1'b1` al bit menos significativo a descartar. 

Como se puede observar, para el caso donde menor ruido de cuantización se consiguió en el ejercico anterior es el sumador más costoso de implementar, en donde se cuantiza con redondeo. Esto significa que se debe realizar una elección de compromiso entre el ruido o ISI que nuestro tranmisor podrá soportar o utilizar hardware complejo que requiere de trabajo de timing, debuggin,etc. 


### Multiplicador en Fixed Point 

El bloque completo del multiplicador  se muestra a continuación. 
* [Descripción en Verilog](https://github.com/matias-dogliani/diseno_digital/blob/master/Tp4/Verilog/FpMul.v)


![Multiplicador Fixed Point](https://github.com/matias-dogliani/diseno_digital/blob/master/Tp4/img/Fpmul.png)

Se implementó de la misma forma que el sumador, con la ventaja de que para realizar la multiplicación no es necesario alinear los puntos decimales. 

### Vector Matching 

Para comprobar el correcto funcionamineto del hardware descripto, se crean variables aleatorias de punto fijo y archivos con valores patrones calculados mediante el módulo *fixedInt* en python. 


Se realizaron modificaciones mínimas al módulo otorgado por la fundación. Estas modificaciones, la generación de entradas aleatorias y los archivos con vectores patrones, se puede encontrar en [cuaderno de resolución](https://github.com/matias-dogliani/diseno_digital/blob/master/Tp4/Vectores.ipynb). 

Luego, mediante Verilog se almacenan las salidas calculadas en un archivo ordenado de la misma forma que los vectores patrones. Esto permite realizar la comparación y cualquier otro tipo de procesamiento en python o cualquier otro lenguaje de alto nivel más flexible que las instrucciones disponibles en Verilog. 

* [Vectores Patrones y entradas](https://github.com/matias-dogliani/diseno_digital/tree/master/Tp4/PatternVec) : A.in y B.in se sobreescriben al correr la generación de entradas de suma y de multiplicación. 

* [Vectores de TestBench](https://github.com/matias-dogliani/diseno_digital/tree/master/Tp4/TbVec)

* [Errores](https://github.com/matias-dogliani/diseno_digital/tree/master/Tp4/logs).**Con las correcciones agregadas a la biblioteca no se obtuvo error en ningún caso.**  


### Indicador de saturación 

Se agrega una salida más que toma el valor de alto cuando se produce la saturación. Esto se agrega dentro de la comparación con el bit de signo del número en punto fijo. 

 
