# Cython
from libc.stdint cimport int32_t, int64_t, uint16_t
from cython cimport view

# Numpy
import numpy as np
cimport numpy as np

# Steim
from csteim cimport msr_decode_steim2, msr_encode_steim2


def encode_steim2(int32_t[:] arr):
    cdef int32_t[:] buf = view.array(shape=(1 + 4*arr.size,), 
                                     itemsize=sizeof(int32_t), format="i")
    cdef int32_t diff0 = 0
    cdef uint16_t byteswritten = 0
    cdef char sid 
    cdef int swapflag = 0
    samplecount = msr_encode_steim2(&arr[0], arr.size, &buf[1], buf.size-1, diff0, 
                                    &byteswritten, &sid, swapflag)
    buf[0] = samplecount                           
    enc = buf[:1+byteswritten//4]
    return enc


def decode_steim2(int32_t[:] enc):
    samplecount = enc[0]
    cdef int32_t[:] buf = view.array(shape=(4*enc.size,),
                                     itemsize=sizeof(int32_t), format="i")
    cdef int32_t[:] dec = view.array(shape=(samplecount,),
                                     itemsize=sizeof(int32_t), format="i")
    buf[:enc.size - 1] = enc[1:]
    cdef char sid 
    cdef int swapflag = 0
    msr_decode_steim2(&buf[0], buf.size, samplecount, &dec[0], dec.size, &sid, 
                      swapflag)
    return np.asarray(dec)
