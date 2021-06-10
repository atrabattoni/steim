import unittest

import numpy as np
from numpy.lib.arraysetops import union1d

from steim.steim import encode_steim2, decode_steim2


class TestEncodeDecode(unittest.TestCase):

    def test_encode_decode(self):
        n = 4096
        arr = np.rint(1000 * np.random.randn(n)).astype(np.int32)
        enc = encode_steim2(arr)
        dec = decode_steim2(enc)
        self.assertTrue(np.array_equal(arr, dec))


if __name__ == '__main__':
    unittest.main()
