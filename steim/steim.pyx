# Cython
from libc.stdint cimport int32_t, int64_t, uint16_t
from cython cimport view

# Numpy
import numpy as np
cimport numpy as np

# Steim
from csteim cimport msr_decode_steim2, msr_encode_steim2


def encode_steim2(int32_t[:] arr):
    cdef int32_t[:] buf = view.array(shape=(4*arr.size,), 
                                     itemsize=sizeof(int32_t), format="i")
    cdef int32_t diff0 = 0
    cdef uint16_t byteswritten = 0
    cdef char sid 
    cdef int swapflag = 0
    samplecount = msr_encode_steim2(&arr[0], arr.size, &buf[0], buf.size, diff0, 
                                    &byteswritten, &sid, swapflag)
    enc = buf[:byteswritten//4]
    return samplecount, enc

def decode_steim2(int64_t samplecount, int32_t[:] enc):
    cdef int32_t[:] buf = view.array(shape=(4*enc.size,),
                                     itemsize=sizeof(int32_t), format="i")
    cdef int32_t[:] dec = view.array(shape=(samplecount,),
                                     itemsize=sizeof(int32_t), format="i")
    buf[:enc.size] = enc
    cdef char sid 
    cdef int swapflag = 0
    msr_decode_steim2(&buf[0], buf.size, samplecount, &dec[0], dec.size, &sid, 
                      swapflag)
    return np.asarray(enc)