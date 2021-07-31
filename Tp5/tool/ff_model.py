import numpy as np

class ff_single:
    def __init__(self, init_val=0):
        self.__i = 0
        self.__o = init_val
   
    @property
    def o(self):
        return self.__o
    
    @property
    def i(self):
        return self.__i
    
    @i.setter
    def i(self,data):
        self.__i = data
    
    def run_clock(self):
        self.__o = self.__i
        
    def reset(self):
        self.__o = 0
        
class ff:
    def __init__(self, size=1, init_val=0):
        self.__size = size
        self.__ffs = [ff_single(init_val) for k in range(size)]
        
    def __getitem__(self, k):
        return self.__ffs[k]
    
    def __len__(self):
        return len(self.__ffs)

    @property
    def o(self):
        if(self.__size>1):
            return [self.__ffs[k].o for k in range(self.__size)]
        else:
             return self.__ffs[0].o
    
    @property
    def i(self):
        if(self.__size>1):
            return [self.__ffs[k].i for k in range(self.__size)]
        else:
             return self.__ffs[0].i
    
    @i.setter
#    def i(self,data):
#        for k in range(self.__size):
#            if isinstance(data, (list, tuple, np.ndarray)):
#                self.__ffs[k].i = data[k]
#            else:
#                self.__ffs[k].i = data
    def i(self,data):
        if isinstance(data, (list, tuple, np.ndarray)):
             for k in range(self.__size):
                self.__ffs[k].i = data[k]
   
        elif isinstance(data,int): #Para 0xAAA o 0bAAA  
            binList = [1 if digit=='1' else 0 for digit in bin(data)[2:]]
            for k in range(self.__size):
                self.__ffs[k].i =binList[k]


    def run_clock(self):
        for k in range(self.__size):
            self.__ffs[k].run_clock()
        
    def reset(self):
        for k in range(self.__size):
            self.__ffs[k].reset()
