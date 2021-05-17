try:
    import pynvim
except:
    try:
        import pip
    except:
        import urllib2
        import sys

        this_python = sys.version_info[:2]
        min_version = (3, 6)
        if this_python < min_version:
            url = "https://bootstrap.pypa.io/pip/{}.{}/get-pip.py".format(*this_python)
        else:
            url = "https://bootstrap.pypa.io/get-pip.py"

        print(url)
        gpf = urllib2.urlopen(url)
        try:
            getpip = gpf.read()
        finally:
            gpf.close()
        exec(getpip)
        import pip
    pip.main(["install", "--user", "pynvim"])
    import pynvim
