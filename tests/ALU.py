from testboard import TestBoard
from digitalio import Direction

class ALU:
    def connectTestBoard(self, testboard, N):
        self.__N = N
        self.__A = []
        self.__B = []
        self.__S = []
        for i in range(N):
            if i >= 4:
                i = i + 1
            self.__A.append(testboard.get_output_pin(128 + 8 * i + 1, 0))
            self.__B.append(testboard.get_output_pin(128 + 8 * i, 0))
            self.__S.append(testboard.get_input_pin(128 + 8 * i + 2))

        # controls
        self.__GNDR = testboard.get_opendrain_pin(2)
        self.__nSET0 = testboard.get_output_pin(3, 0)
        self.__GNDS = testboard.get_opendrain_pin(4)
        self.__C31 = testboard.get_input_pin(5)
        self.__GNDC = testboard.get_opendrain_pin(6)
        self.__S31 = testboard.get_input_pin(7)
        self.__GNDB = testboard.get_opendrain_pin(8)
        self.__AND = testboard.get_output_pin(9, 0)
        self.__GNDA = testboard.get_opendrain_pin(10)
        self.__XOR = testboard.get_output_pin(11, 0)
        self.__E = testboard.get_input_pin(12)
        self.__SUB = testboard.get_output_pin(13, 0)
        self.__Cin = testboard.get_output_pin(14, 0)
        self.__ADD = testboard.get_output_pin(15, 0)

    def __set_X(self, X, x):
        for i in range(self.__N):
            X[i].value = (x >> i) & 1
    def __get_X(self, X):
        x = 0
        for i in range(self.__N):
            x |= X[i].value << i
        return x

    @property
    def A(self):
        return self.__get_X(self.__A)
    @A.setter
    def A(self, x):
        self.__set_X(self.__A, x)
    @property
    def B(self):
        return self.__get_X(self.__B)
    @B.setter
    def B(self, x):
        self.__set_X(self.__B, x)
    @property
    def S(self):
        return self.__get_X(self.__S)
        
    @property
    def N(self):
        return self.__N

    @property
    def ADD(self):
        return self.__ADD.value
    @ADD.setter
    def ADD(self, x):
        self.__ADD.value = x
    @property
    def XOR(self):
        return self.__XOR.value
    @XOR.setter
    def XOR(self, x):
        self.__XOR.value = x
    @property
    def nSET0(self):
        return self.__nSET0.value
    @nSET0.setter
    def nSET0(self, x):
        self.__nSET0.value = x

    def enableLEDs(self, enable):
        for g in [self.__GNDA, self.__GNDB, self.__GNDC, self.__GNDS, self.__GNDR]:
            g.value = 0 if enable else 1
