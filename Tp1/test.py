import numpy as np
import matplotlib.pyplot as plt   


def graficar_plot(): 
    print("Graficar plot") 
    vec = list(map(int, input("Ingrese el vector por elemento separado por espacio: ").split()))    
    plt.figure()
    plt.plot(vec,linewidth=1.0,label='Vector ingresado' )
    plt.ylabel('Valor')
    plt.xlabel('Muestra')
    plt.title('Plot Input Vector')
    plt.legend()
    plt.grid()
    plt.show()

def graficar_stem(): 
    print("Grafico Stem") 
    vec = list(map(int, input("Ingrese el vector por elemento separado por espacio: ").split()))    
    plt.figure()
    plt.stem(vec,label='Vector ingresado' )
    plt.ylabel('Valor')
    plt.xlabel('Muestra')
    plt.title('Stem')
    plt.legend()
    plt.grid()
    plt.show()

def graficar_hist(): 
    print("Grafico histograma") 
    vec = list(map(int, input("Ingrese el vector por elemento separado por espacio: ").split()))    
    plt.figure()
    plt.hist(vec,label='Vector ingresado' )
    plt.ylabel('Valor')
    plt.xlabel('Muestra')
    plt.title('Stem')
    plt.legend()
    plt.grid()
    plt.show()

def graficar_fft(): 
    print("Grafico FFT ") 
    vec = list(map(int, input("Ingrese el vector por elemento separado por espacio: ").split()))    
    vec = np.array(vec) 
    VEC = np.fft.fft(vec) 
    plt.figure()
    plt.plot(VEC,label='Vector ingresado' )
    plt.ylabel('Valor')
    plt.xlabel('Muestra')
    plt.title('FFT')
    plt.legend()
    plt.grid()
    plt.show()

def graficar_filePlot(): 
    print("Grafico de archivo ") 
    vec = np.fromfile('./tp1/sine.log',sep=',') 
    plt.figure()
    plt.plot(vec,label='Vector ingresado' )
    plt.ylabel('Valor')
    plt.xlabel('Muestra')
    plt.title('FFT')
    plt.legend()
    plt.grid()
    plt.show()

def guardar_archivo(): 
    vec = list(map(int, input("Ingrese el vector por elemento separado por espacio: ").split()))    
    vec = np.array(vec).reshape(2,2)
    fd = open("./matrix.log", "w")
    for fila in vec:
        print("guardando ", fila)
        np.savetxt(fd,fila)
    
    fd.close() 

guardar_archivo()
