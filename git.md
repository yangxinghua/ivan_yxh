# Git

## mirror
想将一个git仓库转移到另一个仓库要怎么做? 先clone下代码,删除.git目录,再提交到新仓库? No,No,No.
我们可以使用mirror.

首先从旧的仓库中拉取一个裸仓库
```
git clone --mirror git@github.com:reposity/old.git
```
这样,一个不包含工作区的仓库old.git就clone下来了.进入old.git目录,执行以下命令
```
git push --mirror git@github.com:reposity/new.git
```
这样,旧仓库的内容就同步到新仓库了.
当旧仓库的内容有更新时,进入old.git,
```
cd old.git
git fetch
git push --mirror git@github.com:reposity/new.git
```
然后在新仓库中pull一下,旧仓库的更新以及提交信息就同步到新仓库中了.
