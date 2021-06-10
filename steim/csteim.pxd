from libc.stdint cimport int32_t, int64_t, uint16_t

cdef extern from "packdata.h":
    extern int msr_encode_steim2(int32_t *input, int samplecount, int32_t *output,
                                 int outputlength, int32_t diff0, uint16_t *byteswritten,
                                 char *sid, int swapflag)

cdef extern from "unpackdata.h":
    extern int msr_decode_steim2(int32_t *input, int inputlength, int64_t samplecount,
                                 int32_t *output, int64_t outputlength, char *srcname,
                                 int swapflag)
