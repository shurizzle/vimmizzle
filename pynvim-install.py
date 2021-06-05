try:
    import pynvim
except:
    try:
        import pip
    except:
        try:
            from urllib.request import urlopen
        except ImportError:
            from urllib2 import urlopen
        import sys

        this_python = sys.version_info[:2]
        min_version = (3, 6)
        if this_python < min_version:
            url = "https://bootstrap.pypa.io/pip/{}.{}/get-pip.py".format(*this_python)
        else:
            url = "https://bootstrap.pypa.io/get-pip.py"

        gpf = urlopen(url)
        try:
            getpip = gpf.read()
        finally:
            gpf.close()
        exec(getpip)
        import pip
    pip.main(["install", "--user", "pynvim"])
    import pynvim
