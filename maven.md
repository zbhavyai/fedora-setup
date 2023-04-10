# Settings up Maven

##

Clean the project. Basically, remove all the `.class` files.

```
$ maven clean
```

Skipping Tests. More [info](https://maven.apache.org/surefire/maven-surefire-plugin/examples/skipping-tests.html)

```
$ maven install -DskipTests
```
