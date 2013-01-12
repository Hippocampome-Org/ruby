import numpy as np
import numpy.random as npr

population = npr.rand(1000)

samples = map(
    lambda x: npr.randint(0,1000, 50),
    range(50))
