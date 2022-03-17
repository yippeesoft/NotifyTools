import os
import subprocess

curpath = os.getcwd()
print(curpath)
curpath = "/home/aaa/sdk/android10/"
os.chdir(curpath)
print(curpath)
procpwd = subprocess.Popen('repo forall -c pwd', shell=True,
                     stdout=subprocess.PIPE, stderr=subprocess.STDOUT)


for pathpwd in procpwd.stdout.readlines():
    # kernel = "kernel"
    curpath = pathpwd.decode().rstrip('\n')
    os.chdir(curpath)

    pprj = subprocess.Popen("git remote -v | head -n1 | awk '{print $2}' | sed 's/.*\///' | sed 's/\.git//'",
                        shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    prjname = pprj.stdout.readline().decode().rstrip('\n')
    print("prjname: "+prjname)

    pgitlog = subprocess.Popen("git log --pretty=oneline  --author='ddddd'",
                        shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
  
    filediff=None
    for line in pgitlog.stdout.readlines():
        if "同步" in line.decode():
            continue
        hashcode=line.decode().strip('\n')[0:40]
        if not filediff:
            filediff=open("/home/aaa/diff/"+prjname,"wb")
        showcmd="git show "+hashcode
        print(prjname+": "+showcmd)
        pp = subprocess.Popen(showcmd,
                        shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        if filediff:
            filediff.write(pp.stdout.read())
    if filediff:
        filediff.close()
retval = procpwd.wait()

print("end!")