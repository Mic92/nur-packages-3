{ stdenv, fetchFromGitHub, writeText, python2Packages, z3 }:

let
  setuppy = writeText "setup.py" ''
    from setuptools import setup, find_packages
    from os import path

    here = path.abspath(path.dirname(__file__))

    setup(
        name='alive',
        version='0.0.1',
        description='Alive',
        url='https://github.com/nunoplopes/alive',
        author='Nuno P. Lopes',

        # XXX: License, classifiers, ...

        packages = ['alive', 'pyparsing' ],
        package_dir = { 'alive': "", "pyparsing": "pyparsing" },

        entry_points={
            'console_scripts': [
                'alive=alive:main',
            ],
        },
    )
  '';
in
python2Packages.buildPythonApplication rec {
  name = "alive-${version}";
  version = "2018-03-03";

  src = fetchFromGitHub {
    owner = "nunoplopes";
    repo = "alive";
    rev    = "df211719ade477d8f1205b484da34885d8a7ef74";
    sha256 = "1ixw96nynwysi5glyfxs5gxafyx41p6dj70l0w6and8yhnmqdd5z";
  };

  propagatedNativeBuildInputs = [ z3 ];

  postPatch = ''
    cp ${setuppy} setup.py

    echo "from alive import main" >> __init__.py
  '';

  doCheck = true;

  checkPhase = ''
    ./run-tests.sh
  '';

  meta = with stdenv.lib; {
    description = "Automatic LLVM's Instcombine Verifier";
    homepage = https://github.com/nunoplopes/alive;
    license = licenses.asl20;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}

