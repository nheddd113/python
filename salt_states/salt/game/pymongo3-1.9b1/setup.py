#!/usr/bin/env python

from warnings import warn
import sys
import os
import subprocess

from distribute_setup import use_setuptools
use_setuptools()
from setuptools import setup
from setuptools import Feature
from distutils.cmd import Command
from distutils.command.build_ext import build_ext
from distutils.errors import CCompilerError
from distutils.errors import DistutilsPlatformError, DistutilsExecError
from distutils.core import Extension

# Remember to change in pymongo/__init__.py as well!
version = "1.9b1"

f = open("README.rst")
try:
    readme_content = f.read()
except:
    readme_content = ""
finally:
    f.close()


class doc(Command):

    description = "generate or test documentation"

    user_options = [("test", "t",
                     "run doctests instead of generating documentation")]

    boolean_options = ["test"]

    def initialize_options(self):
        self.test = False

    def finalize_options(self):
        pass

    def run(self):
        if self.test:
            path = "doc/_build/doctest"
            mode = "doctest"
        else:
            path = "doc/_build/%s" % version
            mode = "html"

            # shutil.rmtree("doc/_build", ignore_errors=True)
            try:
                os.makedirs(path)
            except:
                pass

        status = subprocess.call(["sphinx-build", "-b", mode, "doc", path])

        if status:
            raise RuntimeError("documentation step '%s' failed" % mode)

        sys.stdout.write("\nDocumentation step '%s' performed, results here:\n"
                         "   %s/\n" % (mode, path))


if sys.platform == 'win32' and sys.version_info > (2, 6):
    # 2.6's distutils.msvc9compiler can raise an IOError when failing to
    # find the compiler
    build_errors = (CCompilerError, DistutilsExecError, DistutilsPlatformError,
                 IOError)
else:
    build_errors = (CCompilerError, DistutilsExecError, DistutilsPlatformError)


class custom_build_ext(build_ext):
    """Allow C extension building to fail.

    The C extension speeds up BSON encoding, but is not essential.
    """

    warning_message = """
**************************************************************
WARNING: %s could not
be compiled. No C extensions are essential for PyMongo to run,
although they do result in significant speed improvements.

%s
**************************************************************
"""

    def run(self):
        try:
            build_ext.run(self)
        except DistutilsPlatformError:
            e = sys.exc_info()[1]
            sys.stdout.write('%s\n' % e)
            warn(self.warning_message % ("Extension modules",
                                         "There was an issue with your "
                                         "platform configuration - see above."))

    def build_extension(self, ext):
        try:
            build_ext.build_extension(self, ext)
        except build_errors:
            warn(self.warning_message % ("The %s extension module" % ext.name,
                                         "Above is the ouput showing how "
                                         "the compilation failed."))

c_ext = Feature(
    "optional C extensions",
    standard=True,
    ext_modules=[Extension('bson._cbson',
                           include_dirs=['bson'],
                           sources=['bson/_cbsonmodule.c',
                                    'bson/time64.c',
                                    'bson/buffer.c',
                                    'bson/encoding_helpers.c']),
                 Extension('pymongo._cmessage',
                           include_dirs=['bson'],
                           sources=['pymongo/_cmessagemodule.c',
                                    'bson/_cbsonmodule.c',
                                    'bson/time64.c',
                                    'bson/buffer.c',
                                    'bson/encoding_helpers.c'])])

if "--no_ext" in sys.argv:
    sys.argv = [x for x in sys.argv if x != "--no_ext"]
    features = {}
elif sys.byteorder == "big":
    sys.stdout.write("""
*****************************************************\n
The optional C extensions are currently not supported\n
on big endian platforms and will not be built.\n
Performance may be degraded.\n
*****************************************************\n
""")
    features = {}
else:
    features = {"c-ext": c_ext}

setup(
    name="pymongo3",
    version=version,
    description="Python driver for MongoDB <http://www.mongodb.org>",
    long_description=readme_content,
    author="Mike Dirolf",
    author_email="mongodb-user@googlegroups.com",
    maintainer="Alex Grnholm",
    maintainer_email="alex.gronholm+pypi@nextday.fi",
    url="http://github.com/mongodb/mongo-python-driver",
    keywords=["mongo", "mongodb", "pymongo", "gridfs", "bson"],
    packages=["bson", "pymongo", "gridfs"],
    install_requires=[],
    tests_require=['nose'],
    test_suite="nose.collector",
    features=features,
    license="Apache License, Version 2.0",
    classifiers=[
        "Development Status :: 4 - Beta",
        "Intended Audience :: Developers",
        "License :: OSI Approved :: Apache Software License",
        "Operating System :: MacOS :: MacOS X",
        "Operating System :: Microsoft :: Windows",
        "Operating System :: POSIX",
        "Programming Language :: Python",
        "Topic :: Database"],
    cmdclass={"build_ext": custom_build_ext,
              "doc": doc})
