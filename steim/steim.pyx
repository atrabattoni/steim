# Cython
from libc.stdint cimport int32_t, int64_t, uint16_t, UINT16_MAX
from cython cimport view

# Numpy
import numpy as np
cimport numpy as np

# Steim
from csteim cimport msr_decode_steim2, msr_encode_steim2


def encode_steim2(int32_t[:] arr):

    # Check input size
    if arr.size > ((UINT16_MAX + 1) // sizeof(int32_t)):
        raise(MemoryError("Inputted array is to big"))

    # Allocate buffer
    cdef int32_t[:] buf = view.array(shape=(1 + 4*arr.size,), 
                                     itemsize=sizeof(int32_t), format="i")

    # Declare C wrappings 
    cdef int32_t *input_ptr = &arr[0]
    cdef int samplecount = arr.size
    cdef int32_t *output_ptr = &buf[1],
    cdef int outputlength = buf.size - 1
    cdef int32_t diff0 = 0
    cdef uint16_t byteswritten = 0
    cdef char sid 
    cdef int swapflag = 0

    # Compute
    with nogil:
        msr_encode_steim2(input_ptr, samplecount, output_ptr, outputlength,
                          diff0, &byteswritten, &sid, swapflag)
    
    # Write header
    buf[0] = samplecount  

    # Get computed data                         
    enc = buf[:1+byteswritten//sizeof(int32_t)]

    return enc


def decode_steim2(int32_t[:] enc):

    # Read header
    cdef int64_t samplecount = enc[0]

    # Allocate buffer and decoded output
    cdef int32_t[:] buf = view.array(shape=(4*enc.size,),
                                     itemsize=sizeof(int32_t), format="i")
    cdef int32_t[:] dec = view.array(shape=(samplecount,),
                                     itemsize=sizeof(int32_t), format="i")
    buf[:enc.size - 1] = enc[1:]

    # Declare C wrappings 
    cdef int32_t *input_ptr = &buf[0]
    cdef int inputlength = buf.size
    cdef int32_t *output_ptr = &dec[0],
    cdef int outputlength = dec.size
    cdef char sid 
    cdef int swapflag = 0

    # Compute
    with nogil:
        msr_decode_steim2(input_ptr, inputlength, samplecount, output_ptr,
                          outputlength, &sid, swapflag)

    return np.asarray(dec)
