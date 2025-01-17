#pragma once
#include <iostream>
#include <algorithm>
#include <fstream>
#include <cstdio>
#include <vector>
#include <sstream>
#include <cmath>
#include <string>
#include "data_transfer.h"

class Csr2DcsrDataTransfer : public DataTransfer
{

public:
    Csr2DcsrDataTransfer(std::string file) : DataTransfer(file){};
    
    void transfer();
};
