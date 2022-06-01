# Setting up virtual environment with a different version of Python

1. Install `pyenv`. It will download [`pyenv`](https://github.com/pyenv/pyenv.git) github repository in `~/.pyenv` directory.

   ```bash
   $ curl https://pyenv.run | bash
   ```

2. Install a different python version. Let's say system has version `3.10.4`, and you want to install `3.8.0`. The version would be installed in `~/.pyenv/versions/3.8.0` directory.

   ```bash
   $ pyenv install 3.8.0
   ```

3. Now create the virtual environment. The environment will be created in `~/.pyenv/versions/3.8.0/envs` directory.

   ```bash
   $ pyenv virtualenv 3.8.0 <ENV NAME>
   ```

4. To activate the environment

   ```bash
   $ pyenv shell <ENV NAME>     # select just for current shell session
   $ pyenv local <ENV NAME>     # fautomatically select whenever you are in the current directory (or its subdirectories)
   $ pyenv global <ENV NAME>    # select globally for your user account
   ```

5. To deactivate

   ```bash
   $ pyenv [shell|local|global] system      # replace the selection with system python
   ```
