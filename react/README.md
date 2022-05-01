# React Setup

NodeJS and npm must be setup for using React.

## Create new React App

Create react app in the current folder

```
$ npx create-react-app .
```

<!-- ## Install React Dev Tools

```
$ npm install --save-dev react-devtools
``` -->

## Update all dependencies

Points to know:

- `npm-check-updates` will just check the updates.
- Flag `-u` will update the dependencies by modifying `package.json` only. This ignores the specified versions.
- `npm install` will update `package-lock.json` and installed packages.

```
$ npx npm-check-updates -u
$ npm install
```
