from setuptools import setup, Extension
from Cython.Build import cythonize
import numpy as np

from pathlib import Path

steim_src = ["steim/steim.pyx"]

# libmseed_dir = Path(__file__).parent.joinpath("libmseed").absolute()
libmseed_dir = "libmseed"
libmseed_src = [
    "fileutils.c", "genutils.c", "gswap.c", "msio.c", "lookup.c", "parson.c",
    "msrutils.c", "extraheaders.c", "pack.c", "packdata.c", "tracelist.c",
    "gmtime64.c", "crc32c.c", "parseutils.c", "unpack.c", "unpackdata.c",
    "selection.c", "logging.c"
]
libmseed_src = [str(Path(libmseed_dir, path)) for path in libmseed_src]

extensions = [
    Extension(
        "steim.steim",
        steim_src + libmseed_src,
        include_dirs=[libmseed_dir, np.get_include()],
    ),
]

setup(
    name='steim',
    packages=["steim"],
    ext_modules=cythonize(extensions),
    zip_safe=False,
)
