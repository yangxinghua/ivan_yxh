# Check out jenv into ~/.jenv
echo "check out jenv into ~/.jenv"
git clone https://github.com/gcuisinier/jenv.git ~/.jenv
echo "done"

# Add ~/.jenv/bin to your $PATH for access to the jenv command-line utility.
echo "config jenv to path"
echo 'export PATH="$HOME/.jenv/bin:$PATH"' >> ~/.profile

# Add jenv init to your shell to enable shims and autocompletion.
echo 'eval "$(jenv init -)"' >> ~/.profile

# restart shell
exec $SHELL -l
