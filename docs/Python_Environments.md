# Python Environments

Python's `venv` module enables the creation of isolated environments, allowing you to manage project dependencies efficiently. This helps avoid conflicts between different projects and ensures a clean and reproducible development environment.

`pyenv` is a tool that allows you to easily install, manage, and switch between multiple Python versions. This is particularly useful when working on projects with specific version requirements, ensuring compatibility and consistency across different development environments.

## Setting up venv

1. Create a virtual environment called `PY-ENV`

   ```shell
   python -m venv ~/.venv/PY-ENV
   ```

2. To activate the environment

   ```shell
   chmod +x ${HOME}/.venv/PY-ENV/bin/activate
   source ${HOME}/.venv/PY-ENV/bin/activate
   ```

3. To deactivate, simply

   ```shell
   deactivate
   ```

## Setting up venv with a different version of Python

1. Install `pyenv`. It will download [`pyenv`](https://github.com/pyenv/pyenv.git) github repository in `~/.pyenv` directory.

   ```shell
   curl https://pyenv.run | bash
   ```

2. Install a different python version. Let's say system has version `3.10.4`, and you want to install `3.8.0`. The version would be installed in `~/.pyenv/versions/3.8.0` directory.

   ```shell
   pyenv install 3.8.0
   ```

3. Now create the virtual environment. The environment will be created in `~/.pyenv/versions/3.8.0/envs` directory.

   ```shell
   pyenv virtualenv 3.8.0 <ENV NAME>
   ```

4. To activate the environment:

   - Just for current shell session. `pyenv shell` updates the environment variable in the current shell session.

     ```shell
     pyenv shell <ENV NAME>
     ```

   - Automatically select whenever you are in the current directory (or its subdirectories). This creates a `.python-version` file in the current directory.

     ```shell
     pyenv local <ENV NAME>
     ```

   - Select globally for your user account. This is stored in `$(pyenv root)/version` file.

     ```shell
     pyenv global <ENV NAME>
     ```

5. To deactivate

   ```shell
   pyenv [shell|local|global] system      # replace the selection with system python
   ```
