# React Setup

`node` and `npm` must be setup for using React.

## Create new React App

- Create react app in the current folder

  ```
  $ npx create-react-app .
  ```

- Create react app in other folder

  ```
  $ npx create-react-app <folder-name>
  ```

## Update all dependencies

- `npm-check-updates` will just check the updates

- Flag `-u` will update the dependencies by modifying `package.json` only. This ignores the specified versions

- `npm install` will update `package-lock.json` and installed packages

```
$ npx npm-check-updates -u
$ npm install
```

## Run development build

1. Install dependencies, that would create the `package-lock.json` file and `node_modules` directory.

   ```
   $ npm install
   ```

2. Start the dev server

   ```
   $ npm start
   ```

## Run production build

1. Create the static files for the production build

   ```
   $ npm run build
   ```

2. Install `serve`

   ```
   $ npm install -g serve
   ```

3. Serve the production build

   ```
   $ serve -s build
   ```

4. Specify port, to use something other than `3000`

   ```
   $ serve -s build -l 3001
   ```

## Serving production build on default HTTP port

1. Default HTTP port is `80`, so users can access the react app on `http://localhost/`, and don't have to specify the port

2. By default, admin priviledges are required to run a serve on port below `1024`, which can be avoided by giving safe user permission to `node`

   ```
   # dnf install libcap-devel
   # apt install libcap2-bin

   # setcap cap_net_bind_service=+ep `readlink -f \`which node\``
   ```

3. Now, run the server on port `80`

   ```
   $ serve -s build -l 80
   ```

<!-- ## Install React Dev Tools

````
$ npm install --save-dev react-devtools
``` -->

## Environment variables

Full documentation can be found here: [https://github.com/motdotla/dotenv](https://github.com/motdotla/dotenv).

**Notes**:

1. Application must be restarted after making changes to the `.env` files

2. If application is not initialized using **create-react-app**, then do these steps beforehand

   - Install the package dotenv: `npm install dotenv`

   - Add this line to the application: `require('dotenv').config()`

#### Setting up environment variables

Set the environment variables in the `.env` file at the project root directory

```
BROWSER=none
PORT=3005
```

#### Using environment variables

To use environment variables in the application (for example, API keys stored in `.env` file), they must be prefixed with `REACT_APP_` when being declared and used. They can be accessed like this:

To declare:

```
REACT_APP_API_KEY=<API KEY>
```

To use:

```js
let apiKey = process.env.REACT_APP_API_KEY;
```

#### Splitting environment variables

Environment variables can be split into different files based on current environment, for example, `.env.development` and `.env.production`. In this way, store API key in `.env.development` and add this file to `.gitignore`.
