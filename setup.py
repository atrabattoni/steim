from setuptools import setup, Extension
from Cython.Build import cythonize
import numpy as np

steim_src = ["steim.pyx"]

libmseed_src = [
    "fileutils.c", "genutils.c", "gswap.c", "msio.c", "lookup.c", "parson.c",
    "msrutils.c", "extraheaders.c", "pack.c", "packdata.c", "tracelist.c",
    "gmtime64.c", "crc32c.c", "parseutils.c", "unpack.c", "unpackdata.c",
    "selection.c", "logging.c"
]

extensions = [
    Extension(
        "steim.steim",
        steim_src + libmseed_src,
        include_dirs=[np.get_include()],
    ),
]

setup(
    name='steim',
    packages=["steim"],
    ext_module=cythonize(extensions),
    zip_safe=False,
)
