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

4. To activate the environment:

   - Just for current shell session. `pyenv shell` updates the environment variable in the current shell session.

     ```bash
     $ pyenv shell <ENV NAME>
     ```

   - Automatically select whenever you are in the current directory (or its subdirectories). This creates a `.python-version` file in the current directory.

     ```bash
     $ pyenv local <ENV NAME>
     ```

   - Select globally for your user account. This is stored in `$(pyenv root)/version` file.

     ```bash
     $ pyenv global <ENV NAME>
     ```

5. To deactivate

   ```bash
   $ pyenv [shell|local|global] system      # replace the selection with system python
   ```
