## Functional Java

**Note**: In simple terms, you write lambda expressions to create objects of functional interfaces. You write method references to overwrite methods of functional interfaces.

### Interfaces

Data members are inherently `public static final` and Methods are inherently `public abstract`.

All members are public by default.

```java
public interface TestInterface() {
    // testMember is public static final even if not explicitly specified
    public static final T testMember;

    // testMethod is public abstract even if not explicitly specified
    public abstract T testMethod();

    // since java 8, default method implementation can be provided that can be overridden
    public default T testDefaultMethod() {
        System.out.println("testDefaultMethod");
    }

    // since java 8, static method implementation can be provided that cannot be overridden
    public static T testStaticMethod() {
        System.out.println("testStaticMethod");
    }
}
```

## Lambda expressions

Lambda expressions are used to define methods of functional interfaces. If the interface is not functional, then you have to write anonymous classes. Functional interfaces are the ones that have only one abstract method.

```java
java.util.function.*;   // contains built-in functional interfaces
```

#### Context

When writing lambda expressions, context must contain enough information to identify the receiving object of functional interface.

1. RHS of assignment. Here context is LHS.

   ```java
   Consumer<String> = lambda
   ```

2. Actual parameter of a method. Here context is argument type.

   ```java
   new Thread(lambda)
   ```

3. Argument of return. Here context is return type of method.

   ```java
   return lambdaBefore
   ```

4. Argument of cast. Here context is the type of the cast.
   ```java
   (Consumer<String>) lambda
   ```

#### Lambda expressions can access

- Static fields of enclosing class

- Instance fields of enclosing object

- Local variables of enclosing method only if they are final or effectively final

  ```java
  int x = 10;
  x = 13;           // x is reassigned. Not effectively final
  Consumer<String> c1 = (msg) -> System.out.println(x);     // compile error becoz x is not effectively final
  ```

#### Lambda expressions vs Anonymous classes

- Lambda expressions are more succinct
- Lambda expressions don't create additional `class` files
- Not every occurrence of lambda creates a new object
- Lambda expressions can be passed as arguments to other methods, used as return types, or as arguments to other lambda expressions
- Lambda expressions only work with functional interfaces
- Lambda expressions cannot have state (fields)

## Method references

- Static method

  ```java
  Employee::getMaxSalary
  ```

- Instance method, unspecified instance

  ```java
  Employee::getSalary
  ```

- Instance method, specified instance

  ```java
  adrian::getSalary
  ```

- Constructor

  ```java
  Employee::new
  ```

- Instance method of super class

  ```java
  super::foo
  ```

- Array constructor

  ```java
  String[]::new
  ```

#### Context

Method references have no intrinsic type, and the type inference is based on context. Just like lambda expressions, context must contain enough information to identify a functional interface.

1. RHS of assignment. Here context is LHS.

   ```java
   T var = <method reference>
   ```

2. Actual parameter of a method. Here context is argument type.

   ```java
   Foo(<method reference>)
   ```

3. Argument of return. Here context is return type of method.

   ```java
   return <method reference>
   ```

4. Argument of cast. Here context is the type of the cast.
   ```java
   (T) <method reference>
   ```

## Functional Interfaces

Pre Java 8, there were some functional interfaces:

- Runnable and Callable
- ActionListener
- Comparable and Comparator

Over forty functional interfaces were added in Java 8. Classified in six categories:

| Function Type | FI Name        |
| ------------- | -------------- |
| nothing -> T  | Supplier       |
| T -> nothing  | Consumer       |
| T -> T        | UnaryOperator  |
| T,T -> T      | BinaryOperator |
| S -> T        | Function       |
| T -> boolean  | Predicate      |

- A function accepting a object

  ```java
  interface Consumer<T> {
      void accept(T t);
  }
  ```

- A function producing a object

  ```java
  interface Supplier<T> {
      T get();
  }
  ```

- Represents an object updater/modifier. Can be used with `replaceAll` method of `interface List<T>`.

  ```java
  interface UnaryOperator<T> {
    T apply(T t);
  }
  ```

- BinaryOperator is used to combine two objects of the same type. Can be used with `reduce` operations in streams.

  ```java
  interface BinaryOperator<T> {
    T apply(T a, T b);
  }
  ```

- Represents an object transformer. Can be used with `Comparator`, as key extractors, and `map` operations in streams.

  ```java
  interface Function<T, R> {
    R apply(T t);
  }
  ```

  For example, if you need to compare `Employees` by their names,

  ```java
  Comparator<Employee> byName = Comparator.comparing(e -> e.getName()); // try comparing(Employee::getName);
  ```

- Represents a property that some objects have. Can be used with `filter` operations in streams, or in `removeIf` method of `Collection<T>`.

  ```java
  interface Predicate<T> {
      boolean test(T t);
  }
  ```

## Streams

Streams used for sequential data processing. Stream has internal iteration. Present in `java.util.stream.*`. Streams can be ordered/unordered and parallel/sequential. **Streams can only be traversed once.**

List vs Iterator vs Streams example:

```java
// list
List<Integer> l = ...;
for(Integer n:l)
    System.out.println(n);

// iterator
Iterator<Integer> i = ...;
while(i.hasNext())
    System.out.println(i.next());

// streams
Stream<Integer> s = ...;
s.forEach(System.out::println);
```

#### Types of operations on streams

- Build operation: create a stream from data source
- Intermediate operation: transform the stream into another
- Terminal operation: process the stream, convert it into something else or nothing

Example, print names of employees with salary at least $2500 alphabetically:

```java
Employee[] employees = {...};

Arrays.stream(employees)
    .filter(e -> e.getSalary() >= 2500)
    .sorted(Comparator.comparing(Employee::getName))
    .forEach(System.out::println);
```

#### Creating streams

1. Static method `Stream.of`

   ```java
   Stream<Integer> fib = Stream.of(1, 1, 2, 3);

   Employee[] ems = ...;
   Stream<Employee> emsStream = Stream.of(ems);
   ```

2. Using `Arrays.stream` or `Collection.stream` or `Collection.parallelStream`. Streams created from arrays are ordered and sequential. Streams created from list are ordered. Streams created from sets are unordered.

   ```java
   Employee[] ems = ...;
   Stream<Employee> emsStream = Arrays.stream(ems);
   ```

3. `Stream.generate` generates computations lazily on the fly. Using Supplier or UnaryOperator. Computed streams are infinite.

   ```java
   Stream<Integer> randoms = Stream.generate(random::nextInt);

   Stream<Integer> fib = Stream.generate(() -> {
       int a = 1;
       int b = 1;
       return a + b;
   });

   Stream<String> as = Stream.iterate("a", s -> s + "a");
   ```

#### `flatMap`

`<R> Stream<R> flatMap(Function<T, Stream<R>> f);`

Applies function f to every element, `f` returns a new stream for each element. `flatMap` then merges all the streams into one stream.

#### Stream operations

1. Filtering

   Can be done via `filter`, `takeWhile`, `dropWhile`, `limit`, and `distinct`.
